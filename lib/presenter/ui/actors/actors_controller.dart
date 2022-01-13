import 'dart:async';

import 'package:rafael_jobsity_challenge/domain/entities/actor.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_shows_library.dart';

import 'actors_state.dart';

part 'actors_events.dart';

class ActorController {


  final TvShowsLibrary _tvShowsLibrary;

  ActorController(Actor actor):
    _tvShowsLibrary = TvShowsLibrary.instance,
    super(){
    _currentState = ActorState.initial(actor);
    _update(_currentState);
    addEvent(ActorsEvent.start());
  }

  final StreamController<ActorState> _stateStreamController = StreamController();
  Stream<ActorState> get state => _stateStreamController.stream;
  late ActorState _currentState;


  //region Public --------------------------------------------------------------
  addEvent(ActorsEvent event){
    _onEvent(event);
  }

  close(){
    _tvShowsLibrary.close();
    _stateStreamController.close();
  }
  //endregion


  //region Private -------------------------------------------------------------
  Future _onEvent(ActorsEvent event) async {
    switch(event.runtimeType){
      case _StartEvent: await _onStart(event as _StartEvent);
      break;
      default: throw Exception('Event ${event.runtimeType} not process');
    }
  }

  _onStart(_StartEvent event) async {
    var tvShows = await _tvShowsLibrary.getActorsSeries(_currentState.actor.id);
    _update(_currentState.copyWith(tvShows: tvShows));
    print('Start ActorController');
  }

  _update(ActorState state) {
    _currentState = state;
    _stateStreamController.sink.add(state);
  }
  //endregion
}