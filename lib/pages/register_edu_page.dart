import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nampa_hub/src/widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const MyRegisterEdu(),
    );
  }
}

class MyRegisterEdu extends StatefulWidget {
  const MyRegisterEdu({super.key});

  @override
  State<MyRegisterEdu> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegisterEdu> {
  String? selectedstartYear;
  String? selectedendYear;
  List<String> listYear = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, List<String>> yearMap = {
    '1997': ['2020', '2021', '2022', '2023'],
    '1998': ['2021', '2022', '2023', '2024'],
    '1999': ['2022', '2023', '2024', '2025'],
    '2020': ['2023', '2024', '2025', '2026'],
  };

  void _validateAndSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform your submission logic here
      print("Form is valid");
    } else {
      print("Form is invalid");
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
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      width: 350,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFE7E7E7)),
                      child: Center(
                        child: TextFormField(
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(top: 8, left: 10),
                              border: InputBorder.none,
                              hintText: 'School/University name',
                            ),
                            validator: (suName) => suName!.isEmpty
                                ? 'Enter Your company name'
                                : RegExp('[a-zA-Z]').hasMatch(suName)
                                    ? null
                                    : 'Enter a Valid School/University name'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: 350,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7E7E7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                      ),
                      hint: const Text("Start year"),
                      dropdownColor: Colors.grey,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 36,
                      isExpanded: true,
                      value: selectedstartYear,
                      validator: (value) {
                        if (value == null) {
                          return 'Please select your start year';
                        }
                        return null;
                      },
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
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: 350,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7E7E7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                      ),
                      hint: const Text("End year"),
                      dropdownColor: Colors.grey,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 36,
                      isExpanded: true,
                      value: selectedendYear,
                      validator: (value) {
                        if (selectedendYear == null &&
                            (value == null || value.isEmpty)) {
                          return 'Please select your end year';
                        }
                        return null;
                      },
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

                  const SizedBox(height: 300),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _validateAndSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B8900),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Sign up',
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
