
part of 'home_controller.dart';

class HomeEvent {

  HomeEvent._();

  factory HomeEvent.start() = _StartEvent;
  factory HomeEvent.categorySelect(String category) = _CategorySelectEvent;
  factory HomeEvent.genreTap(String genre) = _GenreTapEvent;
  factory HomeEvent.searchText(String search) = _SearchTextEvent;
  factory HomeEvent.searchToggle(bool isOpen) = _SearchToggleEvent;
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

class _SearchTextEvent extends HomeEvent {
  final String text;
  _SearchTextEvent(this.text):super._();
}

class _SearchToggleEvent extends HomeEvent {
  final bool isOpen;
  _SearchToggleEvent(this.isOpen):super._();
}