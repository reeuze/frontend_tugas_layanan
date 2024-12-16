import 'package:flutter/material.dart';
import 'image_model.dart';
import 'package:frontend_tugas_layanan/features/tags/tags_controller.dart';

class UpdateImagePage extends StatefulWidget {
  final ImageModel image;

  const UpdateImagePage({super.key, required this.image});

  @override
  State<UpdateImagePage> createState() => _UpdateImagePageState();
}

class _UpdateImagePageState extends State<UpdateImagePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late List<TagModel> _tags;
  List<int> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.image.name);
    _descriptionController = TextEditingController(text: widget.image.description);
    _tags = [];

    _fetchTags();
  }

  Future<void> _fetchTags() async {
    try {
      final tags = await getAllTags();
      setState(() {
        _tags = tags;
        _selectedTags = widget.image.tags.map((tag) => tag.tagId).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load tags')),
      );
    }
  }

  Future<void> _updateImage() async {
    if (_formKey.currentState?.validate() != true) return;

    final imageUpdate = {
      'name': _nameController.text,
      'description': _descriptionController.text,
      'userId': widget.image.userId.toString(),
      'tags': _selectedTags,
    };

    try {
      await updateImage(widget.image.imageId, imageUpdate);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image updated successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Image'),
        backgroundColor: Colors.redAccent,
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
                validator: (value) => value?.isEmpty == true ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value?.isEmpty == true ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 16),
              const Text('Tags:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8.0,
                children: _tags.map((tag) {
                  return ChoiceChip(
                    label: Text(tag.name),
                    selected: _selectedTags.contains(tag.tagId),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedTags.add(tag.tagId);
                        } else {
                          _selectedTags.remove(tag.tagId);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateImage,
                  child: const Text('Update Image'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
