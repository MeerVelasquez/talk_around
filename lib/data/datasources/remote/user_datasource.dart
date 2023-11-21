import 'package:talk_around/domain/models/user.dart';

class UserDatasource {
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
