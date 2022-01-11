
part of 'tv_show_controller.dart';

class TvShowEvent {

  TvShowEvent._();

  factory TvShowEvent.start() = _StartEvent;
  factory TvShowEvent.addFavorite(TvShow tvShow) = _AddFavoriteEvent;
  factory TvShowEvent.removeFavorite(TvShow tvShow) = _RemoveFavoriteEvent;
}

class _StartEvent extends TvShowEvent {
  _StartEvent():super._();
}

class _AddFavoriteEvent extends TvShowEvent {
  final TvShow tvShow;
  _AddFavoriteEvent(this.tvShow):super._();
}

class _RemoveFavoriteEvent extends TvShowEvent {
  final TvShow tvShow;
  _RemoveFavoriteEvent(this.tvShow):super._();
}