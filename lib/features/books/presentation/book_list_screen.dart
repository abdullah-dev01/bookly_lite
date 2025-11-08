import '../../../bookly_lite.dart';

import '../../../providers/app_providers.dart';

class BookListScreen extends ConsumerStatefulWidget {
  const BookListScreen({super.key});

  @override
  ConsumerState<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends ConsumerState<BookListScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _toggleSearch() {
    ref.read(uiNotifierProvider.notifier).toggleSearch();
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      ref.read(booksNotifierProvider.notifier).searchBooks(query);
      ref.read(uiNotifierProvider.notifier).updateQuery(query);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showSearchBar = ref.watch(uiNotifierProvider).isSearchBarVisible;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookly', style: TextStyle(color: Colors.white)),
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
      body: Consumer(
        builder: (context, ref, _) {
          final booksAsync = ref.watch(booksNotifierProvider);
          return booksAsync.when(
            data: (data) {
              final books = data.books?.items ?? [];

              final searchQuery = ref.watch(uiNotifierProvider).searchQuery;
              return BookDashboard(
                books: books,
                showSearchBar: showSearchBar,
                searchController: _searchController,
                toggleSearch: _toggleSearch,
                performSearch: _performSearch,
                updateSearch: () => setState(() {}),
              );
            },
            error: (error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${error.toString()}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.refresh(booksNotifierProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleSearch,
        icon: Icon(
          showSearchBar ? Icons.close : Icons.search,
          color: Colors.white,
        ),
        label: Text(
          showSearchBar ? 'Close' : 'Search',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
