import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';

class HomeState{
  final List<TvShow> tvShows;

  HomeState({
    required this.tvShows
  });

  factory HomeState.initial(){
    return HomeState(
      tvShows: []
    );
  }

  HomeState copyWith({
    List<TvShow>? tvShows
  }){
    return HomeState(
      tvShows: tvShows ?? List.from(this.tvShows)
    );
  }
}