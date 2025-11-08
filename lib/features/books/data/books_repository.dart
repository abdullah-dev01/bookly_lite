import '../../../bookly_lite.dart';

class BooksRepository {
  final ApiClient apiClient;

  BooksRepository({required this.apiClient});

  Future<BookVolumesResult> searchBooks(String query) async {
    final response = await apiClient.get('/volumes?q=$query');
    return BookVolumesResult.fromJson(response.data);
  }
}
