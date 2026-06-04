import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:nampa_hub/mid/auth.dart';
import 'package:nampa_hub/pages/home_page.dart';

class MainAuth extends StatelessWidget {
  final String token;
  const MainAuth({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    if (token.isEmpty || JwtDecoder.isExpired(token)) {
      return const AuthPage();
    } else {
      return MyHomePage();
    }
  }
}
