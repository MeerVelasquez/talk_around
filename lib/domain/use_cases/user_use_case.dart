import 'package:get/get.dart';

import 'package:talk_around/domain/models/user.dart';
import 'package:talk_around/domain/repositories/user_repository.dart';
// import 'package:talk_around/data/repositories/user_firebase_repository.dart';

class UserUseCase {
  final UserRepository _userRepository = Get.find<UserRepository>();

  Future<User> getCurrUser() async {
    return await _userRepository.getCurrUser();
  }

  Future<User> getUser(String id) async {
    return await _userRepository.getUser(id);
  }

  Future<User> createUser(User user) async {
    return await _userRepository.createUser(user);
  }

  Future<List<User>> getUsersFromChannel(String channelId,
      {int? prefGeolocRadius}) async {
    return await _userRepository.getUsersFromChannel(channelId,
        prefGeolocRadius: prefGeolocRadius);
  }

  Future<User> updateCurrUser(User user) async {
    return await _userRepository.updateCurrUser(user);
  }

  Future<User> updatePartialCurrUser(
      {String? name,
      String? email,
      String? username,
      // String? password,
      bool? geolocEnabled,
      int? prefGeolocRadius,
      double? lat,
      double? lng}) async {
    return await _userRepository.updatePartialCurrUser(
        name: name,
        email: email,
        username: username,
        geolocEnabled: geolocEnabled,
        prefGeolocRadius: prefGeolocRadius,
        lat: lat,
        lng: lng);
  }

  Future<void> deleteCurrUser() async {
    return await _userRepository.deleteCurrUser();
  }
}
