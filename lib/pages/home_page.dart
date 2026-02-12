import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:swifty_companion/models/user.dart';
import 'package:swifty_companion/manager/key_manager.dart';

import 'package:swifty_companion/pages/profile_page.dart';

User targetUser = User(
  name: 'John Doe',
  email: 'johndoe@mail.com',
  avatarUrl: 'https://png.pngtree.com/png-clipart/20240717/original/pngtree-a-cute-penguin-png-image_15572371.png',
  level: 8,
  levelPercentage: 0.2,
  wallet: 300,
  evalPoints: 40,
  rank: 20,
  score: 2,
  projects: [
    Project(name: 'Project 1', score: 100, isSuccess: true),
    Project(name: 'Project 2', score: 50, isSuccess: false),
    Project(name: 'Project 3', score: 125, isSuccess: true),
  ],
  skills: [
    Skill(name: 'Skill 1', score: 5),
    Skill(name: 'Skill 2', score: 10),
  ],
);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 320), () {
      if (_searchController.text.isNotEmpty) {
        _performSearch(_searchController.text);
      }
    });
  }

  Future<void> _lookAtProfile(String username) async {
    TokenManager tokenManager = TokenManager();
    String token = await tokenManager.getValidToken();

    final response = await http.get(
      Uri.parse('https://api.intra.42.fr/v2/users/$username'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      print(userData);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        )
      );
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  void _performSearch(String query) {
    print('Searching for: $query');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            'Search',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Date
                          Text(
                            '23 Jan, 2021',
                            style: TextStyle(color: Colors.grey[400]),
                          )
                        ],
                      ),

                      SizedBox(height: 20),

                      Container(
                        height: 46,
                        margin: const EdgeInsets.only(left: 0),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: Colors.grey.shade600
                          )
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onSubmitted: (value) {
                                  _lookAtProfile(value);
                                },
                                textInputAction: TextInputAction.search,
                                style: const TextStyle(fontSize: 14),
                                decoration: const InputDecoration(
                                  hintText: "Login",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 15),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Recent Searches',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),

                            SizedBox(height: 5),

                            Container(
                                height: 640,
                                child: ListView(
                                  children: [
                                    _profileCard('Project 1', 100, true),
                                  ],
                                )
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _profileCard(String name, num score, bool isSuccess) {
  return Container(
    margin: EdgeInsets.only(bottom: 10),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Color.from(alpha: 0.5, red: 0, green: 0, blue: 0))
          ),
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://img.freepik.com/photos-gratuite/pingouin-amusant-illustration-3d_183364-123493.jpg'),
            radius: 50,
          ),
        ),
        SizedBox(width: 10),
        Text(
          'login',
          style: TextStyle(
            fontSize: 15
          ),
        )
      ],
    ),
  );
}