import '../../bookly_lite.dart';

final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseService = ref.read(firebaseServiceProvider);
  return AuthRepository(firebaseService);
});

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

final splashNotifierProvider = NotifierProvider<SplashNotifier, SplashState>(
  SplashNotifier.new,
);

final booksRepositoryProvider = Provider<BooksRepository>((ref) {
  return BooksRepository(apiClient: ApiClient(baseUrl: ApiConstants.baseUrl));
});

final booksNotifierProvider = AsyncNotifierProvider<BooksNotifier, BooksState>(
  BooksNotifier.new,
);

final uiNotifierProvider = NotifierProvider<UiNotifier, UiState>(
  UiNotifier.new,
);
