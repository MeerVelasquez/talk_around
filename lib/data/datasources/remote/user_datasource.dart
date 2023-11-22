import 'package:talk_around/domain/models/user.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatasource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'user';

  Future<User> getUser(String id) async {
    DocumentSnapshot doc = await _db.collection(_collection).doc(id).get();
    if (!doc.exists) {
      return Future.error('No user with id $id');
    }
    Map<String, dynamic> userMap = doc.data() as Map<String, dynamic>;
    userMap['id'] = doc.id;
    return User.fromJson(userMap);
  }

  // Future<User> createUser(User user) async {}

  Future<List<User>> getUsersFromChannel(String channelId) async {
    QuerySnapshot query = await _db
        .collection(_collection)
        .where('channels', arrayContains: channelId)
        .get();
    return query.docs.map((doc) {
      Map<String, dynamic> userMap = doc.data() as Map<String, dynamic>;
      userMap['id'] = doc.id;
      return User.fromJson(userMap);
    }).toList();
  }

  // Future<User> updateCurrentUser(String id, User user) async {
  //   await _db.collection(_collection).doc(id).update(user.toJson());
  //   return user;
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
    Map<String, dynamic> data = {
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (username != null) 'username': username,
      // if (password != null) 'password': password,
      if (geolocEnabled != null) 'geolocEnabled': geolocEnabled,
      if (prefGeolocRadius != null) 'prefGeolocRadius': prefGeolocRadius,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    };

    await _db.collection(_collection).doc(id).update(data);
    return await getUser(id);
  }

  Future<void> joinChannel(String userId, String channelId) async {
    // await _db
    //     .collection(_collection)
    //     .doc(userId)
    //     .update({'channels': FieldValue.arrayUnion([channelId])});
    DocumentReference docRef = _db.collection(_collection).doc(userId);
    DocumentSnapshot doc = await docRef.get();
    if (!doc.exists) {
      return Future.error('No user with id $userId');
    }
    Map<String, dynamic> userMap = doc.data() as Map<String, dynamic>;
    List<dynamic> channels = userMap['channels'];
    if (channels.contains(channelId)) {
      return Future.error('channel $channelId already in user $userId');
    }
    channels.add(channelId);
    await docRef.update({'channels': channels});
  }

  Future<void> leaveChannel(String userId, String channelId) async {
    // await _db
    //     .collection(_collection)
    //     .doc(userId)
    //     .update({'channels': FieldValue.arrayRemove([channelId])});
    DocumentReference docRef = _db.collection(_collection).doc(userId);
    DocumentSnapshot doc = await docRef.get();
    if (!doc.exists) {
      return Future.error('No user with id $userId');
    }
    Map<String, dynamic> userMap = doc.data() as Map<String, dynamic>;
    List<dynamic> channels = userMap['channels'];
    if (!channels.contains(channelId)) {
      return Future.error('channel $channelId not in user $userId');
    }
    channels.remove(channelId);
    await docRef.update({'channels': channels});
  }
}
