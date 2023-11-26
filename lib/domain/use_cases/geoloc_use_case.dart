import 'dart:async';

import 'package:get/get.dart';

import 'package:talk_around/domain/models/user_location.dart';
import 'package:talk_around/services/locator_service.dart';

class GeolocUseCase {
  final LocatorService _locatorService = Get.find<LocatorService>();

  Stream<UserLocation?> get geolocChanges => _locatorService.locationStream;

  Future<void> startStream() async {
    return await _locatorService.startStream();
  }

  Future<void> stopStream() async {
    return await _locatorService.stopStream();
  }

  Future<UserLocation?> getLocation() async {
    return await _locatorService.getLocation();
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    return _locatorService.calculateDistance(lat1, lng1, lat2, lng2);
  }
}
