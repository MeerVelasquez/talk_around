import 'package:talk_around/domain/models/channel.dart';

abstract class ChannelRepository {
  Future<List<Channel>> getChannelsFromCurrentUser();

  Future<Channel> getChannel(String id);

  Future<List<Channel>> getChannelsFromUser(String id);

  Future<List<Channel>> getChannels();

  Future<Channel> createChannel(Channel channel);

  Future<Channel> updateChannel(String id, Channel channel);

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
  });

  Future<void> joinChannel(String id);

  Future<void> leaveChannel(String id);

  Future<void> deleteChannel(String id);
}
