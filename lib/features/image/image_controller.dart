import 'dart:convert';
// import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;

import 'image_model.dart';

// import 'dart:developer' as developer;

class ImageController {
  final String baseUrl = 'http://localhost:4000';

  Future<List<ImageModel>> getAllImages() async {
    final response = await http.get(Uri.parse('$baseUrl/images'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      // developer.log(data.toString());
      return data.map((image) {
        // developer.log(image.toString());
        return ImageModel.fromJson(image);
      }).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }

  Future<ImageModel> getImageById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/images/$id'));
    // developer.log(response.body);
    if (response.statusCode == 200) {
      // developer.log(jsonDecode(response.body).toString());
      return ImageModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<void> addImage(Map<String, dynamic> image, String filePath) async {
    final uri = Uri.parse('$baseUrl/images');
    final request = http.MultipartRequest('POST', uri);
    Map<String, String> imageFields = {
      for (var entry in image.entries) entry.key: entry.value.toString()
    };
    request.fields.addAll(imageFields);
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to add image');
    }
  }

  Future<void> updateImage(int id, Map<String, dynamic> image) async {
    final response = await http.put(
      Uri.parse('$baseUrl/images/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(image),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update image');
    }
  }

  Future<void> deleteImage(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/images/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete image');
    }
  }
}
