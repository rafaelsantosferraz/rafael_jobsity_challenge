import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/strings.dart';

class HomeState{
  final List<TvShow> tvShows;
  final List<TvShow> tvSearch;
  final List<TvShow> favorites;
  final bool isSearching;
  final String selectCategory;

  HomeState({
    required this.tvShows,
    required this.tvSearch,
    required this.favorites,
    required this.isSearching,
    required this.selectCategory
  });

  factory HomeState.initial(){
    return HomeState(
      tvShows: [],
      tvSearch: [],
      favorites: [],
      isSearching: false,
      selectCategory: categories[0]
    );
  }

  HomeState copyWith({
    List<TvShow>? tvShows,
    List<TvShow>? tvSearch,
    List<TvShow>? favorites,
    bool? isSearching,
    String? selectCategory
  }){
    return HomeState(
      tvShows: tvShows  ?? List.from(this.tvShows),
      tvSearch: tvSearch ?? List.from(this.tvSearch),
      favorites: favorites ?? List.from(this.favorites),
      isSearching: isSearching ?? this.isSearching,
      selectCategory: selectCategory ?? this.selectCategory
    );
  }
}