part of 'navigation_controller.dart';

class NavigationEvent {

  NavigationEvent._();

  factory NavigationEvent.homeReady(BuildContext context) = _HomeReadyEvent;
  factory NavigationEvent.goToTvShow(BuildContext context, TvShow tvShow, ValueNotifier<Color> color) = _GoToTvShowEvent;
  factory NavigationEvent.goToEpisode(BuildContext context, Episode episode) = _GoToEpisodeEvent;
}

class _HomeReadyEvent extends NavigationEvent {
  final BuildContext context;
  _HomeReadyEvent(this.context):super._();
}

class _GoToTvShowEvent extends NavigationEvent {
  final BuildContext context;
  final TvShow tvShow;
  final ValueNotifier<Color> color;

  _GoToTvShowEvent(this.context, this.tvShow, this.color):super._();
}

class _GoToEpisodeEvent extends NavigationEvent {
  final BuildContext context;
  final Episode episode;

  _GoToEpisodeEvent(this.context, this.episode):super._();
}