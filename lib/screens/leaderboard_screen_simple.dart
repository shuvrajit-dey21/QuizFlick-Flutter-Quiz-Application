import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controllers/data_controller.dart';
import '/services/leaderboard_service.dart';
import '/models/user_data.dart';

class LeaderboardScreenSimple extends StatefulWidget {
  const LeaderboardScreenSimple({super.key});

  @override
  State<LeaderboardScreenSimple> createState() => _LeaderboardScreenSimpleState();
}

class _LeaderboardScreenSimpleState extends State<LeaderboardScreenSimple> {
  final LeaderboardService _leaderboardService = LeaderboardService();
  List<UserData> _leaderboardData = [];
  bool _isLoading = true;
  UserData? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadLeaderboardData();
  }

  Future<void> _loadLeaderboardData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Initialize leaderboard with sample data if empty
      await _leaderboardService.initializeLeaderboard();
      
      // Load leaderboard data
      final leaderboardData = await _leaderboardService.getLeaderboard();
      
      // Get current user data
      final dataController = Get.find<DataController>();
      final currentUserId = await _leaderboardService.getCurrentUserId();
      
      // Update current user data in leaderboard
      if (dataController.userName.value.isNotEmpty) {
        final currentUserData = UserData(
          id: currentUserId,
          name: dataController.userName.value,
          totalScore: dataController.totalScore.value,
          gamesPlayed: dataController.gamesPlayed.value,
          level: dataController.getUserLevel(),
          avatar: dataController.userAvatar.value,
          averageScore: dataController.averageScore.value,
          coins: dataController.coins.value,
          dailyStreak: dataController.dailyQuizStreak.value,
          lastPlayedDate: DateTime.now(),
          joinDate: DateTime.now().subtract(Duration(days: 30)),
        );
        
        await _leaderboardService.updateUserData(currentUserData);
        _currentUser = currentUserData;
        
        // Reload leaderboard after updating current user
        final updatedLeaderboard = await _leaderboardService.getLeaderboard();
        setState(() {
          _leaderboardData = updatedLeaderboard;
          _isLoading = false;
        });
      } else {
        setState(() {
          _leaderboardData = leaderboardData;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading leaderboard data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DataController dataController = Get.find<DataController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLeaderboardData,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Current User Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                        dataController.userName.value.isNotEmpty
                            ? dataController.userName.value
                            : 'Guest User',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      const SizedBox(height: 4),
                      Obx(() => Text(
                        'Rank #${dataController.rank.value} • ${dataController.totalScore.value} pts',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      )),
                    ],
                  ),
                ],
              ),
            ),

            // Leaderboard List
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else if (_leaderboardData.isEmpty)
              const Center(
                child: Text(
                  'No leaderboard data available',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _leaderboardData.length,
                  itemBuilder: (context, index) {
                    final player = _leaderboardData[index];
                    final isCurrentUser = _currentUser != null && player.id == _currentUser!.id;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        elevation: isCurrentUser ? 8 : 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: isCurrentUser 
                              ? BorderSide(color: Colors.amber, width: 2)
                              : BorderSide.none,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: _getRankColor(index + 1),
                            child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                player.avatar,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                player.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isCurrentUser ? Colors.amber.shade700 : null,
                                ),
                              ),
                              if (isCurrentUser) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'YOU',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          subtitle: Text('Level ${player.level} • ${player.gamesPlayed} games'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${player.totalScore}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isCurrentUser ? Colors.amber.shade700 : Colors.blue,
                                ),
                              ),
                              const Text(
                                'points',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey.shade400;
      case 3:
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }
}
