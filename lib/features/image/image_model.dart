class ImageModel {
  final int imageId;
  final String name;
  final String description;
  final String path;
  final int userId;
  final String imageUrl;
  final List<TagModel> tags;

  ImageModel({
    required this.imageId,
    required this.name,
    required this.description,
    required this.path,
    required this.userId,
    required this.imageUrl,
    required this.tags,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      imageId: json['imageId'],
      name: json['name'],
      description: json['description'],
      path: json['path'],
      userId: json['userId'],
      imageUrl: json['imageUrl'],
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((tag) => TagModel.fromJson(tag))
          .toList(),
    );
  }
}

class TagModel {
  final int tagId;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TagModel({
    required this.tagId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      tagId: json['tagId'],
      name: json['name'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }
}
