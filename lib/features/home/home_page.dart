import 'package:flutter/material.dart';
import 'package:frontend_tugas_layanan/features/image/image_controller.dart';
import 'package:frontend_tugas_layanan/features/tags/tags_page.dart';
import 'package:frontend_tugas_layanan/features/user/user_page.dart';
import 'package:frontend_tugas_layanan/features/image/image_page.dart';
import 'package:frontend_tugas_layanan/features/image/image_model.dart';

// import 'dart:developer' as developer;

class HomePage extends StatefulWidget {
  final String? filterTag;

  const HomePage({super.key, this.filterTag});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = ImageController();
  List<ImageModel> images = [];
  List<ImageModel> filteredImages = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  void _loadImages() async {
    final allImages = await _controller.getAllImages();
    setState(() {
      images = allImages;
      if (widget.filterTag != null) {
        filteredImages = images
            .where((image) => image.tags.any((tag) => tag.name == widget.filterTag))
            .toList();
      } else {
        filteredImages = images;
      }
    });
  }

  void _searchImages(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredImages = images; // Reset jika pencarian kosong
      } else {
        filteredImages = images.where((image) {
          return image.name.toLowerCase().contains(query.toLowerCase()) ||
              image.tags.any((tag) => tag.name.toLowerCase().contains(query.toLowerCase())) ||
              image.imageId.toString() == query;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _searchController.clear();
                  filteredImages = images;
                });
              },
              child: const Row(
                children: [
                  Icon(Icons.image, size: 32),
                  SizedBox(width: 8),
                  Text('PictBoard', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Spacer(),
            Expanded(
              flex: 2,
              child: TextField(
                controller: _searchController,
                onChanged: _searchImages,
                decoration: InputDecoration(
                  hintText: 'Search by tag, name, or ID...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _searchImages(_searchController.text);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tag),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TagsPage(tag: 'All Tags'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserPage(userId: 10),
                ),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = (constraints.maxWidth > 600) ? 3 : 2;
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: filteredImages.length,
            itemBuilder: (context, index) {
              final image = filteredImages[index];
              return GestureDetector(
                onTap: () async {
                  // developer.log(image.imageId.toString());
                  final ImageModel updatedImage = await _controller.getImageById(image.imageId);
                  // developer.log(updatedImage.toString());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImagePage(image: updatedImage),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    image.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
