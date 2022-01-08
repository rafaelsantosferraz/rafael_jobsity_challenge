import 'package:flutter/material.dart';
import 'package:rafael_jobsity_challenge/presenter/navigation/routes.dart';

class NavigationController{
  static final navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings){
    return Routes.getPage(settings.name);
  }
}