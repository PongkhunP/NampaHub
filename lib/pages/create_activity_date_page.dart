import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nampa_hub/src/widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const MyRegister(),
    );
  }
}

final _formkey = GlobalKey<FormState>();

class MyRegister extends StatefulWidget {
  const MyRegister({super.key});

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  DateTime? _startRegisterDate;
  DateTime? _endRegisterDate;
  DateTime? _eventDate;

  Future<void> _selectStartRegisterDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startRegisterDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startRegisterDate) {
      setState(() {
        _startRegisterDate = picked;
      });
    }
  }

  Future<void> _selectEndRegisterDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endRegisterDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endRegisterDate) {
      setState(() {
        _endRegisterDate = picked;
      });
    }
  }

  Future<void> _selectEventDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _eventDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _eventDate) {
      setState(() {
        _eventDate = picked;
      });
    }
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 150,
                    child: Center(
                      child: Text("Create Activity",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Color(0xFF1B8900),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () => _selectStartRegisterDate(context),
                      child: Container(
                        width: 350,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFE7E7E7),
                        ),
                        child: Center(
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 8, left: 20),
                              border: InputBorder.none,
                              hintText: _startRegisterDate == null
                                  ? 'Start register date'
                                  : _startRegisterDate.toString().split(' ')[0],
                              hintStyle: const TextStyle(color: Colors.black),
                            ),
                            style: const TextStyle(color: Colors.black),
                            validator: (value) {
                              if (_startRegisterDate == null) {
                                return 'Select start register date';
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
                    child: GestureDetector(
                      onTap: () => _selectEndRegisterDate(context),
                      child: Container(
                        width: 350,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFE7E7E7),
                        ),
                        child: Center(
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 8, left: 20),
                              border: InputBorder.none,
                              hintText: _endRegisterDate == null
                                  ? 'End register date'
                                  : _endRegisterDate.toString().split(' ')[0],
                              hintStyle: const TextStyle(color: Colors.black),
                            ),
                            style: const TextStyle(color: Colors.black),
                            validator: (value) {
                              if (_endRegisterDate == null) {
                                return 'Select end register date';
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
                    child: GestureDetector(
                      onTap: () => _selectEventDate(context),
                      child: Container(
                        width: 350,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFE7E7E7),
                        ),
                        child: Center(
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 8, left: 20),
                              border: InputBorder.none,
                              hintText: _eventDate == null
                                  ? 'Event date'
                                  : _eventDate.toString().split(' ')[0],
                              hintStyle: const TextStyle(color: Colors.black),
                            ),
                            style: const TextStyle(color: Colors.black),
                            validator: (value) {
                              if (_eventDate == null) {
                                return 'Select event date';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 150),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          // Print the selected dates to the console
                          print('Start Register Date: ${_startRegisterDate?.toString().split(' ')[0]}');
                          print('End Register Date: ${_endRegisterDate?.toString().split(' ')[0]}');
                          print('Event Date: ${_eventDate?.toString().split(' ')[0]}');
                          // Perform form submission logic here
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
