class Message {
  final String? id;
  final String text;
  final String senderId;
  final String channelId;
  final DateTime createdAt;
  final bool deleted;

  Message({
    this.id,
    required this.text,
    required this.senderId,
    required this.channelId,
    required this.createdAt,
    this.deleted = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      text: json['text'],
      senderId: json['senderId'],
      channelId: json['channelId'],
      createdAt: DateTime.parse(json['createdAt']),
      deleted: json['deleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'senderId': senderId,
      'channelId': channelId,
      'createdAt': createdAt.toIso8601String(),
      'deleted': deleted,
    };
  }
}
