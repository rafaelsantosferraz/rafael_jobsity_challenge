
part of 'tv_show_controller.dart';

class TvShowEvent {

  TvShowEvent._();

  factory TvShowEvent.start() = _StartEvent;
  factory TvShowEvent.favorite(TvShow tvShow, bool isFavorite) = _FavoriteEvent;
}

class _StartEvent extends TvShowEvent {
  _StartEvent():super._();
}

class _FavoriteEvent extends TvShowEvent {
  final TvShow tvShow;
  final bool isFavorite;
  _FavoriteEvent(this.tvShow, this.isFavorite):super._();
}