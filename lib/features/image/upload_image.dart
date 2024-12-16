import 'dart:typed_data';
import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';

import 'image_controller.dart';
import 'image_model.dart';
import 'dart:html' as html;
import 'dart:developer' as developer;

class UploadImagePage extends StatefulWidget {
  final int currentUserId;

  const UploadImagePage({Key? key, required this.currentUserId}) : super(key: key);

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImageController _controller = ImageController();

  Uint8List? _selectedImageBytes;
  String? _selectedFileName;

  Future<void> _pickImage() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files.first;
        final reader = html.FileReader();

        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((_) {
          setState(() {
            _selectedImageBytes = reader.result as Uint8List;
            _selectedFileName = file.name;
          });
          developer.log('Picked file: $_selectedFileName');
        });
      }
    });
  }

  Future<void> _uploadImage() async {
  if (_formKey.currentState?.validate() != true || _selectedImageBytes == null || _selectedFileName == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please complete the form and select an image.')),
    );
    return;
  }

  final imageModel = ImageModel(
    imageId: 0,
    name: _nameController.text,
    description: _descriptionController.text,
    path: _selectedFileName!,
    userId: widget.currentUserId,
    imageUrl: '',
    tags: [],
  );


  try {
    String mime = _selectedFileName!.split('.').last;
    final uploadedImage = await _controller.addImage(
      imageModel,
      _selectedImageBytes!,
      _selectedFileName!,
      'image/$mime',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image uploaded successfully!')),
    );

    developer.log('Uploaded image: ${uploadedImage}');
    Navigator.pop(context, true);
  } catch (e) {
    developer.log('Failed to upload image: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('An error occurred during upload.')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _selectedImageBytes != null
                      ? Image.memory(
                          _selectedImageBytes!,
                          fit: BoxFit.cover,
                        )
                      : const Center(child: Text('Tap to select an image')),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _uploadImage,
                  child: const Text('Upload Image'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
