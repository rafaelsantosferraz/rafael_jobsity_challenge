
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'widget_test.mocks.dart';

class Movie{
  final String title;
  Movie(this.title);

  @override
  String toString() {
    return "Movie: $title";
  }

  @override
  bool operator ==(Object other) {
    other as Movie;
    return other.title == title;
  }

  @override
  int get hashCode => title.hashCode;
}

typedef Series = Stream<List<Movie>>;
class MovieLibrary{

  final MovieRepository _movieRepository;
  MovieLibrary(this._movieRepository);

  final StreamController<List<Movie>> _seriesStream = StreamController();
  final StreamController<List<Movie>> _searchStream = StreamController();


  Series get series => _seriesStream.stream;
  Series get search => _searchStream.stream;

  final _eventsQueue = <MovieLibraryEvent>[];
  final _eventsHistory = <MovieLibraryEvent>[];




  //region Public --------------------------------------------------------------
  addEvent(MovieLibraryEvent event) async {
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
    _seriesStream.close();
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

  Future _onEvent(MovieLibraryEvent event) async {
    switch(event.runtimeType){
      case MovieLibraryStartEvent: await _onStart(event as MovieLibraryStartEvent);
      break;
      case MovieLibraryGetMoreSeriesEvent: await _onGetMoreSeries(event as MovieLibraryGetMoreSeriesEvent);
      break;
      case MovieLibrarySearchSeriesEvent: await _onSearchSeries(event as MovieLibrarySearchSeriesEvent);
      break;
      case MovieLibrarySearchMoreSeriesEvent: await _onSearchMoreSeries(event as MovieLibrarySearchMoreSeriesEvent);
      break;
      default: throw Exception('Event ${event.runtimeType} not process');
    }
  }

  Future _onStart(MovieLibraryStartEvent event) async {
    var series = await _movieRepository.getSeries();
    _seriesStream.sink.add(series);
  }

  Future _onGetMoreSeries(MovieLibraryGetMoreSeriesEvent event) async {
    var series = await _movieRepository.getMoreSeries();
    _seriesStream.sink.add(series);
  }

  Future _onSearchSeries(MovieLibrarySearchSeriesEvent event) async {
    var series = await _movieRepository.searchSeries(event.name);
    _searchStream.sink.add(series);
  }

  Future _onSearchMoreSeries(MovieLibrarySearchMoreSeriesEvent event) async {
    var series = await _movieRepository.searchMoreSeries();
    _searchStream.sink.add(series);
  }
  //endRegion
}



class MovieLibraryEvent{

  const MovieLibraryEvent._();

  factory MovieLibraryEvent.start() = MovieLibraryStartEvent;
  factory MovieLibraryEvent.getMoreSeries() = MovieLibraryGetMoreSeriesEvent;
  factory MovieLibraryEvent.searchSeries(String name) = MovieLibrarySearchSeriesEvent;
  factory MovieLibraryEvent.searchMoreSeries() = MovieLibrarySearchMoreSeriesEvent;
}

class MovieLibraryStartEvent extends MovieLibraryEvent {
  const MovieLibraryStartEvent() : super._();

  @override
  String toString() => 'MovieLibraryEvent: start';
}

class MovieLibraryGetMoreSeriesEvent extends MovieLibraryEvent {
  const MovieLibraryGetMoreSeriesEvent() : super._();

  @override
  String toString() => 'MovieLibraryEvent: get more series';
}

class MovieLibrarySearchSeriesEvent extends MovieLibraryEvent {
  final String name;
  const MovieLibrarySearchSeriesEvent(this.name) : super._();

  @override
  String toString() => 'MovieLibraryEvent: search series named $name';
}

class MovieLibrarySearchMoreSeriesEvent extends MovieLibraryEvent {
  const MovieLibrarySearchMoreSeriesEvent() : super._();

  @override
  String toString() => 'MovieLibraryEvent: search more series with same name';
}



class MovieRepository {

  final MovieRemoteDataSource _movieRemoteDataSource;

  MovieRepository(this._movieRemoteDataSource);

  final seriesPagination = <List<Movie>>[];
  final searchPagination = <List<Movie>>[];
  String searchInput = '';

  ///Get first page of series
  Future<List<Movie>> getSeries() async{
    var series = await _movieRemoteDataSource.getSeries();
    seriesPagination.clear();
    seriesPagination.add(series);
    return seriesPagination.expand<Movie>((pageSeries) => pageSeries).toList();
  }

  ///Get next page series. If there's no more pages, it return list without
  ///changes
  Future<List<Movie>> getMoreSeries() async{
    assert(seriesPagination.isNotEmpty);
    var series = await _movieRemoteDataSource.getSeries(seriesPagination.length);
    seriesPagination.add(series);
    return seriesPagination.expand<Movie>((pageSeries) => pageSeries).toList();
  }

  Future<List<Movie>> searchSeries(String name) async{
    searchInput = name;
    var series = await _movieRemoteDataSource.searchSeries(name: name);
    searchPagination.clear();
    searchPagination.add(series);
    return searchPagination.expand<Movie>((pageSeries) => pageSeries).toList();
  }

  Future<List<Movie>> searchMoreSeries() async{
    assert(searchPagination.isNotEmpty);
    var series = await _movieRemoteDataSource.searchSeries(name: searchInput, page: searchPagination.length);
    searchPagination.add(series);
    return searchPagination.expand<Movie>((pageSeries) => pageSeries).toList();
  }
}

class MovieRemoteDataSource{

  Future<List<Movie>> getSeries([int page = 0]) async{
    return []; //todo: API call
  }

  Future<List<Movie>> searchSeries({required String name, int? page = 0}) async{
    return []; //todo: API call
  }
}


@GenerateMocks([MovieRepository, MovieRemoteDataSource])
void main() {

  group('List all of the series contained in the API used by the paging scheme provided by the API.', (){

    final mockMovieRepository = MockMovieRepository();
    final mockMovieRemoteDataSource = MockMovieRemoteDataSource();

    test('WHEN movie library start, movie library SHOULD fetch from movie repository and stream result ', () async {
      // Given/Arrange

      final movieLibrary = MovieLibrary(mockMovieRepository);
      final mockDbSeries = [
        Movie('1'),
        Movie('2'),
        Movie('3'),
        Movie('4'),
        Movie('5'),
      ];
      when(mockMovieRepository.getSeries()).thenAnswer((_) async => mockDbSeries);

      // When/Act
      movieLibrary.addEvent(MovieLibraryEvent.start());

      // Then/Assert
      expectLater(movieLibrary.series, emits(mockDbSeries));
    });

    test('WHEN get more series, movie library SHOULD fetch from movie repository next page until no more series and stream result', () async {
      // Given/Arrange
      final movieRepository = MovieRepository(mockMovieRemoteDataSource);
      var movieLibrary = MovieLibrary(movieRepository);
      final seriesByPage = <int, List<Movie>>{
        0:[
          Movie('01'),
          Movie('02'),
          Movie('03'),
        ],
        1:[
          Movie('11'),
          Movie('12'),
          Movie('13'),
        ],
        2:[
          Movie('21'),
          Movie('22'),
          Movie('23'),
        ]
      };
      when(mockMovieRemoteDataSource.getSeries(0)).thenAnswer((_) async => seriesByPage[0]!);
      when(mockMovieRemoteDataSource.getSeries(1)).thenAnswer((_) async => seriesByPage[1]!);
      when(mockMovieRemoteDataSource.getSeries(2)).thenAnswer((_) async => seriesByPage[2]!);
      when(mockMovieRemoteDataSource.getSeries(3)).thenAnswer((_) async => []);

      // When/Act
      movieLibrary.addEvent(MovieLibraryEvent.start());
      movieLibrary.addEvent(MovieLibraryEvent.getMoreSeries());
      movieLibrary.addEvent(MovieLibraryEvent.getMoreSeries());
      movieLibrary.addEvent(MovieLibraryEvent.getMoreSeries());

      // Then/Assert
      expectLater(movieLibrary.series, emitsInOrder([
        seriesByPage[0],
        List.of([
          ...seriesByPage[0]!,
          ...seriesByPage[1]!
        ]),
        List.of([
          ...seriesByPage[0]!,
          ...seriesByPage[1]!,
          ...seriesByPage[2]!
        ]),
        List.of([
          ...seriesByPage[0]!,
          ...seriesByPage[1]!,
          ...seriesByPage[2]!
        ])
      ]));
    });
  });

  group('Allow users to search series by name.',(){
    final mockMovieRemoteDataSource = MockMovieRemoteDataSource();

    test('WHEN user input search parameter, SHOULD fetch from movie repository series with that input parameter and stream result ', () async {
      // Given/Arrange
      final movieRepository = MovieRepository(mockMovieRemoteDataSource);
      final movieLibrary = MovieLibrary(movieRepository);
      const searchInput = 'love';
      final mockDbSeriesSearchResult = [
        Movie('in love'),
        Movie('only love'),
        Movie('always love'),
        Movie('never love'),
        Movie('even more love'),
      ];
      when(mockMovieRemoteDataSource.searchSeries(name: searchInput)).thenAnswer((_) async => mockDbSeriesSearchResult);

      // When/Act
      movieLibrary.addEvent(MovieLibraryEvent.searchSeries(searchInput));

      // Then/Assert
      expectLater(movieLibrary.search, emits(mockDbSeriesSearchResult));
    });

    test('WHEN user input search parameter, SHOULD search from movie repository series with that input parameter and stream result ', () async {
      // Given/Arrange
      final movieRepository = MovieRepository(mockMovieRemoteDataSource);
      final movieLibrary = MovieLibrary(movieRepository);
      const searchInput = 'love';
      final mockDbSeriesSearchResult = [
        Movie('in love'),
        Movie('only love'),
        Movie('always love'),
        Movie('never love'),
        Movie('even more love'),
      ];
      when(mockMovieRemoteDataSource.searchSeries(name: searchInput)).thenAnswer((_) async => mockDbSeriesSearchResult);

      // When/Act
      movieLibrary.addEvent(MovieLibraryEvent.searchSeries(searchInput));

      // Then/Assert
      expectLater(movieLibrary.search, emits(mockDbSeriesSearchResult));
    });

    test('WHEN search more, movie library SHOULD search from movie repository next page until no more series and stream result', () async {
      // Given/Arrange
      final movieRepository = MovieRepository(mockMovieRemoteDataSource);
      final movieLibrary = MovieLibrary(movieRepository);
      const searchInput = 'love';
      final searchResultPages = <int, List<Movie>>{
        0:[
          Movie('in love'),
          Movie('only love'),
          Movie('always love')
        ],
        1:[
          Movie('never love'),
          Movie('even more love'),
          Movie('everything is love'),
        ],
        2:[
          Movie('same old love'),
          Movie('more then just usual love'),
          Movie('double infinity love'),
        ]
      };
      when(mockMovieRemoteDataSource.searchSeries(name: searchInput)).thenAnswer((_) async => searchResultPages[0]!);
      when(mockMovieRemoteDataSource.searchSeries(name: searchInput, page: 1)).thenAnswer((_) async => searchResultPages[1]!);
      when(mockMovieRemoteDataSource.searchSeries(name: searchInput, page: 2)).thenAnswer((_) async => searchResultPages[2]!);
      when(mockMovieRemoteDataSource.searchSeries(name: searchInput, page: 3)).thenAnswer((_) async => []);

      // When/Act
      movieLibrary.addEvent(MovieLibraryEvent.searchSeries(searchInput));
      movieLibrary.addEvent(MovieLibraryEvent.searchMoreSeries());
      movieLibrary.addEvent(MovieLibraryEvent.searchMoreSeries());
      movieLibrary.addEvent(MovieLibraryEvent.searchMoreSeries());

      // Then/Assert
      expectLater(movieLibrary.search, emitsInOrder([
        searchResultPages[0],
        List.of([
          ...searchResultPages[0]!,
          ...searchResultPages[1]!
        ]),
        List.of([
          ...searchResultPages[0]!,
          ...searchResultPages[1]!,
          ...searchResultPages[2]!
        ]),
        List.of([
          ...searchResultPages[0]!,
          ...searchResultPages[1]!,
          ...searchResultPages[2]!
        ])
      ]));
    });

  });
}
