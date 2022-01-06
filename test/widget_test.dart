
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'widget_test.mocks.dart';

class Episode {

  final String name;

  Episode({
    required this.name
  });

  factory Episode.fromJson(Map<String, dynamic> json){
    return Episode(
        name: json['name']
    );
  }
}


class ASeries{
  final String name;
  final String posterUrl;
  final DateTime airs;
  final List<String> genres;
  final String summary;
  final List<Episode> episodes;

  ASeries({
    required this.name,
    required this.posterUrl,
    required this.airs,
    required this.genres,
    required this.summary,
    required this.episodes
  });

  factory ASeries.fromJson(Map<String, dynamic> json){
    return ASeries(
        name: json['name'],
        posterUrl: json['posterUrl'],
        airs: DateTime.fromMillisecondsSinceEpoch(json['airs']),
        genres: json['genres'],
        summary: json['summary'],
        episodes: (json['episodes'] as List<Map<String, dynamic>>)
            .map<Episode>((episodeJson) => Episode.fromJson(episodeJson))
            .toList()
    );
  }

  @override
  String toString() {
    return "Series: $name";
  }

  @override
  bool operator ==(Object other) {
    other as ASeries;
    return other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

typedef Series = Stream<List<ASeries>>;
class SeriesLibrary{

  final SeriesRepository _movieRepository;
  SeriesLibrary(this._movieRepository);

  final StreamController<List<ASeries>> _seriesStream = StreamController();
  final StreamController<List<ASeries>> _searchStream = StreamController();


  Series get series => _seriesStream.stream;
  Series get search => _searchStream.stream;

  final _eventsQueue = <SeriesLibraryEvent>[];
  final _eventsHistory = <SeriesLibraryEvent>[];




  //region Public --------------------------------------------------------------
  addEvent(SeriesLibraryEvent event) async {
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

  Future _onEvent(SeriesLibraryEvent event) async {
    switch(event.runtimeType){
      case SeriesLibraryStartEvent: await _onStart(event as SeriesLibraryStartEvent);
      break;
      case SeriesLibraryGetMoreSeriesEvent: await _onGetMoreSeries(event as SeriesLibraryGetMoreSeriesEvent);
      break;
      case SeriesLibrarySearchSeriesEvent: await _onSearchSeries(event as SeriesLibrarySearchSeriesEvent);
      break;
      case SeriesLibrarySearchMoreSeriesEvent: await _onSearchMoreSeries(event as SeriesLibrarySearchMoreSeriesEvent);
      break;
      default: throw Exception('Event ${event.runtimeType} not process');
    }
  }

  Future _onStart(SeriesLibraryStartEvent event) async {
    var series = await _movieRepository.getSeries();
    _seriesStream.sink.add(series);
  }

  Future _onGetMoreSeries(SeriesLibraryGetMoreSeriesEvent event) async {
    var series = await _movieRepository.getMoreSeries();
    _seriesStream.sink.add(series);
  }

  Future _onSearchSeries(SeriesLibrarySearchSeriesEvent event) async {
    var series = await _movieRepository.searchSeries(event.name);
    _searchStream.sink.add(series);
  }

  Future _onSearchMoreSeries(SeriesLibrarySearchMoreSeriesEvent event) async {
    var series = await _movieRepository.searchMoreSeries();
    _searchStream.sink.add(series);
  }
  //endRegion
}



class SeriesLibraryEvent{

  const SeriesLibraryEvent._();

  factory SeriesLibraryEvent.start() = SeriesLibraryStartEvent;
  factory SeriesLibraryEvent.getMoreSeries() = SeriesLibraryGetMoreSeriesEvent;
  factory SeriesLibraryEvent.searchSeries(String name) = SeriesLibrarySearchSeriesEvent;
  factory SeriesLibraryEvent.searchMoreSeries() = SeriesLibrarySearchMoreSeriesEvent;
}

class SeriesLibraryStartEvent extends SeriesLibraryEvent {
  const SeriesLibraryStartEvent() : super._();

  @override
  String toString() => 'SeriesLibraryEvent: start';
}

class SeriesLibraryGetMoreSeriesEvent extends SeriesLibraryEvent {
  const SeriesLibraryGetMoreSeriesEvent() : super._();

  @override
  String toString() => 'SeriesLibraryEvent: get more series';
}

class SeriesLibrarySearchSeriesEvent extends SeriesLibraryEvent {
  final String name;
  const SeriesLibrarySearchSeriesEvent(this.name) : super._();

  @override
  String toString() => 'SeriesLibraryEvent: search series named $name';
}

class SeriesLibrarySearchMoreSeriesEvent extends SeriesLibraryEvent {
  const SeriesLibrarySearchMoreSeriesEvent() : super._();

  @override
  String toString() => 'SeriesLibraryEvent: search more series with same name';
}



class SeriesRepository {

  final SeriesRemoteDataSource _movieRemoteDataSource;

  SeriesRepository(this._movieRemoteDataSource);

  final seriesPagination = <List<ASeries>>[];
  final searchPagination = <List<ASeries>>[];
  String searchInput = '';

  ///Get first page of series
  Future<List<ASeries>> getSeries() async{
    var series = await _movieRemoteDataSource.getSeries();
    seriesPagination.clear();
    seriesPagination.add(series);
    return seriesPagination.expand<ASeries>((pageSeries) => pageSeries).toList();
  }

  ///Get next page series. If there's no more pages, it return list without
  ///changes
  Future<List<ASeries>> getMoreSeries() async{
    assert(seriesPagination.isNotEmpty);
    var series = await _movieRemoteDataSource.getSeries(seriesPagination.length);
    seriesPagination.add(series);
    return seriesPagination.expand<ASeries>((pageSeries) => pageSeries).toList();
  }

  Future<List<ASeries>> searchSeries(String name) async{
    searchInput = name;
    var series = await _movieRemoteDataSource.searchSeries(name: name);
    searchPagination.clear();
    searchPagination.add(series);
    return searchPagination.expand<ASeries>((pageSeries) => pageSeries).toList();
  }

  Future<List<ASeries>> searchMoreSeries() async{
    assert(searchPagination.isNotEmpty);
    var series = await _movieRemoteDataSource.searchSeries(name: searchInput, page: searchPagination.length);
    searchPagination.add(series);
    return searchPagination.expand<ASeries>((pageSeries) => pageSeries).toList();
  }
}

class SeriesRemoteDataSource{

  Future<List<ASeries>> getSeries([int page = 0]) async{
    return []; //todo: API call
  }

  Future<List<ASeries>> searchSeries({required String name, int? page = 0}) async{
    return []; //todo: API call
  }
}


@GenerateMocks([SeriesRepository, SeriesRemoteDataSource])
void main() {

  ASeries FakeEmptySingleSerie(String name){
    return ASeries(
        name: name,
        posterUrl: "",
        airs: DateTime.now(),
        genres: [],
        summary: "",
        episodes: []);
  }
  group('List all of the series contained in the API used by the paging scheme provided by the API.', (){

    final mockSeriesRepository = MockSeriesRepository();
    final mockSeriesRemoteDataSource = MockSeriesRemoteDataSource();

    test('WHEN movie library start, movie library SHOULD fetch from movie repository and stream result ', () async {
      // Given/Arrange

      final movieLibrary = SeriesLibrary(mockSeriesRepository);
      final mockDbSeries = [
        FakeEmptySingleSerie('1'),
        FakeEmptySingleSerie('2'),
        FakeEmptySingleSerie('3'),
        FakeEmptySingleSerie('4'),
        FakeEmptySingleSerie('5'),
      ];
      when(mockSeriesRepository.getSeries()).thenAnswer((_) async => mockDbSeries);

      // When/Act
      movieLibrary.addEvent(SeriesLibraryEvent.start());

      // Then/Assert
      expectLater(movieLibrary.series, emits(mockDbSeries));
    });

    test('WHEN get more series, movie library SHOULD fetch from movie repository next page until no more series and stream result', () async {
      // Given/Arrange
      final movieRepository = SeriesRepository(mockSeriesRemoteDataSource);
      var movieLibrary = SeriesLibrary(movieRepository);
      final seriesByPage = <int, List<ASeries>>{
        0:[
          FakeEmptySingleSerie('01'),
          FakeEmptySingleSerie('02'),
          FakeEmptySingleSerie('03'),
        ],
        1:[
          FakeEmptySingleSerie('11'),
          FakeEmptySingleSerie('12'),
          FakeEmptySingleSerie('13'),
        ],
        2:[
          FakeEmptySingleSerie('21'),
          FakeEmptySingleSerie('22'),
          FakeEmptySingleSerie('23'),
        ]
      };
      when(mockSeriesRemoteDataSource.getSeries(0)).thenAnswer((_) async => seriesByPage[0]!);
      when(mockSeriesRemoteDataSource.getSeries(1)).thenAnswer((_) async => seriesByPage[1]!);
      when(mockSeriesRemoteDataSource.getSeries(2)).thenAnswer((_) async => seriesByPage[2]!);
      when(mockSeriesRemoteDataSource.getSeries(3)).thenAnswer((_) async => []);

      // When/Act
      movieLibrary.addEvent(SeriesLibraryEvent.start());
      movieLibrary.addEvent(SeriesLibraryEvent.getMoreSeries());
      movieLibrary.addEvent(SeriesLibraryEvent.getMoreSeries());
      movieLibrary.addEvent(SeriesLibraryEvent.getMoreSeries());

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
    final mockSeriesRemoteDataSource = MockSeriesRemoteDataSource();

    test('WHEN user input search parameter, SHOULD fetch from movie repository series with that input parameter and stream result ', () async {
      // Given/Arrange
      final movieRepository = SeriesRepository(mockSeriesRemoteDataSource);
      final movieLibrary = SeriesLibrary(movieRepository);
      const searchInput = 'love';
      final mockDbSeriesSearchResult = [
        FakeEmptySingleSerie('in love'),
        FakeEmptySingleSerie('only love'),
        FakeEmptySingleSerie('always love'),
        FakeEmptySingleSerie('never love'),
        FakeEmptySingleSerie('even more love'),
      ];
      when(mockSeriesRemoteDataSource.searchSeries(name: searchInput)).thenAnswer((_) async => mockDbSeriesSearchResult);

      // When/Act
      movieLibrary.addEvent(SeriesLibraryEvent.searchSeries(searchInput));

      // Then/Assert
      expectLater(movieLibrary.search, emits(mockDbSeriesSearchResult));
    });

    test('WHEN user input search parameter, SHOULD search from movie repository series with that input parameter and stream result ', () async {
      // Given/Arrange
      final movieRepository = SeriesRepository(mockSeriesRemoteDataSource);
      final movieLibrary = SeriesLibrary(movieRepository);
      const searchInput = 'love';
      final mockDbSeriesSearchResult = [
        FakeEmptySingleSerie('in love'),
        FakeEmptySingleSerie('only love'),
        FakeEmptySingleSerie('always love'),
        FakeEmptySingleSerie('never love'),
        FakeEmptySingleSerie('even more love'),
      ];
      when(mockSeriesRemoteDataSource.searchSeries(name: searchInput)).thenAnswer((_) async => mockDbSeriesSearchResult);

      // When/Act
      movieLibrary.addEvent(SeriesLibraryEvent.searchSeries(searchInput));

      // Then/Assert
      expectLater(movieLibrary.search, emits(mockDbSeriesSearchResult));
    });

    test('WHEN search more, movie library SHOULD search from movie repository next page until no more series and stream result', () async {
      // Given/Arrange
      final movieRepository = SeriesRepository(mockSeriesRemoteDataSource);
      final movieLibrary = SeriesLibrary(movieRepository);
      const searchInput = 'love';
      final searchResultPages = <int, List<ASeries>>{
        0:[
          FakeEmptySingleSerie('in love'),
          FakeEmptySingleSerie('only love'),
          FakeEmptySingleSerie('always love')
        ],
        1:[
          FakeEmptySingleSerie('never love'),
          FakeEmptySingleSerie('even more love'),
          FakeEmptySingleSerie('everything is love'),
        ],
        2:[
          FakeEmptySingleSerie('same old love'),
          FakeEmptySingleSerie('more then just usual love'),
          FakeEmptySingleSerie('double infinity love'),
        ]
      };
      when(mockSeriesRemoteDataSource.searchSeries(name: searchInput)).thenAnswer((_) async => searchResultPages[0]!);
      when(mockSeriesRemoteDataSource.searchSeries(name: searchInput, page: 1)).thenAnswer((_) async => searchResultPages[1]!);
      when(mockSeriesRemoteDataSource.searchSeries(name: searchInput, page: 2)).thenAnswer((_) async => searchResultPages[2]!);
      when(mockSeriesRemoteDataSource.searchSeries(name: searchInput, page: 3)).thenAnswer((_) async => []);

      // When/Act
      movieLibrary.addEvent(SeriesLibraryEvent.searchSeries(searchInput));
      movieLibrary.addEvent(SeriesLibraryEvent.searchMoreSeries());
      movieLibrary.addEvent(SeriesLibraryEvent.searchMoreSeries());
      movieLibrary.addEvent(SeriesLibraryEvent.searchMoreSeries());

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

    group('After clicking on a series, the application should show the details of the series', (){

      test('When parse from json, series SHOULD have Name, Poster, Days and time during which the series airs, Genres, Summary, List of episodes separated by season', (){
        //Given/Arrange
        var json = {
          'name': 'name',
          'posterUrl': 'posterUrl',
          'airs': DateTime.now().millisecondsSinceEpoch,
          'genres': ['love, horror'],
          'summary': 'summary',
          'episodes': [
            {'name': 'name'},
            {'name': 'name'},
            {'name': 'name'}
          ],
        };
        late ASeries aSeries;

        //When/Act
        aSeries = ASeries.fromJson(json);

        //Then/Assert
        expect(aSeries, isNot(equals(null)));
        expect(aSeries.name, isNot(equals(null)));
        expect(aSeries.posterUrl, isNot(equals(null)));
        expect(aSeries.airs, isNot(equals(null)));
        expect(aSeries.genres, isNot(equals(null)));
        expect(aSeries.summary, isNot(equals(null)));
        expect(aSeries.episodes, isNot(equals(null)));
      });
    });
  });
}
