import 'dart:async';

import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/domain/repositories_interfaces/tv_shows_repository_interface.dart';

typedef TvShows = Stream<List<TvShow>>;
class TvShowsLibrary{

  final TvShowsRepositoryInterface _tvShowsRepository;
  TvShowsLibrary(this._tvShowsRepository);

  final StreamController<List<TvShow>> _tvShowsStream = StreamController();
  final StreamController<List<TvShow>> _searchStream  = StreamController();


  TvShows get tvShows => _tvShowsStream.stream;
  TvShows get search => _searchStream.stream;

  final _eventsQueue = <TvShowsLibraryEvent>[];
  final _eventsHistory = <TvShowsLibraryEvent>[];




  //region Public --------------------------------------------------------------
  addEvent(TvShowsLibraryEvent event) async {
    _eventsQueue.add(event);
    if(_eventsQueue.length == 1){
      _processNextEvent();
    }
  }

  printEventHistory(){
    for(var event in _eventsHistory){
      print(event);
    }
  }

  close(){
    _tvShowsStream.close();
  }
  //endregion


  //region Private -------------------------------------------------------------
  ///Controls that every event get process in order of arrival to avoid any race
  ///conditions
  Future _processNextEvent() async {
    if(_eventsQueue.isNotEmpty){
      await _onEvent(_eventsQueue.first);
      _eventsHistory.add(_eventsQueue.first);
      _eventsQueue.removeAt(0);
      _processNextEvent();
    }
  }

  Future _onEvent(TvShowsLibraryEvent event) async {
    switch(event.runtimeType){
      case _TvShowsLibraryStartEvent: await _onStart(event as _TvShowsLibraryStartEvent);
      break;
      case _TvShowsLibraryGetMoreTvShowsEvent: await _onGetMoreTvShows(event as _TvShowsLibraryGetMoreTvShowsEvent);
      break;
      case _TvShowsLibrarySearchTvShowsEvent: await _onSearchTvShows(event as _TvShowsLibrarySearchTvShowsEvent);
      break;
      case _TvShowsLibrarySearchMoreTvShowsEvent: await _onSearchMoreTvShows(event as _TvShowsLibrarySearchMoreTvShowsEvent);
      break;
      default: throw Exception('Event ${event.runtimeType} not process');
    }
  }

  Future _onStart(_TvShowsLibraryStartEvent event) async {
    var tvShows = await _tvShowsRepository.getTvShows();
    _tvShowsStream.sink.add(tvShows);
  }

  Future _onGetMoreTvShows(_TvShowsLibraryGetMoreTvShowsEvent event) async {
    var tvShows = await _tvShowsRepository.getMoreTvShows();
    _tvShowsStream.sink.add(tvShows);
  }

  Future _onSearchTvShows(_TvShowsLibrarySearchTvShowsEvent event) async {
    var search = await _tvShowsRepository.searchTvShows(event.name);
    _searchStream.sink.add(search);
  }

  Future _onSearchMoreTvShows(_TvShowsLibrarySearchMoreTvShowsEvent event) async {
    var search = await _tvShowsRepository.searchMoreTvShows();
    _searchStream.sink.add(search);
  }
//endRegion
}

class TvShowsLibraryEvent{

  const TvShowsLibraryEvent._();

  factory TvShowsLibraryEvent.start() = _TvShowsLibraryStartEvent;
  factory TvShowsLibraryEvent.getMoreTvShows() = _TvShowsLibraryGetMoreTvShowsEvent;
  factory TvShowsLibraryEvent.searchTvShows(String name) = _TvShowsLibrarySearchTvShowsEvent;
  factory TvShowsLibraryEvent.searchMoreTvShows() = _TvShowsLibrarySearchMoreTvShowsEvent;
}

class _TvShowsLibraryStartEvent extends TvShowsLibraryEvent {
  const _TvShowsLibraryStartEvent() : super._();

  @override
  String toString() => 'TvShowsLibraryEvent: start';
}

class _TvShowsLibraryGetMoreTvShowsEvent extends TvShowsLibraryEvent {
  const _TvShowsLibraryGetMoreTvShowsEvent() : super._();

  @override
  String toString() => 'TvShowsLibraryEvent: get more series';
}

class _TvShowsLibrarySearchTvShowsEvent extends TvShowsLibraryEvent {
  final String name;
  const _TvShowsLibrarySearchTvShowsEvent(this.name) : super._();

  @override
  String toString() => 'TvShowsLibraryEvent: search series named $name';
}

class _TvShowsLibrarySearchMoreTvShowsEvent extends TvShowsLibraryEvent {
  const _TvShowsLibrarySearchMoreTvShowsEvent() : super._();

  @override
  String toString() => 'TvShowsLibraryEvent: search more series with same name';
}