import 'package:talk_around/domain/models/user.dart';

abstract class UserRepository {
  Future<User> getCurrentUser();

  Future<User> getUser(String id);

  Future<User> getUserByEmail(String email);

  // Future<User> createUser(User user);

  Future<List<User>> getUsersFromChannel(String channelId);

  Future<void> setLocalUser(User user);

  // Future<User> updateCurrentUser(String id, User user);

  Future<User> updatePartialCurrentUser(String id,
      {String? name,
      String? email,
      String? username,
      // String? password,
      bool? geolocEnabled,
      int? prefGeolocRadius,
      double? lat,
      double? lng});

  Future<void> joinChannel(String channelId);

  Future<void> leaveChannel(String channelId);

  Future<void> deleteLocalUser();
}
