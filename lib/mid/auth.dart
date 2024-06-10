import 'package:flutter/material.dart';
import 'package:nampa_hub/auth/login.dart';
import 'package:nampa_hub/auth/register.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showloginPage = true;

  void toggleScreens() {
    setState(() {
      showloginPage = !showloginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showloginPage) {
      return LoginPage(showRegisterPage: toggleScreens,);
    } else {
      return RegisterPage(showLoginPage: toggleScreens,);
    }
  }
}
