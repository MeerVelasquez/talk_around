class Topic {
  String? id;
  String title;
  String description;
  String imageUrl;

  Topic({
    this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
      };
}
