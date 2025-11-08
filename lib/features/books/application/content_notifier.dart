import 'package:bookly_lite/bookly_lite.dart';

import '../../../providers/app_providers.dart';

class BooksNotifier extends AsyncNotifier<BooksState> {
  BooksRepository get _booksRepository => ref.read(booksRepositoryProvider);

  @override
  Future<BooksState> build() async {
    final books = await _booksRepository.searchBooks('programming');
    return BooksState(books: books);
  }

  Future<void> searchBooks(String query) async {
    state = AsyncValue.loading();
    try {
      if (query.isEmpty) {
        state = AsyncValue.data(BooksState(books: null));
        return;
      }
      final books = await _booksRepository.searchBooks(query);
      state = AsyncValue.data(BooksState(books: books));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
