import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rafael_jobsity_challenge/data/datasources/local/favorite_tv_shows_local_datasource.dart';
import 'package:rafael_jobsity_challenge/data/datasources/remote/tv_shows_remote_datasource.dart';
import 'package:rafael_jobsity_challenge/data/repositories/tv_shows_repository.dart';
import 'package:rafael_jobsity_challenge/domain/entities/episode.dart';
import 'package:rafael_jobsity_challenge/domain/entities/pagination.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_shows_library.dart';

import 'widget_test.mocks.dart';


@GenerateMocks([TvShowsRepository, TvShowsRemoteDataSource, FavoriteTvShowsLocalDataSource])
void main() {

  TvShow FakeEmptyTvShow(String name){
    return TvShow(
        id: 0,
        name: name,
        posterUrl: "",
        airs: DateTime.now(),
        genres: [],
        summary: "",
        episodes: [],
        rating: 0,
        weight: 0
    );
  }
  group('List all of the series contained in the API used by the paging scheme provided by the API.', (){

    final mockTvShowsRepository = MockTvShowsRepository();
    final mockTvShowsRemoteDataSource = MockTvShowsRemoteDataSource();
    final mockFavoriteTvShowsLocalDataSource = MockFavoriteTvShowsLocalDataSource();

    test('WHEN tvShows library start, tvShows library SHOULD fetch from tvShows repository and stream result ', () async {
      // Given/Arrange

      final tvShowsLibrary = TvShowsLibrary.instanceWith(mockTvShowsRepository);
      final mockDbTvShows = PaginatedList<TvShow>(
          pages: [[
        FakeEmptyTvShow('1'),
        FakeEmptyTvShow('2'),
        FakeEmptyTvShow('3'),
        FakeEmptyTvShow('4'),
        FakeEmptyTvShow('5'),
      ]]);
      when(mockTvShowsRepository.getTvShows()).thenAnswer((_) async => mockDbTvShows);

      // When/Act
      tvShowsLibrary.addEvent(TvShowsLibraryEvent.start());

      // Then/Assert
      expectLater(tvShowsLibrary.tvShows, emits(mockDbTvShows));
    });

    test('WHEN get more series, tvShows library SHOULD fetch from tvShows repository next page until no more series and stream result', () async {
      // Given/Arrange
      final tvShowsRepository = TvShowsRepository(mockTvShowsRemoteDataSource, mockFavoriteTvShowsLocalDataSource);
      var tvShowsLibrary = TvShowsLibrary.instanceWith(tvShowsRepository);
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
      tvShowsLibrary.addEvent(TvShowsLibraryEvent.start());
      tvShowsLibrary.addEvent(TvShowsLibraryEvent.getMore());
      tvShowsLibrary.addEvent(TvShowsLibraryEvent.getMore());
      tvShowsLibrary.addEvent(TvShowsLibraryEvent.getMore());

      // Then/Assert
      expectLater(tvShowsLibrary.tvShows, emitsInOrder([
        PaginatedList<TvShow>(pages: [seriesByPage[0]!]),
        PaginatedList<TvShow>(pages: [seriesByPage[0]!, seriesByPage[1]!]),
        PaginatedList<TvShow>(pages: [seriesByPage[0]!, seriesByPage[1]!, seriesByPage[2]!]),
        PaginatedList<TvShow>(pages: [seriesByPage[0]!, seriesByPage[1]!, seriesByPage[2]!], isLastPage: true),
      ]));
    });
  });

  group('Allow users to search series by name.',(){
    final mockTvShowsRemoteDataSource = MockTvShowsRemoteDataSource();
    final mockFavoriteTvShowsLocalDataSource = MockFavoriteTvShowsLocalDataSource();

    test('WHEN user input search parameter, SHOULD fetch from tvShows repository series with that input parameter and stream result ', () async {
      // Given/Arrange
      final tvShowsRepository = TvShowsRepository(mockTvShowsRemoteDataSource, mockFavoriteTvShowsLocalDataSource);
      final tvShowsLibrary = TvShowsLibrary.instanceWith(tvShowsRepository);
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
      tvShowsLibrary.addEvent(TvShowsLibraryEvent.search(searchInput));

      // Then/Assert
      expectLater(tvShowsLibrary.search, emits(mockDbTvShowsSearchResult));
    });

    test('WHEN user input search parameter, SHOULD search from tvShows repository series with that input parameter and stream result ', () async {
      // Given/Arrange
      final tvShowsRepository = TvShowsRepository(mockTvShowsRemoteDataSource, mockFavoriteTvShowsLocalDataSource);
      final tvShowsLibrary = TvShowsLibrary.instanceWith(tvShowsRepository);
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
      tvShowsLibrary.addEvent(TvShowsLibraryEvent.search(searchInput));

      // Then/Assert
      expectLater(tvShowsLibrary.search, emits(mockDbTvShowsSearchResult));
    });

    test('WHEN search more, tvShows library SHOULD search from tvShows repository next page until no more series and stream result', () async {
      // Given/Arrange
      final tvShowsRepository = TvShowsRepository(mockTvShowsRemoteDataSource, mockFavoriteTvShowsLocalDataSource);
      final tvShowsLibrary = TvShowsLibrary.instanceWith(tvShowsRepository);
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
      tvShowsLibrary.addEvent(TvShowsLibraryEvent.search(searchInput));
      tvShowsLibrary.addEvent(TvShowsLibraryEvent.searchMore());
      tvShowsLibrary.addEvent(TvShowsLibraryEvent.searchMore());
      tvShowsLibrary.addEvent(TvShowsLibraryEvent.searchMore());

      // Then/Assert
      expectLater(tvShowsLibrary.search, emitsInOrder([
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
        'id': 0,
        'name': 'name',
        'posterUrl': 'posterUrl',
        'airstamp': '2022-01-01T15:00:00+00:00',
        'genres': ['love, horror'],
        'summary': 'summary',
        'episodes': [
          {
            'id': 0,
            'name': 'name',
            'number': 1,
            'season': 1,
            'summary': 'summary',
            'imageUrl': 'imageUrl'
          },
          {
            'id': 1,
            'name': 'name',
            'number': 1,
            'season': 1,
            'summary': 'summary',
            'imageUrl': 'imageUrl'
          },
          {
            'id': 2,
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
        'id': 0,
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
      expect(episode.thumb, isNot(equals(null)));
    });
  });
}
