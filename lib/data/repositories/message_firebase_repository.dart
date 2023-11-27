import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import 'package:talk_around/data/datasources/local/message_local_datasource.dart';
import 'package:talk_around/data/datasources/remote/message_datasource.dart';
import 'package:talk_around/services/network_service.dart';

import 'package:talk_around/domain/models/message.dart';
import 'package:talk_around/domain/repositories/message_repository.dart';

class MessageFirebaseRepository implements MessageRepository {
  final MessageLocalDatasource _messageLocalDatasource =
      MessageLocalDatasource();
  final MessageDatasource _messageDatasource = MessageDatasource();

  final Rx<Stream<List<Message>?>> _messageChanges =
      Rx<Stream<List<Message>?>>(const Stream.empty());

  String? _channelId;
  String? _userId;

  // MessageFirebaseRepository() {
  //   _messageChanges.value =
  //       _messageDatasource.messageChanges.stream.asBroadcastStream().asyncMap((user) {
  //     if (user == null) {
  //       return null;
  //     } else {
  //       return Message();
  //     }
  //   });
  // }

  @override
  Stream<List<Message>?> getMessageChanges(String channelId, String userId) {
    if (_channelId != channelId || _userId != userId) {
      _channelId = channelId;
      _userId = userId;
      _messageChanges.value = _messageDatasource.messageChanges.stream
          .asBroadcastStream()
          .map((List<Message>? messages) => messages);
    }
    return _messageChanges.value;
  }

  @override
  Future<List<Message>> getMessagesFromChannel(String channelId) async {
    bool lastNetworkCheck = NetworkService.lastNetworkCheck;

    if (await NetworkService.hasNetwork()) {
      if (!lastNetworkCheck) {
        await createMissingMessages();
      }
      List<Message> messages =
          await _messageDatasource.getMessagesFromChannel(channelId);
      await _messageLocalDatasource.addMessagesIfNotExist(true, messages);
      return messages;
    } else {
      return await _messageLocalDatasource.getMessagesFromChannel(channelId);
    }
  }

  @override
  Future<Message> createMessage(Message message) async {
    bool lastNetworkCheck = NetworkService.lastNetworkCheck;

    if (await NetworkService.hasNetwork()) {
      if (!lastNetworkCheck) {
        await createMissingMessages();
      }
      Message createdMessage = await _messageDatasource.createMessage(message);
      await _messageLocalDatasource
          .addMessagesIfNotExist(true, [createdMessage]);
      return createdMessage;
    } else {
      await _messageLocalDatasource.addMessagesIfNotExist(false, [message]);
      return message;
    }
  }

  @override
  Future<void> deleteMessage(String id) async {
    bool lastNetworkCheck = NetworkService.lastNetworkCheck;

    if (await NetworkService.hasNetwork()) {
      if (!lastNetworkCheck) {
        await createMissingMessages();
      }
      await _messageDatasource.deleteMessage(id);
      await _messageLocalDatasource.deleteMessage(id);
    } else {
      await _messageLocalDatasource.deleteMessage(id);
    }
  }

  Future<void> createMissingMessages() async {
    final List<MessageStore> messagesStore =
        await _messageLocalDatasource.getMessagesStore();
    final List<MessageStore> missingMessagesStore =
        messagesStore.where((e) => !e.isUpToDate).toList();
    if (missingMessagesStore.isEmpty) return;

    final List<Future<bool>> futures =
        missingMessagesStore.map<Future<bool>>((messageStore) async {
      try {
        Message newMessage =
            await _messageDatasource.createMessage(messageStore.data);
        logInfo('Missing message added!');
        messageStore.data = newMessage;
        messageStore.isUpToDate = true;
        return true;
      } catch (err) {
        logError(err);
        return false;
      }
    }).toList();

    try {
      List<bool> processed = await Future.wait(futures);
      if (processed.contains(false)) {
        await _messageLocalDatasource.setMessagesStore(messagesStore);
        logInfo('Missing messages updated locally!');
      }
    } catch (err) {
      logError(err);
    }
  }
}
