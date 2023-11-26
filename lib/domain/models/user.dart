// import 'package:talk_around/domain/models/channel.dart';

import 'package:loggy/loggy.dart';

class User {
  String? id;
  String name;
  String email;
  String username;
  String? password;
  bool geolocEnabled;
  int? prefGeolocRadius;
  double? lat;
  double? lng;
  // List<Channel> channels;
  List<String>? channels;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.username,
    this.password,
    required this.geolocEnabled,
    required this.prefGeolocRadius,
    required this.lat,
    required this.lng,
    required this.channels,
  });

  User.defaultUser()
      : id = null,
        name = '',
        email = '',
        username = '',
        password = null,
        geolocEnabled = true,
        prefGeolocRadius = 0,
        lat = 0,
        lng = 0,
        channels = [];

  factory User.fromJson(Map<String, dynamic> json) {
    bool geolocEnabled;
    int? prefGeolocRadius;
    double? lat;
    double? lng;
    List<String>? channels;

    try {
      geolocEnabled = json['geolocEnabled'];
    } catch (err) {
      geolocEnabled = true;
      logError('User.fromJson: geolocEnabled: $err');
    }

    try {
      prefGeolocRadius = json['prefGeolocRadius'] ?? 0;
    } catch (err) {
      logError('User.fromJson: prefGeolocRadius: $err');
    }

    try {
      lat =
          json['lat'].runtimeType == int ? json['lat'].toDouble() : json['lat'];
    } catch (err) {
      logError('User.fromJson: lat: $err');
    }

    try {
      lng =
          json['lng'].runtimeType == int ? json['lng'].toDouble() : json['lng'];
    } catch (err) {
      logError('User.fromJson: lng: $err');
    }

    try {
      channels = json['channels'] != null
          ? List<String>.from(json['channels'] as List)
          : null;
    } catch (err) {
      logError(err);
    }

    return User(
        id: json["id"],
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        username: json["username"] ?? "",
        password: json["password"],
        geolocEnabled: geolocEnabled,
        prefGeolocRadius: prefGeolocRadius,
        lat: lat,
        lng: lng,
        channels: channels);
  }

  factory User.from(User user) => User(
        id: user.id,
        name: user.name,
        email: user.email,
        username: user.username,
        password: user.password,
        geolocEnabled: user.geolocEnabled,
        prefGeolocRadius: user.prefGeolocRadius,
        lat: user.lat,
        lng: user.lng,
        channels: user.channels,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "username": username,
        // "password": password,
        "geolocEnabled": geolocEnabled,
        "prefGeolocRadius": prefGeolocRadius,
        "lat": lat,
        "lng": lng,
        // "channels": channels.map((c) => c.id).toList(),
        "channels": channels,
      };
}
