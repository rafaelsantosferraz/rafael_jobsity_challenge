import 'dart:async';

import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_shows_library.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/strings.dart';

import 'tv_show_state.dart';

part 'tv_show_events.dart';

class TvShowController {

  final List<bool> _selectedGenres;
  final TvShowsLibrary _tvShowsLibrary;

  TvShowController(TvShow tvShow):
    _selectedGenres = List.generate(genres.length, (index) => false),
    _tvShowsLibrary = TvShowsLibrary.instance,
    super(){
    _currentState = TvShowState.initial(tvShow);
    _update(_currentState);
    addEvent(TvShowEvent.start());
  }

  final StreamController<TvShowState> _stateStreamController = StreamController();
  Stream<TvShowState> get state => _stateStreamController.stream;
  late TvShowState _currentState;


  //region Public --------------------------------------------------------------
  addEvent(TvShowEvent event){
    _onEvent(event);
  }

  close(){
    _tvShowsLibrary.close();
    _stateStreamController.close();
  }
  //endregion


  //region Private -------------------------------------------------------------
  Future _onEvent(TvShowEvent event) async {
    switch(event.runtimeType){
      case _StartEvent: await _onStart(event as _StartEvent);
      break;
      case _FavoriteEvent: await _onFavoriteEvent(event as _FavoriteEvent);
      break;
      default: throw Exception('Event ${event.runtimeType} not process');
    }
  }

  _onStart(_StartEvent event) async {
    if(_currentState.episodes == null) {
      var episodes = await _tvShowsLibrary.getEpisodes(_currentState.tvShow.id);
      _update(_currentState.copyWith(episodes: episodes));
    }
    print('Start TvShowController');
  }

  _onFavoriteEvent(_FavoriteEvent event) {
    for (var genre in _selectedGenres) {
      genre = false;
    }
    print('Favorite: ${event.tvShow.name}(${event.isFavorite})');
  }

  _update(TvShowState state) {
    _currentState = state;
    _stateStreamController.sink.add(state);
  }
  //endregion
}