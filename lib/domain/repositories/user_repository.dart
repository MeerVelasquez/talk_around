import 'package:talk_around/domain/models/user.dart';

abstract class UserRepository {
  Future<User> getCurrUser();

  Future<User> getUser(String id);

  Future<User> createUser(User user);

  Future<List<User>> getUsersFromChannel(String channelId,
      {int? prefGeolocRadius});

  Future<User> updateCurrUser(User user);

  Future<User> updatePartialCurrUser(
      {String? name,
      String? email,
      String? username,
      // String? password,
      bool? geolocEnabled,
      int? prefGeolocRadius,
      double? lat,
      double? lng});

  Future<void> deleteCurrUser();
}
