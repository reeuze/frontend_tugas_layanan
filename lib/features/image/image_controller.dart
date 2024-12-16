import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'image_model.dart';

import 'dart:developer' as developer;

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

  Future<ImageModel> addImage(
    ImageModel imageModel,
    Uint8List fileBytes,
    String fileName,
    String mimeType,
  ) async {
    final uri = Uri.parse('$baseUrl/images');
    final request = http.MultipartRequest('POST', uri);

    // Konversi ImageModel ke Map untuk fields
    Map<String, String> imageFields = {
      'name': imageModel.name,
      'description': imageModel.description,
      'userId': imageModel.userId.toString(),
      'path': imageModel.path,
    };
    request.fields.addAll(imageFields);

    // Tambahkan file ke request
    final file = http.MultipartFile.fromBytes(
      'file',
      fileBytes,
      filename: fileName,
      contentType: MediaType.parse(mimeType),
    );
    request.files.add(file);

    developer.log('Request fields: ${request.fields}');
    developer.log('Uploading file: $fileName with MIME type: $mimeType');

    // Kirim request
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(responseBody);
      return ImageModel.fromJson(jsonResponse);
    } else {
      throw Exception(
        'Failed to upload image. Status: ${response.statusCode}, Reason: ${response.reasonPhrase}',
      );
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
