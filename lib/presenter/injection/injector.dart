
import 'package:shared_preferences/shared_preferences.dart';



class Injector{

  static Future init() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    Injector.setSharedPreferences(sharedPreferences);
  }

  static late SharedPreferences _sharedPreferences;
  static get sharedPreferences => _sharedPreferences;

  static setSharedPreferences(SharedPreferences sharedPreferences){
    _sharedPreferences = sharedPreferences;
  }
}