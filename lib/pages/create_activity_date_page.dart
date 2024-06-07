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
                    child: Container(
                      width: 350,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFE7E7E7)),
                      child: Center(
                        child: TextFormField(
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(top: 8, left: 20),
                              border: InputBorder.none,
                              
                              hintText: 'Start register date',
                            ),
                            validator: (srDate) => srDate!.isEmpty
                                ? 'Enter Your Name'
                                : RegExp('[a-zA-Z]').hasMatch(srDate)
                                    ? null
                                    : 'Enter a Valid Name'),
                      ),
                    ),
                  ),
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
                            contentPadding: EdgeInsets.only(top: 8, left: 20),
                            border: InputBorder.none,
                            
                            hintText: 'End register date',
                          ),
                          validator: (erDate) => erDate!.isEmpty
                              ? null
                              : RegExp('[a-zA-Z]').hasMatch(erDate)
                                  ? null
                                  : 'Enter a Valid Name',
                        ),
                      ),
                    ),
                  ),
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
                              contentPadding: EdgeInsets.only(top: 8, left: 20),
                              border: InputBorder.none,
                              
                              hintText: 'Event date',
                            ),
                            validator: (evDate) => evDate!.isEmpty
                                ? 'Enter Your Name'
                                : RegExp('[a-zA-Z]').hasMatch(evDate)
                                    ? null
                                    : 'Enter a Valid Name'),
                      ),
                    ),
                  ),
                 
                 

                  const SizedBox(height: 150),

                  SizedBox(
                      width: 350,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            _formkey.currentState!.validate();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1B8900),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: const Text(
                            'Next',
                            style: TextStyle(fontSize: 18),
                          ))),

                  // Add more widgets here as needed for your registration form
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
