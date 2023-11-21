import 'package:get/get.dart';

import 'package:talk_around/domain/models/topic.dart';
import 'package:talk_around/domain/repositories/topic_repository.dart';
// import 'package:talk_around/data/repositories/topic_firebase_repository.dart';

class TopicUseCase {
  final TopicRepository _topicRepository = Get.find<TopicRepository>();

  Future<Topic> getTopic(String id) async {
    return await _topicRepository.getTopic(id);
  }

  Future<List<Topic>> getTopics() async {
    return await _topicRepository.getTopics();
  }

  Future<Topic> createTopic(Topic topic) async {
    return await _topicRepository.createTopic(topic);
  }

  Future<void> deleteTopic() async {
    return await _topicRepository.deleteTopic();
  }
}
