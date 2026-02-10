import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:swifty_companion/pages/home_page.dart';
import 'package:swifty_companion/pages/profile_page.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env.example");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
      //profile: ProfilePage(),
    );
  }
}
