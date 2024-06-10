import 'package:flutter/material.dart';
import 'package:nampa_hub/src/user.dart';
import 'package:nampa_hub/src/widget.dart';
import 'package:nampa_hub/pages/register_workinfo_page.dart';

class MyRegisterEdu extends StatefulWidget {
  final VoidCallback showWorkregisPage;
  final User user;
  const MyRegisterEdu(
      {super.key, required this.showWorkregisPage, required this.user});

  @override
  State<MyRegisterEdu> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegisterEdu> {
  String? selectedstartYear;
  String? selectedendYear;
  List<String> listYear = [];

  String? selectedJob;
  bool isAgreed = false;
  List<String> joblist = ['Student', 'Police', 'Teacher', 'Marine'];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _validateAndRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      if (isAgreed) {
        // Perform your submission logic here
        registerUser();
      } else {
        print("You must agree to the terms and conditions");
      }
    } else {
      print("Form is invalid");
    }
  }

  void registerUser() async {}

  final Map<String, List<String>> yearMap = {
    '1997': ['2020', '2021', '2022', '2023'],
    '1998': ['2021', '2022', '2023', '2024'],
    '1999': ['2022', '2023', '2024', '2025'],
    '2020': ['2023', '2024', '2025', '2026'],
  };

  // void _navigateToStudentForm() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const MyRegisterWorkInfo()),
  //   );
  // }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Terms and Conditions'),
          content: const SingleChildScrollView(
            child: Text(
              'Terms and Conditions\n\n'
              '1. Introduction\n\n'
              'Welcome to NamPaHUB. By using our application, you agree to comply with and be bound by the following terms and conditions. Please review them carefully. If you do not agree to these terms and conditions, you should not use our application.\n\n'
              '2. Information Collection\n\n'
              'We collect the following personal information from you to verify your identity as a human user:\n'
              '- Name\n'
              '- Work Information (e.g., job title, company name)\n'
              '- Location\n\n'
              '3. Use of Information\n\n'
              'The information we collect is used solely for the purpose of verifying that you are a human user. We do not share, sell, or distribute your personal information to third parties without your explicit consent, except as required by law.\n\n'
              '4. Data Protection\n\n'
              'We are committed to ensuring that your information is secure. In order to prevent unauthorized access or disclosure, we have put in place suitable physical, electronic, and managerial procedures to safeguard and secure the information we collect online.\n\n'
              '5. User Responsibilities\n\n'
              'By providing your personal information, you:\n'
              '- Confirm that the information you provide is accurate and complete.\n'
              '- Agree to update your information as necessary to keep it accurate and complete.\n'
              '- Acknowledge that providing false or misleading information may result in the termination of your account.\n\n'
              '6. Account Termination\n\n'
              'We reserve the right to terminate or suspend your account at any time, without prior notice, for any reason, including but not limited to violation of these terms and conditions.\n\n'
              '7. Changes to Terms and Conditions\n\n'
              'We may update these terms and conditions from time to time. Any changes will be posted on this page, and we encourage you to review our terms and conditions regularly to stay informed of any updates.\n\n'
              '8. Contact Us\n\n'
              'If you have any questions or concerns about these terms and conditions, please contact us at support@nampahub.com.\n\n'
              '9. Acceptance of Terms\n\n'
              'By using our application, you signify your acceptance of these terms and conditions. If you do not agree to these terms, please do not use our application. Your continued use of the application following the posting of changes to these terms will be deemed your acceptance of those changes.\n',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                setState(() {
                  isAgreed = true;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                        validator: (suName) => suName!.isEmpty
                            ? 'Enter Your company name'
                            : RegExp('[a-zA-Z]').hasMatch(suName)
                                ? null
                                : 'Enter a Valid School/University name'),
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

                  Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 210),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                shape: const CircleBorder(),
                                value: isAgreed,
                                onChanged: (newValue) {
                                  setState(() {
                                    isAgreed = newValue!;
                                  });
                                },
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'I agree to the ',
                                style: TextStyle(fontSize: 16),
                              ),
                              GestureDetector(
                                onTap: _showTermsDialog,
                                child: const Text(
                                  'Terms and Conditions',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'you are employee? ',
                                style: TextStyle(fontSize: 16),
                              ),
                              GestureDetector(
                                onTap: widget.showWorkregisPage,
                                child: const Text(
                                  'Employee form',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isAgreed ? _validateAndRegister : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isAgreed ? const Color(0xFF1B8900) : Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Circle shape
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
