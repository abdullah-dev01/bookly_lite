import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' as html_parser;
import '../../../bookly_lite.dart';

/// Helper function to strip HTML tags from text
String _stripHtml(String? htmlString) {
  if (htmlString == null || htmlString.isEmpty) return '';
  final document = html_parser.parse(htmlString);
  return document.body?.text ?? htmlString;
}

/// screen expects a BookVolume object via route arguments
class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({super.key, required this.book});
  final BookVolume book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          book.volumeInfo.title,
          style: const TextStyle(color: Colors.white),
        ),
        titleSpacing: 20,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
      body: BookDetailsView(book: book),
    );
  }
}

/// Main content, stateless for performance; split up widgets for separation.
class BookDetailsView extends StatelessWidget {
  const BookDetailsView({super.key, required this.book});
  final BookVolume book;

  @override
  Widget build(BuildContext context) {
    final info = book.volumeInfo;
    final sale = book.saleInfo;
    final search = book.searchInfo;

    // Core fields
    final String? thumbnail = info.imageLinks?.thumbnail;
    final String title = info.title;
    final String? subtitle = info.subtitle;
    final List<String>? authors = info.authors;
    final String authorText = (authors == null || authors.isEmpty)
        ? 'Unknown Author'
        : authors.join(', ');
    final List<String>? categories = info.categories;
    final String? categoriesText = (categories != null && categories.isNotEmpty)
        ? categories.join(', ')
        : null;
    final String? publishedDate = info.publishedDate;
    final int? pageCount = info.pageCount;
    final String? description = info.description;
    final String? publisher = info.publisher;
    final String? language = info.language;
    final String? previewLink = info.previewLink;
    final String? buyLink = sale?.buyLink;

    final String cleanDescription = _stripHtml(description);

    // Sale info
    String? price;
    if (sale?.listPrice?.amount != null) {
      final currency = sale!.listPrice!.currencyCode ?? '';
      price = '${sale.listPrice!.amount} $currency';
    }
    final bool isEbook = sale?.isEbook ?? false;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      children: [
        _BookCoverImage(thumbnail: thumbnail, semanticsLabel: title),
        const SizedBox(height: 24),
        // Title Card
        _InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null && subtitle.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 8),
                  child: Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              BookAuthorsAndPublisher(
                authors: authorText,
                publisher: publisher,
              ),
              if (categoriesText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      categoriesText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              BookMetaRow(
                publishedDate: publishedDate,
                pageCount: pageCount,
                language: language,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Action Card (Price, Buy, Preview)
        if ((previewLink != null && previewLink.isNotEmpty) ||
            (buyLink != null && buyLink.isNotEmpty) ||
            (price != null && price.isNotEmpty))
          _InfoCard(
            child: BookActionRow(
              buyLink: buyLink,
              previewLink: previewLink,
              price: price,
              isEbook: isEbook,
            ),
          ),
        const SizedBox(height: 16),
        // Snippet Card
        // Description Card
        if (cleanDescription.isNotEmpty)
          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cleanDescription,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        // Identifiers Card
        BookIdentifiers(volumeInfo: info),
        const SizedBox(height: 24),
      ],
    );
  }
}

// Book cover image widget.
class _BookCoverImage extends StatelessWidget {
  const _BookCoverImage({
    super.key,
    required this.thumbnail,
    this.semanticsLabel,
  });

  final String? thumbnail;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 160,
            height: 240,
            color: Colors.grey.shade200,
            child: thumbnail != null
                ? CachedNetworkImage(
                    imageUrl: thumbnail!,
                    placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 56),
                    fit: BoxFit.cover,
                    imageBuilder: (_, img) => Semantics(
                      label: semanticsLabel ?? "Book cover",
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(image: img, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  )
                : const Icon(Icons.book_outlined, size: 60),
          ),
        ),
      ),
    );
  }
}

// Reusable info card with consistent styling
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade50],
            ),
          ),
          child: Padding(padding: const EdgeInsets.all(16.0), child: child),
        ),
      ),
    );
  }
}

// Book meta (author, publisher)
class BookAuthorsAndPublisher extends StatelessWidget {
  const BookAuthorsAndPublisher({
    super.key,
    required this.authors,
    this.publisher,
  });
  final String authors;
  final String? publisher;
  @override
  Widget build(BuildContext context) {
    final bool showDivider = publisher != null && publisher!.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Flexible(
            child: Text(
              authors,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: Colors.grey[700],
                fontStyle: FontStyle.italic,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (showDivider)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                "•",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
          if (showDivider)
            Flexible(
              child: Text(
                publisher!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}

// Publishing info row (date, pages, language)
class BookMetaRow extends StatelessWidget {
  const BookMetaRow({
    super.key,
    this.publishedDate,
    this.pageCount,
    this.language,
  });
  final String? publishedDate;
  final int? pageCount;
  final String? language;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (publishedDate != null && publishedDate!.isNotEmpty) {
      children.add(
        Text(
          publishedDate!,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      );
    }
    if (pageCount != null) {
      if (children.isNotEmpty) {
        children.add(Text(" • ", style: TextStyle(color: Colors.grey[500])));
      }
      children.add(
        Text(
          "$pageCount pages",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      );
    }
    if (language != null && language!.isNotEmpty) {
      if (children.isNotEmpty) {
        children.add(Text(" • ", style: TextStyle(color: Colors.grey[500])));
      }
      children.add(
        Text(
          language!.toUpperCase(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(children: children),
    );
  }
}

// Preview, Buy, Price row (with proper separation)
class BookActionRow extends StatelessWidget {
  const BookActionRow({
    super.key,
    this.price,
    this.buyLink,
    this.previewLink,
    this.isEbook,
  });

  final String? price;
  final String? buyLink;
  final String? previewLink;
  final bool? isEbook;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (price != null && price!.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[300]!),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  price!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isEbook == true) ...[
                  const SizedBox(width: 6),
                  Icon(Icons.phone_android, size: 18, color: Colors.green[700]),
                ],
              ],
            ),
          ),
        ] else if (isEbook == true)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[300]!),
            ),
            child: Icon(Icons.phone_android, size: 18, color: Colors.blue[700]),
          ),
        const Spacer(),
        if (previewLink != null && previewLink!.isNotEmpty)
          OutlinedButton.icon(
            onPressed: () async {
              final uri = Uri.tryParse(previewLink!);
              if (uri != null) {
                try {
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Could not launch preview link'),
                        ),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                }
              }
            },
            icon: const Icon(Icons.visibility_outlined, size: 18),
            label: const Text("Preview"),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
        if (buyLink != null && buyLink!.isNotEmpty) ...[
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () async {
              final uri = Uri.tryParse(buyLink!);
              if (uri != null) {
                try {
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Could not launch buy link'),
                        ),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                }
              }
            },
            icon: const Icon(Icons.shopping_cart_outlined, size: 18),
            label: const Text("Buy"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
        ],
      ],
    );
  }
}

// Identifiers, for completeness and based on the spec
class BookIdentifiers extends StatelessWidget {
  const BookIdentifiers({super.key, required this.volumeInfo});
  final VolumeInfo volumeInfo;

  @override
  Widget build(BuildContext context) {
    final ids = volumeInfo.industryIdentifiers;
    if (ids == null || ids.isEmpty) return const SizedBox.shrink();
    return _InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Identifiers',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          ...ids.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      e.type,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      e.identifier,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
