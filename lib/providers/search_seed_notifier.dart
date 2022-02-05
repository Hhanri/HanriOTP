import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchSeedNotifier extends StateNotifier<SearchModel> {
  SearchSeedNotifier() : super(_initialState);

  static final SearchModel _initialState = SearchModel(searchedSeed: '', isSearching: false);

  void searchSeed(String seed) {
    state = SearchModel(isSearching: state.isSearching, searchedSeed: seed);
  }

  void openSearchBar() {
    state = SearchModel(isSearching: !state.isSearching, searchedSeed: "");
  }

}

class SearchModel {
  final bool isSearching;
  final String searchedSeed;

  SearchModel({
    required this.isSearching,
    required this.searchedSeed
  });

}