import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nampa_hub/mid/token_manager.dart';
import 'package:nampa_hub/pages/home_page.dart';
import 'package:nampa_hub/src/user.dart';
import 'package:nampa_hub/src/widget.dart';
import 'package:nampa_hub/src/config.dart';
import 'package:http/http.dart' as http;

class MyEditProfilePage extends StatefulWidget {
  final User user;
  const MyEditProfilePage({super.key, required this.user});

  @override
  MyEditProfilePageState createState() => MyEditProfilePageState();
}

class MyEditProfilePageState extends State<MyEditProfilePage> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _middlenameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _edunameController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstnameController.dispose();
    _middlenameController.dispose();
    _lastnameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _countryController.dispose();
    _edunameController.dispose();
    super.dispose();
  }

  void validateAndSubmit() {
    if (_formkey.currentState!.validate() && _isAtLeastOneFieldFilled()) {
      widget.user.setFirstName(_firstnameController.text);
      widget.user.setMiddleName(_middlenameController.text);
      widget.user.setLastName(_lastnameController.text);
      widget.user.setAge(int.parse(_ageController.text));
      widget.user.setCity(_locationController.text);
      widget.user.setPhone(_phoneController.text);
      widget.user.setCountry(_countryController.text);
      widget.user.setInstituteName(_edunameController.text);
      _editUser();
    } else {
      // Show a message to the user that at least one field is required
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in at least one field.'),
        ),
      );
    }
  }

  bool _isAtLeastOneFieldFilled() {
    return _firstnameController.text.isNotEmpty ||
        _middlenameController.text.isNotEmpty ||
        _lastnameController.text.isNotEmpty ||
        _ageController.text.isNotEmpty ||
        _phoneController.text.isNotEmpty ||
        _locationController.text.isNotEmpty ||
        _countryController.text.isNotEmpty ||
        _edunameController.text.isNotEmpty;
  }

  Future<void> _editUser() async {
    print("user body: ${widget.user}");
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        print('User not authenticated');
        return;
      }
      print("token ${token.isNotEmpty}");
      final uri = Uri.parse(edituser);
      print("body: ${jsonEncode(widget.user.toJson())}");
      print("uri : $uri");
      final response = await http.patch(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(widget.user.toJson()),
      );
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        print("User edit successfully");
        if (mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const MyHomePage();
          }));
        }
      }
    } catch (e) {
      print(e);
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
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Stack(
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: ClipOval(
                        child: Image(
                          image: AssetImage('images/Beach.jpg'),
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: 100,
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.black),
                      onPressed: () {
                        // Add functionality to change the image
                      },
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30, left: 30),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Current information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF1B8900),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'King Mongkut’s University of Technology Thonburi (KMUTT)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30, left: 30),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'New personal information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF1B8900),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, bottom: 10, top: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: _firstnameController,
                    decoration: const InputDecoration(
                      hintText: 'New Firstname',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null; // Optional field, so no error if empty
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, bottom: 10, top: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: _middlenameController,
                    decoration: const InputDecoration(
                      hintText: 'New Middle Name',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null; // Optional field, so no error if empty
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, bottom: 10, top: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: _lastnameController,
                    decoration: const InputDecoration(
                      hintText: 'New Last Name',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null; // Optional field, so no error if empty
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, bottom: 10, top: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _ageController,
                    decoration: const InputDecoration(
                      hintText: 'New Age',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null; // Optional field, so no error if empty
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, bottom: 10, top: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      hintText: 'New Phone',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null; // Optional field, so no error if empty
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30, left: 30),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'New location',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF1B8900),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, bottom: 10, top: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      hintText: 'New Location',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null; // Optional field, so no error if empty
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, bottom: 10, top: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: _countryController,
                    decoration: const InputDecoration(
                      hintText: 'New Country',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null; // Optional field, so no error if empty
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30, left: 30),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'New Education',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF1B8900),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, bottom: 60, top: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: _edunameController,
                    decoration: const InputDecoration(
                      hintText: 'New Education Name',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null; // Optional field, so no error if empty
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Container(
                width: 380,
                height: 50,
                margin: const EdgeInsets.all(30.0),
                child: ElevatedButton(
                  onPressed: validateAndSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B8900),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
