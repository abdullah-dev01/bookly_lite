import '../../../bookly_lite.dart';

class UiNotifier extends Notifier<UiState> {
  @override
  UiState build() {
    return UiState(isSearchBarVisible: false, searchQuery: '');
  }

  void toggleSearch() =>
      state = state.copyWith(isSearchBarVisible: !state.isSearchBarVisible);

  void updateQuery(String query) => state = state.copyWith(searchQuery: query);
}
