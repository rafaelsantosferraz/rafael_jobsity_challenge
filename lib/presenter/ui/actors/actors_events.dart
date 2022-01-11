
part of 'actors_controller.dart';

class ActorsEvent {

  ActorsEvent._();

  factory ActorsEvent.start() = _StartEvent;
  factory ActorsEvent.addFavorite(TvShow tvShow) = _AddFavoriteEvent;
  factory ActorsEvent.removeFavorite(TvShow tvShow) = _RemoveFavoriteEvent;
}

class _StartEvent extends ActorsEvent {
  _StartEvent():super._();
}

class _AddFavoriteEvent extends ActorsEvent {
  final TvShow tvShow;
  _AddFavoriteEvent(this.tvShow):super._();
}

class _RemoveFavoriteEvent extends ActorsEvent {
  final TvShow tvShow;
  _RemoveFavoriteEvent(this.tvShow):super._();
}