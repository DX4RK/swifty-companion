import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:swifty_companion/models/user.dart';
import 'package:swifty_companion/manager/key_manager.dart';

import 'package:swifty_companion/pages/profile_page.dart';
import 'package:swifty_companion/pages/loading_page.dart';

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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingPage(),
      )
    );

    final response = await http.get(
      Uri.parse('https://api.intra.42.fr/v2/users/$username'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);

      int currentCursus = 0;
      int currentCursusId = 0;
      double level = 0.0;
      DateTime latestMarked = DateTime.parse("1970-01-01T00:00:00Z");

      for (var project in userData['projects_users']) {
        if (project['marked_at'] != null) {
          DateTime markedAt = DateTime.parse(project['marked_at']);

          if (markedAt.isAfter(latestMarked)) {
            latestMarked = markedAt;

            if (project['cursus_ids'] != null && project['cursus_ids'].length > 0) {
              currentCursusId = project['cursus_ids'][0];

              currentCursus = userData['cursus_users']
                  .indexWhere((c) => c['cursus_id'] == currentCursusId);

              if (currentCursus != -1) {
                var cursus = userData['cursus_users'][currentCursus];
                level = (cursus['level'] as num).toDouble();
              }
            }
          }
        }
      }

      // for (var cursus in userData['cursus_users']) {
      //   if (cursus['end_at'] == null) {
      //     currentCursusId = cursus['cursus_id'];
      //     level = (cursus['level'] as num).toDouble();
      //     break;
      //   }
      //   currentCursus += 1;
      // }

      double decimalPart = level - level.toInt();
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

      if (currentCursus != -1 && userData['cursus_users'].isNotEmpty) {
        var skills = userData['cursus_users'][currentCursus]['skills'];

        if (skills != null) {
          for (var item in skills) {
            Skill skill = Skill(
              name: item["name"] ?? "Unknown",
              score: item["level"] ?? 0,
            );

            filteredSkills.add(skill);
          }
        }
      }

      var cursusData = currentCursus != -1 && currentCursus < userData['cursus_users'].length
          ? userData['cursus_users'][currentCursus]
          : null;

      User user = User(
        name: userData['usual_full_name'] ?? 'Unknown',
        email: userData['email'] ?? 'unknown',
        avatarUrl: userData['image']?['link'] ?? '',
        level: cursusData != null ? (cursusData['level'] as num).toInt() : 0,
        levelPercentage: decimalPart,
        wallet: userData['wallet'] ?? 0,
        evalPoints: userData['correction_point'] ?? 0,
        grade: cursusData?['grade'] ?? 'Unknown',
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        )
      );
      print('Error: ${response.statusCode}');
    }
  }

  List<dynamic> _users = [];
  bool _isLoading = false;

  void _performSearch(String query) async {
    print('Searching for: $query');

    if (query.isEmpty) {
      setState(() {
        _users.clear();
      });
      return;
    }

    try {
      if (!await hasNetwork()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No internet connection')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      TokenManager tokenManager = TokenManager();
      String token = await tokenManager.getValidToken();

      final prefix = query;
      final max = '${prefix}zzzz';

      final uri = Uri.https(
        'api.intra.42.fr',
        '/v2/users',
        {
          'range[login]': '$prefix,$max',
          'per_page': '8',
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        //print(userData[0]['login']);
        setState(() {
          _users = userData;
        });
      } else {
        setState(() {
          _users.clear();
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                'Suggested Profiles',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 5),

              Expanded(
                child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return _profileCard(
                        user['login'] ?? 'Unknown',
                        user['image']['link'] ?? '',
                        _lookAtProfile
                      );
                    },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

Widget _profileCard(String name, String imageLink, Future<void> Function(String) callback) {
  return InkWell(
    onTap: () => callback(name),
    child: Container(
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
              backgroundImage: NetworkImage(imageLink),
              radius: 50,
            ),
          ),
          SizedBox(width: 10),
          Text(
            name,
            style: TextStyle(
                fontSize: 15
            ),
          )
        ],
      ),
    ),
  );
}
