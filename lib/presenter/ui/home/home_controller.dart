import 'package:rafael_jobsity_challenge/presenter/ui/common/strings.dart';

part 'home_events.dart';

class HomeController {

  final List<bool> _selectedGenres;

  HomeController():
    _selectedGenres = List.generate(genres.length, (index) => false);

  final List<HomeEvent> _events = [];


  //region Public --------------------------------------------------------------
  addEvent(HomeEvent event){
    _events.add(event);
    _onEvent(event);
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
      default: throw Exception('Event ${event.runtimeType} not process');
    }
  }

  _onStart(_StartEvent event) {
    print('Start');
  }

  _onCategorySelectEvent(_CategorySelectEvent event) {
    for (var genre in _selectedGenres) {
      genre = false;
    }
    print('Category select: ${event.category}');
  }

  _onGenreTapEvent(_GenreTapEvent event) {
    _selectedGenres[genres.indexOf(event.genre)] = !_selectedGenres[genres.indexOf(event.genre)];
    print('Genre tap: ${event.genre}(${_selectedGenres[genres.indexOf(event.genre)]})');
  }
  //endregion
}