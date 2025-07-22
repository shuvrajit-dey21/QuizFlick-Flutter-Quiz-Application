class UserData {
  final String id;
  final String name;
  final int totalScore;
  final int gamesPlayed;
  final int level;
  final String avatar;
  final double averageScore;
  final int coins;
  final int dailyStreak;
  final DateTime lastPlayedDate;
  final DateTime joinDate;

  UserData({
    required this.id,
    required this.name,
    required this.totalScore,
    required this.gamesPlayed,
    required this.level,
    required this.avatar,
    required this.averageScore,
    required this.coins,
    required this.dailyStreak,
    required this.lastPlayedDate,
    required this.joinDate,
  });

  // Convert UserData to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'totalScore': totalScore,
      'gamesPlayed': gamesPlayed,
      'level': level,
      'avatar': avatar,
      'averageScore': averageScore,
      'coins': coins,
      'dailyStreak': dailyStreak,
      'lastPlayedDate': lastPlayedDate.toIso8601String(),
      'joinDate': joinDate.toIso8601String(),
    };
  }

  // Create UserData from JSON
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      totalScore: json['totalScore'] ?? 0,
      gamesPlayed: json['gamesPlayed'] ?? 0,
      level: json['level'] ?? 1,
      avatar: json['avatar'] ?? '🎮',
      averageScore: (json['averageScore'] ?? 0.0).toDouble(),
      coins: json['coins'] ?? 0,
      dailyStreak: json['dailyStreak'] ?? 0,
      lastPlayedDate: json['lastPlayedDate'] != null 
          ? DateTime.parse(json['lastPlayedDate'])
          : DateTime.now(),
      joinDate: json['joinDate'] != null 
          ? DateTime.parse(json['joinDate'])
          : DateTime.now(),
    );
  }

  // Create a copy with updated values
  UserData copyWith({
    String? id,
    String? name,
    int? totalScore,
    int? gamesPlayed,
    int? level,
    String? avatar,
    double? averageScore,
    int? coins,
    int? dailyStreak,
    DateTime? lastPlayedDate,
    DateTime? joinDate,
  }) {
    return UserData(
      id: id ?? this.id,
      name: name ?? this.name,
      totalScore: totalScore ?? this.totalScore,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      level: level ?? this.level,
      avatar: avatar ?? this.avatar,
      averageScore: averageScore ?? this.averageScore,
      coins: coins ?? this.coins,
      dailyStreak: dailyStreak ?? this.dailyStreak,
      lastPlayedDate: lastPlayedDate ?? this.lastPlayedDate,
      joinDate: joinDate ?? this.joinDate,
    );
  }

  // Calculate rank based on total score
  int getRank() {
    if (totalScore >= 2500) return 1;
    if (totalScore >= 2000) return 2;
    if (totalScore >= 1500) return 3;
    if (totalScore >= 1000) return (2500 - totalScore) ~/ 50 + 4;
    if (totalScore >= 500) return (1000 - totalScore) ~/ 25 + 34;
    return (500 - totalScore) ~/ 10 + 84;
  }

  // Get user level based on total score
  int getUserLevel() {
    return (totalScore / 100).floor() + 1;
  }

  // Get performance rating
  String getPerformanceRating() {
    if (averageScore >= 90) return 'Legendary';
    if (averageScore >= 80) return 'Expert';
    if (averageScore >= 70) return 'Advanced';
    if (averageScore >= 60) return 'Intermediate';
    if (averageScore >= 50) return 'Beginner';
    return 'Novice';
  }

  // Get achievement badges based on stats
  List<String> getAchievementBadges() {
    List<String> badges = [];
    
    if (totalScore >= 2500) badges.add('🏆');
    if (gamesPlayed >= 100) badges.add('🎯');
    if (dailyStreak >= 7) badges.add('🔥');
    if (averageScore >= 90) badges.add('⭐');
    if (coins >= 1000) badges.add('💰');
    
    return badges;
  }

  @override
  String toString() {
    return 'UserData(id: $id, name: $name, totalScore: $totalScore, level: $level)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserData && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
