import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:swifty_companion/pages/home_page.dart';
import 'package:swifty_companion/pages/profile_page.dart';
import 'package:swifty_companion/pages/loading_page.dart';
import 'package:swifty_companion/manager/key_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  TokenManager tokenManager = TokenManager();
  print("hey");
  try {
    String token = await tokenManager.getValidToken();
    print('Token read: $token');
  } catch (e) {
    print('Error getting token: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingPage(),
      //profile: ProfilePage(),
    );
  }
}
