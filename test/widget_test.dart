
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'widget_test.mocks.dart';

class Movie{
  final String title;
  Movie(this.title);
}

typedef Series = Stream<List<Movie>>;
class MovieLibrary{

  final MovieRepository _movieRepository;
  MovieLibrary(this._movieRepository);

  final StreamController<List<Movie>> _seriesStream = StreamController();


  Series get series => _seriesStream.stream;

  addEvent(MovieLibraryEvent event){
    _onEvent(event);
  }

  //region Private -------------------------------------------------------------
  _onEvent(MovieLibraryEvent event){
    switch(event.runtimeType){
      case MovieLibraryStartEvent: _onStart(event as MovieLibraryStartEvent);
      break;
    }
  }

  void _onStart(MovieLibraryStartEvent event) async {
    var series = await _movieRepository.getSeries();
    _seriesStream.sink.add(series);
  }
  //endRegion


  //region Public --------------------------------------------------------------
  close(){
    _seriesStream.close();
  }
  //endregion
}



class MovieLibraryEvent{

  const MovieLibraryEvent._();

  factory MovieLibraryEvent.start() = MovieLibraryStartEvent;
}

class MovieLibraryStartEvent extends MovieLibraryEvent {
  const MovieLibraryStartEvent() : super._();
}

class MovieRepository {

  Future<List<Movie>> getSeries() async{
    return [];
  }
}


@GenerateMocks([MovieRepository])
void main() {

  group('WHEN app start, app SHOULD list all of the series contained in the API used by the paging scheme provided by the API.', (){

    final movieRepository = MockMovieRepository();

    test('On movie library start EVENT, movie library SHOULD fetch from movie repository and stream result ', () async {
      // Given/Arrange
      var movieLibrary = MovieLibrary(movieRepository);
      var mockDbSeries = [
        Movie('1'),
        Movie('2'),
        Movie('3'),
        Movie('4'),
        Movie('5'),
      ];
      when(movieRepository.getSeries()).thenAnswer((_) async => mockDbSeries);

      // When/Act
      movieLibrary.addEvent(MovieLibraryEvent.start());

      // Then/Assert
      expectLater(movieLibrary.series, emits(mockDbSeries));
    });
  });

}
