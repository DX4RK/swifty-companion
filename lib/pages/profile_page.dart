import 'package:flutter/material.dart';
import 'package:swifty_companion/models/user.dart';
import 'package:swifty_companion/pages/home_page.dart';

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

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final avatarTop = MediaQuery.of(context).padding.top + screenHeight * 0.1;
    final avatarRadius = screenWidth * 0.13;

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
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 80),

              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.09),
                          Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.08),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: TextStyle(fontSize: screenHeight * 0.022, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  user.email,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'Level ${user.level}',
                                          style: TextStyle(fontWeight: FontWeight.bold)
                                      ),
                                      Text('${(user.levelPercentage * 100).round()}%'),
                                    ],
                                  ),
                                  LinearProgressIndicator(
                                    value: user.levelPercentage,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                    minHeight: 10,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ],
                              )
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                            child: GridView.count(
                              padding: EdgeInsets.only(top: screenWidth * 0.04),
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 7,
                              crossAxisSpacing: 7,
                              childAspectRatio: 1.3,
                              children: [
                                _buildCard('💰', '₳${user.wallet}', 'Wallet', Colors.green.shade50, screenHeight, screenWidth),
                                _buildCard('📝', user.evalPoints.toString(), 'Ev. Point', Colors.blue.shade50, screenHeight, screenWidth),
                                _buildCard('📜', user.grade, 'Grade', Colors.yellow.shade50, screenHeight, screenWidth),
                                _buildCard('🎯', user.available, 'Location', Colors.red.shade50, screenHeight, screenWidth),
                              ],
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.035),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Projects',
                                  style: TextStyle(fontSize: screenHeight * 0.024, fontWeight: FontWeight.bold),
                                ),

                                SizedBox(height: screenHeight * 0.01),

                                Container(
                                    height: screenHeight * 0.4,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ListView.builder(
                                      padding: EdgeInsets.all(screenWidth * 0.04),
                                      itemCount: user.projects.length,
                                      itemBuilder: (context, index) {
                                        final project = user.projects[index];

                                        return _projectCard(
                                            project.name,
                                            project.score,
                                            project.isFinished,
                                            project.isValidated,
                                            screenHeight,
                                            screenWidth,
                                        );
                                      },
                                    )
                                ),
                                SizedBox(height: screenHeight * 0.04),
                              ],
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Skills',
                                  style: TextStyle(fontSize: screenHeight * 0.024, fontWeight: FontWeight.bold),
                                ),

                                SizedBox(height: screenHeight * 0.01),

                                Container(
                                    height: screenHeight * 0.4,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ListView.builder(
                                      padding: EdgeInsets.all(screenWidth * 0.04),
                                      itemCount: user.skills.length,
                                      itemBuilder: (context, index) {
                                        final skill = user.skills[index];

                                        return _skillsCard(
                                          skill.name,
                                          skill.score,
                                          screenHeight,
                                          screenWidth,
                                        );
                                      },
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

          Stack(
            children: [
              Positioned(
                top: avatarTop + avatarRadius * 0.97,
                left: 0,
                right: 0,
                child: Container(
                  height: screenHeight * 0.095,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.grey[200]!,
                        Colors.grey[200]!,
                        Colors.grey[200]!,
                        Colors.grey[200]!.withOpacity(0.0),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: avatarTop,
                left: screenWidth * 0.08,
                child: CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: screenWidth * 0.125,
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

Widget _skillsCard(String name, num score, final screenHeight, final screenWidth) {
  return Container(
    margin: EdgeInsets.only(bottom: screenWidth * 0.025),
    padding: EdgeInsets.all(screenWidth * 0.04),
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                name,
                softWrap: true,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(width: screenWidth * 0.01),
                Text(
                  "${score.toStringAsFixed(2)} (${((score / 20) * 100).toInt()}%)",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: screenHeight * 0.01),

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

Widget _projectCard(String name, num score, bool isFinished, bool isValidated, final screenHeight, final screenWidth) {
  return Container(
    margin: EdgeInsets.only(bottom: screenWidth * 0.025),
    padding: EdgeInsets.all(screenWidth * 0.03),
    decoration: BoxDecoration(
      color: isValidated
          ? (score > 100 ? Colors.amber.shade100 : Colors.green.shade50)
          : (!isFinished ? Colors.orange : Colors.red.shade50),
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
              isValidated
                  ? (score > 100 ? Icons.star_border_outlined : Icons.check)
                  : (!isFinished ? Icons.construction_sharp : Icons.close),
              color: Colors.black,
            ),
            SizedBox(width: screenWidth * 0.01),
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
Widget _buildCard(String emoji, String value, String label, Color bgColor, final screenHeight, final screenWidth) {
  return Container(
    padding: EdgeInsets.all(screenWidth * 0.04),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.0168),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(emoji, style: TextStyle(fontSize: screenHeight * 0.03)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: screenHeight * 0.023,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: screenHeight * 0.013,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}