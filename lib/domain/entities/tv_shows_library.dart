import 'dart:async';

import 'package:rafael_jobsity_challenge/data/datasources/local/favorite_tv_shows_local_datasource.dart';
import 'package:rafael_jobsity_challenge/data/datasources/remote/tv_shows_remote_datasource.dart';
import 'package:rafael_jobsity_challenge/data/repositories/tv_shows_repository.dart';
import 'package:rafael_jobsity_challenge/domain/entities/actor.dart';
import 'package:rafael_jobsity_challenge/domain/entities/pagination.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/domain/repositories_interfaces/favorite_tv_shows_repository_interface.dart';
import 'package:rafael_jobsity_challenge/domain/repositories_interfaces/tv_shows_repository_interface.dart';
import 'package:rafael_jobsity_challenge/presenter/injection/injector.dart';
import 'package:rafael_jobsity_challenge/presenter/services/tv_maze_service.dart';


class TvShowsLibrary{

  final TvShowsRepositoryInterface _tvShowsRepository;
  final FavoriteTvShowsRepositoryInterface _favoriteTvShowsRepository;
  TvShowsLibrary._(this._tvShowsRepository, this._favoriteTvShowsRepository);


  static TvShowsLibrary? _instance;
  static TvShowsLibrary get instance => _instance ?? TvShowsLibrary._getInstance();

  factory TvShowsLibrary._getInstance()  {
    var tvShowsRepository = TvShowsRepository(TvShowsRemoteDataSource(TvMazeService.instance), FavoriteTvShowsLocalDataSource(Injector.sharedPreferences));
    return _instance ??= TvShowsLibrary._(tvShowsRepository, tvShowsRepository);
  }

  factory TvShowsLibrary.instanceWith(TvShowsRepository tvShowsRepository) {
    return TvShowsLibrary._(tvShowsRepository, tvShowsRepository);
  }

  final StreamController<PaginatedList<TvShow>> _tvShowsStream = StreamController.broadcast();
  final StreamController<List<TvShow>> _searchStream  = StreamController.broadcast();
  final StreamController<List<TvShow>> _favoriteStream  = StreamController.broadcast();


  Stream<PaginatedList<TvShow>> get tvShows => _tvShowsStream.stream;
  Stream<List<TvShow>> get search => _searchStream.stream;
  Stream<List<TvShow>> get favorites => _favoriteStream.stream;

  final _getMoreventsQueue = <_GetMoreEvent>[];
  final _eventsHistory = <TvShowsLibraryEvent>[];
  bool _gettingMore = false;



  //region Public --------------------------------------------------------------
  addEvent(TvShowsLibraryEvent event) async {
    if(event is _GetMoreEvent){
      _getMoreventsQueue.add(event);
      if(_getMoreventsQueue.length == 1){
        _processNextGetMoreEvent();
      }
    } else {
      _onEvent(event);
    }
  }

  printEventHistory(){
    for(var event in _eventsHistory){
      print(event);
    }
  }

  //todo: move to future tv_show_library.dart
  Future getEpisodes(int tvShowId){
    return _tvShowsRepository.getEpisodes(tvShowId);
  }

  bool checkIsFavorite(TvShow tvShow){
    return _favoriteTvShowsRepository.checkIsFavorite(tvShow);
  }

  Future<List<Actor>> getActors(int tvShowId) async {
    return _tvShowsRepository.getActors(tvShowId);
  }

  Future<List<TvShow>> getActorsSeries(int actorId) async {
    return _tvShowsRepository.getActorSeries(actorId);
  }

  close(){
    _tvShowsStream.close();
  }
  //endregion


  //region Private -------------------------------------------------------------
  ///Controls that every event get process in order of arrival to avoid any race
  ///conditions
  Future _processNextGetMoreEvent() async {
    if(_getMoreventsQueue.isNotEmpty){
      await _onEvent(_getMoreventsQueue.first);
      _eventsHistory.add(_getMoreventsQueue.first);
      _getMoreventsQueue.removeAt(0);
      _processNextGetMoreEvent();
    }
  }

  Future _onEvent(TvShowsLibraryEvent event) async {
    switch(event.runtimeType){
      case _StartEvent: await _onStart(event as _StartEvent);
      break;
      case _GetMoreEvent: await _onGetMore(event as _GetMoreEvent);
      break;
      case _SearchEvent: await _onSearch(event as _SearchEvent);
      break;
      case _SearchMoreEvent: await _onSearchMore(event as _SearchMoreEvent);
      break;
      case _GetFavoritesEvent: await _onGetFavorites(event as _GetFavoritesEvent);
      break;
      case _AddFavoriteEvent: await _onAddFavorite(event as _AddFavoriteEvent);
      break;
      case _RemoveFavoriteEvent: await _onRemoveFavorite(event as _RemoveFavoriteEvent);
      break;

      default: throw Exception('Event ${event.runtimeType} not process');
    }
  }

  Future _onStart(_StartEvent event) async {
    var tvShows = await _tvShowsRepository.getTvShows();
    _tvShowsStream.sink.add(tvShows);
  }

  Future _onGetMore(_GetMoreEvent event) async {
    var tvShows = await _tvShowsRepository.getMoreTvShows();
    _tvShowsStream.sink.add(tvShows);
    _gettingMore = false;
  }

  Future _onSearch(_SearchEvent event) async {
    var search = await _tvShowsRepository.searchTvShows(event.name);
    _searchStream.sink.add(search);
  }

  Future _onSearchMore(_SearchMoreEvent event) async {
    var search = await _tvShowsRepository.searchMoreTvShows();
    _searchStream.sink.add(search);
  }

  Future _onGetFavorites(_GetFavoritesEvent event) async {
    var favorite = await _favoriteTvShowsRepository.getFavorite();
    _favoriteStream.sink.add(favorite);
  }

  Future _onAddFavorite(_AddFavoriteEvent event) async {
    var isAdd = await _favoriteTvShowsRepository.addFavorite(event.tvShow);
    if(isAdd){
      _favoriteStream.sink.add(_favoriteTvShowsRepository.getFavorite());
    }
  }

  Future _onRemoveFavorite(_RemoveFavoriteEvent event) async {
    var isRemove = await _favoriteTvShowsRepository.removeFavorite(event.tvShow);
    if(isRemove){
      _favoriteStream.sink.add(_favoriteTvShowsRepository.getFavorite());
    }
  }
  //endRegion
}

class TvShowsLibraryEvent{

  const TvShowsLibraryEvent._();

  factory TvShowsLibraryEvent.start() = _StartEvent;
  factory TvShowsLibraryEvent.getMore() = _GetMoreEvent;
  factory TvShowsLibraryEvent.search(String name) = _SearchEvent;
  factory TvShowsLibraryEvent.searchMore() = _SearchMoreEvent;
  factory TvShowsLibraryEvent.getFavorites() = _GetFavoritesEvent;
  factory TvShowsLibraryEvent.addFavorite(TvShow tvShow) = _AddFavoriteEvent;
  factory TvShowsLibraryEvent.removeFavorite(TvShow tvShow) = _RemoveFavoriteEvent;
}

class _StartEvent extends TvShowsLibraryEvent {
  const _StartEvent() : super._();

  @override
  String toString() => 'TvShowsLibraryEvent: start';
}

class _GetMoreEvent extends TvShowsLibraryEvent {
  const _GetMoreEvent() : super._();

  @override
  String toString() => 'TvShowsLibraryEvent: get more series';
}

class _SearchEvent extends TvShowsLibraryEvent {
  final String name;
  const _SearchEvent(this.name) : super._();

  @override
  String toString() => 'TvShowsLibraryEvent: search series named $name';
}

class _SearchMoreEvent extends TvShowsLibraryEvent {
  const _SearchMoreEvent() : super._();

  @override
  String toString() => 'TvShowsLibraryEvent: search more series with same name';
}

class _GetFavoritesEvent extends TvShowsLibraryEvent {
  const _GetFavoritesEvent() : super._();

  @override
  String toString() => 'TvShowsLibraryEvent: get favorites';
}

class _AddFavoriteEvent extends TvShowsLibraryEvent {
  final TvShow tvShow;
  const _AddFavoriteEvent(this.tvShow) : super._();

  @override
  String toString() => 'TvShowsLibraryEvent: add ${tvShow.name} to favorites';
}

class _RemoveFavoriteEvent extends TvShowsLibraryEvent {
  final TvShow tvShow;
  const _RemoveFavoriteEvent(this.tvShow) : super._();

  @override
  String toString() => 'TvShowsLibraryEvent: remove ${tvShow.name} to favorites';
}