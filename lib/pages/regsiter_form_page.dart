import 'package:flutter/material.dart';
import 'package:nampa_hub/src/widget.dart';

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
                      child: Text("Personal Information",
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
                              contentPadding: EdgeInsets.only(top: 15),
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Icon(Icons.person),
                              ),
                              hintText: 'First name',
                            ),
                            validator: (firstName) => firstName!.isEmpty
                                ? 'Enter Your Name'
                                : RegExp('[a-zA-Z]').hasMatch(firstName)
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
                            contentPadding: EdgeInsets.only(top: 15),
                            border: InputBorder.none,
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Icon(Icons.person_outline),
                            ),
                            hintText: 'Middle name (Optional)',
                          ),
                          validator: (middleName) => middleName!.isEmpty
                              ? null
                              : RegExp('[a-zA-Z]').hasMatch(middleName)
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
                              contentPadding: EdgeInsets.only(top: 15),
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Icon(Icons.person),
                              ),
                              hintText: 'Last name',
                            ),
                            validator: (lastName) => lastName!.isEmpty
                                ? 'Enter Your Name'
                                : RegExp('[a-zA-Z]').hasMatch(lastName)
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
                              contentPadding: EdgeInsets.only(top: 15),
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Icon(Icons.cake),
                              ),
                              hintText: 'Age',
                            ),
                            validator: (ageValue) => ageValue!.isEmpty
                                ? 'Enter Your Age'
                                : RegExp(r'^[0-9]{1,2}$').hasMatch(ageValue)
                                    ? null
                                    : 'Enter a Valid Age'),
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
                              contentPadding: EdgeInsets.only(top: 15),
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Icon(Icons.phone),
                              ),
                              hintText: 'Phone',
                            ),
                            validator: (phoneValue) => phoneValue!.isEmpty
                                ? 'Enter Phone Number'
                                : RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                                        .hasMatch(phoneValue)
                                    ? null
                                    : 'Enter a Valid Phone Number'),
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
