import 'package:get/get.dart';

import 'package:talk_around/domain/models/message.dart';
import 'package:talk_around/domain/repositories/message_repository.dart';
// import 'package:talk_around/data/repositories/message_firebase_repository.dart';

class MessageUseCase {
  final MessageRepository _messageRepository = Get.find<MessageRepository>();

  Future<List<Message>> getMessagesFromChannel() async {
    return await _messageRepository.getMessagesFromChannel();
  }

  Future<Message> createMessage(Message message) async {
    return await _messageRepository.createMessage(message);
  }

  Future<void> deleteMessage(String id) async {
    return await _messageRepository.deleteMessage(id);
  }
}
