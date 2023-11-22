import 'package:talk_around/domain/models/message.dart';

abstract class MessageRepository {
  Future<List<Message>> getMessagesFromChannel(String channelId);

  Future<Message> createMessage(Message message);

  Future<void> deleteMessage(String id);
}
