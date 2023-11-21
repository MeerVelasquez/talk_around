import 'package:talk_around/domain/models/channel.dart';

class ChannelLocalDatasource {
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
