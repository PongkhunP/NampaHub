import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for TextInputFormatter
import 'package:nampa_hub/src/widget.dart';

class MyDonation extends StatefulWidget {
  const MyDonation({super.key});

  @override
  MyDonationState createState() => MyDonationState();
}

class MyDonationState extends State<MyDonation> {
  int selectedAmount = 0; // Variable to store the selected amount
  TextEditingController amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    amountController.dispose();
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
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          height: 600, // Adjust the height as needed
          width: 380, // Adjust the width as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Donation Here',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: Text(
                  'Your support helps make the campaign better and higher quality.',
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: Text(
                    'Donation information',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: SizedBox(
                      height: 45,
                      width: 100,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            selectedAmount = 100;
                            amountController.text = '100';
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: selectedAmount == 100 ? Colors.green : Colors.transparent,
                        ),
                        child: Text(
                          '100 B',
                          style: TextStyle(
                            fontSize: 18,
                            color: selectedAmount == 100 ? Colors.white : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: SizedBox(
                      height: 45,
                      width: 100,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            selectedAmount = 300;
                            amountController.text = '300';
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: selectedAmount == 300 ? Colors.green : Colors.transparent,
                        ),
                        child: Text(
                          '300 B',
                          style: TextStyle(
                            fontSize: 18,
                            color: selectedAmount == 300 ? Colors.white : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: SizedBox(
                      height: 45,
                      width: 100,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            selectedAmount = 500;
                            amountController.text = '500';
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: selectedAmount == 500 ? Colors.green : Colors.transparent,
                        ),
                        child: Text(
                          '500 B',
                          style: TextStyle(
                            fontSize: 18,
                            color: selectedAmount == 500 ? Colors.white : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: amountController,
                        decoration: const InputDecoration(
                          labelText: 'Enter custom amount',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ], // Allow only numbers
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an amount';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              selectedAmount = 0;
                            } else {
                              selectedAmount = int.parse(value);
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                        visible: selectedAmount > 0,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.verified, color: Colors.green),
                                const SizedBox(width: 10),
                                Text(
                                  "Confirm donation, I’ll support $selectedAmount \n to this campaign",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 350,
                              height: 45, // Adjust the width as needed
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // Add your submission logic here
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Donation of $selectedAmount B submitted')),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellow, // Background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text('Confirm',style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
