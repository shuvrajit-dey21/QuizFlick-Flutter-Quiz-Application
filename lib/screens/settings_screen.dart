import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/theme_provider.dart';
import '../controllers/data_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final DataController dataController = Get.find<DataController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  colors: [
                    const Color(0xFF1A1A2E),
                    const Color(0xFF16213E),
                    const Color(0xFF0F3460),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    const Color(0xFF667eea),
                    const Color(0xFF764ba2),
                    const Color(0xFFf093fb),
                    const Color(0xFFf5f7fa),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Custom App Bar
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        'Settings',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                              color: Colors.black.withValues(alpha: 0.3),
                            ),
                          ],
                        ),
                      ),
                      centerTitle: false,
                      titlePadding: const EdgeInsets.only(left: 72, bottom: 16),
                    ),
                  ),

                  // Settings Content
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Profile Section
                        _buildModernSectionCard(
                          title: 'Profile',
                          icon: Icons.person_outline_rounded,
                          gradient: [
                            const Color(0xFF667eea),
                            const Color(0xFF764ba2),
                          ],
                          children: [
                            _buildProfileHeader(dataController),
                            const SizedBox(height: 16),
                            _buildModernSettingsTile(
                              icon: Icons.edit_outlined,
                              title: 'Edit Profile',
                              subtitle: 'Update your personal information',
                              onTap: () => _showModernEditProfileDialog(context, dataController),
                              isDark: isDark,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // App Preferences Section
                        _buildModernSectionCard(
                          title: 'Preferences',
                          icon: Icons.tune_rounded,
                          gradient: [
                            const Color(0xFF8360c3),
                            const Color(0xFF2ebf91),
                          ],
                          children: [
                            Obx(() => _buildModernSwitchTile(
                              icon: themeController.themeMode == ThemeMode.dark
                                  ? Icons.dark_mode_rounded
                                  : Icons.light_mode_rounded,
                              title: 'Dark Mode',
                              subtitle: 'Switch between light and dark theme',
                              value: themeController.themeMode == ThemeMode.dark,
                              onChanged: (value) {
                                HapticFeedback.lightImpact();
                                themeController.toggleTheme();
                              },
                              isDark: isDark,
                            )),
                            const SizedBox(height: 12),
                            _buildModernSettingsTile(
                              icon: Icons.notifications_outlined,
                              title: 'Notifications',
                              subtitle: 'Manage your notification preferences',
                              onTap: () {
                                HapticFeedback.lightImpact();
                                _showComingSoonSnackbar('Notifications', 'Notification settings will be available soon');
                              },
                              isDark: isDark,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Data & Privacy Section
                        _buildModernSectionCard(
                          title: 'Data & Privacy',
                          icon: Icons.security_rounded,
                          gradient: [
                            const Color(0xFFff6b6b),
                            const Color(0xFFee5a24),
                          ],
                          children: [
                            _buildModernSettingsTile(
                              icon: Icons.delete_outline_rounded,
                              title: 'Clear Data',
                              subtitle: 'Reset all quiz progress and scores',
                              onTap: () => _showModernClearDataDialog(context, dataController),
                              isDark: isDark,
                              isDestructive: true,
                            ),
                            const SizedBox(height: 12),
                            _buildModernSettingsTile(
                              icon: Icons.privacy_tip_outlined,
                              title: 'Privacy Policy',
                              subtitle: 'Read our privacy policy',
                              onTap: () {
                                HapticFeedback.lightImpact();
                                _showComingSoonSnackbar('Privacy Policy', 'Privacy policy will be available soon');
                              },
                              isDark: isDark,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // About Section
                        _buildModernSectionCard(
                          title: 'About',
                          icon: Icons.info_outline_rounded,
                          gradient: [
                            const Color(0xFF00d2ff),
                            const Color(0xFF3a7bd5),
                          ],
                          children: [
                            _buildModernSettingsTile(
                              icon: Icons.star_outline_rounded,
                              title: 'Rate App',
                              subtitle: 'Help us improve by rating the app',
                              onTap: () {
                                HapticFeedback.lightImpact();
                                _showComingSoonSnackbar('Rate App', 'Rating feature will be available soon');
                              },
                              isDark: isDark,
                            ),
                            const SizedBox(height: 12),
                            _buildModernSettingsTile(
                              icon: Icons.help_outline_rounded,
                              title: 'Help & Support',
                              subtitle: 'Get help and contact support',
                              onTap: () {
                                HapticFeedback.lightImpact();
                                _showComingSoonSnackbar('Support', 'Help center will be available soon');
                              },
                              isDark: isDark,
                            ),
                            const SizedBox(height: 12),
                            _buildModernSettingsTile(
                              icon: Icons.code_rounded,
                              title: 'Version',
                              subtitle: 'Quiz App v1.0.0',
                              onTap: null,
                              isDark: isDark,
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),
                      ]),
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







  // Modern Section Card Widget
  Widget _buildModernSectionCard({
    required String title,
    required IconData icon,
    required List<Color> gradient,
    required List<Widget> children,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.grey.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: gradient[0].withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Profile Header Widget
  Widget _buildProfileHeader(DataController dataController) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() => Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark ? [
            Colors.white.withValues(alpha: 0.2),
            Colors.white.withValues(alpha: 0.1),
          ] : [
            Colors.grey.withValues(alpha: 0.1),
            Colors.grey.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667eea).withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dataController.userName.value.isEmpty
                      ? 'Guest User'
                      : dataController.userName.value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${dataController.gamesPlayed.value} games played',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.8)
                        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          // Stats
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '${dataController.coins.value}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  'coins',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.8)
                        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  // Modern Settings Tile Widget
  Widget _buildModernSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    required bool isDark,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDestructive
                        ? Colors.red.withValues(alpha: 0.2)
                        : isDark
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive
                        ? Colors.red
                        : isDark
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDestructive
                              ? Colors.red
                              : isDark
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDestructive
                              ? Colors.red.withValues(alpha: 0.8)
                              : isDark
                                  ? Colors.white.withValues(alpha: 0.7)
                                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow Icon
                if (onTap != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.8)
                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Modern Switch Tile Widget
  Widget _buildModernSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon Container
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDark
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.7)
                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            // Switch
            Transform.scale(
              scale: 0.9,
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeColor: isDark ? Colors.white : Theme.of(context).colorScheme.primary,
                activeTrackColor: const Color(0xFF667eea),
                inactiveThumbColor: isDark
                    ? Colors.white.withValues(alpha: 0.8)
                    : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                inactiveTrackColor: isDark
                    ? Colors.white.withValues(alpha: 0.3)
                    : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for showing coming soon snackbar
  void _showComingSoonSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color(0xFF667eea).withValues(alpha: 0.9),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 16,
      margin: const EdgeInsets.all(20),
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 500),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      icon: const Icon(Icons.info_outline, color: Colors.white),
      shouldIconPulse: false,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  // Modern Edit Profile Dialog
  void _showModernEditProfileDialog(BuildContext context, DataController dataController) {
    final TextEditingController nameController = TextEditingController(
      text: dataController.userName.value,
    );

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF667eea).withValues(alpha: 0.95),
                const Color(0xFF764ba2).withValues(alpha: 0.95),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Input Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: nameController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                    hintText: 'Enter your username',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(20),
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.trim().isNotEmpty) {
                          dataController.initUsername(nameController.text.trim());
                          Get.back();
                          HapticFeedback.lightImpact();
                          Get.snackbar(
                            'Success',
                            'Profile updated successfully!',
                            backgroundColor: Colors.green.withValues(alpha: 0.9),
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            borderRadius: 16,
                            margin: const EdgeInsets.all(20),
                            icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF667eea),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  // Modern Clear Data Dialog
  void _showModernClearDataDialog(BuildContext context, DataController dataController) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFff6b6b).withValues(alpha: 0.95),
                const Color(0xFFee5a24).withValues(alpha: 0.95),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.warning_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Clear All Data',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Warning Message
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Are you sure you want to clear all your data?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This will permanently delete all your quiz progress, scores, and achievements. This action cannot be undone.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        dataController.resetUserData();
                        Get.back();
                        HapticFeedback.heavyImpact();
                        Get.snackbar(
                          'Data Cleared',
                          'All your data has been successfully cleared',
                          backgroundColor: Colors.green.withValues(alpha: 0.9),
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          borderRadius: 16,
                          margin: const EdgeInsets.all(20),
                          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFff6b6b),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Clear Data',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
