import 'dart:convert';

import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteTvShowsLocalDataSource {

  final SharedPreferences sharedPreferences;
  static const String favoriteTvShowsConst = 'favorites';

  FavoriteTvShowsLocalDataSource(this.sharedPreferences);

  List<TvShow> getFavorite(){
    var jsonText = sharedPreferences.getString(favoriteTvShowsConst) ?? '';
    if(jsonText.isNotEmpty){
      var jsonArray = (jsonDecode(jsonText) as List);
      return jsonArray.map<TvShow>((json) => TvShow.fromJson(json)).toList();
    }
    return [];
  }

  Future<bool> addFavorite(TvShow tvShow) async {
    var favorites = getFavorite();
    favorites.add(tvShow);
    var jsonText = jsonEncode(favorites);
    return sharedPreferences.setString(favoriteTvShowsConst, jsonText);
  }

  Future<bool> removeFavorite(TvShow tvShow){
    var favorites = getFavorite();
    favorites.remove(tvShow);
    var jsonText = jsonEncode(favorites);
    return sharedPreferences.setString(favoriteTvShowsConst, jsonText);
  }

  bool checkIsFavorite(TvShow tvShow){
    var favorites = getFavorite();
    return favorites.contains(tvShow);
  }
}