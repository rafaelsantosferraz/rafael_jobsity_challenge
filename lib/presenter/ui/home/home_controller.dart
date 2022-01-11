import 'dart:async';

import 'package:rafael_jobsity_challenge/domain/entities/tv_shows_library.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/strings.dart';

import 'home_state.dart';

part 'home_events.dart';

class HomeController {

  final List<bool> _selectedGenres;
  final TvShowsLibrary _tvShowsLibrary;

  HomeController():
    _selectedGenres = List.generate(genres.length, (index) => false),
    _tvShowsLibrary = TvShowsLibrary.instance,
    super(){
    _update(currentState);
  }

  final StreamController<HomeState> _stateStreamController = StreamController();
  Stream<HomeState> get state => _stateStreamController.stream;
  HomeState _currentState = HomeState.initial();
  HomeState get currentState => _currentState;

  HomeState? _previousState;
  HomeState? get previousState => _previousState;


  //region Public --------------------------------------------------------------
  addEvent(HomeEvent event){
    _onEvent(event);
  }

  close(){
    _tvShowsLibrary.close();
    _stateStreamController.close();
  }
  //endregion


  //region Private -------------------------------------------------------------
  Future _onEvent(HomeEvent event) async {
    switch(event.runtimeType){
      case _StartEvent: await _onStart(event as _StartEvent);
      break;
      case _CategorySelectEvent: await _onCategorySelectEvent(event as _CategorySelectEvent);
      break;
      case _GenreTapEvent: await _onGenreTapEvent(event as _GenreTapEvent);
      break;
      case _SearchTextEvent: await _onSearchTextEvent(event as _SearchTextEvent);
      break;
      case _SearchToggleEvent: await _onSearchToggleEvent(event as _SearchToggleEvent);
      break;
      default: throw Exception('Event ${event.runtimeType} not process');
    }
  }

  _onStart(_StartEvent event) {
    _tvShowsLibrary.tvShows.listen((tvShows) {
      _update(currentState.copyWith(tvShows: tvShows));
    });
    _tvShowsLibrary.addEvent(TvShowsLibraryEvent.start());
    print('Start');
  }

  _onCategorySelectEvent(_CategorySelectEvent event) {
    _update(currentState.copyWith(selectCategory: event.category));
    if(event.category == favorites) {
      _tvShowsLibrary.favorites.listen((favorites) {
        _update(currentState.copyWith(favorites: favorites));
      });
    } else {
      _tvShowsLibrary.favorites.listen((favorites) {});
    }
    _tvShowsLibrary.addEvent(TvShowsLibraryEvent.getFavorites());
    print('Category select: ${event.category}');
  }

  _onGenreTapEvent(_GenreTapEvent event) {
    _selectedGenres[genres.indexOf(event.genre)] = !_selectedGenres[genres.indexOf(event.genre)];
    print('Genre tap: ${event.genre}(${_selectedGenres[genres.indexOf(event.genre)]})');
  }

  _onSearchTextEvent(_SearchTextEvent event) {
    _tvShowsLibrary.addEvent(TvShowsLibraryEvent.search(event.text));
    print('Search: ${event.text}');
  }

  _onSearchToggleEvent(_SearchToggleEvent event) {
    _update(currentState.copyWith(isSearching: event.isOpen));
    if(event.isOpen) {
      _tvShowsLibrary.search.listen((tvSearch) {
        _update(currentState.copyWith(tvSearch: tvSearch));
      });
    } else {
      _tvShowsLibrary.search.listen((tvShows) {});
    }
    print('Appbar search: ${event.isOpen}');
  }

  _update(HomeState state) {
    _previousState = _currentState;
    _currentState  = state;
    _stateStreamController.sink.add(state);
  }
  //endregion
}