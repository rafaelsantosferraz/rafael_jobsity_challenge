import 'package:rafael_jobsity_challenge/domain/entities/episode.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/presenter/services/tv_maze_service.dart';

class TvShowsRemoteDataSource{

  final TvMazeService tvShowsService;

  TvShowsRemoteDataSource(this.tvShowsService);

  Future<List<TvShow>> getTvShows([int page = 0]) async{
    return tvShowsService.getTvShows();
  }

  Future<List<TvShow>> searchTvShows({required String name, int? page = 0}) async{
    return tvShowsService.searchTvShow(query: name); //todo: API call
  }

  Future<List<Episode>> getEpisodes(int tvShowId) async{
    return tvShowsService.getEpisodes(id: tvShowId);
  }
}