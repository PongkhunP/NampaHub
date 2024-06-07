import 'package:flutter/material.dart';
import 'package:nampa_hub/src/widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Logo(),
        ),
        backgroundColor: const Color(0xFF1B8900),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Login',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1B8900),
                    fontSize: 24),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Welcome back! We miss you so much',
                style: TextStyle(
                    color: Color.fromARGB(255, 148, 148, 148),
                    fontWeight: FontWeight.normal,
                    fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                decoration: const InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Color.fromARGB(255, 230, 229, 229),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        borderSide: BorderSide.none)),
                controller: _emailController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                decoration: const InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Color.fromARGB(255, 230, 229, 229),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        borderSide: BorderSide.none)),
                controller: _emailController,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1B8900),
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        child: const Center(
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Already have an account?',
                    style: TextStyle(
                        color: Color.fromARGB(255, 148, 148, 148),
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                  ),
                ),
                GestureDetector(
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Text(
                      'Register',
                      style: TextStyle(
                          color: Color(0xFF1B8900),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
