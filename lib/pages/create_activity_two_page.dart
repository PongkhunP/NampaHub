import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nampa_hub/src/activity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nampa_hub/src/widget.dart'; // Make sure this import is correct

final _formkey = GlobalKey<FormState>();

class CreateActivityTwoPage extends StatefulWidget {
  final Activity activity;
  const CreateActivityTwoPage({super.key, required this.activity});

  @override
  State<CreateActivityTwoPage> createState() => _CreateActivityOnePageState();
}

List<String> options = ['Donate', 'No donate'];

class _CreateActivityOnePageState extends State<CreateActivityTwoPage> {
  String donationOption = options[0];
  final List<ActivityReward> _rewards = [];

  final TextEditingController _participantsController = TextEditingController();
  final TextEditingController _meetingLocationController =
      TextEditingController();
  final TextEditingController _eventLocationController =
      TextEditingController();
  final TextEditingController _organizerController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _addReward() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController rewardNameController =
            TextEditingController();
        final TextEditingController rewardDescriptionController =
            TextEditingController();
        XFile? imagefile;

        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> _pickImage() async {
              final ImagePicker picker = ImagePicker();
              final XFile? pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);

              if (pickedFile != null) {
                setState(() {
                  imagefile = pickedFile;
                });
              }
            }

            return AlertDialog(
              title: const Text('Add Reward'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: rewardNameController,
                      decoration: const InputDecoration(
                        hintText: 'Reward Name',
                        border:
                            OutlineInputBorder(), // Removes the underline border
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: rewardDescriptionController,
                      decoration: const InputDecoration(
                          hintText: 'Reward Description',
                          border:
                              OutlineInputBorder() // Removes the underline border
                          ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: imagefile != null
                            ? Image.file(File(imagefile!.path),
                                fit: BoxFit.cover)
                            : const Center(child: Text('Tap to pick an image')),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (rewardNameController.text.isNotEmpty &&
                        imagefile != null) {
                      setState(() {
                        _rewards.add(ActivityReward(
                          name: rewardNameController.text,
                          rewardImage: imagefile!.path,
                          description: rewardDescriptionController.text,
                        ));
                      });
                      Navigator.of(context).pop();
                    } else {
                      // Show error if necessary fields are not filled
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _participantsController.dispose();
    _meetingLocationController.dispose();
    _eventLocationController.dispose();
    _organizerController.dispose();
    super.dispose();
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Form(
            key: _formkey,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Participants amount ex. 10 people',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color.fromARGB(255, 230, 229, 229),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide: BorderSide.none),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide: BorderSide.none),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide: BorderSide.none),
                      ),
                      validator: (amountParticipant) =>
                          amountParticipant!.isEmpty
                              ? 'Enter amount of participant'
                              : RegExp(r"^\d+$").hasMatch(amountParticipant)
                                  ? null
                                  : 'Please put the number'),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Meeting Location ex. KMUTT Thonburi',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Color.fromARGB(255, 230, 229, 229),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none),
                    ),
                    validator: (meetLocate) {
                      if (meetLocate == null || meetLocate.isEmpty) {
                        return "Please enter meeting location";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Location of event ex. KMUTT Thonburi',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Color.fromARGB(255, 230, 229, 229),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none),
                    ),
                    validator: (eventLocate) {
                      if (eventLocate == null || eventLocate.isEmpty) {
                        return "Please enter event location";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Organize by ...',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Color.fromARGB(255, 230, 229, 229),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none),
                    ),
                    validator: (organizeName) {
                      if (organizeName == null || organizeName.isEmpty) {
                        return "Please enter your organize";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: GestureDetector(
                    onTap: _addReward,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 0.05,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reward (Optional)',
                            style: TextStyle(
                                color: Color(0xFF1B8900),
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                          Icon(
                            Icons.add_circle,
                            color: Color(0xFF1B8900),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                //   child: TextFormField(
                //     controller: _rewardController,
                //     decoration: InputDecoration(
                //       border: InputBorder.none,
                //       hintText: 'Reward (Optional)',
                //       suffixIcon: Padding(
                //         padding: const EdgeInsets.only(right: 6),
                //         child: IconButton(
                //           onPressed: () {
                //             _addReward(_rewardController.text);
                //             _rewardController.clear();
                //           },
                //           icon: const Icon(Icons.add),
                //           color: const Color(0xFF1B8900),
                //         ),
                //       ),
                //       filled: true,
                //       fillColor: const Color.fromARGB(255, 230, 229, 229),
                //       enabledBorder: const OutlineInputBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(7)),
                //           borderSide: BorderSide.none),
                //       focusedBorder: const OutlineInputBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(7)),
                //           borderSide: BorderSide.none),
                //       errorBorder: const OutlineInputBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(7)),
                //           borderSide: BorderSide.none),
                //       focusedErrorBorder: const OutlineInputBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(7)),
                //           borderSide: BorderSide.none),
                //     ),
                //   ),
                // ),
                Column(
                  children: List.generate(_rewards.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Container(
                          width: 350,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFE7E7E7),
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    '${index + 1}.',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 2, top: 10),
                                        border: InputBorder.none,
                                        hintText: 'Goal',
                                        suffixIcon: IconButton(
                                          onPressed: () => {},
                                          icon: const Icon(Icons.remove_circle),
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                const Padding(
                  padding: EdgeInsets.only(left: 45),
                  child: Row(
                    children: [
                      Text(
                        'Donation',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),

                Row(
                  children: [
                    const SizedBox(width: 35),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          donationOption = options[0];
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(
                            value: options[0],
                            groupValue: donationOption,
                            onChanged: (value) {
                              setState(() {
                                donationOption = value.toString();
                              });
                            },
                          ),
                          const Text('Donate'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          donationOption = options[1];
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(
                            value: options[1],
                            groupValue: donationOption,
                            onChanged: (value) {
                              setState(() {
                                donationOption = value.toString();
                              });
                            },
                          ),
                          const Text('No donate'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Add more options here if needed
                  ],
                ),
                if (donationOption == options[0])
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Amount of Donation',
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Color.fromARGB(255, 230, 229, 229),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                              borderSide: BorderSide.none),
                          errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                              borderSide: BorderSide.none),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                              borderSide: BorderSide.none),
                        ),
                        validator: (amountDonation) => amountDonation!.isEmpty
                            ? "Please enter amount of donation"
                            : RegExp(r"^\d+$").hasMatch(amountDonation)
                                ? null
                                : 'Please enter valid input'),
                  ),

                const SizedBox(height: 10),
                SizedBox(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        // Handle form submission
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B8900),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                // Add more widgets here as needed for your registration form
              ],
            ),
          ),
        ),
      ),
    );
  }
}
