import 'package:geolocator/geolocator.dart';
import 'package:loggy/loggy.dart';

import 'dart:async';

import 'package:talk_around/domain/models/user_location.dart';

class LocatorService {
  StreamSubscription<Position>? _positionStreamSubscription;

  final StreamController<UserLocation> _locationStreamController =
      StreamController<UserLocation>.broadcast();

  Geolocator geolocator = Geolocator();
  Stream<UserLocation> get locationStream => _locationStreamController.stream;

  Future<bool> getPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return Future.value(true);
  }

  Future<UserLocation> getLocation() async {
    UserLocation userLocation;
    await getPermission();
    try {
      Position l = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      userLocation = UserLocation(lat: l.latitude, lng: l.longitude);
      return Future.value(userLocation);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> startStream() async {
    logInfo("startStream with Locator library");

    await getPermission().onError((error, stackTrace) {
      logError("Controller startStream got the error ${error.toString()}");
      return Future.error(error.toString());
    });

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 50,
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .handleError((onError) {
      logError("Got error from Geolocator stream");
      return Future.error(onError.toString());
    }).listen((Position? position) {
      if (position != null) {
        _locationStreamController.add(UserLocation.fromPosition(position));
      }
    });
  }

  Future<void> stopStream() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel().catchError(logError);
    }
    // else {
    //   logError("stopStream _positionStreamSubscription is null");
    //   return Future.error("stopStream _positionStreamSubscription is null");
    // }
    return Future.value();
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2) / 1000;
  }
}
