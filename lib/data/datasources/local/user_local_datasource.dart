import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:talk_around/domain/models/user.dart';

class UserLocalDatasource {
  final String _userKey = 'user';
  final String _usersKey = 'users';
  SharedPreferences? _prefs;

  Future<User> getCurrentUser() async {
    final SharedPreferences prefs = await _getPrefs();

    final String? userString = prefs.getString(_userKey);
    if (userString == null) return Future.error('No user in local storage');

    final Map<String, dynamic> userMap = jsonDecode(userString);
    return User.fromJson(userMap);
  }

  Future<User> getUser(String id) async {
    final SharedPreferences prefs = await _getPrefs();

    final String? usersString = prefs.getString(_usersKey);
    if (usersString == null) return Future.error('No users in local storage');

    final List<dynamic> usersList = jsonDecode(usersString);
    final Map<String, dynamic> userMap =
        usersList.firstWhere((user) => user['id'] == id);

    return User.fromJson(userMap);
  }

  // Future<User> createUser(User user) async {}

  Future<List<User>> getUsersFromChannel(String channelId) async {
    final SharedPreferences prefs = await _getPrefs();

    final String? usersString = prefs.getString(_usersKey);
    if (usersString == null) return [];

    final List<dynamic> usersList = jsonDecode(usersString);
    final List<Map<String, dynamic>> usersChannelList = usersList
        .where((user) => (user['channels'] as List<String>).contains(channelId))
        .toList()
        .cast<Map<String, dynamic>>();
    return usersChannelList.map((userMap) => User.fromJson(userMap)).toList();
  }

  // Future<User> updateCurrentUser(String id, User user) async {}

  Future<User> updatePartialCurrentUser(
      {String? name,
      String? email,
      String? username,
      // String? password,
      bool? geolocEnabled,
      int? prefGeolocRadius,
      double? lat,
      double? lng}) async {
    final SharedPreferences prefs = await _getPrefs();

    final String? userString = prefs.getString(_userKey);
    if (userString == null) return Future.error('No user in local storage');

    final Map<String, dynamic> userMap = jsonDecode(userString);
    final Map<String, dynamic> updatedUserMap = {
      ...userMap,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (username != null) 'username': username,
      // if (password != null) 'password': password,
      if (geolocEnabled != null) 'geolocEnabled': geolocEnabled,
      if (prefGeolocRadius != null) 'prefGeolocRadius': prefGeolocRadius,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    };

    prefs.setString(_userKey, jsonEncode(updatedUserMap));
    return User.fromJson(updatedUserMap);
  }

  Future<bool> deleteLocalUser() async {
    final SharedPreferences prefs = await _getPrefs();
    return await prefs.remove(_userKey);
  }

  Future<void> addUsersIfNotExist(List<User> users) async {
    final SharedPreferences prefs = await _getPrefs();

    final String? usersString = prefs.getString(_usersKey);
    if (usersString == null) {
      // prefs.setString(_usersKey, jsonEncode(users));
      prefs.setString(
          _usersKey, jsonEncode(users.map((user) => user.toJson()).toList()));
      return;
    }

    final List<dynamic> currentUsers = jsonDecode(usersString);

    final List<User> newUsers = users
        .where((user) => !currentUsers.any((e) => e['id'] == user.id))
        .toList();
    currentUsers.addAll(newUsers.map((user) => user.toJson()).toList());
  }

  Future<void> setUser(User user) async {
    final SharedPreferences prefs = await _getPrefs();
    prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }
}
