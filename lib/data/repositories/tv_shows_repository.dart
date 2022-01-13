import 'package:rafael_jobsity_challenge/data/datasources/local/favorite_tv_shows_local_datasource.dart';
import 'package:rafael_jobsity_challenge/data/datasources/remote/tv_shows_remote_datasource.dart';
import 'package:rafael_jobsity_challenge/domain/entities/actor.dart';
import 'package:rafael_jobsity_challenge/domain/entities/episode.dart';
import 'package:rafael_jobsity_challenge/domain/entities/pagination.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/domain/repositories_interfaces/favorite_tv_shows_repository_interface.dart';
import 'package:rafael_jobsity_challenge/domain/repositories_interfaces/tv_shows_repository_interface.dart';

class TvShowsRepository implements TvShowsRepositoryInterface, FavoriteTvShowsRepositoryInterface{

  final TvShowsRemoteDataSource _tvShowsRemoteDataSource;
  final FavoriteTvShowsLocalDataSource _favoriteTvShowsLocalDataSource;

  TvShowsRepository(this._tvShowsRemoteDataSource, this._favoriteTvShowsLocalDataSource);

  final tvShowsPagination = PaginatedList<TvShow>();
  final searchPagination = PaginatedList<TvShow>();
  String searchInput = '';

  ///Get first page of series
  @override
  Future<PaginatedList<TvShow>> getTvShows() async{
    var series = await _tvShowsRemoteDataSource.getTvShows();
    tvShowsPagination.clear();
    tvShowsPagination.add(series);
    return tvShowsPagination.copy();
  }

  ///Get next page series. If there's no more pages, it return list without
  ///changes
  @override
  Future<PaginatedList<TvShow>> getMoreTvShows() async{
    assert(tvShowsPagination.isNotEmpty);
    var series = await _tvShowsRemoteDataSource.getTvShows(tvShowsPagination.length);
    tvShowsPagination.add(series);
    return tvShowsPagination.copy();
  }

  @override
  Future<List<TvShow>> searchTvShows(String name) async{
    searchInput = name;
    var series = await _tvShowsRemoteDataSource.searchTvShows(name: name);
    searchPagination.clear();
    searchPagination.add(series);
    return searchPagination.getAll();
  }

  @override
  Future<List<TvShow>> searchMoreTvShows() async{
    assert(searchPagination.isNotEmpty);
    var series = await _tvShowsRemoteDataSource.searchTvShows(name: searchInput, page: searchPagination.length);
    searchPagination.add(series);
    return searchPagination.getAll();
  }

  @override
  Future<List<Episode>> getEpisodes(int tvShowId) async{
    var episodes = await _tvShowsRemoteDataSource.getEpisodes(tvShowId);
    return episodes;
  }

  @override
  List<TvShow> getFavorite(){
    return _favoriteTvShowsLocalDataSource.getFavorite();
  }

  @override
  Future<bool> addFavorite(TvShow tvShow) async {
    return _favoriteTvShowsLocalDataSource.addFavorite(tvShow);
  }

  @override
  Future<bool> removeFavorite(TvShow tvShow){
    return _favoriteTvShowsLocalDataSource.removeFavorite(tvShow);
  }

  @override
  bool checkIsFavorite(TvShow tvShow){
    return _favoriteTvShowsLocalDataSource.checkIsFavorite(tvShow);
  }

  @override
  Future<List<Actor>> getActors(int tvShowId) async {
    return _tvShowsRemoteDataSource.getActors(tvShowId);
  }

  @override
  Future<List<TvShow>> getActorSeries(int actorId) async {
    return _tvShowsRemoteDataSource.getActorSeries(actorId);
  }
}