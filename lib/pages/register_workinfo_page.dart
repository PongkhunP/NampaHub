import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nampa_hub/pages/home_page.dart';
import '../src/config.dart';
import 'package:nampa_hub/src/user.dart';
import 'package:nampa_hub/src/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyRegisterWorkInfo extends StatefulWidget {
  final User user;
  const MyRegisterWorkInfo({super.key, required this.user});

  @override
  State<MyRegisterWorkInfo> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegisterWorkInfo> {
  final TextEditingController _companyNameController = TextEditingController();
  String? selectedJob;
  bool isAgreed = false;
  bool _isRegistering = false;
  late SharedPreferences prefs;
  List<String> joblist = ['Student', 'Police', 'Teacher', 'Marine'];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _validateAndRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.user.setCompanyName(_companyNameController.text);
      widget.user.setJob(selectedJob ?? '');
      if (isAgreed) {
        _registerUser();
        print('Register successfully');
      } else {
        print("You must agree to the terms and conditions");
      }
    } else {
      print("Form is invalid");
    }
  }

  void _registerUser() async {
    setState(() {
      _isRegistering = true;
    });

    try {
      final response = await http.post(
        Uri.parse(registration),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(widget.user.toJson()),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print('User registered successfully with response $jsonResponse');

        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);

        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return MyHomePage();
            },
          ));
        }
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isRegistering = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initSharedPref();
  }

  void _initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // void _navigateToStudentForm() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const MyRegisterEdu()),
  //   );
  // }

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
                        "Work Information",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Color(0xFF1B8900),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Company name TextField
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Company name (Optional)',
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
                      validator: (companyName) {
                        if (companyName!.isNotEmpty) {
                          if (!RegExp('[a-zA-Z]').hasMatch(companyName)) {
                            return 'Please enter valid company name';
                          }
                        }
                        return null;
                      },
                      controller: _companyNameController,
                    ),
                  ),
                  // Job Dropdown Widget
                  Padding(
                    padding: const EdgeInsets.all(10),
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
                      hint: const Text("Job (Optional)"),
                      dropdownColor: Colors.grey,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 36,
                      isExpanded: true,
                      value: selectedJob,
                      onChanged: (newValue) {
                        setState(() {
                          selectedJob = newValue;
                        });
                      },
                      items: joblist.map((String job) {
                        return DropdownMenuItem<String>(
                          value: job,
                          child: Text(job),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(
                      height:
                          270), // Added space to push terms closer to the button
                  // Terms and Conditions Checkbox
                  Center(
                    child: Column(
                      children: [
                        Row(
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isAgreed && !_isRegistering
                          ? _validateAndRegister
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAgreed && !_isRegistering
                            ? const Color(0xFF1B8900)
                            : Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Circle shape
                        ),
                      ),
                      child: _isRegistering
                          ? const CircularProgressIndicator()
                          : const Text(
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
