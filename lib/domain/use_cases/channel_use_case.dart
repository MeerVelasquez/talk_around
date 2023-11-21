import 'package:get/get.dart';

import 'package:talk_around/domain/models/channel.dart';
import 'package:talk_around/domain/repositories/channel_repository.dart';
// import 'package:talk_around/data/repositories/channel_firebase_repository.dart';

class ChannelUseCase {
  final ChannelRepository _channelRepository = Get.find<ChannelRepository>();

  Future<List<Channel>> getChannelsFromCurrUser() async {
    return await _channelRepository.getChannelsFromCurrUser();
  }

  Future<Channel> getChannel(String id) async {
    return await _channelRepository.getChannel(id);
  }

  Future<List<Channel>> getChannelsFromUser(String id) async {
    return await _channelRepository.getChannelsFromUser(id);
  }

  Future<List<Channel>> getChannels() async {
    return await _channelRepository.getChannels();
  }

  Future<Channel> createChannel(Channel channel) async {
    return await _channelRepository.createChannel(channel);
  }

  Future<Channel> updateChannel(String id, Channel channel) async {
    return await _channelRepository.updateChannel(id, channel);
  }

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
  }) async {
    return await _channelRepository.updatePartialChannel(
      id,
      topicId: topicId,
      creatorId: creatorId,
      name: name,
      description: description,
      imageUrl: imageUrl,
      language: language,
      country: country,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lat: lat,
      lng: lng,
    );
  }

  Future<void> joinChannel(String id) async {
    return await _channelRepository.joinChannel(id);
  }

  Future<void> leaveChannel(String id) async {
    return await _channelRepository.leaveChannel(id);
  }

  Future<void> deleteChannel(String id) async {
    return await _channelRepository.deleteChannel(id);
  }
}
