import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rafael_jobsity_challenge/data/datasources/remote/tv_shows_remote_datasource.dart';
import 'package:rafael_jobsity_challenge/data/repositories/tv_shows_repository.dart';
import 'package:rafael_jobsity_challenge/domain/entities/episode.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_shows_library.dart';

import 'widget_test.mocks.dart';


@GenerateMocks([TvShowsRepository, TvShowsRemoteDataSource])
void main() {

  TvShow FakeEmptyTvShow(String name){
    return TvShow(
        name: name,
        posterUrl: "",
        airs: DateTime.now(),
        genres: [],
        summary: "",
        episodes: []);
  }
  group('List all of the series contained in the API used by the paging scheme provided by the API.', (){

    final mockTvShowsRepository = MockTvShowsRepository();
    final mockTvShowsRemoteDataSource = MockTvShowsRemoteDataSource();

    test('WHEN movie library start, movie library SHOULD fetch from movie repository and stream result ', () async {
      // Given/Arrange

      final movieLibrary = TvShowsLibrary(mockTvShowsRepository);
      final mockDbTvShows = [
        FakeEmptyTvShow('1'),
        FakeEmptyTvShow('2'),
        FakeEmptyTvShow('3'),
        FakeEmptyTvShow('4'),
        FakeEmptyTvShow('5'),
      ];
      when(mockTvShowsRepository.getTvShows()).thenAnswer((_) async => mockDbTvShows);

      // When/Act
      movieLibrary.addEvent(TvShowsLibraryEvent.start());

      // Then/Assert
      expectLater(movieLibrary.tvShows, emits(mockDbTvShows));
    });

    test('WHEN get more series, movie library SHOULD fetch from movie repository next page until no more series and stream result', () async {
      // Given/Arrange
      final movieRepository = TvShowsRepository(mockTvShowsRemoteDataSource);
      var movieLibrary = TvShowsLibrary(movieRepository);
      final seriesByPage = <int, List<TvShow>>{
        0:[
          FakeEmptyTvShow('01'),
          FakeEmptyTvShow('02'),
          FakeEmptyTvShow('03'),
        ],
        1:[
          FakeEmptyTvShow('11'),
          FakeEmptyTvShow('12'),
          FakeEmptyTvShow('13'),
        ],
        2:[
          FakeEmptyTvShow('21'),
          FakeEmptyTvShow('22'),
          FakeEmptyTvShow('23'),
        ]
      };
      when(mockTvShowsRemoteDataSource.getTvShows(0)).thenAnswer((_) async => seriesByPage[0]!);
      when(mockTvShowsRemoteDataSource.getTvShows(1)).thenAnswer((_) async => seriesByPage[1]!);
      when(mockTvShowsRemoteDataSource.getTvShows(2)).thenAnswer((_) async => seriesByPage[2]!);
      when(mockTvShowsRemoteDataSource.getTvShows(3)).thenAnswer((_) async => []);

      // When/Act
      movieLibrary.addEvent(TvShowsLibraryEvent.start());
      movieLibrary.addEvent(TvShowsLibraryEvent.getMoreTvShows());
      movieLibrary.addEvent(TvShowsLibraryEvent.getMoreTvShows());
      movieLibrary.addEvent(TvShowsLibraryEvent.getMoreTvShows());

      // Then/Assert
      expectLater(movieLibrary.tvShows, emitsInOrder([
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
    final mockTvShowsRemoteDataSource = MockTvShowsRemoteDataSource();

    test('WHEN user input search parameter, SHOULD fetch from movie repository series with that input parameter and stream result ', () async {
      // Given/Arrange
      final movieRepository = TvShowsRepository(mockTvShowsRemoteDataSource);
      final movieLibrary = TvShowsLibrary(movieRepository);
      const searchInput = 'love';
      final mockDbTvShowsSearchResult = [
        FakeEmptyTvShow('in love'),
        FakeEmptyTvShow('only love'),
        FakeEmptyTvShow('always love'),
        FakeEmptyTvShow('never love'),
        FakeEmptyTvShow('even more love'),
      ];
      when(mockTvShowsRemoteDataSource.searchTvShows(name: searchInput)).thenAnswer((_) async => mockDbTvShowsSearchResult);

      // When/Act
      movieLibrary.addEvent(TvShowsLibraryEvent.searchTvShows(searchInput));

      // Then/Assert
      expectLater(movieLibrary.search, emits(mockDbTvShowsSearchResult));
    });

    test('WHEN user input search parameter, SHOULD search from movie repository series with that input parameter and stream result ', () async {
      // Given/Arrange
      final movieRepository = TvShowsRepository(mockTvShowsRemoteDataSource);
      final movieLibrary = TvShowsLibrary(movieRepository);
      const searchInput = 'love';
      final mockDbTvShowsSearchResult = [
        FakeEmptyTvShow('in love'),
        FakeEmptyTvShow('only love'),
        FakeEmptyTvShow('always love'),
        FakeEmptyTvShow('never love'),
        FakeEmptyTvShow('even more love'),
      ];
      when(mockTvShowsRemoteDataSource.searchTvShows(name: searchInput)).thenAnswer((_) async => mockDbTvShowsSearchResult);

      // When/Act
      movieLibrary.addEvent(TvShowsLibraryEvent.searchTvShows(searchInput));

      // Then/Assert
      expectLater(movieLibrary.search, emits(mockDbTvShowsSearchResult));
    });

    test('WHEN search more, movie library SHOULD search from movie repository next page until no more series and stream result', () async {
      // Given/Arrange
      final movieRepository = TvShowsRepository(mockTvShowsRemoteDataSource);
      final movieLibrary = TvShowsLibrary(movieRepository);
      const searchInput = 'love';
      final searchResultPages = <int, List<TvShow>>{
        0:[
          FakeEmptyTvShow('in love'),
          FakeEmptyTvShow('only love'),
          FakeEmptyTvShow('always love')
        ],
        1:[
          FakeEmptyTvShow('never love'),
          FakeEmptyTvShow('even more love'),
          FakeEmptyTvShow('everything is love'),
        ],
        2:[
          FakeEmptyTvShow('same old love'),
          FakeEmptyTvShow('more then just usual love'),
          FakeEmptyTvShow('double infinity love'),
        ]
      };
      when(mockTvShowsRemoteDataSource.searchTvShows(name: searchInput)).thenAnswer((_) async => searchResultPages[0]!);
      when(mockTvShowsRemoteDataSource.searchTvShows(name: searchInput, page: 1)).thenAnswer((_) async => searchResultPages[1]!);
      when(mockTvShowsRemoteDataSource.searchTvShows(name: searchInput, page: 2)).thenAnswer((_) async => searchResultPages[2]!);
      when(mockTvShowsRemoteDataSource.searchTvShows(name: searchInput, page: 3)).thenAnswer((_) async => []);

      // When/Act
      movieLibrary.addEvent(TvShowsLibraryEvent.searchTvShows(searchInput));
      movieLibrary.addEvent(TvShowsLibraryEvent.searchMoreTvShows());
      movieLibrary.addEvent(TvShowsLibraryEvent.searchMoreTvShows());
      movieLibrary.addEvent(TvShowsLibraryEvent.searchMoreTvShows());

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
          {
            'name': 'name',
            'number': 1,
            'season': 1,
            'summary': 'summary',
            'imageUrl': 'imageUrl'
          },
          {
            'name': 'name',
            'number': 1,
            'season': 1,
            'summary': 'summary',
            'imageUrl': 'imageUrl'
          },
          {
            'name': 'name',
            'number': 1,
            'season': 1,
            'summary': 'summary',
            'imageUrl': 'imageUrl'
          }
        ],
      };
      late TvShow aTvShows;

      //When/Act
      aTvShows = TvShow.fromJson(json);

      //Then/Assert
      expect(aTvShows, isNot(equals(null)));
      expect(aTvShows.name, isNot(equals(null)));
      expect(aTvShows.posterUrl, isNot(equals(null)));
      expect(aTvShows.airs, isNot(equals(null)));
      expect(aTvShows.genres, isNot(equals(null)));
      expect(aTvShows.summary, isNot(equals(null)));
      expect(aTvShows.episodes, isNot(equals(null)));
    });
  });

  group('After clicking on an episode, the application should show the episode’s information', (){

    test('When parse from json, episode SHOULD have Name, Number, Season, Image if there is one', (){
      //Given/Arrange
      var json = {
        'name': 'name',
        'number': 1,
        'season': 1,
        'summary': 'summary',
        'imageUrl': 'imageUrl'
      };
      late Episode episode;

      //When/Act
      episode = Episode.fromJson(json);

      //Then/Assert
      expect(episode, isNot(equals(null)));
      expect(episode.name, isNot(equals(null)));
      expect(episode.number, isNot(equals(null)));
      expect(episode.season, isNot(equals(null)));
      expect(episode.summary, isNot(equals(null)));
      expect(episode.imageUrl, isNot(equals(null)));
    });
  });
}
