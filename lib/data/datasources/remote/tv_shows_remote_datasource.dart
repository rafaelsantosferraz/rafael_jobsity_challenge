import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';

class TvShowsRemoteDataSource{

  Future<List<TvShow>> getTvShows([int page = 0]) async{
    return []; //todo: API call
  }

  Future<List<TvShow>> searchTvShows({required String name, int? page = 0}) async{
    return []; //todo: API call
  }
}