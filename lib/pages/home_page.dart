import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:swifty_companion/models/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title column
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        'Search',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 3),

                      // Date
                      Text(
                        '23 Jan, 2021',
                        style: TextStyle(color: Colors.grey[400]),
                      )
                    ],
                  ),

                  SizedBox(height: 25),

                  // search bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                            'Search',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15
                            )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 15),

          Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.grey[100],
                child: Column(
                  children: [
                    // header

                  ],),
              )
          )
        ],
      ),
    );
  }
}