import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nampa_hub/src/widget.dart';
import  'package:nampa_hub/pages/register_edu_page.dart';

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
      home: const MyRegisterWorkTwo(),
    );
  }
}

class MyRegisterWorkTwo extends StatefulWidget {
  const MyRegisterWorkTwo({Key? key}) : super(key: key);

  @override
  State<MyRegisterWorkTwo> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegisterWorkTwo> {
  String? selectedJob;
  bool isAgreed = false;
  List<String> joblist = ['Student', 'Police', 'Teacher', 'Marine'];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _validateAndSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (isAgreed) {
        // Perform your submission logic here
        print("Form is valid and terms are agreed");
      } else {
        print("You must agree to the terms and conditions");
      }
    } else {
      print("Form is invalid");
    }
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

  void _navigateToStudentForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyRegisterEdu()),
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
                              hintText: 'Company name',
                            ),
                            validator: (companyName) => companyName!.isEmpty
                                ? 'Enter your company name'
                                : RegExp('[a-zA-Z]').hasMatch(companyName)
                                    ? null
                                    : 'Enter a valid company name'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Job Dropdown Widget
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
                      hint: const Text("Job"),
                      dropdownColor: Colors.grey,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 36,
                      isExpanded: true,
                      value: selectedJob,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a job';
                        }
                        return null;
                      },
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
                  const SizedBox(height: 270), // Added space to push terms closer to the button
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
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'you are student? ',
                                style: TextStyle(fontSize: 16),
                              ),
                              GestureDetector(
                                onTap: _navigateToStudentForm,
                                child: const Text(
                                  'Student form',
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
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isAgreed ? _validateAndSubmit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAgreed
                            ? const Color(0xFF1B8900)
                            : Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Circle shape
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