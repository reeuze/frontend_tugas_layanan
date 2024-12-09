import 'package:frontend_tugas_layanan/features/image/image_model.dart';

class TagModel {
  final int tagId;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<ImageModel> images;

  TagModel({
    required this.tagId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      tagId: json['tagId'],
      name: json['name'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      images: (json['images'] as List<dynamic>? ?? [])
          .map((image) => ImageModel.fromJson(image))
          .toList(),
    );
  }
}
