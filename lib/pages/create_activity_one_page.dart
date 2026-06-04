import 'package:flutter/material.dart';
import 'package:nampa_hub/pages/create_activity_two_page.dart';
import 'package:nampa_hub/src/activity.dart';
import 'package:nampa_hub/src/widget.dart'; // Make sure this import is correct

class CreateActivityOnePage extends StatefulWidget {
  const CreateActivityOnePage({super.key});

  @override
  State<CreateActivityOnePage> createState() => _CreateActivityOnePageState();
}

List<String> options = ['Marine', 'Forest', 'Other'];

class _CreateActivityOnePageState extends State<CreateActivityOnePage> {
  final _formkey = GlobalKey<FormState>();
  String currentOption = options[0];
  final List<TextEditingController> _goalControllers = [];
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _activityTitleController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _otherOptionController = TextEditingController();

  void _validateAndSend() {
    if (_formkey.currentState!.validate()) {
      List<String> goals =
          _goalControllers.map((controller) => controller.text).toList();
      String activityType = currentOption;
      Activity activity = Activity(
        title: _activityTitleController.text,
        contactEmail: _emailController.text,
        description: _descriptionController.text,
        activityType: activityType,
        status: 'On-going',
        goals: goals,
      );
      print("Activity type : $activityType");
      for (var goal in goals) {
        print("Goals : $goal");
      }

      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return CreateActivityTwoPage(
            activity: activity,
          );
        },
      ));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void _addGoal(String goal) {
    if (goal.isNotEmpty) {
      setState(() {
        var controller = TextEditingController(text: goal);
        _goalControllers.add(controller);
      });
    }
  }

  void _removeGoal(int index) {
    setState(() {
      _goalControllers.removeAt(index);
    });
  }

  @override
  void dispose() {
    for (var controller in _goalControllers) {
      controller.dispose();
    }
    _goalController.dispose();
    _activityTitleController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    _otherOptionController.dispose();
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
                  height: 150,
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
                      border: InputBorder.none,
                      hintText: 'Activity Title',
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
                    validator: (activityName) {
                      if (activityName == null || activityName.isEmpty) {
                        return "Please enter activity name";
                      }
                      return null;
                    },
                    controller: _activityTitleController,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Contact Email',
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
                    validator: (email) {
                      // Allow null or empty
                      if (email == null || email.isEmpty) {
                        return null;
                      }
                      // Define email regex pattern
                      final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
                      // Validate email
                      if (!regex.hasMatch(email)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                    controller: _emailController,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                    controller: _goalController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Goals',
                      filled: true,
                      fillColor: const Color.fromARGB(255, 230, 229, 229),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none),
                      errorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none),
                      focusedErrorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _addGoal(_goalController.text);
                          _goalController.clear();
                        },
                        icon: const Icon(Icons.add_circle),
                        color: const Color(0xFF1B8900),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: List.generate(_goalControllers.length, (index) {
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
                                      controller: _goalControllers[index],
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(left: 20, top: 8),
                                        border: InputBorder.none,
                                        hintText: 'Goal',
                                        suffixIcon: IconButton(
                                          onPressed: () => _removeGoal(index),
                                          icon: Icon(Icons.remove_circle),
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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Description .....',
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
                    validator: (activityName) {
                      if (activityName == null || activityName.isEmpty) {
                        return "Please provide description of your activity";
                      }
                      return null;
                    },
                    controller: _descriptionController,
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(left: 22, top: 20),
                  child: Row(
                    children: [
                      Text(
                        'Type of Activity',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentOption = options[0];
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio(
                              value: options[0],
                              groupValue: currentOption,
                              onChanged: (value) {
                                setState(() {
                                  currentOption = value.toString();
                                });
                              },
                            ),
                            const Text('Marine'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentOption = options[1];
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio(
                              value: options[1],
                              groupValue: currentOption,
                              onChanged: (value) {
                                setState(() {
                                  currentOption = value.toString();
                                });
                              },
                            ),
                            const Text('Forest'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentOption = options[2];
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio(
                              value: options[2],
                              groupValue: currentOption,
                              onChanged: (value) {
                                setState(() {
                                  currentOption = value.toString();
                                });
                              },
                            ),
                            const Text('Other...'),
                          ],
                        ),
                      ),
                      // Add more options here if needed
                    ],
                  ),
                ),
                if (currentOption == options[2])
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Other ...',
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
                      validator: (activityName) {
                        if (activityName == null || activityName.isEmpty) {
                          return "Please clarify you activity type";
                        }
                        return null;
                      },
                      controller: _otherOptionController,
                    ),
                  ),

                const SizedBox(height: 10),
                SizedBox(
                  width: 350,
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

                // Add more widgets here as needed for your registration form
              ],
            ),
          ),
        ),
      ),
    );
  }
}
