import 'package:flutter/material.dart';
import 'package:frontend_tugas_layanan/features/home/home_page.dart'; // Import HomePage
import 'tags_model.dart';
import 'tags_controller.dart';

class TagsPage extends StatelessWidget {
  final String tag;

  TagsPage({super.key, required this.tag});

  final controller = TagsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tags: $tag'),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder<List<TagModel>>(
        future: controller.getAllTags(), // Memanggil fungsi getAllTags untuk mengambil data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tags available'));
          } else {
            final tags = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tags.length,
              itemBuilder: (context, index) {
                final tag = tags[index];
                return ListTile(
                  title: Text(tag.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(filterTag: tag.name), // Navigasi ke HomePage dengan filter
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
