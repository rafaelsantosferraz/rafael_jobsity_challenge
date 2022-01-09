import 'package:flutter/material.dart';
import 'package:rafael_jobsity_challenge/domain/entities/episode.dart';
import 'package:rafael_jobsity_challenge/presenter/navigation/navigation_routes.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/episode/episode_dialog.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/home/home_page.dart';

part 'navigation_event.dart';

class NavigationController{
  static final navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case NavigationRoutes.home: return MaterialPageRoute(builder: (_) => HomePage());
      case NavigationRoutes.episode: return PageRouteBuilder(
          opaque: false,
          fullscreenDialog: true,
          barrierDismissible: true,
          barrierColor: Colors.transparent,
          pageBuilder: (_, __, ___) => EpisodeDialog(episode: settings.arguments as Episode)
      );
      default:   return MaterialPageRoute(builder: (_) => HomePage());
    }
  }

  //region Public --------------------------------------------------------------
  static addEvent(NavigationEvent event){
    _onEvent(event);
  }
  //endregion


  //region Private -------------------------------------------------------------
  static Future _onEvent(NavigationEvent event) async {
    switch(event.runtimeType){
      case _GoToEpisodeEvent: await _onGoToEpisodeEvent(event as _GoToEpisodeEvent);
      break;
      default: throw Exception('Event ${event.runtimeType} not process');
    }
  }

  static _onGoToEpisodeEvent(_GoToEpisodeEvent event){
    Navigator.of(event.context).pushNamed(NavigationRoutes.episode, arguments: event.episode);
  }
  //endregion
}