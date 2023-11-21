import 'package:talk_around/domain/models/topic.dart';

class TopicLocalDatasource {
  Future<Topic> getTopic(String id) async {}

  Future<List<Topic>> getTopics() async {}

  Future<Topic> createTopic(Topic topic) async {}

  Future<void> deleteTopic() async {}
}
