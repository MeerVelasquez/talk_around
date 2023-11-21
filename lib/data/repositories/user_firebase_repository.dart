import 'package:talk_around/data/datasources/local/user_local_datasource.dart';
import 'package:talk_around/data/datasources/remote/user_datasource.dart';

import 'package:talk_around/domain/models/user.dart';
import 'package:talk_around/domain/repositories/user_repository.dart';

class UserFirebaseRepository implements UserRepository {
  final UserLocalDatasource _userLocalDatasource = UserLocalDatasource();
  final UserDatasource _userDatasource = UserDatasource();

  Future<User> getCurrUser() async {}

  Future<User> getUser(String id) async {}

  Future<User> createUser(User user) async {}

  Future<List<User>> getUsersFromChannel(String channelId,
      {int? prefGeolocRadius}) async {}

  Future<User> updateCurrUser(User user) async {}

  Future<User> updatePartialCurrUser(
      {String? name,
      String? email,
      String? username,
      // String? password,
      bool? geolocEnabled,
      int? prefGeolocRadius,
      double? lat,
      double? lng}) async {}

  Future<void> deleteCurrUser() async {}
}
