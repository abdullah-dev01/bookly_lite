class UiState {
  final bool isSearchBarVisible;
  final String searchQuery;

  UiState({required this.isSearchBarVisible, required this.searchQuery});

  UiState copyWith({bool? isSearchBarVisible, String? searchQuery}) {
    return UiState(
      isSearchBarVisible: isSearchBarVisible ?? this.isSearchBarVisible,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
