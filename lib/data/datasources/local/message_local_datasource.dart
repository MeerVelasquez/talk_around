import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:talk_around/domain/models/message.dart';

class MessageLocalDatasource {
  final String _messagesKey = 'messages';
  SharedPreferences? _prefs;

  Future<List<MessageStore>> getMessagesStore() async =>
      await _getMessagesStore();

  Future<List<MessageStore>> getMessagesStoreFromChannel(
          String channelId) async =>
      await _getMessagesStoreFromChannel(channelId);

  Future<List<Message>> getMessagesFromChannel(String channelId) async =>
      (await _getMessagesStoreFromChannel(channelId))
          .map((messageStore) => messageStore.data)
          .toList();

  // Future<void> addMessage(bool isUpToDate, Message message) async {
  //   final SharedPreferences prefs = await _getPrefs();
  //   final String? messagesString = prefs.getString(_messagesKey);
  //   if (messagesString == null) {
  //     await prefs.setString(
  //         _messagesKey,
  //         jsonEncode([
  //           MessageStore(message, isUpToDate).toJson(),
  //         ]));
  //   } else {
  //     List<Map<String, dynamic>> messagesStoreList = jsonDecode(messagesString);
  //     messagesStoreList.add(MessageStore(message, isUpToDate).toJson());
  //     await prefs.setString(_messagesKey, jsonEncode(messagesStoreList));
  //   }
  // }

  Future<void> addMessagesIfNotExist(
      bool isUpToDate, List<Message> messages) async {
    final SharedPreferences prefs = await _getPrefs();

    final List<MessageStore> messagesStoreList = await _getMessagesStore();
    for (final Message message in messages) {
      try {
        final MessageStore messageStore = messagesStoreList
            .firstWhere((messageStore) => messageStore.data.id == message.id);
        if (isUpToDate && !messageStore.isUpToDate) {
          messageStore.isUpToDate = true;
        }
      } catch (err) {
        // messageStore was not found
        messagesStoreList.add(MessageStore(message, isUpToDate));
      }
    }

    await prefs.setString(
        _messagesKey,
        jsonEncode(
            messagesStoreList.map((messageStore) => messageStore.toJson())));
  }

  Future<void> setMessagesStore(List<MessageStore> messagesStore) async {
    final SharedPreferences prefs = await _getPrefs();
    await prefs.setString(
        _messagesKey, jsonEncode(messagesStore.map((e) => e.toJson())));
  }

  Future<void> deleteMessage(String id) async {
    final SharedPreferences prefs = await _getPrefs();
    final String? messagesString = prefs.getString(_messagesKey);
    if (messagesString == null) return;

    final List<Map<String, dynamic>> messagesStoreList =
        jsonDecode(messagesString);
    Map<String, dynamic> messageStore = messagesStoreList
        .firstWhere((messageStore) => messageStore['data']['id'] == 'id');
    messageStore['data']['deleted'] = true;
    await prefs.setString(_messagesKey, jsonEncode(messagesStoreList));
  }

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<List<MessageStore>> _getMessagesStore() async {
    final SharedPreferences prefs = await _getPrefs();
    final String? messagesString = prefs.getString(_messagesKey);
    if (messagesString == null) return [];

    final List<Map<String, dynamic>> messagesStoreList =
        jsonDecode(messagesString);
    return messagesStoreList
        .map((messageStoreMap) => MessageStore.fromJson(messageStoreMap))
        .toList();
  }

  Future<List<MessageStore>> _getMessagesStoreFromChannel(
          String channelId) async =>
      (await _getMessagesStore()).where((message) {
        return message.data.channelId == channelId;
      }).toList();
}

class MessageStore {
  MessageStore(this.data, this.isUpToDate);

  Message data;
  bool isUpToDate; // whether the data is updated in the backend

  factory MessageStore.fromJson(Map<String, dynamic> json) => MessageStore(
        Message.fromJson(json["data"]),
        json["isUpToDate"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "isUpToDate": isUpToDate,
      };
}
