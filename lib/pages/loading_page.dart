import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
					valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
				  ),
				  SizedBox(height: 10),
                  Text(
					"Loading Content...",
					style: TextStyle(
                  		fontWeight: FontWeight.bold,
                		),
					)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
