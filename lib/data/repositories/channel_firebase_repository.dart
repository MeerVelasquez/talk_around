import 'package:talk_around/data/datasources/local/channel_local_datasource.dart';
import 'package:talk_around/data/datasources/remote/channel_datasource.dart';

import 'package:talk_around/domain/models/channel.dart';
import 'package:talk_around/domain/repositories/channel_repository.dart';

class ChannelFirebaseRepository implements ChannelRepository {
  final ChannelLocalDatasource _channelLocalDatasource =
      ChannelLocalDatasource();
  final ChannelDatasource _channelDatasource = ChannelDatasource();

  Future<List<Channel>> getChannelsFromCurrUser() async {}

  Future<Channel> getChannel(String id) async {}

  Future<List<Channel>> getChannelsFromUser(String id) async {}

  Future<List<Channel>> getChannels() async {}

  Future<Channel> createChannel(Channel channel) async {}

  Future<Channel> updateChannel(String id, Channel channel) async {}

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

  Future<void> joinChannel(String id) async {}

  Future<void> leaveChannel(String id) async {}

  Future<void> deleteChannel(String id) async {}
}
