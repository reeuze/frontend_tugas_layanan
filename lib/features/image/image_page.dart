import 'package:flutter/material.dart';
import 'package:frontend_tugas_layanan/features/image/image_model.dart';
// import 'package:frontend_tugas_layanan/features/image/update_image.dart';
import 'package:frontend_tugas_layanan/features/home/home_page.dart';
import 'package:frontend_tugas_layanan/features/user/user_page.dart';

class ImagePage extends StatelessWidget {
  final ImageModel image;

  const ImagePage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(image.name),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigasi ke halaman update image
              // Navigator.push(
                // context,
                // MaterialPageRoute(
                //   builder: (context) => UpdateImagePage(image: image),
                // ),
              // );
            },
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Kiri: Gambar
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.network(
                image.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Bagian Kanan: Detail Gambar
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID: ${image.imageId}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Name: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(image.name),
                  const SizedBox(height: 10),
                  const Text(
                    'Description:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(image.description),
                  const SizedBox(height: 10),
                  const Text(
                    'Tags:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: image.tags.map((tag) {
                      return GestureDetector(
                        onTap: () {
                          // Navigasi ke HomePage dengan filter berdasarkan tag
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(filterTag: tag.name),
                            ),
                          );
                        },
                        child: Chip(
                          label: Text(tag.name),
                          backgroundColor: Colors.blue[100],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserPage(userId: image.userId)),
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: Colors.blue),
                        const SizedBox(width: 5),
                        Text(
                          image.userId.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

