class User {
  final String name;
  final String email;
  final String avatarUrl;
  final int level;
  final double levelPercentage;
  final int wallet;
  final int evalPoints;
  final int rank;
  final double score;
  final List<Project> projects;
  final List<Skill> skills;

  User({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.level,
    required this.levelPercentage,
    required this.wallet,
    required this.evalPoints,
    required this.rank,
    required this.score,
    required this.projects,
    required this.skills,
  });
}

class Project {
  final String name;
  final int score;
  final bool isSuccess;

  Project({
    required this.name,
    required this.score,
    required this.isSuccess,
  });
}

class Skill {
  final String name;
  final int score;

  Skill({
    required this.name,
    required this.score,
  });
}