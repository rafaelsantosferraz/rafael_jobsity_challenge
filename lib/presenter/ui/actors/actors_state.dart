import 'package:rafael_jobsity_challenge/domain/entities/actor.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';

class ActorState{
  final Actor actor;
  final List<TvShow>? tvShows;

  ActorState({
    required this.actor,
    required this.tvShows,
  });

  factory ActorState.initial(Actor actor){
    return ActorState(
      actor: actor,
      tvShows: null,
    );
  }

  ActorState copyWith({
    Actor? actor,
    List<TvShow>? tvShows,
  }){
    return ActorState(
      actor: actor ?? this.actor.copy(),
      tvShows: tvShows  ?? (this.tvShows != null ? List.from(this.tvShows!) : null),
    );
  }
}