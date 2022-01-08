import 'package:rafael_jobsity_challenge/data/datasources/remote/tv_shows_remote_datasource.dart';
import 'package:rafael_jobsity_challenge/domain/entities/pagination.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/domain/repositories_interfaces/tv_shows_repository_interface.dart';

class TvShowsRepository implements TvShowsRepositoryInterface {

  final TvShowsRemoteDataSource _tvShowsRemoteDataSource;

  TvShowsRepository(this._tvShowsRemoteDataSource);

  final tvShowsPagination = Pagination<TvShow>();
  final searchPagination = Pagination<TvShow>();
  String searchInput = '';

  ///Get first page of series
  @override
  Future<List<TvShow>> getTvShows() async{
    var series = await _tvShowsRemoteDataSource.getTvShows();
    tvShowsPagination.clear();
    tvShowsPagination.add(series);
    return tvShowsPagination.getAll();
  }

  ///Get next page series. If there's no more pages, it return list without
  ///changes
  @override
  Future<List<TvShow>> getMoreTvShows() async{
    assert(tvShowsPagination.isNotEmpty);
    var series = await _tvShowsRemoteDataSource.getTvShows(tvShowsPagination.length);
    tvShowsPagination.add(series);
    return tvShowsPagination.getAll();
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
}