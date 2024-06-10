import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nampa_hub/auth/main_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load(fileName: '.env');
  String? storedToken = prefs.getString('token');
  runApp(MyApp(
    token: storedToken ?? '',
  ));
}

class MyApp extends StatelessWidget {
  final String token;
  const MyApp({super.key, required this.token});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NampaHub',
      home: MainAuth(token: token),
    );
  }
}
