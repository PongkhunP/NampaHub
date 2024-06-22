import 'package:flutter/material.dart';
import 'package:nampa_hub/pages/create_activity_upload_images.dart';
import 'package:nampa_hub/src/activity.dart';
import 'package:nampa_hub/src/widget.dart';

class CreateActivityDate extends StatefulWidget {
  final Activity activity;
  const CreateActivityDate({super.key, required this.activity});

  @override
  State<CreateActivityDate> createState() => _CreateActivityDateState();
}

class _CreateActivityDateState extends State<CreateActivityDate> {
  final _formkey = GlobalKey<FormState>();
  DateTime? _startRegisterDate;
  DateTime? _endRegisterDate;
  DateTime? _eventDate;

  void _validateAndSend() {
    if (_formkey.currentState!.validate()) {
      try {
        ActivityDate activityDate = ActivityDate(
          startRegisDate: _startRegisterDate!,
          endRegisDate: _endRegisterDate!,
          eventDate: _eventDate!,
        );

        widget.activity.setActivityDate(activityDate);

        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return MyUploadActivityImages(
              activity: widget.activity,
            );
          },
        ));
      } catch (e) {
        print('Error parsing input: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid input, please check your entries.')),
        );
      }
    }
  }

  Future<void> _selectStartRegisterDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startRegisterDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startRegisterDate) {
      setState(() {
        _startRegisterDate = picked;
      });
    }
  }

  Future<void> _selectEndRegisterDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endRegisterDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endRegisterDate) {
      setState(() {
        _endRegisterDate = picked;
      });
    }
  }

  Future<void> _selectEventDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _eventDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _eventDate) {
      setState(() {
        _eventDate = picked;
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: GestureDetector(
                      onTap: () => _selectStartRegisterDate(context),
                      child: TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: _startRegisterDate == null
                              ? 'Start register date'
                              : _startRegisterDate.toString().split(' ')[0],
                          hintStyle: const TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 230, 229, 229),
                          border: InputBorder.none,
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none),
                          errorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none),
                          disabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none),
                        ),
                        style: const TextStyle(color: Colors.black),
                        validator: (value) {
                          if (_startRegisterDate == null) {
                            return 'Select start register date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: GestureDetector(
                      onTap: () => _selectEndRegisterDate(context),
                      child: TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: const Color.fromARGB(255, 230, 229, 229),
                          hintText: _endRegisterDate == null
                              ? 'End register date'
                              : _endRegisterDate.toString().split(' ')[0],
                          hintStyle: const TextStyle(color: Colors.black),
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none),
                          errorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none),
                          disabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none),
                        ),
                        style: const TextStyle(color: Colors.black),
                        validator: (value) {
                          if (_endRegisterDate == null) {
                            return 'Select end register date';
                          }else if (_endRegisterDate ==  _startRegisterDate){
                            return 'Cannnot select same date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: GestureDetector(
                      onTap: () => _selectEventDate(context),
                      child: TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: _eventDate == null
                              ? 'Event date'
                              : _eventDate.toString().split(' ')[0],
                          hintStyle: const TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 230, 229, 229),
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none),
                          errorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none),
                          disabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none),
                        ),
                        style: const TextStyle(color: Colors.black),
                        validator: (value) {
                          if (_eventDate == null) {
                            return 'Select event date';
                          }else if (_endRegisterDate ==  _startRegisterDate){
                            return 'Cannnot select same date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 150),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _validateAndSend,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B8900),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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
