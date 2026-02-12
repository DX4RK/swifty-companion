import 'package:flutter/material.dart';
import 'package:swifty_companion/models/user.dart';

User defaultUser = User(
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

class ProfilePage extends StatefulWidget {
  final User targetUser;

  const ProfilePage({
    super.key,
    required this.targetUser,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    User user = widget.targetUser;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 149, 137),
      body: Stack(
        children: [
          Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 80),

              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 70),
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.email,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 25),

                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Level 5', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text('42%'),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    value: 0.42,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                    minHeight: 10,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ],
                              )
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: GridView.count(
                              padding: const EdgeInsets.only(top: 10),
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 7,
                              crossAxisSpacing: 7,
                              childAspectRatio: 1.3,
                              children: [
                                _buildCard('💰', '₳372', 'Wallet', Colors.green.shade50),
                                _buildCard('📝', '40', 'Ev. Point', Colors.blue.shade50),
                                _buildCard('📜', '26', 'Rank', Colors.yellow.shade50),
                                _buildCard('🎯', '2.2k', 'Score', Colors.red.shade50),
                              ],
                            ),
                          ),

                          SizedBox(height: 25),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Projects',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),

                                SizedBox(height: 10),

                                Container(
                                  height: 320,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ListView(
                                      padding: const EdgeInsets.all(15),
                                      children: [
                                        _projectCard('Project 1', 100, true),
                                        _projectCard('Project 2', 50, false),
                                        _projectCard('Project 3', 125, true),
                                        _projectCard('Project 4', 80, true),
                                        _projectCard('Project 5', 45, false),

                                      ],
                                    )
                                ),
                                SizedBox(height: 30),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Skills',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),

                                SizedBox(height: 10),

                                Container(
                                  height: 320,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ListView(
                                      padding: const EdgeInsets.all(15),
                                      children: [
                                        _skillsCard('Skill 1', 5),
                                        _skillsCard('Skill 2', 10),
                                        _skillsCard('Skill 3', 5),
                                        _skillsCard('Skill 4', 7),
                                        _skillsCard('Skill 5', 15),
                                      ],
                                    )
                                ),
                                SizedBox(height: 30),
                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Avatar floating - FIXE
          Positioned(
            top: MediaQuery.of(context).padding.top + 44 + 80 - 45,
            left: 30,
            child: CircleAvatar(
              radius: 52,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  user.avatarUrl,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _skillsCard(String name, num score) {
  return Container(
    margin: EdgeInsets.only(bottom: 5),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),
            ),
            Row(
              children: [
                SizedBox(width: 5),
                Text(
                  "${score.toString()} (${((score / 20) * 100).toInt()}%)",
                  style: TextStyle(
                      fontWeight: FontWeight.w500
                  ),
                ),
              ],
            )
          ],
        ),

        SizedBox(height: 5),

        LinearProgressIndicator(
          value: 0.42,
          backgroundColor: Colors.blue.shade100,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade400),
          minHeight: 5,
          borderRadius: BorderRadius.circular(100),
        ),
      ],
    ),
  );
}

Widget _projectCard(String name, num score, bool isSuccess) {
  return Container(
    margin: EdgeInsets.only(bottom: 10),
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: isSuccess && score > 100
          ? Colors.amber.shade100
          : isSuccess
          ? Colors.green.shade50
          : Colors.red.shade50,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(
              fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Icon(
              isSuccess ? Icons.check : Icons.close,
              color: Colors.black,
            ),
            SizedBox(width: 5),
            Text(
              score.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.w500
              ),
            ),
          ],
        )
      ],
    ),
  );
}

Widget _buildCard(String emoji, String value, String label, Color bgColor) {
  return Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 20)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}