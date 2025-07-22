import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controllers/theme_provider.dart';
import '/controllers/data_controller.dart';
import 'daily_quiz_screen.dart';
import 'leaderboard_screen.dart';
import 'how_to_use_screen.dart';
import 'about_us_screen.dart';
import 'contact_us_screen.dart';
import 'terms_conditions_screen.dart';
import 'category_screen_2.dart';

class SideNav extends StatefulWidget {
  const SideNav({super.key});

  @override
  State<SideNav> createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final DataController dataController = Get.find<DataController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SlideTransition(
      position: _slideAnimation,
      child: Drawer(
        width: screenWidth > 600 ? 320 : screenWidth * 0.85,
        child: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1A1A2E),
                      const Color(0xFF16213E),
                      const Color(0xFF0F3460),
                      const Color(0xFF533483),
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF667eea),
                      const Color(0xFF764ba2),
                      const Color(0xFF6366f1),
                      const Color(0xFF8b5cf6),
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // User Profile Header
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildUserProfileHeader(dataController, screenWidth),
                ),

                // Stats Section
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildStatsSection(dataController, screenWidth),
                ),

                const SizedBox(height: 20),

                // Navigation Menu
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildNavigationMenu(context, themeController, screenWidth),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileHeader(DataController dataController, double screenWidth) {
    return Container(
      margin: EdgeInsets.all(screenWidth > 600 ? 20 : 16),
      padding: EdgeInsets.all(screenWidth > 600 ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Animated Avatar
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 600),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: screenWidth > 600 ? 60 : 50,
                  height: screenWidth > 600 ? 60 : 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.white.withValues(alpha: 0.9),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Obx(() => Center(
                    child: Text(
                      dataController.userName.value.isNotEmpty
                          ? dataController.userName.value[0].toUpperCase()
                          : 'U',
                      style: TextStyle(
                        color: const Color(0xFF6366f1),
                        fontSize: screenWidth > 600 ? 24 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
                ),
              );
            },
          ),

          SizedBox(width: screenWidth > 600 ? 16 : 12),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                  dataController.userName.value.isNotEmpty
                      ? dataController.userName.value
                      : "Guest User",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth > 600 ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                )),

                const SizedBox(height: 4),

                Obx(() => Row(
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: Colors.amber,
                      size: screenWidth > 600 ? 16 : 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${dataController.coins.value} coins",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: screenWidth > 600 ? 14 : 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )),

                const SizedBox(height: 2),

                Obx(() => Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: screenWidth > 600 ? 14 : 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Level ${dataController.getUserLevel()}",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: screenWidth > 600 ? 12 : 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildStatsSection(DataController dataController, double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? 20 : 16),
      padding: EdgeInsets.all(screenWidth > 600 ? 16 : 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                icon: Icons.emoji_events,
                label: "Rank",
                value: "#${dataController.rank.value}",
                color: Colors.amber,
                screenWidth: screenWidth,
              ),
              _buildStatItem(
                icon: Icons.score,
                label: "Score",
                value: "${dataController.totalScore.value}",
                color: Colors.greenAccent,
                screenWidth: screenWidth,
              ),
            ],
          )),

          const SizedBox(height: 12),

          // Level Progress
          Obx(() {
            final progress = dataController.getLevelProgress();
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Level Progress",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: screenWidth > 600 ? 12 : 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "${(progress * 100).toInt()}%",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: screenWidth > 600 ? 12 : 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween(begin: 0.0, end: progress),
                  builder: (context, value, child) {
                    return Container(
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: value,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            gradient: const LinearGradient(
                              colors: [Colors.amber, Colors.orange],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required double screenWidth,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: screenWidth > 600 ? 20 : 18,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth > 600 ? 16 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: screenWidth > 600 ? 11 : 10,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationMenu(BuildContext context, ThemeController themeController, double screenWidth) {
    final menuItems = [
      {'label': 'HOME', 'icon': Icons.home_rounded, 'route': () => Get.offAll(() => CategoryScreen())},
      {'label': 'DAILY QUIZ', 'icon': Icons.quiz_rounded, 'route': () => Get.to(() => const DailyQuizScreen())},
      {'label': 'Leaderboard', 'icon': Icons.leaderboard_rounded, 'route': () => Get.to(() => const LeaderboardScreen())},
      {'label': 'How To Use', 'icon': Icons.help_outline_rounded, 'route': () => Get.to(() => const HowToUseScreen())},
      {'label': 'About Us', 'icon': Icons.info_outline_rounded, 'route': () => Get.to(() => const AboutUsScreen())},
      {'label': 'Contact Us', 'icon': Icons.contact_support_rounded, 'route': () => Get.to(() => const ContactUsScreen())},
      {'label': 'Terms & Conditions', 'icon': Icons.description_rounded, 'route': () => Get.to(() => const TermsConditionsScreen())},
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? 12 : 8),
      child: Column(
        children: [
          // Main Menu Items
          ...menuItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 300 + (index * 50)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: _buildAnimatedMenuItem(
                      context: context,
                      label: item['label'] as String,
                      icon: item['icon'] as IconData,
                      onTap: () {
                        Navigator.of(context).pop();
                        (item['route'] as Function)();
                      },
                      screenWidth: screenWidth,
                    ),
                  ),
                );
              },
            );
          }).toList(),

          // Divider
          Container(
            margin: EdgeInsets.symmetric(vertical: screenWidth > 600 ? 16 : 12),
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Theme Toggle
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 600),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: _buildAnimatedMenuItem(
                    context: context,
                    label: 'Toggle Theme',
                    icon: Icons.palette_rounded,
                    onTap: () {
                      themeController.toggleTheme();
                      Navigator.of(context).pop();
                    },
                    screenWidth: screenWidth,
                    isSpecial: true,
                  ),
                ),
              );
            },
          ),

          SizedBox(height: screenWidth > 600 ? 20 : 16),
        ],
      ),
    );
  }

  Widget _buildAnimatedMenuItem({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required double screenWidth,
    bool isSpecial = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenWidth > 600 ? 4 : 3),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          splashColor: Colors.white.withValues(alpha: 0.1),
          highlightColor: Colors.white.withValues(alpha: 0.05),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth > 600 ? 16 : 12,
              vertical: screenWidth > 600 ? 14 : 12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(screenWidth > 600 ? 8 : 6),
                  decoration: BoxDecoration(
                    color: isSpecial
                        ? Colors.amber.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: isSpecial ? Colors.amber : Colors.white,
                    size: screenWidth > 600 ? 20 : 18,
                  ),
                ),
                SizedBox(width: screenWidth > 600 ? 16 : 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSpecial ? Colors.amber : Colors.white,
                      fontSize: screenWidth > 600 ? 16 : 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withValues(alpha: 0.4),
                  size: screenWidth > 600 ? 16 : 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
