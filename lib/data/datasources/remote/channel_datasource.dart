import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talk_around/data/datasources/data_util.dart';

import 'package:talk_around/domain/models/channel.dart';

class ChannelDatasource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'channel';

  Future<Channel> getChannel(String id) async {
    DocumentSnapshot doc = await _db.collection(_collection).doc(id).get();
    if (!doc.exists) {
      return Future.error('No channel with id $id');
    }
    Map<String, dynamic> channelMap = doc.data() as Map<String, dynamic>;
    channelMap['id'] = doc.id;
    return Channel.fromJson(channelMap);
  }

  Future<List<Channel>> getChannelsFromUser(String userId) async {
    QuerySnapshot query = await _db
        .collection(_collection)
        .where('users', arrayContains: userId)
        .get();
    return query.docs.map((doc) {
      Map<String, dynamic> channelMap = doc.data() as Map<String, dynamic>;
      channelMap['id'] = doc.id;
      return Channel.fromJson(channelMap);
    }).toList();
  }

  Future<List<Channel>> getChannels(
      {double? lat, double? lng, double? radius}) async {
    QuerySnapshot query = await _db.collection(_collection).get();

    List<Channel> channelsList = query.docs.map((doc) {
      Map<String, dynamic> channelMap = doc.data() as Map<String, dynamic>;
      channelMap['id'] = doc.id;
      return Channel.fromJson(channelMap);
    }).toList();

    if (lat != null && lng != null && radius != null) {
      channelsList = channelsList
          .where((e) =>
              DataUtil.calculateDistance(lat, lng, e.lat, e.lng) < radius)
          .toList();
    }

    return channelsList;
  }

  Future<Channel> createChannel(Channel channel) async {
    final Channel newChannel = Channel.from(channel);
    DocumentReference docRef =
        await _db.collection(_collection).add(channel.toJson());
    newChannel.id = docRef.id;
    return newChannel;
  }

  // Future<Channel> updateChannel(String id, Channel channel) async {}

  // Future<Channel> updatePartialChannel(
  //   String id, {
  //   String? topicId,
  //   String? creatorId,
  //   String? name,
  //   String? description,
  //   String? imageUrl,
  //   String? language,
  //   String? country,
  //   String? createdAt,
  //   String? updatedAt,
  //   double? lat,
  //   double? lng,
  //   // String? users,
  // }) async {}

  Future<void> joinChannel(String channelId, String userId) async {
    DocumentReference docRef = _db.collection(_collection).doc(channelId);
    DocumentSnapshot doc = await docRef.get();
    if (!doc.exists) {
      return Future.error('No channel with id $channelId');
    }
    Map<String, dynamic> channelMap = doc.data() as Map<String, dynamic>;
    List<dynamic> users = channelMap['users'];
    if (users.contains(userId)) {
      return Future.error('User $userId already in channel $channelId');
    }
    users.add(userId);
    await docRef.update({'users': users});
  }

  Future<void> leaveChannel(String channelId, String userId) async {
    DocumentReference docRef = _db.collection(_collection).doc(channelId);
    DocumentSnapshot doc = await docRef.get();
    if (!doc.exists) {
      return Future.error('No channel with id $channelId');
    }
    Map<String, dynamic> channelMap = doc.data() as Map<String, dynamic>;
    List<dynamic> users = channelMap['users'];
    if (!users.contains(userId)) {
      return Future.error('User $userId not in channel $channelId');
    }
    users.remove(userId);
    await docRef.update({'users': users});
  }

  Future<void> deleteChannel(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }
}
