import '../../../../bookly_lite.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookDashboard extends StatelessWidget {
  final List<BookVolume> books;
  final bool showSearchBar;
  final TextEditingController searchController;
  final VoidCallback toggleSearch;
  final ValueChanged<String> performSearch;
  final VoidCallback updateSearch;

  const BookDashboard({
    super.key,
    required this.books,
    required this.showSearchBar,
    required this.searchController,
    required this.toggleSearch,
    required this.performSearch,
    required this.updateSearch,
  });

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No books found',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Use the search button to find books',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Optional search bar
              if (showSearchBar)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.white,
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for a book',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                searchController.clear();
                                updateSearch();
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    onFieldSubmitted: performSearch,
                    onChanged: (_) => updateSearch(),
                  ),
                ),
              // Trending Books header
              const SizedBox(height: 8),
              SectionHeader(title: "Trending Books", icon: Icons.trending_up),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: books.length > 10 ? 10 : books.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _BookCardHorizontal(book: books[index]),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: const SizedBox(height: 24)),
        SliverToBoxAdapter(
          child: SectionHeader(
            title: 'Popular Programming Books',
            icon: Icons.code,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: books.length > 10 ? 10 : books.length,
              itemBuilder: (context, index) {
                final reversedIndex = books.length - 1 - index;
                return ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 180,
                    minWidth: 120,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _BookCardHorizontal(book: books[reversedIndex]),
                  ),
                );
              },
            ),
          ),
        ),
        SliverToBoxAdapter(child: const SizedBox(height: 24)),
        SliverToBoxAdapter(
          child: SectionHeader(
            title: 'Recommended for You',
            icon: Icons.favorite,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: books.length > 5 ? 5 : books.length,
              itemBuilder: (context, index) => ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 180, minWidth: 120),
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _BookCardHorizontal(book: books[index]),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: const SizedBox(height: 24)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: SectionHeader(title: "All Books", icon: Icons.library_books),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BookItem(book: books[index]),
              ),
              childCount: books.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 80)), // Space for FAB
      ],
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const SectionHeader({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Horizontal scrolling card for dashboard sections
class _BookCardHorizontal extends StatelessWidget {
  // const BookCardHorizontal({super.key, required this.book});
  final BookVolume book;
  const _BookCardHorizontal({required this.book});

  @override
  Widget build(BuildContext context) {
    final volume = book.volumeInfo;
    final sale = book.saleInfo;
    final search = book.searchInfo;

    final thumbnail = volume.imageLinks?.thumbnail;
    final title = volume.title;
    final authors = volume.authors;
    final authorText = (authors == null || authors.isEmpty)
        ? 'Unknown Author'
        : authors.join(', ');
    final category = volume.categories?.first;
    final snippet = search?.textSnippet ?? volume.description;
    final price = sale?.listPrice != null
        ? '${sale!.listPrice!.amount} ${sale.listPrice!.currencyCode ?? ""}'
        : null;
    final buyLink = sale?.buyLink;
    final previewLink = volume.previewLink;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BookDetailsScreen(book: book)),
      ),
      child: SizedBox(
        width: 180,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover image
              Container(
                height: 140,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: thumbnail != null
                    ? CachedNetworkImage(
                        imageUrl: thumbnail,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (_, __, ___) =>
                            const Icon(Icons.broken_image, size: 40),
                      )
                    : const Icon(Icons.book, size: 50),
              ),
              // Book details
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // Author
                    Text(
                      authorText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (category != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        category,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (snippet != null && snippet.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        snippet,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    // Price & Actions
                    if (price != null ||
                        buyLink != null ||
                        previewLink != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (price != null)
                            Flexible(
                              child: Text(
                                price,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (previewLink != null)
                                IconButton(
                                  icon: const Icon(Icons.preview, size: 16),
                                  onPressed: () {
                                    // Handle preview
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              if (buyLink != null)
                                Container(
                                  margin: const EdgeInsets.only(left: 4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Buy',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookItem extends StatelessWidget {
  const BookItem({super.key, required this.book});

  final BookVolume book;

  @override
  Widget build(BuildContext context) {
    final volume = book.volumeInfo;
    final sale = book.saleInfo;
    final search = book.searchInfo;

    // Prepare all optional fields with null safety.
    final String? thumbnail = volume.imageLinks?.thumbnail;
    final String title = volume.title;
    final String? subtitle = volume.subtitle;
    final List<String>? authors = volume.authors;
    final String authorText = authors == null || authors.isEmpty
        ? 'Unknown Author'
        : authors.join(', ');
    final List<String>? categories = volume.categories;
    final String? categoryText = categories != null && categories.isNotEmpty
        ? categories.join(', ')
        : null;
    final String? publishedDate = volume.publishedDate;
    final int? pageCount = volume.pageCount;
    final String? snippet = search?.textSnippet ?? volume.description;
    final String? previewLink = volume.previewLink;

    // Sale Information
    final price = sale?.listPrice != null
        ? '${sale!.listPrice!.amount} ${sale.listPrice!.currencyCode ?? ""}'
        : null;
    final String? buyLink = sale?.buyLink;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookDetailsScreen(book: book)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.grey.shade50],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book cover image with rounded corners
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 80,
                      height: 120,
                      color: Colors.grey.shade200,
                      child: thumbnail != null
                          ? CachedNetworkImage(
                              imageUrl: thumbnail,
                              placeholder: (_, __) => const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (_, __, ___) =>
                                  const Icon(Icons.broken_image, size: 38),
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.book, size: 40),
                    ),
                  ),
                  const SizedBox(width: 18),
                  // Book details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle != null && subtitle.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              subtitle,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[700]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        const SizedBox(height: 6),
                        // Author and category in smaller text below title
                        Text(
                          authorText,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontSize: 12,
                                color: Colors.grey[700],
                                fontStyle: FontStyle.italic,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (categoryText != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              categoryText,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        // Published date and page count
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              if (publishedDate != null &&
                                  publishedDate.isNotEmpty)
                                Text(
                                  publishedDate,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        fontSize: 11,
                                        color: Colors.grey[600],
                                      ),
                                ),
                              if (publishedDate != null &&
                                  publishedDate.isNotEmpty &&
                                  pageCount != null)
                                const Text(
                                  " • ",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              if (pageCount != null)
                                Text(
                                  "$pageCount pages",
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        fontSize: 11,
                                        color: Colors.grey[600],
                                      ),
                                ),
                            ],
                          ),
                        ),
                        // Optional snippet text
                        if (snippet != null && snippet.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              snippet,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.black87,
                                    fontSize: 12,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        // Optional price and action buttons
                        if ((price != null && price.isNotEmpty) ||
                            (buyLink != null && buyLink.isNotEmpty) ||
                            (previewLink != null && previewLink.isNotEmpty))
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                if (price != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green[50],
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: Colors.green[300]!,
                                      ),
                                    ),
                                    child: Text(
                                      price,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.green[700],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                    ),
                                  ),
                                const Spacer(),
                                if (previewLink != null &&
                                    previewLink.isNotEmpty)
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      // Handle preview
                                    },
                                    icon: const Icon(Icons.preview, size: 16),
                                    label: const Text("Preview"),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                if (buyLink != null && buyLink.isNotEmpty) ...[
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Open buy link in webview or browser
                                      // You may use url_launcher package for actual implementation.
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: const Text("Buy"),
                                  ),
                                ],
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
