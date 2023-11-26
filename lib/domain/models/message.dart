import 'package:loggy/loggy.dart';

class Message {
  String? id;
  String text;
  String senderId;
  String channelId;
  DateTime? createdAt;
  bool deleted;

  Message({
    this.id,
    required this.text,
    required this.senderId,
    required this.channelId,
    required this.createdAt,
    this.deleted = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    DateTime? createdAt;
    bool deleted = false;

    try {
      createdAt =
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    } catch (err) {
      logError('Message.fromJson: createdAt: $err');
    }

    try {
      deleted = json['deleted'] ?? false;
    } catch (err) {
      logError('Message.fromJson: deleted: $err');
    }

    return Message(
      id: json['id'],
      text: json['text'] ?? '',
      senderId: json['senderId'] ?? '',
      channelId: json['channelId'] ?? '',
      createdAt: createdAt,
      deleted: deleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'senderId': senderId,
      'channelId': channelId,
      'createdAt': createdAt,
      'deleted': deleted,
    };
  }
}
