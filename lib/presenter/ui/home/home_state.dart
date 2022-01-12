import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/strings.dart';

class HomeState{
  final List<TvShow>? tvShows;
  final List<TvShow>? tvSearch;
  final List<TvShow>? favorites;
  final List<String>? selectedGenres;
  final bool isSearching;
  final bool isEnd;
  final String selectCategory;

  HomeState({
    required this.tvShows,
    required this.tvSearch,
    required this.favorites,
    required this.selectedGenres,
    required this.isSearching,
    required this.isEnd,
    required this.selectCategory
  });

  factory HomeState.initial(){
    return HomeState(
      tvShows: null,
      tvSearch: [],
      favorites: null,
      selectedGenres: [],
      isSearching: false,
      isEnd: false,
      selectCategory: categories[0]
    );
  }

  HomeState copyWith({
    List<TvShow>? tvShows,
    List<TvShow>? tvSearch,
    List<TvShow>? favorites,
    List<String>? selectedGenres,
    bool? isSearching,
    bool? isEnd,
    String? selectCategory
  }){
    return HomeState(
      tvShows: tvShows  ?? (this.tvShows != null ? List.from(this.tvShows!) : null),
      tvSearch: tvSearch ?? (this.tvSearch != null ? List.from(this.tvSearch!) : null),
      favorites: favorites ?? (this.favorites != null ? List.from(this.favorites!) : null),
      selectedGenres: selectedGenres ?? (this.selectedGenres != null ? List.from(this.selectedGenres!) : null),
      isSearching: isSearching ?? this.isSearching,
      isEnd: isEnd ?? this.isEnd,
      selectCategory: selectCategory ?? this.selectCategory
    );
  }
}