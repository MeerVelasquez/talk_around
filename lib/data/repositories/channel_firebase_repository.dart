import 'package:loggy/loggy.dart';
import 'package:talk_around/data/datasources/local/channel_local_datasource.dart';
import 'package:talk_around/data/datasources/remote/channel_datasource.dart';
import 'package:talk_around/services/network_service.dart';

import 'package:talk_around/domain/models/channel.dart';
import 'package:talk_around/domain/repositories/channel_repository.dart';

class ChannelFirebaseRepository implements ChannelRepository {
  final ChannelLocalDatasource _channelLocalDatasource =
      ChannelLocalDatasource();
  final ChannelDatasource _channelDatasource = ChannelDatasource();

  // @override
  // Future<List<Channel>> getChannelsFromCurrentUser() async {}

  @override
  Future<Channel> getChannel(String id) async {
    try {
      return await _channelDatasource.getChannel(id);
    } catch (err) {
      if (!(await NetworkService.hasNetwork())) {
        return await _channelLocalDatasource.getChannel(id);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<List<Channel>> getChannelsFromUser(String id) async {
    try {
      List<Channel> channels = await _channelDatasource.getChannelsFromUser(id);
      _channelLocalDatasource.addChannelsIfNotExist(channels).catchError((err) {
        logError(err);
      });
      return channels;
    } catch (err) {
      if (!(await NetworkService.hasNetwork())) {
        return await _channelLocalDatasource.getChannelsFromUser(id);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<List<Channel>> getChannels(
      {double? lat, double? lng, double? radius}) async {
    try {
      List<Channel> channels = await _channelDatasource.getChannels(
        lat: lat,
        lng: lng,
        radius: radius,
      );
      _channelLocalDatasource.addChannelsIfNotExist(channels).catchError((err) {
        logError(err);
      });
      return channels;
    } catch (err) {
      if (!(await NetworkService.hasNetwork())) {
        return await _channelLocalDatasource.getChannels(
          lat: lat,
          lng: lng,
          radius: radius,
        );
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<Channel> createChannel(Channel channel) async {
    Channel newChannel = await _channelDatasource.createChannel(channel);
    await _channelLocalDatasource.createChannel(newChannel);
    return newChannel;
  }

  // @override
  // Future<Channel> updateChannel(String id, Channel channel) async {}

  // @override
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

  @override
  Future<void> joinChannel(String channelId, String userId) async {
    await _channelDatasource.joinChannel(channelId, userId);
    await _channelLocalDatasource.joinChannel(channelId, userId);
  }

  @override
  Future<void> leaveChannel(String channelId, String userId) async {
    await _channelDatasource.leaveChannel(channelId, userId);
    await _channelLocalDatasource.leaveChannel(channelId, userId);
  }

  @override
  Future<void> deleteChannel(String id) async {
    await _channelDatasource.deleteChannel(id);
    await _channelLocalDatasource.deleteChannel(id);
  }
}
