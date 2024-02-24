import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../Controller/RoutineController.dart';
import '../../../Databases/MemoryDatabase.dart';
import '../../../Models/Vedio.dart';

class VideoNotesPage  extends GetView<RoutineController> {
       VideoNotesPage({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // For form validation

  Memory? _newMemory;
  ContentType? _selectedContentType=ContentType.video;
  ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _emotionController = TextEditingController();
  String localPath='';


  void _resetForm() {
    _newMemory = null;
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
    print(localPath+"       Vedio Location =========================================<><><><><>><><><><><><>><><");
    final memory = Memory(
      id: UniqueKey().toString(), // Generate a unique ID
      contentType: ContentType.video,
      content: _contentController.text,
      createdAt: DateTime.now(),
      location: localPath,
      emotion: _emotionController.text,
      isPrivate: false, // Adjust based on your requirements
    );

    await MemoriesDatabase.instance.createMemory(memory);

   _resetForm();

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
         localPath = await _saveFileLocally(file);
         print("data $localPath");
      }
    } on Exception catch (e) {
      print('Error picking media: $e');
      // Show an error message to the user
    }
  }
  Future<String> _saveFileLocally(XFile file) async {
    // Create a unique file name with extension
    final DateTime now = DateTime.now();
    final String fileName = '${now.millisecondsSinceEpoch}.mp4';

    // Get the documents directory path
    final directory = await getApplicationDocumentsDirectory();
    final filePath = File(join(directory.path, fileName));

    // Read file bytes
    final bytes = await file.readAsBytes();

    // Write bytes to local file
    await filePath.writeAsBytes(bytes);

    print(filePath.path);
    // Return the local file path
    return filePath.path;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
      ),
      body:
      Expanded(
        child: Obx(() => ListView.builder(
          itemCount: controller.memoryV.length,
          itemBuilder: (context, index) {
            return  card(
                controller.memoryV[index].location,
                '${controller.memoryV[index].content}'??'',
                "${controller.memoryV[index].createdAt}"??'');
          },
        ),)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {_openMemoryDialog(context);},
        child: Icon(Icons.add),
      ),
    );
  }

  Widget card(image, name, who) {
    return InkWell(
      child: Container(
        width: 150,
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: const Offset(
                1.0,
                1.0,
              ),
              blurRadius: 15.0,
              spreadRadius: 2.0,
            ), //BoxShadow
            BoxShadow(
              color: Colors.white,
              offset: const Offset(0.0, 0.0),
              blurRadius: 0.0,
              spreadRadius: 0.0,
            ), //BoxShadow
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 150,
                  child: VideoThumbnailContainer(videoPath: image) ,
                ),
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      size: 40,
                    ),
                  ),
                )
              ],
            ),
            ListTile(
              title: Center(child: Text(name)),
              subtitle: Center(child: Text(who)),
            ),
          ],
        ),
      ),
    );
  }
}
// For video thumbnail extraction

class VideoThumbnailContainer extends StatelessWidget {
  final String videoPath; // Path to the local video file
  final double height; // Height of the container
  final BoxFit fit; // How to fit the image within the container

  const VideoThumbnailContainer({
    Key? key,
    required this.videoPath,
    this.height = 150.0,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: fit,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.dstATop,
          ),
          image:NetworkImage("https://hips.hearstapps.com/hmg-prod/images/birthday-cake-with-happy-birthday-banner-royalty-free-image-1656616811.jpg?crop=0.668xw:1.00xh;0.0255xw,0&resize=980:*"), // Use placeholder if no thumbnail found
        ),
      ),
    );
  }

  // Widget _getVideoThumbnail(String videoPath) async {
  //   print(videoPath);
  //
  //   // Check if file exists
  //   if (!File(videoPath).existsSync()) {
  //     print("vedio exist :");
  //     return AssetImage(""); // Return null for non-existent files
  //   }
  //
  //   try {
  //     Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
  //       video: videoPath,
  //       imageFormat: ImageFormat.JPEG,
  //       maxWidth: 128,
  //       maxHeight: 128,
  //     );
  //
  //     if (thumbnail != null) {
  //       return MemoryImage(thumbnail);
  //     }
  //   } catch (error) {
  //     print('Error getting video thumbnail: $error');
  //   }
  //
  //   // If thumbnail extraction fails, use a placeholder image
  //   return AssetImage('assets/placeholder.png');
  // }

}
