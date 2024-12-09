import 'dart:convert';
import 'package:http/http.dart' as http;
import 'tags_model.dart';

class TagsController {
  final String baseUrl = 'http://localhost:4000';

  Future<List<TagModel>> getAllTags() async {
    final response = await http.get(Uri.parse('$baseUrl/tags'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((tag) => TagModel.fromJson(tag)).toList();
    } else {
      throw Exception('Failed to load tags');
    }
  }

  Future<TagModel> getTagById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/tags/$id'));
    if (response.statusCode == 200) {
      return TagModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load tag');
    }
  }

  Future<void> addTag(Map<String, dynamic> tag) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tags'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tag),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add tag');
    }
  }

  Future<void> deleteTag(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/tags/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete tag');
    }
  }
}
