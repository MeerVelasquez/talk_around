class Channel {
  String? id;
  String topicId;
  String creatorId;
  String name;
  String description;
  String imageUrl;
  String language;
  String country;
  String createdAt;
  String updatedAt;
  double lat;
  double lng;
  List<String> users;

  Channel({
    this.id,
    required this.topicId,
    required this.creatorId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.language,
    required this.country,
    required this.createdAt,
    required this.updatedAt,
    required this.lat,
    required this.lng,
    required this.users,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'],
      topicId: json['topicId'],
      creatorId: json['creatorId'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      language: json['language'],
      country: json['country'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      lat: json['lat'],
      lng: json['lng'],
      users: List<String>.from(json['users'] as List),
    );
  }

  factory Channel.from(Channel channel) {
    return Channel(
      id: channel.id,
      topicId: channel.topicId,
      creatorId: channel.creatorId,
      name: channel.name,
      description: channel.description,
      imageUrl: channel.imageUrl,
      language: channel.language,
      country: channel.country,
      createdAt: channel.createdAt,
      updatedAt: channel.updatedAt,
      lat: channel.lat,
      lng: channel.lng,
      users: channel.users,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'topicId': topicId,
        'creatorId': creatorId,
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'language': language,
        'country': country,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'lat': lat,
        'lng': lng,
        'users': users,
      };
}
