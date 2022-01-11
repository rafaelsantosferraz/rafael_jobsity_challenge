import 'package:flutter/material.dart';
import 'package:rafael_jobsity_challenge/domain/entities/episode.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/presenter/navigation/navigation_routes.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/episode/episode_dialog.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/home/home_page.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/pin_code/pin_code_dialog.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/tv_show/tv_show_page.dart';

part 'navigation_event.dart';

class NavigationController{

  static final navigatorKey = GlobalKey<NavigatorState>();


  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case NavigationRoutes.home:    return MaterialPageRoute(builder: (_) => HomePage());
      case NavigationRoutes.tvShow:  return MaterialPageRoute(builder: (_) => TvShowPage(tvShow: (settings.arguments as TvShowPageArguments).tvShow, color: (settings.arguments as TvShowPageArguments).color));
      case NavigationRoutes.episode: return PageRouteBuilder(
          opaque: false,
          fullscreenDialog: true,
          barrierDismissible: true,
          barrierColor: Colors.transparent,
          pageBuilder: (_, __, ___) => EpisodeDialog(episode: settings.arguments as Episode)
      );
      case NavigationRoutes.pinCode: return PageRouteBuilder(
          opaque: false,
          fullscreenDialog: true,
          barrierDismissible: false,
          barrierColor: Colors.transparent,
          pageBuilder: (_, __, ___) => PinCodeDialog()
      );
      default: return MaterialPageRoute(builder: (_) => HomePage());
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
      case _HomeReadyEvent: await _onHomeReadyEvent(event as _HomeReadyEvent);
      break;
      case _GoToTvShowEvent: await _onGoToTvShowEvent(event as _GoToTvShowEvent);
      break;
      case _GoToEpisodeEvent: await _onGoToEpisodeEvent(event as _GoToEpisodeEvent);
      break;
      default: throw Exception('Event ${event.runtimeType} not process');
    }
  }

  static bool alreadyStart = false;
  static _onHomeReadyEvent(_HomeReadyEvent event){
    if(!alreadyStart) {
      alreadyStart = true;
      Navigator.of(event.context).pushNamed(NavigationRoutes.pinCode);
    }
  }

  static _onGoToTvShowEvent(_GoToTvShowEvent event){
    Navigator.of(event.context).pushNamed(NavigationRoutes.tvShow, arguments: TvShowPageArguments(event.tvShow, event.color));
  }

  static _onGoToEpisodeEvent(_GoToEpisodeEvent event){
    Navigator.of(event.context).pushNamed(NavigationRoutes.episode, arguments: event.episode);
  }
  //endregion
}