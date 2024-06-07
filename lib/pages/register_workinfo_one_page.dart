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
      home: const MyRegisterWorkOne(),
    );
  }
}

class MyRegisterWorkOne extends StatefulWidget {
  const MyRegisterWorkOne({super.key});

  @override
  State<MyRegisterWorkOne> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegisterWorkOne> {
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

  void _validateAndSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform your submission logic here
      print("Form is valid");
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
                  Container(
                    width: 350,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                  const SizedBox(height: 15),
                  // City Dropdown Widget
                  Container(
                    width: 350,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                      hint: const Text("City"),
                      dropdownColor: Colors.grey,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 36,
                      isExpanded: true,
                      value: selectedCity,
                      validator: (value) {
                        if (selectedCountry == null && (value == null || value.isEmpty)) {
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
                      onPressed: _validateAndSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B8900),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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
