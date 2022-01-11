import 'package:rafael_jobsity_challenge/domain/entities/episode.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';

class TvShowState{
  final TvShow tvShow;
  final List<Episode>? episodes;
  final bool? isFavorite;

  TvShowState({
    required this.tvShow,
    this.episodes,
    this.isFavorite
  });

  factory TvShowState.initial(TvShow tvShow){
    return TvShowState(
      tvShow: tvShow,
      episodes: null,
      isFavorite: null
    );
  }

  TvShowState copyWith({
    TvShow? tvShow,
    List<Episode>? episodes,
    bool? isFavorite
  }){
    return TvShowState(
      tvShow: tvShow ?? this.tvShow.copy(),
      episodes: episodes ?? (this.episodes != null ? List.from(this.episodes!) : null),
      isFavorite: isFavorite ?? this.isFavorite
    );
  }
}