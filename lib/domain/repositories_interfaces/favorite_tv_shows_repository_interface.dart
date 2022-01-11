import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';

abstract class FavoriteTvShowsRepositoryInterface {

  List<TvShow> getFavorite();

  Future<bool> addFavorite(TvShow tvShow);

  Future<bool> removeFavorite(TvShow tvShow);

  bool checkIsFavorite(TvShow tvShow);
}