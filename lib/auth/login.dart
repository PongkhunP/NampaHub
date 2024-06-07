import 'package:flutter/material.dart';
import 'package:nampa_hub/src/widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Logo(),
        ),
        backgroundColor: const Color(0xFF1B8900),
      ),
      body: Column(
        children: [
          const Text('Login'),
          const Text('Welcome back! We miss you so much'),
          TextFormField(
            decoration: const InputDecoration(label: Text('Email')),
          ),
        ],
      ),
    );
  }
}
