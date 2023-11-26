import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk_around/data/datasources/data_util.dart';
import 'package:talk_around/domain/models/channel.dart';

class ChannelLocalDatasource {
  final String _channelsKey = 'channels';
  SharedPreferences? _prefs;

  Future<Channel> getChannel(String id) async {
    final SharedPreferences prefs = await _getPrefs();

    final String? channelsString = prefs.getString(_channelsKey);
    if (channelsString == null) {
      return Future.error('No channels in local storage');
    }

    final List<dynamic> channelsList = jsonDecode(channelsString);
    final Map<String, dynamic> channelMap =
        channelsList.firstWhere((channel) => channel['id'] == id);

    return Channel.fromJson(channelMap);
  }

  Future<List<Channel>> getChannelsFromUser(String userId) async {
    final SharedPreferences prefs = await _getPrefs();

    final String? channelsString = prefs.getString(_channelsKey);
    if (channelsString == null) return [];

    final List<dynamic> channelsList = jsonDecode(channelsString);
    final List<Map<String, dynamic>> channelsUserList = channelsList
        .where((channel) => (channel['users'] as List<String>).contains(userId))
        .toList()
        .cast<Map<String, dynamic>>();
    return channelsUserList.map((e) => Channel.fromJson(e)).toList();
  }

  Future<List<Channel>> getChannels(
      {double? lat, double? lng, double? radius}) async {
    final SharedPreferences prefs = await _getPrefs();

    final String? channelsString = prefs.getString(_channelsKey);
    if (channelsString == null) return [];

    List<Channel> channelsList =
        jsonDecode(channelsString).map((e) => Channel.fromJson(e));
    if (lat != null && lng != null && radius != null) {
      channelsList = channelsList.where((e) {
        if (e.lat == null || e.lng == null) return false;
        return DataUtil.calculateDistance(lat, lng, e.lat!, e.lng!) < radius;
      }).toList();
    }

    return channelsList;
  }

  Future<Channel> createChannel(Channel channel) async {
    final SharedPreferences prefs = await _getPrefs();

    final String? channelsString = prefs.getString(_channelsKey);
    if (channelsString == null)
      return Future.error('No channels in local storage');

    final List<dynamic> channelsList = jsonDecode(channelsString);
    final Map<String, dynamic> channelMap = channel.toJson();
    channelsList.add(channelMap);
    prefs.setString(_channelsKey, jsonEncode(channelsList));

    return channel;
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
    final SharedPreferences prefs = await _getPrefs();

    final String? channelsString = prefs.getString(_channelsKey);
    if (channelsString == null) {
      return Future.error('No channels in local storage');
    }

    final List<dynamic> channelsList = jsonDecode(channelsString);
    final List<dynamic> newChannelsList = channelsList.map((channel) {
      if (channel['id'] == channelId) {
        final List<dynamic> usersList = channel['users'];
        usersList.add(userId);
        channel['users'] = usersList;
      }
      return channel;
    }).toList();
    prefs.setString(_channelsKey, jsonEncode(newChannelsList));
  }

  Future<void> leaveChannel(String channelId, String userId) async {
    final SharedPreferences prefs = await _getPrefs();

    final String? channelsString = prefs.getString(_channelsKey);
    if (channelsString == null) {
      return Future.error('No channels in local storage');
    }

    final List<dynamic> channelsList = jsonDecode(channelsString);
    final List<dynamic> newChannelsList = channelsList.map((channel) {
      if (channel['id'] == channelId) {
        final List<dynamic> usersList = channel['users'];
        usersList.remove(userId);
        channel['users'] = usersList;
      }
      return channel;
    }).toList();
    prefs.setString(_channelsKey, jsonEncode(newChannelsList));
  }

  Future<void> deleteChannel(String id) async {
    final SharedPreferences prefs = await _getPrefs();

    final String? channelsString = prefs.getString(_channelsKey);
    if (channelsString == null) {
      return Future.error('No channels in local storage');
    }

    final List<dynamic> channelsList = jsonDecode(channelsString);
    final List<dynamic> newChannelsList =
        channelsList.where((channel) => channel['id'] != id).toList();
    prefs.setString(_channelsKey, jsonEncode(newChannelsList));
  }

  // Future<void> setChannels(List<Channel> channels) async {
  //   final SharedPreferences prefs = await _getPrefs();

  //   final List<dynamic> channelsList = channels.map((e) => e.toJson()).toList();
  //   prefs.setString(_channelsKey, jsonEncode(channelsList));
  // }

  Future<void> addChannelsIfNotExist(List<Channel> channels) async {
    final SharedPreferences prefs = await _getPrefs();

    final String? channelsString = prefs.getString(_channelsKey);
    if (channelsString == null) {
      prefs.setString(
          _channelsKey, jsonEncode(channels.map((e) => e.toJson()).toList()));
      return;
    }

    final List<dynamic> currentChannels = jsonDecode(channelsString);

    final List<Channel> newChannels = channels
        .where((channel) => !currentChannels.any((e) => e['id'] == channel.id))
        .toList();

    final List<dynamic> newChannelsList =
        newChannels.map((e) => e.toJson()).toList();
    prefs.setString(_channelsKey, jsonEncode(newChannelsList));
  }

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }
}
