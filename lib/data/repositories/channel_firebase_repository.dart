import 'package:talk_around/data/datasources/local/channel_local_datasource.dart';
import 'package:talk_around/data/datasources/remote/channel_datasource.dart';

import 'package:talk_around/domain/models/channel.dart';
import 'package:talk_around/domain/repositories/channel_repository.dart';

class ChannelFirebaseRepository implements ChannelRepository {
  final ChannelLocalDatasource _channelLocalDatasource =
      ChannelLocalDatasource();
  final ChannelDatasource _channelDatasource = ChannelDatasource();

  @override
  Future<List<Channel>> getChannelsFromCurrentUser() async {}

  @override
  Future<Channel> getChannel(String id) async {}

  @override
  Future<List<Channel>> getChannelsFromUser(String id) async {}

  @override
  Future<List<Channel>> getChannels() async {}

  @override
  Future<Channel> createChannel(Channel channel) async {}

  @override
  Future<Channel> updateChannel(String id, Channel channel) async {}

  @override
  Future<Channel> updatePartialChannel(
    String id, {
    String? topicId,
    String? creatorId,
    String? name,
    String? description,
    String? imageUrl,
    String? language,
    String? country,
    String? createdAt,
    String? updatedAt,
    double? lat,
    double? lng,
  }) async {}

  @override
  Future<void> joinChannel(String id) async {}

  @override
  Future<void> leaveChannel(String id) async {}

  @override
  Future<void> deleteChannel(String id) async {}
}
