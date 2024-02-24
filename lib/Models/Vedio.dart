class Memory {
  String id;
  ContentType contentType;
  String? content;
  DateTime createdAt;
  DateTime? lastModified;
  List<String> tags;
  String? location;
  String? emotion;
  bool isPrivate;
  // Constructor
  Memory({
    required this.id,
    required this.contentType,
    this.content,
    required this.createdAt,
    this.lastModified,
    this.tags = const [],
    this.location,
    this.emotion,
    this.isPrivate = false,
  });

  // Example method to add a tag
  void addTag(String tag) {
    tags.add(tag);
  }

  // Convert a Memory object to a Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content_type': contentType.index,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'last_modified': lastModified?.toIso8601String(),
      'tags': tags.join(','),
      'location': location,
      'emotion': emotion,
      'is_private': isPrivate ? 1 : 0,
    };
  }

  // Create a Memory object from a database Map
  static Memory fromMap(Map<String, dynamic> map) {
    return Memory(
      id: map['id'],
      contentType: ContentType
          .values[map['content_type']], // Convert integer back to enum
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
      lastModified: map['last_modified'] != null
          ? DateTime.parse(map['last_modified'])
          : null,
      tags: map['tags'] != null
          ? map['tags'].split(',')
          : [], // Split tags string
      location: map['location'],
      emotion: map['emotion'],
      isPrivate: map['is_private'] == 1,
    );
  }
}

enum ContentType { text, image, video, audio }
