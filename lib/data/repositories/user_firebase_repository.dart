import 'package:loggy/loggy.dart';
import 'package:talk_around/data/datasources/local/user_local_datasource.dart';
import 'package:talk_around/data/datasources/remote/user_datasource.dart';
import 'package:talk_around/data/utils/network_util.dart';

import 'package:talk_around/domain/models/user.dart';
import 'package:talk_around/domain/repositories/user_repository.dart';

class UserFirebaseRepository implements UserRepository {
  final UserLocalDatasource _userLocalDatasource = UserLocalDatasource();
  final UserDatasource _userDatasource = UserDatasource();

  @override
  Future<User> getCurrentUser() async {
    final User user = await _userLocalDatasource.getCurrentUser();
    // if (user.id != null) return user;

    try {
      return await _userDatasource.getUser(user.id!);
    } catch (err) {
      logError(err);
      return user;
    }
  }

  @override
  Future<User> getUser(String id) async {
    try {
      return await _userDatasource.getUser(id);
    } catch (err) {
      logError(err);
      if (!(await NetworkUtil.hasNetwork())) {
        return await _userLocalDatasource.getUser(id);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<User> getUserByEmail(String email) async {
    return await _userDatasource.getUserByEmail(email);
  }

  //@override
  //Future<User> createUser(User user) async {}

  @override
  Future<List<User>> getUsersFromChannel(String channelId) async {
    try {
      final List<User> users =
          await _userDatasource.getUsersFromChannel(channelId);
      _userLocalDatasource.addUsersIfNotExist(users);

      return users;
    } catch (err) {
      logError(err);
      if (!(await NetworkUtil.hasNetwork())) {
        return await _userLocalDatasource.getUsersFromChannel(channelId);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future setLocalUser(User user) async {
    await _userLocalDatasource.setUser(user);
  }

  // @override
  // Future<User> updateCurrentUser(String id, User user) async {
  //   try {
  //     return await _userDatasource.updateCurrentUser(id, user);
  //   } catch (err) {
  //     logError(err);
  //     if (!(await NetworkUtil.hasNetwork())) {
  //       return await _userLocalDatasource.updateCurrentUser(id, user);
  //     } else {
  //       rethrow;
  //     }
  //   }
  // }

  @override
  Future<User> updatePartialCurrentUser(String id,
      {String? name,
      String? email,
      String? username,
      // String? password,
      bool? geolocEnabled,
      int? prefGeolocRadius,
      double? lat,
      double? lng}) async {
    try {
      return await _userDatasource.updatePartialCurrentUser(id,
          name: name,
          email: email,
          username: username,
          geolocEnabled: geolocEnabled,
          prefGeolocRadius: prefGeolocRadius,
          lat: lat,
          lng: lng);
    } catch (err) {
      logError(err);
      if (!(await NetworkUtil.hasNetwork())) {
        return await _userLocalDatasource.updatePartialCurrentUser(
            name: name,
            email: email,
            username: username,
            geolocEnabled: geolocEnabled,
            prefGeolocRadius: prefGeolocRadius,
            lat: lat,
            lng: lng);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<void> joinChannel(String channelId) async {
    final User user = await _userLocalDatasource.getCurrentUser();
    await _userDatasource.joinChannel(user.id!, channelId);
    await _userLocalDatasource.joinChannel(channelId);
  }

  @override
  Future<void> leaveChannel(String channelId) async {
    final User user = await _userLocalDatasource.getCurrentUser();
    await _userDatasource.leaveChannel(user.id!, channelId);
    await _userLocalDatasource.leaveChannel(channelId);
  }

  @override
  Future<void> deleteLocalUser() async {
    await _userLocalDatasource.deleteLocalUser();
  }
}
