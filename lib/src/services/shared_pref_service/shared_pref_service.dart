import 'package:shared_preferences/shared_preferences.dart';

const _token = "token";

class PrefService {
  static Future<bool> saveToken(String? token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (token == null) return prefs.remove(_token);
    return prefs.setString(_token, token);
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_token);
  }
}
