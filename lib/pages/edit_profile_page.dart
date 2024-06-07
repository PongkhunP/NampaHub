import 'package:flutter/material.dart';
import 'package:nampa_hub/src/widget.dart';


class MyEditProfilePage extends StatefulWidget {
  const MyEditProfilePage({super.key});

  @override
  MyEditProfilePageState createState() => MyEditProfilePageState();
}

class MyEditProfilePageState extends State<MyEditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _universityController.dispose();
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
                  'New information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF1B8900),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom:10,top: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: 'New Username',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom:60,top: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _universityController,
                  decoration: const InputDecoration(
                    hintText: 'New Education',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            Container(
              width: 380,
              height: 50,
              margin: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                onPressed: () {
              
                  String newUsername = _usernameController.text;
                  String newUniversity = _universityController.text;
          
                },
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
    );
  }
}
