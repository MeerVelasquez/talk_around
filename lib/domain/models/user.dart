// import 'package:talk_around/domain/models/channel.dart';

import 'package:loggy/loggy.dart';

class User {
  String? id;
  String name;
  String email;
  String username;
  String? password;
  bool geolocEnabled;
  double? prefGeolocRadius;
  double? lat;
  double? lng;
  // List<Channel> channels;
  List<String>? channels;
  List<String>? interests;

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
    required this.interests,
  });

  User.defaultUser()
      : id = null,
        name = '',
        email = '',
        username = '',
        password = null,
        geolocEnabled = false,
        prefGeolocRadius = 0,
        lat = 0,
        lng = 0,
        channels = [],
        interests = [];

  factory User.fromJson(Map<String, dynamic> json) {
    bool geolocEnabled;
    double? prefGeolocRadius;
    double? lat;
    double? lng;
    List<String>? channels;
    List<String>? interests;

    try {
      geolocEnabled = json['geolocEnabled'];
    } catch (err) {
      geolocEnabled = false;
      logError('User.fromJson: geolocEnabled: $err');
    }

    try {
      prefGeolocRadius = json['prefGeolocRadius'].runtimeType == int
          ? json['prefGeolocRadius'].toDouble()
          : json['prefGeolocRadius'];
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

    try {
      interests = json['interests'] != null
          ? List<String>.from(json['interests'] as List)
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
        channels: channels,
        interests: interests);
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
        interests: user.interests,
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
        "interests": interests,
      };
}
