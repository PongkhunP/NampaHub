import 'package:flutter/material.dart';
import 'package:nampa_hub/pages/register_location_page.dart';
import 'package:nampa_hub/src/user.dart';
import 'package:nampa_hub/src/widget.dart';

class MyRegisterPersonalInfo extends StatefulWidget {
  final User user;
  const MyRegisterPersonalInfo({super.key, required this.user});

  @override
  State<MyRegisterPersonalInfo> createState() => _MyRegisterPersonalInfoState();
}

class _MyRegisterPersonalInfoState extends State<MyRegisterPersonalInfo> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _middlenameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void validateandSend() {
    if (_formkey.currentState!.validate()) {
      widget.user.setFirstName(_firstnameController.text);
      widget.user.setMiddleName(_middlenameController.text);
      widget.user.setLastName(_lastnameController.text);
      widget.user.setAge(int.parse(_ageController.text));
      widget.user.setPhone(_phoneController.text);
      widget.user.printDetails();
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return MyRegisterLocation(
            user: widget.user,
          );
        },
      ));
    }
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _middlenameController.dispose();
    _lastnameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'First name',
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
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Icon(Icons.person),
                        ),
                      ),
                      validator: (firstName) {
                        if (firstName!.isEmpty) {
                          return 'Name cannot be empty';
                        }
                        if (!RegExp('[a-zA-Z]').hasMatch(firstName)) {
                          return 'Enter a valid name';
                        } else {
                          return null;
                        }
                      },
                      controller: _firstnameController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Middle name (Optional)',
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
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Icon(Icons.person_outline),
                        ),
                      ),
                      validator: (middleName) => middleName!.isEmpty
                          ? null
                          : RegExp('[a-zA-Z]').hasMatch(middleName)
                              ? null
                              : 'Enter a Valid Name',
                      controller: _middlenameController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Lastname',
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
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Icon(Icons.person),
                        ),
                      ),
                      validator: (lastName) => lastName!.isEmpty
                          ? 'Enter Your Name'
                          : RegExp('[a-zA-Z]').hasMatch(lastName)
                              ? null
                              : 'Enter a Valid Name',
                      controller: _lastnameController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Age',
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
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Icon(Icons.cake),
                        ),
                      ),
                      validator: (ageValue) => ageValue!.isEmpty
                          ? 'Enter Your Age'
                          : RegExp(r'^[0-9]{1,2}$').hasMatch(ageValue)
                              ? null
                              : 'Enter a Valid Age',
                      controller: _ageController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Phone number',
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
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Icon(Icons.phone),
                        ),
                      ),
                      validator: (phoneValue) => phoneValue!.isEmpty
                          ? 'Enter Phone Number'
                          : RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                                  .hasMatch(phoneValue)
                              ? null
                              : 'Enter a Valid Phone Number',
                      controller: _phoneController,
                    ),
                  ),

                  const SizedBox(height: 150),

                  SizedBox(
                      width: 350,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            validateandSend();
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
