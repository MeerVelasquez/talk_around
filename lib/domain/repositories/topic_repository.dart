import 'package:talk_around/domain/models/topic.dart';

abstract class TopicRepository {
  Future<Topic> getTopic(String id);

  Future<List<Topic>> getTopics();

  Future<Topic> createTopic(Topic topic);

  Future<void> deleteTopic();
}
