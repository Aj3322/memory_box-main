import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../../../Databases/MemoryDatabase.dart';
import '../../../Models/Vedio.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // For form validation

  Memory? _newMemory;
  ContentType? _selectedContentType;
  ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _emotionController = TextEditingController();
  final String localPath='';

  @override
  void initState() {
    super.initState();
    _resetForm(); // Initialize form fields
  }

  void _resetForm() {
    _newMemory = null;
    _selectedContentType = null;
    _contentController.clear();
    _locationController.clear();
    _emotionController.clear();
  }
  Future<void> _openMemoryDialog(BuildContext context) async{
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create a New Memory'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey, // Apply form validation
            child: Column(
              children: [
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(labelText: 'Content'),
                  validator: (value) => value!.isEmpty ? 'Please enter content.' : null,
                ),
                  ElevatedButton.icon(
                    onPressed: () => _pickMedia(contentType: ContentType.video),
                    icon: Icon(_selectedContentType == ContentType.image ? Icons.image : Icons.video_call),
                    label: Text(_selectedContentType == ContentType.image ? 'Pick Image' : 'Pick Video'),
                  ),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                ),
                TextFormField(
                  controller: _emotionController,
                  decoration: InputDecoration(labelText: 'Emotion'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) return; // Check form validation
              _createMemory();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _createMemory() async {
    // Create a new memory object based on user input
    final memory = Memory(
      id: UniqueKey().toString(), // Generate a unique ID
      contentType: _selectedContentType!,
      content: _contentController.text,
      createdAt: DateTime.now(),
      location: localPath,
      emotion: _emotionController.text,
      isPrivate: false,
    );

    await MemoriesDatabase.instance.createMemory(memory);

    setState(() {
      _resetForm(); // Clear form fields after saving
    });

    // Show a success message or perform other actions as needed
    print('Memory saved successfully!');
  }

  Future<void> _pickMedia({required ContentType contentType}) async {
    try {
      final XFile? result;
      if (contentType == ContentType.image) {
        result = await _imagePicker.pickImage(source: ImageSource.gallery);
      } else if (contentType == ContentType.video) {
        result = await _imagePicker.pickVideo(source: ImageSource.gallery);
      } else {
        throw Exception('Unsupported content type: $contentType');
      }

      if (result != null) {
        final XFile file = result; // Assuming 'path' is present and valid
        final String localPath = await _saveFileLocally(file);
        _createMemory();


      }
    } on Exception catch (e) {
      print('Error picking media: $e');
      // Show an error message to the user
    }
  }
  Future<String> _saveFileLocally(XFile file) async {
    // Create a unique file name with extension
    final DateTime now = DateTime.now();
    final String fileName = '${now.millisecondsSinceEpoch}.jpg';

    // Get the documents directory path
    final directory = await getApplicationDocumentsDirectory();
    final filePath = File(join(directory.path, fileName));

    // Read file bytes
    final bytes = await file.readAsBytes();

    // Write bytes to local file
    await filePath.writeAsBytes(bytes);

    // Return the local file path
    return filePath.path;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

}