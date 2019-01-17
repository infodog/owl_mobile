import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class DataUtils {
  static final String SP_SESSION = "SESSION";

  static Future<String> getAccessToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(SP_SESSION);
  }

  static Future<bool> setAccessToken(String session) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setString(SP_SESSION, session);
  }
}