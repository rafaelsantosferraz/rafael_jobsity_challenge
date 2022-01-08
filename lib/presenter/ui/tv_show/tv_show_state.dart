import 'package:rafael_jobsity_challenge/domain/entities/episode.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';

class TvShowState{
  final TvShow tvShow;
  final List<Episode>? episodes;

  TvShowState({
    required this.tvShow,
    this.episodes
  });

  factory TvShowState.initial(TvShow tvShow){
    return TvShowState(
      tvShow: tvShow
    );
  }

  TvShowState copyWith({
    TvShow? tvShow,
    List<Episode>? episodes,
  }){
    return TvShowState(
      tvShow: tvShow ?? this.tvShow.copy(),
      episodes: episodes ?? (this.episodes != null ? List.from(this.episodes!) : null)
    );
  }
}