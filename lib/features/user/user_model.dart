// import 'package:frontend_tugas_layanan/features/image/image_model.dart';

class UserModel {
  final int userId;
  final String name;
  final String email;
  final String password;
  final DateTime? birthdate;
  final String? gender;
  final String? phone;
  final String? urlProfile;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<UserImage>? images;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.password,
    this.birthdate,
    this.gender,
    this.phone,
    required this.urlProfile,
    required this.createdAt,
    required this.updatedAt,
    this.images,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      birthdate: json['birthdate'] != null ? DateTime.tryParse(json['birthdate']) : null,
      gender: json['gender'],
      phone: json['phone'],
      urlProfile: json['url_profile'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      images: (json['images'] as List<dynamic>? ?? [])
          .map((image) => UserImage.fromJson(image))
          .toList(),
    );
  }
}

class UserImage {
  final int imageId;
  final String name;
  final String path;
  final String imageUrl;

  UserImage({
    required this.imageId,
    required this.name,
    required this.path,
    required this.imageUrl,
  });

  factory UserImage.fromJson(Map<String, dynamic> json) {
    return UserImage(
      imageId: json['imageId'],
      name: json['name'],
      path: json['path'],
      imageUrl: json['imageUrl'],
    );
  }
}
