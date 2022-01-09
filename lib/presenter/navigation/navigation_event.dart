part of 'navigation_controller.dart';

class NavigationEvent {

  NavigationEvent._();

  factory NavigationEvent.goToEpisode(BuildContext context, Episode episode) = _GoToEpisodeEvent;
}

class _GoToEpisodeEvent extends NavigationEvent {
  final BuildContext context;
  final Episode episode;

  _GoToEpisodeEvent(this.context, this.episode):super._();
}