import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rafael_jobsity_challenge/domain/entities/episode.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';

class TvMazeService {

  TvMazeService._();

  static TvMazeService? _instance;
  static TvMazeService get instance => TvMazeService._getInstance();
  factory TvMazeService._getInstance() {
    return _instance ??= TvMazeService._();
  }

  static const String _baseUrl = 'https://api.tvmaze.com/';
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl
    )
  );

  Future<List<TvShow>> getSchedule({String country = 'US'}) async {
    var tvShows = <TvShow>[];
    try {
      var result = await _dio.get('schedule?country=$country');
      var json = result.data as List<dynamic>;
      for (var element in json) {
        element['show']['airstamp'] = element['airstamp'] ;
        tvShows.add(TvShow.fromJson(element['show']));
      }
    } catch(e, s){
      print(e);
      print(s);
    }
    return tvShows;
  }

  Future<List<TvShow>> getTvShows({int page = 0}) async {
    var tvShows = <TvShow>[];
    try {
      var result = await _dio.get('shows?page=$page');
      var json = result.data as List<dynamic>;
      for (var element in json) {
        tvShows.add(TvShow.fromJson(element));
      }
    } catch(e, s){
      print(e);
      print(s);
    }
    return tvShows;
  }

  Future<List<Episode>> getEpisodes({required int id}) async {
    var episodes = <Episode>[];
    try {
      var result = await _dio.get('shows/$id/episodes');
      var json = result.data as List<dynamic>;
      for (var element in json) {
        episodes.add(Episode.fromJson(element));
      }
    } catch(e, s){
      print(e);
      print(s);
    }
    return episodes;
  }
}