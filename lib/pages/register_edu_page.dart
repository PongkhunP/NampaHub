import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nampa_hub/src/user.dart';
import 'package:nampa_hub/src/widget.dart';
import 'package:nampa_hub/pages/register_workinfo_page.dart';

class MyRegisterEdu extends StatefulWidget {
  final User user;
  const MyRegisterEdu({super.key, required this.user});

  @override
  State<MyRegisterEdu> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegisterEdu> {
  String? selectedstartYear;
  String? selectedendYear;
  List<String> listYear = [];

  String? selectedJob;
  List<String> joblist = ['Student', 'Police', 'Teacher', 'Marine'];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _edunameController = TextEditingController();

  void _validateAndSend() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.user.setStartDate(selectedstartYear ?? '');
      widget.user.setEndDate(selectedendYear ?? '');
      _edunameController.text.isNotEmpty ? widget.user.setInstituteName(_edunameController.text) : null;

      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return MyRegisterWorkInfo(user: widget.user);
        },
      ));
    } else {
      print("Form is invalid");
    }
  }

  final Map<String, List<String>> yearMap = {
    '1997': ['2020', '2021', '2022', '2023'],
    '1998': ['2021', '2022', '2023', '2024'],
    '1999': ['2022', '2023', '2024', '2025'],
    '2020': ['2023', '2024', '2025', '2026'],
  };

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
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 150,
                    child: Center(
                      child: Text(
                        "Education Information",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Color(0xFF1B8900),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Country Dropdown Widget
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'School/University name',
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
                          controller: _edunameController,
                          validator: (suName) {
                            if (suName!.isNotEmpty) {
                              if (RegExp('[a-zA-Z]').hasMatch(suName)) {
                                return null;
                              } else {
                                return 'Enter a Valid School/University name';
                              }
                            }
                            return null;
                          })),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
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
                      hint: const Text("Start year"),
                      dropdownColor: Colors.grey,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 36,
                      isExpanded: true,
                      value: selectedstartYear,
                      onChanged: (newValue) {
                        setState(() {
                          selectedstartYear = newValue;
                          selectedendYear = null;
                          listYear = yearMap[selectedstartYear!] ?? [];
                        });
                      },
                      items: yearMap.keys.map((String sYear) {
                        return DropdownMenuItem<String>(
                          value: sYear,
                          child: Text(sYear),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
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
                      hint: const Text("End year"),
                      dropdownColor: Colors.grey,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 36,
                      isExpanded: true,
                      value: selectedendYear,
                      onChanged: (newValue) {
                        setState(() {
                          selectedendYear = newValue;
                        });
                      },
                      items: listYear.map((String eYear) {
                        return DropdownMenuItem<String>(
                          value: eYear,
                          child: Text(eYear),
                        );
                      }).toList(),
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
                          borderRadius:
                              BorderRadius.circular(10), // Circle shape
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _validateAndSend,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Circle shape
                        ),
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(fontSize: 18, color: Colors.black),
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
