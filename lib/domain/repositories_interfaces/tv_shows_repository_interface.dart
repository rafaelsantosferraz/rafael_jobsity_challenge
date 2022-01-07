import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';

abstract class TvShowsRepositoryInterface {
  Future<List<TvShow>> getTvShows();

  Future<List<TvShow>> getMoreTvShows();

  Future<List<TvShow>> searchTvShows(String name);

  Future<List<TvShow>> searchMoreTvShows();
}