part of 'navigation_controller.dart';

class NavigationEvent {

  NavigationEvent._();

  factory NavigationEvent.homeReady(BuildContext context) = _HomeReadyEvent;
  factory NavigationEvent.goToTvShow(BuildContext context, TvShowPageArguments tvShowPageArguments) = _GoToTvShowEvent;
  factory NavigationEvent.goToEpisode(BuildContext context, Episode episode) = _GoToEpisodeEvent;
  factory NavigationEvent.goToActor(BuildContext context, Actor actor) = _GoToActorEvent;
}

class _HomeReadyEvent extends NavigationEvent {
  final BuildContext context;
  _HomeReadyEvent(this.context):super._();
}

class _GoToTvShowEvent extends NavigationEvent {
  final BuildContext context;
  final TvShowPageArguments tvShowPageArguments;

  _GoToTvShowEvent(this.context, this.tvShowPageArguments):super._();
}

class _GoToEpisodeEvent extends NavigationEvent {
  final BuildContext context;
  final Episode episode;

  _GoToEpisodeEvent(this.context, this.episode):super._();
}

class _GoToActorEvent extends NavigationEvent {
  final BuildContext context;
  final Actor actor;

  _GoToActorEvent(this.context, this.actor):super._();
}