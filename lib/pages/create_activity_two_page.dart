import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nampa_hub/src/widget.dart'; // Make sure this import is correct

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ActivityCreation2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const CreateActivityTwoPage(),
    );
  }
}

final _formkey = GlobalKey<FormState>();

class CreateActivityTwoPage extends StatefulWidget {
  const CreateActivityTwoPage({super.key});

  @override
  State<CreateActivityTwoPage> createState() => _CreateActivityOnePageState();
}

List<String> options = ['Donate', 'No donate'];

class _CreateActivityOnePageState extends State<CreateActivityTwoPage> {
  String currentOption = options[0];
  final List<TextEditingController> _goalControllers = [];
  final TextEditingController _goalController = TextEditingController();

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
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Container(
                      width: 350,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFE7E7E7),
                      ),
                      child: Center(
                        child: TextFormField(
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),
                              border: InputBorder.none,
                              hintText: 'Amount participants ex. 10 people',
                            ),
                            validator: (amountParticipant) => amountParticipant!
                                    .isEmpty
                                ? 'Enter amount of participant'
                                : RegExp(r"^\d+$").hasMatch(amountParticipant)
                                    ? null
                                    : 'Please put the number'),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Container(
                      width: 350,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFE7E7E7),
                      ),
                      child: Center(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            border: InputBorder.none,
                            hintText: 'Meeting Location ex. KMUTT Thonburi',
                          ),
                          validator: (meetLocate) {
                            if (meetLocate == null || meetLocate.isEmpty) {
                              return "Please enter meeting location";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Container(
                      width: 350,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFE7E7E7),
                      ),
                      child: Center(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            border: InputBorder.none,
                            hintText: 'Location of event ex. KMUTT Thonburi',
                          ),
                          validator: (eventLocate) {
                            if (eventLocate == null || eventLocate.isEmpty) {
                              return "Please enter event location";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Container(
                      width: 350,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFE7E7E7),
                      ),
                      child: Center(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            border: InputBorder.none,
                            hintText: 'Organize by ...',
                          ),
                          validator: (organizeName) {
                            if (organizeName == null || organizeName.isEmpty) {
                              return "Please enter your organize";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Container(
                      width: 350,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFE7E7E7),
                      ),
                      child: Center(
                        child: TextFormField(
                          controller: _goalController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 20, top: 13),
                            border: InputBorder.none,
                            hintText: 'Reward (Optional)',
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: IconButton(
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
                                        contentPadding: const EdgeInsets.only(
                                            left: 2, top: 10),
                                        border: InputBorder.none,
                                        hintText: 'Goal',
                                        suffixIcon: IconButton(
                                          onPressed: () => _removeGoal(index),
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
                          const Text('Donate'),
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
                          const Text('No donate'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Add more options here if needed
                  ],
                ),
                if (currentOption == options[0])
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Container(
                        width: 350,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFE7E7E7),
                        ),
                        child: Center(
                          child: TextFormField(
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(left: 20),
                                border: InputBorder.none,
                                hintText: 'Amount of Donation',
                              ),
                              validator: (amountDonation) =>
                                  amountDonation!.isEmpty
                                      ? "Please enter amount of donation"
                                      : RegExp(r"^\d+$").hasMatch(amountDonation)
                                          ? null
                                          : 'Please enter valid input'),
                        ),
                      ),
                    ),
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
