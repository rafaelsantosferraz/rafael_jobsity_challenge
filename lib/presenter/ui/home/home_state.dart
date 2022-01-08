import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';

class HomeState{
  final List<TvShow> tvShows;
  final List<TvShow> tvSearch;
  final bool isSearching;

  HomeState({
    required this.tvShows,
    required this.tvSearch,
    required this.isSearching
  });

  factory HomeState.initial(){
    return HomeState(
      tvShows: [],
      tvSearch: [],
      isSearching: false
    );
  }

  HomeState copyWith({
    List<TvShow>? tvShows,
    List<TvShow>? tvSearch,
    bool? isSearching
  }){
    return HomeState(
      tvShows: tvShows  ?? List.from(this.tvShows),
      tvSearch: tvSearch ?? List.from(this.tvSearch),
      isSearching: isSearching ?? this.isSearching
    );
  }
}