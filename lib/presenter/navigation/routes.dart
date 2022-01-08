import 'package:flutter/material.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/home/home_page.dart';

class Routes {
  static const initialRoute = home;
  static const String home = '/';
  static const String tvShows = '/tv_shows';

  static MaterialPageRoute getPage(String? route){
    switch(route){
      case home: return MaterialPageRoute(builder: (_) => HomePage());
      default:   return MaterialPageRoute(builder: (_) => HomePage());
    }
  }
}