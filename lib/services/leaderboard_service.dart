import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_data.dart';

class LeaderboardService {
  static const String _leaderboardKey = 'leaderboard_data';
  static const String _currentUserIdKey = 'current_user_id';
  
  // Singleton pattern
  static final LeaderboardService _instance = LeaderboardService._internal();
  factory LeaderboardService() => _instance;
  LeaderboardService._internal();

  // Available avatars for users
  static const List<String> availableAvatars = [
    '🏆', '🧠', '👑', '🍪', '🎯', '🥷', '📚', '⚡', '🌟', '🎮',
    '🚀', '💎', '🔥', '⭐', '🎪', '🎨', '🎭', '🎪', '🎲', '🎸',
    '🎺', '🎻', '🎹', '🎤', '🎧', '🎬', '📱', '💻', '⌚', '📷'
  ];

  // Get current user ID
  Future<String> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(_currentUserIdKey);
    
    if (userId == null) {
      userId = _generateUserId();
      await prefs.setString(_currentUserIdKey, userId);
    }
    
    return userId;
  }

  // Generate unique user ID
  String _generateUserId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomNum = random.nextInt(9999);
    return 'user_${timestamp}_$randomNum';
  }

  // Get random avatar
  String getRandomAvatar() {
    final random = Random();
    return availableAvatars[random.nextInt(availableAvatars.length)];
  }

  // Save leaderboard data
  Future<void> _saveLeaderboardData(List<UserData> users) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = users.map((user) => user.toJson()).toList();
    await prefs.setString(_leaderboardKey, jsonEncode(jsonList));
  }

  // Load leaderboard data
  Future<List<UserData>> _loadLeaderboardData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_leaderboardKey);
    
    if (jsonString == null) {
      return [];
    }
    
    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => UserData.fromJson(json)).toList();
    } catch (e) {
      print('Error loading leaderboard data: $e');
      return [];
    }
  }

  // Add or update user in leaderboard
  Future<void> updateUserData(UserData userData) async {
    List<UserData> users = await _loadLeaderboardData();
    
    // Find existing user or add new one
    int existingIndex = users.indexWhere((user) => user.id == userData.id);
    
    if (existingIndex != -1) {
      users[existingIndex] = userData;
    } else {
      users.add(userData);
    }
    
    await _saveLeaderboardData(users);
  }

  // Get sorted leaderboard (top users first)
  Future<List<UserData>> getLeaderboard({int limit = 50}) async {
    List<UserData> users = await _loadLeaderboardData();
    
    // Sort by total score (descending), then by games played (ascending for tie-breaking)
    users.sort((a, b) {
      int scoreComparison = b.totalScore.compareTo(a.totalScore);
      if (scoreComparison != 0) return scoreComparison;
      return a.gamesPlayed.compareTo(b.gamesPlayed);
    });
    
    return users.take(limit).toList();
  }

  // Get user's rank in leaderboard
  Future<int> getUserRank(String userId) async {
    List<UserData> users = await getLeaderboard();
    
    for (int i = 0; i < users.length; i++) {
      if (users[i].id == userId) {
        return i + 1;
      }
    }
    
    return users.length + 1; // User not found, return last position
  }

  // Get user data by ID
  Future<UserData?> getUserData(String userId) async {
    List<UserData> users = await _loadLeaderboardData();
    
    try {
      return users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  // Initialize leaderboard with sample data if empty
  Future<void> initializeLeaderboard() async {
    List<UserData> users = await _loadLeaderboardData();
    
    if (users.isEmpty) {
      // Add some sample users for demonstration
      final sampleUsers = [
        UserData(
          id: 'sample_1',
          name: 'Quiz Master',
          totalScore: 2500,
          gamesPlayed: 25,
          level: 25,
          avatar: '🏆',
          averageScore: 100.0,
          coins: 1250,
          dailyStreak: 15,
          lastPlayedDate: DateTime.now().subtract(Duration(hours: 2)),
          joinDate: DateTime.now().subtract(Duration(days: 30)),
        ),
        UserData(
          id: 'sample_2',
          name: 'Brain Genius',
          totalScore: 2200,
          gamesPlayed: 22,
          level: 22,
          avatar: '🧠',
          averageScore: 95.5,
          coins: 1100,
          dailyStreak: 12,
          lastPlayedDate: DateTime.now().subtract(Duration(hours: 5)),
          joinDate: DateTime.now().subtract(Duration(days: 25)),
        ),
        UserData(
          id: 'sample_3',
          name: 'Knowledge King',
          totalScore: 2000,
          gamesPlayed: 20,
          level: 20,
          avatar: '👑',
          averageScore: 90.0,
          coins: 1000,
          dailyStreak: 10,
          lastPlayedDate: DateTime.now().subtract(Duration(hours: 8)),
          joinDate: DateTime.now().subtract(Duration(days: 20)),
        ),
      ];
      
      for (UserData user in sampleUsers) {
        await updateUserData(user);
      }
    }
  }

  // Clear all leaderboard data (for testing)
  Future<void> clearLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_leaderboardKey);
  }

  // Get leaderboard statistics
  Future<Map<String, dynamic>> getLeaderboardStats() async {
    List<UserData> users = await _loadLeaderboardData();
    
    if (users.isEmpty) {
      return {
        'totalUsers': 0,
        'averageScore': 0.0,
        'highestScore': 0,
        'totalGamesPlayed': 0,
      };
    }
    
    int totalScore = users.fold(0, (sum, user) => sum + user.totalScore);
    int totalGames = users.fold(0, (sum, user) => sum + user.gamesPlayed);
    int highestScore = users.map((user) => user.totalScore).reduce((a, b) => a > b ? a : b);
    
    return {
      'totalUsers': users.length,
      'averageScore': totalScore / users.length,
      'highestScore': highestScore,
      'totalGamesPlayed': totalGames,
    };
  }
}
