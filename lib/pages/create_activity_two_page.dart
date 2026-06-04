import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nampa_hub/pages/create_activity_date_page.dart';
import 'package:nampa_hub/src/activity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nampa_hub/src/widget.dart'; // Make sure this import is correct

class CreateActivityTwoPage extends StatefulWidget {
  final Activity activity;
  const CreateActivityTwoPage({super.key, required this.activity});

  @override
  State<CreateActivityTwoPage> createState() => _CreateActivityOnePageState();
}

List<String> options = ['Donate', 'No donate'];

class _CreateActivityOnePageState extends State<CreateActivityTwoPage> {
  final _formkey = GlobalKey<FormState>();
  String donationOption = options[0];
  double _donationAmount = 0;
  int _participantsAmount = 0;
  double _attendfee = 0;
  final List<ActivityReward> _rewards = [];
  final List<ActivityExpense> _expenses = [];

  final TextEditingController _participantsController = TextEditingController();
  final TextEditingController _meetingLocationController =
      TextEditingController();
  final TextEditingController _eventLocationController =
      TextEditingController();
  final TextEditingController _organizerController = TextEditingController();
  final TextEditingController _donationController = TextEditingController();
  final TextEditingController _attendFeeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _validateAndSend() {
    if (_formkey.currentState!.validate()) {
      // Use a try-catch block to handle any unexpected parsing errors
      try {
        _participantsAmount = _participantsController.text.isNotEmpty
            ? int.parse(_participantsController.text)
            : 0;
        _donationAmount = _donationController.text.isNotEmpty
            ? double.parse(_donationController.text)
            : 0;
        _attendfee = _attendFeeController.text.isNotEmpty
            ? double.parse(_attendFeeController.text)
            : 0;

        ActivityLocation activityLocation = ActivityLocation(
          eventLocation: _eventLocationController.text,
          meetLocation: _meetingLocationController.text,
        );

        ActivitySupport activitySupport = ActivitySupport(
          maxDonation: _donationAmount,
          participants: _participantsAmount,
          attendFee: _attendfee,
          budget: 0, // Set this value accordingly
        );

        widget.activity.setActivityLocation(activityLocation);
        widget.activity.setActivitySupport(activitySupport);
        widget.activity.setOrganizer(_organizerController.text);
        widget.activity.setRewards(_rewards);
        widget.activity.setExpenses(_expenses);
        widget.activity.activitySupport!.currentParticipants = 0;

        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return CreateActivityDate(activity: widget.activity);
          },
        ));
      } catch (e) {
        // Handle parsing error, if any
        print('Error parsing input: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid input, please check your entries.')),
        );
      }
    }
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

            String convertImageToBase64(XFile file) {
              final bytes = File(file.path).readAsBytesSync();
              return base64Encode(bytes);
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
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: rewardDescriptionController,
                      decoration: const InputDecoration(
                          hintText: 'Reward Description',
                          border: OutlineInputBorder()),
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
                          rewardImage: ActivityMedia(
                              activityImage: convertImageToBase64(imagefile!)),
                          description: rewardDescriptionController.text,
                        ));
                      });
                      Navigator.of(context).pop();
                      this.setState(() {});
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

  void _addExpense() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController expenseNameController =
            TextEditingController();
        final TextEditingController expenseAmountController =
            TextEditingController();

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Expense'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: expenseNameController,
                      decoration: const InputDecoration(
                        hintText: 'Expense Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: expenseAmountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintText: 'Expense amount',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10),
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
                    if (expenseNameController.text.isNotEmpty &&
                        expenseAmountController.text.isNotEmpty) {
                      setState(() {
                        _expenses.add(ActivityExpense(
                            expense: double.parse(expenseAmountController.text),
                            name: expenseNameController.text));
                      });
                      Navigator.of(context).pop();
                      this.setState(() {});
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
      body: Stack(
        children: [
          SingleChildScrollView(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Participants amount ex. 10 people',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color.fromARGB(255, 230, 229, 229),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (amountParticipant) {
                        if (amountParticipant == null ||
                            amountParticipant.isEmpty) {
                          return 'Enter amount of participant';
                        } else if (!RegExp(r"^\d+$")
                            .hasMatch(amountParticipant)) {
                          return 'Please enter a valid number';
                        } else if (int.parse(amountParticipant) <= 0) {
                          return 'Number of participants must be greater than zero';
                        }
                        return null;
                      },
                      controller: _participantsController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Meeting Location ex. KMUTT Thonburi',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color.fromARGB(255, 230, 229, 229),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (meetLocate) {
                        if (meetLocate == null || meetLocate.isEmpty) {
                          return "Please enter meeting location";
                        }
                        return null;
                      },
                      controller: _meetingLocationController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Location of event ex. KMUTT Thonburi',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color.fromARGB(255, 230, 229, 229),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (eventLocate) {
                        if (eventLocate == null || eventLocate.isEmpty) {
                          return "Please enter event location";
                        }
                        return null;
                      },
                      controller: _eventLocationController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Organize by ...',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color.fromARGB(255, 230, 229, 229),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      controller: _organizerController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Reward (Optional)',
                              style: TextStyle(
                                color: Color(0xFF1B8900),
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Icon(
                              Icons.add_circle,
                              color: Color(0xFF1B8900),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: List.generate(_rewards.length, (index) {
                      final reward = _rewards[index];
                      Uint8List _imageFromBase64String(String base64String) {
                        return base64Decode(base64String);
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Center(
                          child: Container(
                            width: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFE7E7E7),
                            ),
                            child: Row(
                              children: [
                                // Left side image
                                Container(
                                  width: 80,
                                  height: 80,
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: reward.rewardImage != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.memory(
                                            _imageFromBase64String(reward
                                                .rewardImage!.activityImage!),
                                            fit: BoxFit.cover,
                                            width: 80,
                                            height: 80,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.image,
                                          size: 80,
                                          color: Colors.grey,
                                        ),
                                ),
                                // Right side text
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Reward name
                                        Text(
                                          reward.name!,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        // Reward description
                                        Text(
                                          reward.description!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Delete button
                                IconButton(
                                  icon: const Icon(Icons.remove_circle,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _rewards.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: GestureDetector(
                      onTap: _addExpense,
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Expense (You can add this later)',
                              style: TextStyle(
                                color: Color(0xFF1B8900),
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Icon(
                              Icons.add_circle,
                              color: Color(0xFF1B8900),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: List.generate(_expenses.length, (index) {
                      final expense = _expenses[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Center(
                          child: Container(
                            width: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFE7E7E7),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Expense name
                                        Text(
                                          expense.name!,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        // Expense description
                                        Text(
                                          expense.expense!.toStringAsFixed(0),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Delete button
                                IconButton(
                                  icon: const Icon(Icons.remove_circle,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _expenses.removeAt(index);
                                    });
                                  },
                                ),
                              ],
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
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide: BorderSide.none,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (amountDonation) => amountDonation!.isEmpty
                            ? "Please enter amount of donation"
                            : RegExp(r"^\d+$").hasMatch(amountDonation)
                                ? null
                                : 'Please enter valid input',
                        controller: _donationController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Attend fee',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color.fromARGB(255, 230, 229, 229),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (amountParticipant) {
                        if (amountParticipant == null ||
                            amountParticipant.isEmpty) {
                          return 'Enter attend fee';
                        } else if (!RegExp(r"^\d+$")
                            .hasMatch(amountParticipant)) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      controller: _attendFeeController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 100), // Add some space for the button
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors
                  .white, // Set the background color of the container to white
              padding: const EdgeInsets.all(10), // Optional: Add some padding
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _validateAndSend,
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
            ),
          )
        ],
      ),
    );
  }
}
