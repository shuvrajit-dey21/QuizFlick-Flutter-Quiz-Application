import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/services/leaderboard_service.dart';
import '/models/user_data.dart';

class DataController extends GetxController {
  RxString category = ''.obs;
  RxString userName = ''.obs;
  RxInt coins = 0.obs;
  RxInt totalScore = 0.obs;
  RxInt gamesPlayed = 0.obs;
  RxInt rank = 999.obs;
  RxDouble averageScore = 0.0.obs;
  RxString userAvatar = '🎮'.obs;

  // Daily Quiz Streak variables
  RxInt dailyQuizStreak = 0.obs;
  RxString lastDailyQuizDate = ''.obs;
  RxList<String> weeklyCompletions = <String>[].obs;
  RxBool isCurrentQuizDaily = false.obs;

  final categoryNameController = TextEditingController();
  final LeaderboardService _leaderboardService = LeaderboardService();
  String? _currentUserId;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    _initializeUserId();
  }

  Future<void> _initializeUserId() async {
    _currentUserId = await _leaderboardService.getCurrentUserId();
  }

  void initCategory(String data, {bool isDailyQuiz = false}) {
    category.value = data;
    isCurrentQuizDaily.value = isDailyQuiz;
  }

  void initUsername(String data) {
    userName.value = data;
    saveUserData();
    _updateLeaderboardData();
  }

  // Load user data from SharedPreferences
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userName.value = prefs.getString('username') ?? '';
    coins.value = prefs.getInt('coins') ?? 0;
    totalScore.value = prefs.getInt('totalScore') ?? 0;
    gamesPlayed.value = prefs.getInt('gamesPlayed') ?? 0;
    rank.value = prefs.getInt('rank') ?? 999;
    averageScore.value = prefs.getDouble('averageScore') ?? 0.0;
    userAvatar.value = prefs.getString('userAvatar') ?? '🎮';

    // Load daily quiz streak data
    dailyQuizStreak.value = prefs.getInt('dailyQuizStreak') ?? 0;
    lastDailyQuizDate.value = prefs.getString('lastDailyQuizDate') ?? '';
    weeklyCompletions.value = prefs.getStringList('weeklyCompletions') ?? [];
  }

  // Save user data to SharedPreferences
  Future<void> saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', userName.value);
    await prefs.setInt('coins', coins.value);
    await prefs.setInt('totalScore', totalScore.value);
    await prefs.setInt('gamesPlayed', gamesPlayed.value);
    await prefs.setInt('rank', rank.value);
    await prefs.setDouble('averageScore', averageScore.value);
    await prefs.setString('userAvatar', userAvatar.value);

    // Save daily quiz streak data
    await prefs.setInt('dailyQuizStreak', dailyQuizStreak.value);
    await prefs.setString('lastDailyQuizDate', lastDailyQuizDate.value);
    await prefs.setStringList('weeklyCompletions', weeklyCompletions);
  }

  // Update user stats after completing a quiz
  void updateQuizStats(int score, int totalQuestions, {bool isDailyQuiz = false}) {
    totalScore.value += score;
    gamesPlayed.value += 1;

    // Award coins based on performance
    int earnedCoins = _calculateCoins(score, totalQuestions);
    coins.value += earnedCoins;

    // Calculate average score
    averageScore.value = totalScore.value / gamesPlayed.value;

    // Update rank based on total score
    _updateRank();

    // If this is a daily quiz, update streak
    if (isDailyQuiz) {
      completeDailyQuiz();
    }

    // Save updated data
    saveUserData();

    // Update leaderboard data
    _updateLeaderboardData();
  }

  // Update leaderboard with current user data
  Future<void> _updateLeaderboardData() async {
    if (_currentUserId != null && userName.value.isNotEmpty) {
      final userData = UserData(
        id: _currentUserId!,
        name: userName.value,
        totalScore: totalScore.value,
        gamesPlayed: gamesPlayed.value,
        level: getUserLevel(),
        avatar: userAvatar.value,
        averageScore: averageScore.value,
        coins: coins.value,
        dailyStreak: dailyQuizStreak.value,
        lastPlayedDate: DateTime.now(),
        joinDate: DateTime.now().subtract(Duration(days: 30)), // Default join date
      );

      await _leaderboardService.updateUserData(userData);

      // Update rank based on leaderboard position
      final userRank = await _leaderboardService.getUserRank(_currentUserId!);
      rank.value = userRank;
      await saveUserData();
    }
  }

  // Update user avatar
  Future<void> updateUserAvatar(String avatar) async {
    userAvatar.value = avatar;
    await saveUserData();
    await _updateLeaderboardData();
  }

  // Calculate coins earned based on quiz performance
  int _calculateCoins(int score, int totalQuestions) {
    double percentage = (score / totalQuestions) * 100;
    if (percentage >= 90) return 50;
    if (percentage >= 80) return 30;
    if (percentage >= 70) return 20;
    if (percentage >= 60) return 10;
    if (percentage >= 50) return 5;
    return 1; // Participation coin
  }

  // Update rank based on total score
  void _updateRank() {
    if (totalScore.value >= 1000) {
      rank.value = 1;
    } else if (totalScore.value >= 800) {
      rank.value = (1000 - totalScore.value) ~/ 10 + 1;
    } else if (totalScore.value >= 500) {
      rank.value = (800 - totalScore.value) ~/ 5 + 20;
    } else if (totalScore.value >= 200) {
      rank.value = (500 - totalScore.value) ~/ 3 + 80;
    } else {
      rank.value = 999 - totalScore.value;
    }

    // Ensure rank is at least 1
    if (rank.value < 1) rank.value = 1;
  }

  // Get user level based on total score
  int getUserLevel() {
    return (totalScore.value / 100).floor() + 1;
  }

  // Get progress to next level
  double getLevelProgress() {
    int currentLevelScore = (getUserLevel() - 1) * 100;
    int progressScore = totalScore.value - currentLevelScore;
    return progressScore / 100.0;
  }

  // Daily Quiz Streak Management
  void completeDailyQuiz() {
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    // Check if already completed today
    if (lastDailyQuizDate.value == todayString) {
      return; // Already completed today
    }

    // Check if this continues the streak
    final yesterday = today.subtract(Duration(days: 1));
    final yesterdayString = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';

    if (lastDailyQuizDate.value == yesterdayString || lastDailyQuizDate.value.isEmpty) {
      // Continue or start streak
      dailyQuizStreak.value += 1;
    } else {
      // Streak broken, restart
      dailyQuizStreak.value = 1;
    }

    lastDailyQuizDate.value = todayString;

    // Update weekly completions (keep last 7 days)
    updateWeeklyCompletions(todayString);

    // Award bonus coins for streak
    int bonusCoins = _calculateStreakBonus();
    coins.value += bonusCoins;

    saveUserData();
  }

  void updateWeeklyCompletions(String dateString) {
    // Add today's completion
    if (!weeklyCompletions.contains(dateString)) {
      weeklyCompletions.add(dateString);
    }

    // Keep only last 7 days
    final today = DateTime.now();
    weeklyCompletions.removeWhere((date) {
      final completionDate = DateTime.parse(date);
      final difference = today.difference(completionDate).inDays;
      return difference >= 7;
    });

    weeklyCompletions.sort();
  }

  int _calculateStreakBonus() {
    if (dailyQuizStreak.value >= 7) return 100;
    if (dailyQuizStreak.value >= 5) return 50;
    if (dailyQuizStreak.value >= 3) return 25;
    return 10;
  }

  bool isDailyQuizCompletedToday() {
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return lastDailyQuizDate.value == todayString;
  }

  List<bool> getWeeklyStreakStatus() {
    final today = DateTime.now();
    List<bool> weekStatus = [];

    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      weekStatus.add(weeklyCompletions.contains(dateString));
    }

    return weekStatus;
  }

  // Reset user data (for testing or new user)
  Future<void> resetUserData() async {
    userName.value = '';
    coins.value = 0;
    totalScore.value = 0;
    gamesPlayed.value = 0;
    rank.value = 999;
    averageScore.value = 0.0;
    userAvatar.value = '🎮';
    dailyQuizStreak.value = 0;
    lastDailyQuizDate.value = '';
    weeklyCompletions.clear();
    await saveUserData();
  }

  // Future<void> showNamePopUp(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 TextField(
  //                   controller: categoryNameController,
  //                   keyboardType: TextInputType.text,
  //                   maxLines: 1,
  //                   decoration: const InputDecoration(
  //                       labelText: 'Enter your Name',
  //                       hintMaxLines: 1,
  //                       border: OutlineInputBorder(
  //                           borderSide:
  //                               BorderSide(color: Colors.green, width: 4.0))),
  //                 ),
  //                 const SizedBox(
  //                   height: 30.0,
  //                 ),
  //                 ElevatedButton(
  //                     onPressed: () {
  //                       userName.value = categoryNameController.text.trim();
  //                       Get.back();
  //                     },
  //                     child: const Text("Submit"))
  //               ],
  //             ),
  //             elevation: 12.0,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10.0)));
  //       });
  // }
}
