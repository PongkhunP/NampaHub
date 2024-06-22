import 'package:flutter/material.dart';
import 'package:nampa_hub/pages/register_edu_page.dart';
import 'package:nampa_hub/src/user.dart';
import 'package:nampa_hub/src/widget.dart';

class MyRegisterLocation extends StatefulWidget {
  final User user;
  const MyRegisterLocation({super.key, required this.user});

  @override
  State<MyRegisterLocation> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegisterLocation> {
  String? selectedCountry;
  String? selectedCity;
  List<String> listCity = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, List<String>> countryCityMap = {
    'Thailand': ['Bangkok', 'Chiang Mai', 'Pattaya', 'Phuket'],
    'Indo': ['Jakarta', 'Surabaya', 'Bandung', 'Bali'],
    'Brazil': ['São Paulo', 'Rio de Janeiro', 'Brasília', 'Salvador'],
    'China': ['Beijing', 'Shanghai', 'Guangzhou', 'Shenzhen'],
  };

  void _validateAndSend() {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform your submission logic here
      widget.user.setCountry(selectedCountry!);
      widget.user.setCity(selectedCity!);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return MyRegisterEdu( user: widget.user,);
        },
      ));
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
                        "Location Information",
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
                      hint: const Text("Country"),
                      dropdownColor: Colors.grey,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 36,
                      isExpanded: true,
                      value: selectedCountry,
                      validator: (value) {
                        if (value == null) {
                          return 'Please select your country';
                        }
                        return null;
                      },
                      onChanged: (newValue) {
                        setState(() {
                          selectedCountry = newValue;
                          selectedCity = null;
                          listCity = countryCityMap[selectedCountry!] ?? [];
                        });
                      },
                      items: countryCityMap.keys.map((String country) {
                        return DropdownMenuItem<String>(
                          value: country,
                          child: Text(country),
                        );
                      }).toList(),
                    ),
                  ),
                  // City Dropdown Widget
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
                      hint: const Text("City"),
                      dropdownColor: Colors.grey,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 36,
                      isExpanded: true,
                      value: selectedCity,
                      validator: (value) {
                        if (selectedCountry == null &&
                            (value == null || value.isEmpty)) {
                          return 'Please select your city';
                        }
                        return null;
                      },
                      onChanged: (newValue) {
                        setState(() {
                          selectedCity = newValue;
                        });
                      },
                      items: listCity.map((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 420),
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
