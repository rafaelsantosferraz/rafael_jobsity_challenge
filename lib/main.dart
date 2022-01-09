import 'package:flutter/material.dart';
import 'package:rafael_jobsity_challenge/presenter/navigation/navigation_routes.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/colors.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/home/home_page.dart';

import 'presenter/navigation/navigation_controller.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: kBackgroundColor
      ),
      home: Navigator(
        key: NavigationController.navigatorKey,
        initialRoute: NavigationRoutes.initialRoute,
        onGenerateRoute: NavigationController.generateRoute,
      )
    );
  }
}

