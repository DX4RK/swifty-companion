import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:swifty_companion/models/user.dart';
import 'package:swifty_companion/manager/key_manager.dart';

import 'package:swifty_companion/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

Future<bool> hasNetwork() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  }
  return true;
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
    if (!await hasNetwork()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No internet connection')),
      );
      return;
    }

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

      double level = (userData['cursus_users'][1]['level'] as num).toDouble();
      double decimalPart = level - level.toInt();
      
      int currentCursus = 1;
      int currentCursusId = userData['cursus_users'][currentCursus]['cursus_id'];

      List<Project> filteredProjects = [];

      for (var item in userData['projects_users']) {
        List cursusIds = item["cursus_ids"] ?? [];

        if (cursusIds.contains(currentCursusId)) {
          Project project = Project(
            name: item["project"]["name"] ?? "Unknown",
            score: item["final_mark"] ?? 0,
            isFinished: item['status'] == "finished",
            isValidated: item["validated?"] ?? false,
          );

          filteredProjects.add(project);
        }
      }

      List<Skill> filteredSkills = [];

      for (var item in userData['cursus_users'][currentCursus]['skills']) {
        Skill skill = Skill(
          name: item["name"] ?? "Unknown",
          score: item["level"] ?? 0,
        );

        filteredSkills.add(skill);
      }

      User user = User(
        name: userData['usual_full_name'],
        email: userData['email'],
        avatarUrl: userData['image']['link'],
        level: userData['cursus_users'][currentCursus]['level'].toInt(),
        levelPercentage: decimalPart,
        wallet: userData['wallet'],
        evalPoints: userData['correction_point'],
        grade: userData['cursus_users'][currentCursus]['grade'],
        available: userData['location'] ?? 'Unavailable',
        projects: filteredProjects,
        skills: filteredSkills,
      );

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(
                targetUser: user
            ),
          )
      );
    } else {
      if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login does not exist.'),
            duration: Duration(seconds: 4),
          ),
        );
      }

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
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

              Text(
                '23 Jan, 2021',
                style: TextStyle(color: Colors.grey),
              ),

              SizedBox(height: 20),

              // Search bar
              Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade600),
                ),
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (value) => _lookAtProfile(value),
                  decoration: const InputDecoration(
                    hintText: "Login",
                    border: InputBorder.none,
                  ),
                ),
              ),

              SizedBox(height: 15),

              const Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 5),

              // 🔥 IMPORTANT : la liste prend le reste de l'écran
              Expanded(
                child: ListView(
                  children: [
                    _profileCard('Project 1', 100, true),
                  ],
                ),
              ),
            ],
          ),
        ),
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