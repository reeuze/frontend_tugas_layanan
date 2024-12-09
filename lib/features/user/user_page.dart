import 'package:flutter/material.dart';
import 'package:frontend_tugas_layanan/features/image/image_controller.dart';
// import 'package:frontend_tugas_layanan/features/image/image_model.dart';
import 'package:frontend_tugas_layanan/features/image/image_page.dart';
import 'package:frontend_tugas_layanan/features/user/user_controller.dart';
import 'package:frontend_tugas_layanan/features/user/user_model.dart';

class UserPage extends StatelessWidget {
  final int userId;

  const UserPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final userController = UserController();
    final imageController = ImageController();

    return Scaffold(
      appBar: AppBar(
        title: Text('User: $userId'),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder<UserModel>(
        future: userController.getUserById(userId), // Mengambil data UserModel berdasarkan userId
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Tampilkan loading saat data masih dimuat
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Menangani error jika ada
          } else if (!snapshot.hasData) {
            return const Center(child: Text('User not found')); // Menangani jika data tidak ada
          }

          final user = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: user.urlProfile != null
                          ? NetworkImage(user.urlProfile!)
                          : null,
                      radius: 40,
                      child: user.urlProfile == null
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.birthdate != null ? user.birthdate.toString() : '-',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.gender != null ? user.gender.toString() : '-',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.phone != null ? user.phone.toString() : '-',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Uploaded Images:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: user.images != null && user.images!.isNotEmpty
                      ? GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: user.images!.length,
                          itemBuilder: (context, index) {
                            final image = user.images![index];
                            return GestureDetector(
                              onTap: () async {
                                try {
                                  final fetchedImage = await imageController.getImageById(image.imageId);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImagePage(image: fetchedImage),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed to load image: $e')),
                                  );
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  image.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(child: Text('No images available')),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
