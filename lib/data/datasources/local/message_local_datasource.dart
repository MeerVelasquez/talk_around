import 'package:talk_around/domain/models/message.dart';

class MessageLocalDatasource {
  Future<List<Message>> getMessagesFromChannel() async {}

  Future<Message> createMessage(Message message) async {}

  Future<void> deleteMessage(String id) async {}
}
