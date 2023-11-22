import 'package:shared_preferences/shared_preferences.dart';

import 'package:talk_around/domain/models/user.dart';

class AuthLocalDatasource {
  final String _authKey = 'auth';
  SharedPreferences? _prefs;

  Future<void> signInAsAnonymous() async {
    final SharedPreferences prefs = await _getPrefs();
    await prefs.setBool(_authKey, true);
  }

  Future<bool> logOut() async {
    final SharedPreferences prefs = await _getPrefs();
    return await prefs.remove(_authKey);
  }

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await _getPrefs();
    return prefs.getBool(_authKey) ?? false;
  }

  Future<bool> containsToken() async {
    final SharedPreferences prefs = await _getPrefs();
    return prefs.containsKey(_authKey);
  }

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }
}
