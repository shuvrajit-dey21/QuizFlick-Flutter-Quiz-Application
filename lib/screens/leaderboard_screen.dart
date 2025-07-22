import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '/controllers/data_controller.dart';
import '/services/leaderboard_service.dart';
import '/models/user_data.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final LeaderboardService _leaderboardService = LeaderboardService();
  List<UserData> _leaderboardData = [];
  bool _isLoading = true;
  UserData? _currentUser;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _loadLeaderboardData();
    _animationController.forward();
  }

  Future<void> _loadLeaderboardData() async {
    try {
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
          avatar: _leaderboardService.getRandomAvatar(),
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DataController dataController = Get.find<DataController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  colors: [
                    Color(0xFF1A1A2E),
                    Color(0xFF16213E),
                    Color(0xFF0F3460),
                    Color(0xFF533483),
                  ],
                  stops: [0.0, 0.3, 0.7, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [
                    Color(0xFF4A90E2),
                    Color(0xFF7B68EE),
                    Color(0xFF9B59B6),
                    Color(0xFFE74C3C),
                  ],
                  stops: [0.0, 0.3, 0.7, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Modern Header with App Bar
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: isDark ? Colors.white : Colors.white,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Leaderboard',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.refresh_rounded,
                              color: isDark ? Colors.white : Colors.white,
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              _loadLeaderboardData();
                            },
                            tooltip: 'Refresh Leaderboard',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.person_outline_rounded,
                              color: isDark ? Colors.white : Colors.white,
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              _showProfileDialog();
                            },
                            tooltip: 'Edit Profile',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Enhanced Current User Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              Colors.white.withValues(alpha: 0.15),
                              Colors.white.withValues(alpha: 0.05),
                            ]
                          : [
                              Colors.white.withValues(alpha: 0.3),
                              Colors.white.withValues(alpha: 0.1),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // User Avatar
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.amber.shade400,
                                  Colors.orange.shade600,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.amber.withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() => Text(
                                  dataController.userName.value.isNotEmpty
                                    ? dataController.userName.value
                                    : 'Guest User',
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                                const SizedBox(height: 4),
                                Obx(() => Text(
                                  'Rank #${dataController.rank.value}',
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.8)
                                        : Colors.white.withValues(alpha: 0.9),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                              ],
                            ),
                          ),
                          Obx(() => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Level ${dataController.getUserLevel()}',
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Stats Row
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Obx(() => Text(
                                    '${dataController.totalScore.value}',
                                    style: TextStyle(
                                      color: isDark ? Colors.white : Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                  Text(
                                    'Points',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.7)
                                          : Colors.white.withValues(alpha: 0.8),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Obx(() => Text(
                                    '${dataController.gamesPlayed.value}',
                                    style: TextStyle(
                                      color: isDark ? Colors.white : Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                  Text(
                                    'Games',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.7)
                                          : Colors.white.withValues(alpha: 0.8),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Obx(() => Text(
                                    '${(dataController.totalScore.value / (dataController.gamesPlayed.value > 0 ? dataController.gamesPlayed.value : 1) * 10).toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      color: isDark ? Colors.white : Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                  Text(
                                    'Average',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.7)
                                          : Colors.white.withValues(alpha: 0.8),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
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
                ),

                const SizedBox(height: 20),

                // Leaderboard Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.emoji_events_rounded,
                        color: isDark ? Colors.amber : Colors.amber,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Top Players',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Leaderboard List
                Expanded(
                  child: _isLoading
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isDark ? Colors.white : Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Loading leaderboard...',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.7)
                                      : Colors.white.withValues(alpha: 0.9),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : _leaderboardData.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.leaderboard_outlined,
                                    size: 64,
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.5)
                                        : Colors.white.withValues(alpha: 0.6),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No leaderboard data available',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.7)
                                          : Colors.white.withValues(alpha: 0.9),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Play some games to see rankings!',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.5)
                                          : Colors.white.withValues(alpha: 0.7),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadLeaderboardData,
                              color: Colors.amber,
                              backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                              child: ListView.builder(
                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                itemCount: _leaderboardData.length,
                                itemBuilder: (context, index) {
                                  final player = _leaderboardData[index];
                                  final isCurrentUser = _currentUser != null && player.id == _currentUser!.id;

                                  return AnimatedContainer(
                                    duration: Duration(milliseconds: 300 + (index * 50)),
                                    margin: const EdgeInsets.only(bottom: 12),
                                    child: _buildModernLeaderboardItem(
                                      rank: index + 1,
                                      name: player.name,
                                      score: player.totalScore,
                                      level: player.level,
                                      avatar: player.avatar,
                                      isCurrentUser: isCurrentUser,
                                      userData: player,
                                      isDark: isDark,
                                    ),
                                  );
                                },
                              ),
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildLeaderboardItem({
    required int rank,
    required String name,
    required int score,
    required int level,
    required String avatar,
    bool isCurrentUser = false,
    UserData? userData,
  }) {
    Color getRankColor() {
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

    IconData getRankIcon() {
      switch (rank) {
        case 1:
          return Icons.emoji_events;
        case 2:
          return Icons.military_tech;
        case 3:
          return Icons.workspace_premium;
        default:
          return Icons.person;
      }
    }

    return Card(
      elevation: rank <= 3 ? 12 : (isCurrentUser ? 8 : 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: isCurrentUser
            ? BorderSide(color: Colors.amber, width: 2)
            : BorderSide.none,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: rank <= 3
              ? LinearGradient(
                  colors: [
                    getRankColor().withValues(alpha: 0.15),
                    getRankColor().withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : isCurrentUser
                  ? LinearGradient(
                      colors: [
                        Colors.amber.withValues(alpha: 0.1),
                        Colors.orange.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [
                        Colors.grey.withValues(alpha: 0.05),
                        Colors.grey.withValues(alpha: 0.02),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: getRankColor(),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: getRankColor().withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (rank <= 3)
                  Icon(
                    getRankIcon(),
                    color: Colors.white,
                    size: 24,
                  )
                else
                  Text(
                    rank.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
              ],
            ),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  avatar,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: isCurrentUser
                                  ? Colors.amber.shade700
                                  : rank <= 3
                                      ? getRankColor()
                                      : Theme.of(context).colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isCurrentUser)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(12),
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
                    ),
                    if (userData != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          ...userData!.getAchievementBadges().take(3).map(
                            (badge) => Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Text(badge, style: const TextStyle(fontSize: 14)),
                            ),
                          ),
                          if (userData!.getAchievementBadges().length > 3)
                            Text(
                              '+${userData!.getAchievementBadges().length - 3}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  size: 16,
                  color: Colors.amber,
                ),
                const SizedBox(width: 4),
                Text(
                  'Level $level',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (userData != null) ...[
                  const SizedBox(width: 12),
                  Icon(
                    Icons.games,
                    size: 16,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${userData!.gamesPlayed} games',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: rank <= 3
                      ? getRankColor().withValues(alpha: 0.1)
                      : isCurrentUser
                          ? Colors.amber.withValues(alpha: 0.1)
                          : Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$score',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: rank <= 3
                        ? getRankColor()
                        : isCurrentUser
                            ? Colors.amber.shade700
                            : Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'points',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              if (userData != null && userData!.averageScore > 0) ...[
                const SizedBox(height: 2),
                Text(
                  'Avg: ${userData!.averageScore.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernLeaderboardItem({
    required int rank,
    required String name,
    required int score,
    required int level,
    required String avatar,
    bool isCurrentUser = false,
    UserData? userData,
    required bool isDark,
  }) {
    Color getRankColor() {
      switch (rank) {
        case 1:
          return Colors.amber;
        case 2:
          return Colors.grey.shade300;
        case 3:
          return Colors.orange.shade400;
        default:
          return Colors.blue.shade400;
      }
    }

    IconData getRankIcon() {
      switch (rank) {
        case 1:
          return Icons.emoji_events_rounded;
        case 2:
          return Icons.military_tech_rounded;
        case 3:
          return Icons.workspace_premium_rounded;
        default:
          return Icons.person_rounded;
      }
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCurrentUser
              ? [
                  Colors.amber.withValues(alpha: 0.15),
                  Colors.amber.withValues(alpha: 0.05),
                ]
              : rank <= 3
                  ? [
                      getRankColor().withValues(alpha: 0.1),
                      getRankColor().withValues(alpha: 0.02),
                    ]
                  : isDark
                      ? [
                          Colors.white.withValues(alpha: 0.08),
                          Colors.white.withValues(alpha: 0.02),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.2),
                          Colors.white.withValues(alpha: 0.05),
                        ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCurrentUser
              ? Colors.amber.withValues(alpha: 0.4)
              : rank <= 3
                  ? getRankColor().withValues(alpha: 0.3)
                  : isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.2),
          width: isCurrentUser ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isCurrentUser
                ? Colors.amber.withValues(alpha: 0.2)
                : rank <= 3
                    ? getRankColor().withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.05),
            blurRadius: isCurrentUser ? 12 : rank <= 3 ? 8 : 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Rank Badge
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: rank <= 3
                      ? [getRankColor(), getRankColor().withValues(alpha: 0.7)]
                      : [Colors.blue.shade400, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (rank <= 3 ? getRankColor() : Colors.blue).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: rank <= 3
                  ? Icon(
                      getRankIcon(),
                      color: Colors.white,
                      size: 24,
                    )
                  : Center(
                      child: Text(
                        rank.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
            ),

            const SizedBox(width: 16),

            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: isCurrentUser
                                ? Colors.amber.shade700
                                : rank <= 3
                                    ? getRankColor()
                                    : isDark
                                        ? Colors.white
                                        : Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isCurrentUser) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(12),
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
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Level $level',
                        style: TextStyle(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.7)
                              : Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (userData != null) ...[
                        const SizedBox(width: 12),
                        Icon(
                          Icons.games_rounded,
                          size: 16,
                          color: Colors.blue.shade400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${userData.gamesPlayed} games',
                          style: TextStyle(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.7)
                                : Colors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Score
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: rank <= 3
                        ? getRankColor().withValues(alpha: 0.2)
                        : isCurrentUser
                            ? Colors.amber.withValues(alpha: 0.2)
                            : isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    score.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: rank <= 3
                          ? getRankColor()
                          : isCurrentUser
                              ? Colors.amber.shade700
                              : isDark
                                  ? Colors.white
                                  : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'points',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.6)
                        : Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        const Color(0xFF1A1A2E),
                        const Color(0xFF16213E),
                      ]
                    : [
                        Colors.white,
                        Colors.grey.shade50,
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.grey.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      color: isDark ? Colors.white : Colors.grey[800],
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Choose Avatar',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Select your profile avatar:',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.8)
                        : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: LeaderboardService.availableAvatars.map((avatar) {
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).pop();
                        _updateUserAvatar(avatar);
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade400,
                              Colors.blue.shade600,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.3)
                                : Colors.blue.withValues(alpha: 0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            avatar,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        backgroundColor: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.grey[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _updateUserAvatar(String avatar) async {
    final DataController dataController = Get.find<DataController>();
    await dataController.updateUserAvatar(avatar);
    await _loadLeaderboardData();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                avatar,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Avatar updated successfully!',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
