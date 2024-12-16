import 'package:flutter/material.dart';
// import 'package:frontend_tugas_layanan/features/home/controllers/image_controller.dart';
import 'package:frontend_tugas_layanan/features/home/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PinterestCloneApp());
}

class PinterestCloneApp extends StatelessWidget {
  const PinterestCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
