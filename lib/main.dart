import 'package:flutter/material.dart';
import 'package:rafael_jobsity_challenge/presenter/injection/injector.dart';
import 'package:rafael_jobsity_challenge/presenter/navigation/navigation_routes.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/colors.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'presenter/navigation/navigation_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Injector.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: kBackgroundColor,
        scaffoldBackgroundColor: kBackgroundColor
      ),
      navigatorKey: NavigationController.navigatorKey,
      initialRoute: NavigationRoutes.initialRoute,
      onGenerateRoute: NavigationController.generateRoute,
    );
  }
}

