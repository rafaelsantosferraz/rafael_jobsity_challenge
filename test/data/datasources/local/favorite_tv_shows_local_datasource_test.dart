import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:rafael_jobsity_challenge/data/datasources/local/favorite_tv_shows_local_datasource.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main(){

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

  test('WHEN get favorite tv shows, SHOULD return favorites', () async {
    //Given/Arrange
    var fake = FakeEmptyTvShow('fake');
    SharedPreferences.setMockInitialValues({
      FavoriteTvShowsLocalDataSource.favoriteTvShowsConst: jsonEncode([fake])
    }); //set values here
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final FavoriteTvShowsLocalDataSource favoriteTvShowsLocalDataSource = FavoriteTvShowsLocalDataSource(sharedPreferences);


    //When/Act
    var favorites = favoriteTvShowsLocalDataSource.getFavorite();

    //Then/Assert
    expectLater(favorites, equals([fake]));
  });

  test('WHEN add tv show to favorites, SHOULD add tv show to favorites', () async {
    //Given/Arrange
    SharedPreferences.setMockInitialValues({}); //set values here
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final FavoriteTvShowsLocalDataSource favoriteTvShowsLocalDataSource = FavoriteTvShowsLocalDataSource(sharedPreferences);
    var myFavoriteFakeTvShow = FakeEmptyTvShow('fake');
    var favorites = <TvShow>[];

    //When/Act
    await favoriteTvShowsLocalDataSource.addFavorite(myFavoriteFakeTvShow);
    favorites = favoriteTvShowsLocalDataSource.getFavorite();

    //Then/Assert
    expectLater(favorites, equals([myFavoriteFakeTvShow]));
  });

  test('WHEN remove tv show  from favorites, SHOULD remove select tv show from other favorites', () async {
    //Given/Arrange
    var fake = FakeEmptyTvShow('fake');
    SharedPreferences.setMockInitialValues({
      FavoriteTvShowsLocalDataSource.favoriteTvShowsConst: jsonEncode([fake])
    }); //set values here
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final FavoriteTvShowsLocalDataSource favoriteTvShowsLocalDataSource = FavoriteTvShowsLocalDataSource(sharedPreferences);


    //When/Act
    var favorites_1 = favoriteTvShowsLocalDataSource.getFavorite();
    await favoriteTvShowsLocalDataSource.removeFavorite(fake);
    var favorites_2 = favoriteTvShowsLocalDataSource.getFavorite();

    //Then/Assert
    expectLater(favorites_1, equals([fake]));
    expectLater(favorites_2, equals([]));
  });
}