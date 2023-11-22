import 'package:talk_around/data/datasources/local/message_local_datasource.dart';
import 'package:talk_around/data/datasources/remote/message_datasource.dart';
import 'package:talk_around/data/utils/network_util.dart';

import 'package:talk_around/domain/models/message.dart';
import 'package:talk_around/domain/repositories/message_repository.dart';

class MessageFirebaseRepository implements MessageRepository {
  final MessageLocalDatasource _messageLocalDatasource =
      MessageLocalDatasource();
  final MessageDatasource _messageDatasource = MessageDatasource();

  @override
  Future<List<Message>> getMessagesFromChannel(String channelId) async {
    try {
      List<Message> messages =
          await _messageDatasource.getMessagesFromChannel(channelId);
      await _messageLocalDatasource.addMessagesIfNotExist(true, messages);

      return messages;
    } catch (err) {
      if (!(await NetworkUtil.hasNetwork())) {
        return await _messageLocalDatasource.getMessagesFromChannel(channelId);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<Message> createMessage(Message message) async {
    try {
      Message createdMessage = await _messageDatasource.createMessage(message);
      await _messageLocalDatasource
          .addMessagesIfNotExist(true, [createdMessage]);
      return createdMessage;
    } catch (err) {
      if (!(await NetworkUtil.hasNetwork())) {
        await _messageLocalDatasource.addMessagesIfNotExist(false, [message]);
        return message;
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<void> deleteMessage(String id) async {
    try {
      await _messageDatasource.deleteMessage(id);
      await _messageLocalDatasource.deleteMessage(id);
    } catch (err) {
      if (!(await NetworkUtil.hasNetwork())) {
        await _messageLocalDatasource.deleteMessage(id);
      } else {
        rethrow;
      }
    }
  }
}
