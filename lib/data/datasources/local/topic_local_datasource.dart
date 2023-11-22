import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk_around/domain/models/topic.dart';

class TopicLocalDatasource {
  final String _topicsKey = 'topics';
  SharedPreferences? _prefs;

  Future<Topic> getTopic(String id) async {
    final SharedPreferences prefs = await _getPrefs();
    final String? topicsString = prefs.getString(_topicsKey);
    if (topicsString == null) return Future.error('No topics found');

    List<Map<String, dynamic>> topicsList = jsonDecode(topicsString);
    final Map<String, dynamic> topicsMap =
        topicsList.firstWhere((e) => e['id'] == id);

    return Topic.fromJson(topicsMap);
  }

  Future<List<Topic>> getTopics() async {
    final SharedPreferences prefs = await _getPrefs();
    final String? topicsString = prefs.getString(_topicsKey);
    if (topicsString == null) {
      return [];
    }

    List<Map<String, dynamic>> topicsList = jsonDecode(topicsString);
    return topicsList.map((e) => Topic.fromJson(e)).toList();
  }

  Future<void> setTopics(List<Topic> topics) async {
    final SharedPreferences prefs = await _getPrefs();
    final String topicsString =
        jsonEncode(topics.map((e) => e.toJson()).toList());
    await prefs.setString(_topicsKey, topicsString);
  }

  Future<void> addTopic(Topic topic) async {
    final SharedPreferences prefs = await _getPrefs();
    final String? topicsString = prefs.getString(_topicsKey);
    if (topicsString == null) {
      await prefs.setString(_topicsKey, jsonEncode([topic.toJson()]));
    } else {
      List<Map<String, dynamic>> topicsList = jsonDecode(topicsString);
      topicsList.add(topic.toJson());
      await prefs.setString(_topicsKey, jsonEncode(topicsList));
    }
  }

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }
}
