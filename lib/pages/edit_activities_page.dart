import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nampa_hub/mid/token_manager.dart';
import 'package:nampa_hub/src/activity.dart';
import 'package:nampa_hub/src/config.dart';
import 'package:nampa_hub/src/widget.dart';

class EditActivityPage extends StatefulWidget {
  final Activity activity;
  const EditActivityPage({super.key, required this.activity});

  @override
  State<EditActivityPage> createState() => _EditActivityPageState();
}

class _EditActivityPageState extends State<EditActivityPage> {
  Uint8List imageBytes = Uint8List(0);
  bool _isSubmitting = false;

  late TextEditingController titleController;
  late TextEditingController locationController;
  late TextEditingController donationGoalController;
  late TextEditingController participantsController;
  late TextEditingController descritpionController;
  late TextEditingController meetLocationController;
  late TextEditingController attendFeeController;

  void validateAndSubmit() {}

  @override
  void initState() {
    super.initState();
    imageBytes = base64Decode(widget.activity.activityMedia!.base64Image);

    titleController = TextEditingController(text: widget.activity.title);
    locationController = TextEditingController(
        text: widget.activity.activityLocation?.eventLocation);
    donationGoalController = TextEditingController(
      text: widget.activity.activitySupport?.maxDonation != null
          ? widget.activity.activitySupport!.maxDonation!.toStringAsFixed(1)
          : '0',
    );
    participantsController = TextEditingController(
      text: widget.activity.activitySupport?.participants != null
          ? widget.activity.activitySupport!.participants!.toString()
          : '0',
    );
    descritpionController = TextEditingController(
        text: widget.activity.description!.isNotEmpty
            ? widget.activity.description
            : 'Add new Description');
    meetLocationController = TextEditingController(
        text: widget.activity.activityLocation!.meetLocation!.isNotEmpty
            ? widget.activity.activityLocation!.meetLocation!
            : 'Add new meet location');
    attendFeeController = TextEditingController(
        text: widget.activity.activitySupport!.attendFee!.toString());
  }

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    donationGoalController.dispose();
    participantsController.dispose();
    descritpionController.dispose();
    super.dispose();
  }

  Future<void> _editActivity() async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Invalid user token please try again');
      }

      final response = await http.patch(Uri.parse(editactivity),
          headers: {
            'Content-type': 'application/json',
            'Autherization': 'Bearer $token'
          },
          body: jsonEncode(widget.activity.toJson()));

      if (response.statusCode == 200) {
      } else {
        throw Exception('Failed to edit activity information');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Center(
          child: Logo(),
        ),
        backgroundColor: const Color(0xFF1B8900),
      ), // Set background color to white
      body: Stack(children: [
        SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                screenWidth < 600
                    ? Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          MemoryImage(imageBytes, scale: 0.1),
                                      fit: BoxFit.cover, // Adjust as needed
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black
                                          .withOpacity(0.5), // Dark overlay
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () {
                                        // Call your function here
                                      },
                                      child: Icon(
                                        Icons
                                            .add_circle_outline, // Change to your desired icon
                                        size: 50.0, // Adjust the size as needed
                                        color: Colors
                                            .white, // Adjust the color as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Activity name',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Colors.black, // Set text color to black
                                ),
                              ),
                              TextFormField(
                                controller: titleController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                              const Text(
                                'Description',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // fontSize: 10,
                                  color: Colors.black,
                                  fontSize: 18, // Set text color to black
                                ),
                              ),
                              TextFormField(
                                controller: descritpionController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                minLines: 3,
                                maxLines: 5,
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Event Location',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Colors.black, // Set text color to black
                                ),
                              ),
                              TextFormField(
                                controller: locationController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Meeting location',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color:
                                      Colors.black, // Set text color to black
                                ),
                              ),
                              TextFormField(
                                controller: meetLocationController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            color: Colors.black,
                            // Replace with your image widget
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.activity.title ??
                                            'Unknown activity',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors
                                              .black, // Set text color to black
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.edit)),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      widget.activity.activityLocation
                                              ?.eventLocation ??
                                          'Unknown location',
                                      style: const TextStyle(
                                        color: Colors
                                            .black, // Set text color to black
                                        decoration: TextDecoration
                                            .none, // Remove underline
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Donation Goal',
                                      style: TextStyle(
                                        // fontSize: 10,
                                        color: Colors
                                            .black, // Set text color to black
                                        decoration: TextDecoration
                                            .none, // Remove underline
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Participants',
                                      style: TextStyle(
                                        // fontSize: 10,
                                        color: Colors
                                            .black, // Set text color to black
                                        decoration: TextDecoration
                                            .none, // Remove underline
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                const Text(
                  'Donation Goal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Set text color to black
                  ),
                ),
                TextFormField(
                  controller: donationGoalController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                const Text(
                  'Participants',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Set text color to black
                  ),
                ),
                TextFormField(
                  controller: participantsController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                const Text(
                  'Attend Fee',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Set text color to black
                  ),
                ),
                TextFormField(
                  controller: attendFeeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 60,
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : validateAndSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isSubmitting ? Colors.grey : const Color(0xFF1B8900),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                minimumSize: const Size.fromHeight(50), // Set button height
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ]),
    );
  }
}
