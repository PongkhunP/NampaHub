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
  DateTime? _startYear;
  DateTime? _endYear;
  bool _isSubmitting = false;

  late TextEditingController _firstnameController;
  late TextEditingController _middlenameController;
  late TextEditingController _lastnameController;
  late TextEditingController _ageController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _edunameController;

  final _formkey = GlobalKey<FormState>();

  // Track visibility state
  bool _isPersonalInfoVisible = false;
  bool _isLocationVisible = false;
  bool _isEducationVisible = false;
  bool _isWorkVisible = false;

  @override
  void dispose() {
    _firstnameController.dispose();
    _middlenameController.dispose();
    _lastnameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _edunameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _firstnameController = TextEditingController(text: widget.user.firstname);
    _middlenameController = TextEditingController(text: widget.user.middlename);
    _lastnameController = TextEditingController(text: widget.user.lastname);
    _ageController = TextEditingController(text: widget.user.age.toString());
    _phoneController = TextEditingController(text: widget.user.phone);
    _cityController = TextEditingController(text: widget.user.city);
    _countryController = TextEditingController(text: widget.user.country);
    _edunameController = TextEditingController(text: widget.user.instituteName);

    super.initState();
  }

  void validateAndSubmit() {
    setState(() {
      _isSubmitting = true;
    });

    if (_formkey.currentState!.validate() && _isAtLeastOneFieldFilled()) {
      try {
        _firstnameController.text.isNotEmpty
            ? widget.user.setFirstName(_firstnameController.text)
            : null;
        _middlenameController.text.isNotEmpty
            ? widget.user.setMiddleName(_middlenameController.text)
            : null;
        _lastnameController.text.isNotEmpty
            ? widget.user.setLastName(_lastnameController.text)
            : null;
        _ageController.text.isNotEmpty
            ? widget.user.setAge(int.parse(_ageController.text))
            : null;
        _cityController.text.isNotEmpty
            ? widget.user.setCity(_cityController.text)
            : null;
        _phoneController.text.isNotEmpty
            ? widget.user.setPhone(_phoneController.text)
            : null;
        _countryController.text.isNotEmpty
            ? widget.user.setCountry(_countryController.text)
            : null;
        _edunameController.text.isNotEmpty
            ? widget.user.setInstituteName(_edunameController.text)
            : null;
        _startYear != null
            ? widget.user.setStartDate(_startYear.toString())
            : null;
        _endYear != null ? widget.user.setEndDate(_endYear.toString()) : null;

        _editUser();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'),
          ),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    } else {
      // Show a message to the user that at least one field is required
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in neccessary field.'),
        ),
      );
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  bool _isAtLeastOneFieldFilled() {
    return _firstnameController.text.isNotEmpty ||
        _middlenameController.text.isNotEmpty ||
        _lastnameController.text.isNotEmpty ||
        _ageController.text.isNotEmpty ||
        _phoneController.text.isNotEmpty ||
        _cityController.text.isNotEmpty ||
        _countryController.text.isNotEmpty ||
        _edunameController.text.isNotEmpty;
  }

  Future<void> _editUser() async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        print('User not authenticated');
        return;
      }
      final uri = Uri.parse(edituser);
      final response = await http.patch(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(widget.user.toJson()),
      );
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

  Future<void> _selectStartYear(BuildContext context) async {
    final int? pickedYear = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int selectedYear = _startYear?.year ?? DateTime.now().year;
        return AlertDialog(
          title: const Text('Select Year'),
          content: Container(
            // Need to use container to add size constraint.
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year - 100, 1),
              lastDate: DateTime(2101, 1),
              selectedDate: DateTime(selectedYear, 1),
              onChanged: (DateTime dateTime) {
                // Close the dialog and return the selected year.
                Navigator.pop(context, dateTime.year);
              },
            ),
          ),
        );
      },
    );

    if (pickedYear != null && pickedYear != _startYear?.year) {
      setState(() {
        _startYear = DateTime(pickedYear);
        // Reset end year if it's before the new start year
        if (_endYear != null && _endYear!.year < pickedYear) {
          _endYear = null;
        }
      });
    }
  }

  Future<void> _selectEndYear(BuildContext context) async {
    final int? pickedYear = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int selectedYear = _endYear?.year ?? DateTime.now().year;
        return AlertDialog(
          title: const Text('Select Year'),
          content: Container(
            // Need to use container to add size constraint.
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: _startYear ?? DateTime(DateTime.now().year, 1),
              lastDate: DateTime(2101, 1),
              selectedDate: DateTime(selectedYear, 1),
              onChanged: (DateTime dateTime) {
                // Close the dialog and return the selected year.
                Navigator.pop(context, dateTime.year);
              },
            ),
          ),
        );
      },
    );

    if (pickedYear != null && pickedYear != _endYear?.year) {
      setState(() {
        _endYear = DateTime(pickedYear);

        if (_startYear != null && _startYear!.year > pickedYear) {
          _startYear = null;
        }
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    const Stack(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: ClipOval(
                              child: Image(
                                image: AssetImage('assets/images/Beach.jpg'),
                                width: 180,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ListTile(
                      title: const Text(
                        'Personal information',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF1B8900),
                        ),
                      ),
                      trailing: Icon(_isPersonalInfoVisible
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down),
                      onTap: () {
                        setState(() {
                          _isPersonalInfoVisible = !_isPersonalInfoVisible;
                        });
                      },
                    ),
                    Visibility(
                      visible: _isPersonalInfoVisible,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 10, top: 10),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: _firstnameController,
                                decoration: const InputDecoration(
                                  labelText: 'First name',
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: _middlenameController,
                                decoration: const InputDecoration(
                                  labelText: 'Middle name',
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: _lastnameController,
                                decoration: const InputDecoration(
                                  labelText: 'Last name',
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _ageController,
                                decoration: const InputDecoration(
                                  labelText: 'Age',
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: _phoneController,
                                decoration: const InputDecoration(
                                  labelText: 'Phone',
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15),
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
                        ],
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        'Location',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF1B8900),
                        ),
                      ),
                      trailing: Icon(_isLocationVisible
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down),
                      onTap: () {
                        setState(() {
                          _isLocationVisible = !_isLocationVisible;
                        });
                      },
                    ),
                    Visibility(
                      visible: _isLocationVisible,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 10, top: 10),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: _cityController,
                                decoration: const InputDecoration(
                                  labelText: 'City',
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: _countryController,
                                decoration: const InputDecoration(
                                  labelText: 'Country',
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15),
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
                        ],
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        'Education',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF1B8900),
                        ),
                      ),
                      trailing: Icon(_isEducationVisible
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down),
                      onTap: () {
                        setState(() {
                          _isEducationVisible = !_isEducationVisible;
                        });
                      },
                    ),
                    Visibility(
                      visible: _isEducationVisible,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 5, top: 5),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: _edunameController,
                                decoration: const InputDecoration(
                                  labelText: 'Education name',
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15),
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
                                left: 25, right: 25, bottom: 5, top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: GestureDetector(
                                    onTap: () => _selectStartYear(context),
                                    child: TextFormField(
                                      enabled: false,
                                      decoration: InputDecoration(
                                        hintText: _startYear == null
                                            ? 'Start Year'
                                            : _startYear
                                                .toString()
                                                .split('-')[0],
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 15),
                                      ),
                                    ),
                                  ),
                                ),
                                FormField<String>(
                                  validator: (value) {
                                    if (_startYear == null &&
                                        _endYear != null) {
                                      return 'Select start year';
                                    }
                                    return null;
                                  },
                                  builder: (FormFieldState<String> field) {
                                    return field.hasError
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 5),
                                            child: Text(
                                              field.errorText!,
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        : Container();
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 5, top: 5),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: GestureDetector(
                                onTap: () => _selectEndYear(context),
                                child: TextFormField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                    hintText: _endYear == null
                                        ? 'End Year'
                                        : _endYear.toString().split('-')[0],
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                  ),
                                  validator: (value) {
                                    if (_endYear == null &&
                                        _startYear != null) {
                                      return 'Select End year';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        'Work information',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF1B8900),
                        ),
                      ),
                      trailing: Icon(_isWorkVisible
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down),
                      onTap: () {
                        setState(() {
                          _isWorkVisible = !_isWorkVisible;
                        });
                      },
                    ),
                    Visibility(
                      visible: _isWorkVisible,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 10, top: 10),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: _cityController,
                                decoration: const InputDecoration(
                                  labelText: 'Company',
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: _countryController,
                                decoration: const InputDecoration(
                                  labelText: 'Job',
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : validateAndSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isSubmitting ? Colors.grey : const Color(0xFF1B8900),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: const Size.fromHeight(50), // Set button height
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
