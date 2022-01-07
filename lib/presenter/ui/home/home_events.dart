
part of 'home_controller.dart';

class HomeEvent {

  HomeEvent._();

  factory HomeEvent.start() = _StartEvent;
  factory HomeEvent.categorySelect(String category) = _CategorySelectEvent;
  factory HomeEvent.genreTapEvent(String genre) = _GenreTapEvent;
}

class _StartEvent extends HomeEvent {
  _StartEvent():super._();
}

class _CategorySelectEvent extends HomeEvent {
  final String category;

  _CategorySelectEvent(this.category):super._();
}

class _GenreTapEvent extends HomeEvent {
  final String genre;

  _GenreTapEvent(this.genre):super._();
}