import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static get preferences async {
    return await SharedPreferences.getInstance();
  }

  static Future<String?> get accessToken async {
    return (await preferences).getString('access_token');
  }

  static Future<void> setAccessToken(String? accessToken) async {
    if (accessToken == null) {
      (await preferences).remove('access_token');
      return;
    }
    (await preferences).setString('access_token', accessToken);
  }
}
