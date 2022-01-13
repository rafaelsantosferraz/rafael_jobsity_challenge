
part of 'actors_controller.dart';

class ActorsEvent {

  ActorsEvent._();

  factory ActorsEvent.start() = _StartEvent;
}

class _StartEvent extends ActorsEvent {
  _StartEvent():super._();
}