import 'package:geolocator/geolocator.dart';

class UserLocation {
  final double lat;
  final double lng;

  UserLocation({required this.lat, required this.lng});

  static UserLocation fromPosition(Position position) {
    return UserLocation(lat: position.latitude, lng: position.longitude);
  }
}
