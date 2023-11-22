import 'package:get/get.dart';

import 'package:talk_around/domain/models/user.dart';
import 'package:talk_around/domain/repositories/user_repository.dart';
// import 'package:talk_around/data/repositories/user_firebase_repository.dart';

class UserUseCase {
  final UserRepository _userRepository = Get.find<UserRepository>();

  Future<User> getCurrentUser() async {
    return await _userRepository.getCurrentUser();
  }

  Future<User> getUser(String id) async {
    return await _userRepository.getUser(id);
  }

  // Future<User> createUser(User user) async {
  //   return await _userRepository.createUser(user);
  // }

  Future<List<User>> getUsersFromChannel(String channelId) async {
    return await _userRepository.getUsersFromChannel(channelId);
  }

  Future<void> setLocalUser(User user) async {
    return await _userRepository.setLocalUser(user);
  }

  // Future<User> updateCurrentUser(String id, User user) async {
  //   return await _userRepository.updateCurrentUser(id, user);
  // }

  Future<User> updatePartialCurrentUser(String id,
      {String? name,
      String? email,
      String? username,
      // String? password,
      bool? geolocEnabled,
      int? prefGeolocRadius,
      double? lat,
      double? lng}) async {
    return await _userRepository.updatePartialCurrentUser(id,
        name: name,
        email: email,
        username: username,
        geolocEnabled: geolocEnabled,
        prefGeolocRadius: prefGeolocRadius,
        lat: lat,
        lng: lng);
  }

  Future<void> joinChannel(String userId, String channelId) async {
    _userRepository.joinChannel(channelId);
  }

  Future<void> leaveChannel(String userId, String channelId) async {
    _userRepository.leaveChannel(channelId);
  }

  Future<void> deleteLocalUser() async {
    return await _userRepository.deleteLocalUser();
  }
}
