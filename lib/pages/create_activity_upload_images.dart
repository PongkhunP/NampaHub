import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nampa_hub/pages/home_page.dart';
import 'package:nampa_hub/src/activity.dart';
import 'package:nampa_hub/src/config.dart';
import 'package:nampa_hub/mid/token_manager.dart';
import 'dart:typed_data';
import 'package:nampa_hub/src/widget.dart'; // Make sure this import is correct

class MyUploadActivityImages extends StatefulWidget {
  final Activity activity;
  const MyUploadActivityImages({super.key, required this.activity});

  @override
  MyUploadActivityImagesState createState() => MyUploadActivityImagesState();
}

class MyUploadActivityImagesState extends State<MyUploadActivityImages> {
  XFile? _imageData;
  String displayImage = '';

  void _validateAndSubmit() {
    if (_imageData != null) {
      String base64Image = convertImageToBase64(_imageData!);
      ActivityMedia activityMedia = ActivityMedia(activityImage: base64Image);
      widget.activity.setActivityMedia(activityMedia);
      widget.activity.activitySupport!.currentParticipants = 0;
      
      _createActivity();
    } else {
      // Handle the case when no image is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image to upload.')),
      );
    }
  }

  Future<void> _createActivity() async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        print('User not authenticated');
        return;
      }
        print("Token : $token");
        print("Activity : ${widget.activity.activitySupport!.currentParticipants}");

      final uri = Uri.parse(createactivity);
      final request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      request.fields['activityData'] = jsonEncode(widget.activity.toJson());

      if (_imageData != null) {
        final bytes = await _imageData!.readAsBytes();
        final multipartFile = http.MultipartFile.fromBytes(
            'activity_image', bytes,
            filename: _imageData!.name);
        request.files.add(multipartFile);
      }

      if (widget.activity.rewards != null) {
        for (int i = 0; i < widget.activity.rewards!.length; i++) {
          final reward = widget.activity.rewards![i];
          if (reward.rewardImage != null) {
            final bytes = base64Decode(reward.rewardImage!.activityImage!);
            final multipartFile = http.MultipartFile.fromBytes(
              'reward_images',
              bytes,
              filename: reward.name,
            );
            request.files.add(multipartFile);
          }
        }
      }

      print(request);
      final response = await request.send();

      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        print('Activity created successfully!');
        if (mounted) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return MyHomePage();
            },
          ));
        }
      } else {
        print('Failed to create activity: $responseBody');
      }
    } catch (e) {
      print(e);
    }
  }

  String convertImageToBase64(XFile file) {
    final bytes = File(file.path).readAsBytesSync();
    return base64Encode(bytes);
  }

  Uint8List _imageFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageData = pickedFile;
        displayImage = convertImageToBase64(pickedFile);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _imageData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Logo(),
        ),
        backgroundColor: const Color(0xFF1B8900),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
                child: Center(
                  child: Text(
                    "Create Activity",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Color(0xFF1B8900),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: _imageData == null ? _pickImage : null,
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color of the box
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: _imageData == null
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.upload,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Upload Image',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: Image.memory(
                                      _imageFromBase64String(displayImage),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: GestureDetector(
                                  onTap: _removeImage,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 230),
                child: SizedBox(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _validateAndSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _imageData == null
                          ? Colors.grey
                          : const Color(0xFF1B8900),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Circle shape
                      ),
                    ),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
