import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/data_controller.dart';
import 'quiz_screen_2.dart';

class DailyQuizScreen extends StatefulWidget {
  const DailyQuizScreen({super.key});

  @override
  State<DailyQuizScreen> createState() => _DailyQuizScreenState();
}

class _DailyQuizScreenState extends State<DailyQuizScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  int _selectedCategoryIndex = 0;

  final List<Map<String, dynamic>> _dailyCategories = [
    {
      'name': 'General Knowledge',
      'icon': Icons.public,
      'color': Colors.purple,
      'description': 'Test your general knowledge with diverse questions',
      'questions': 10,
      'difficulty': 'Medium',
    },
    {
      'name': 'Science',
      'icon': Icons.science,
      'color': Colors.green,
      'description': 'Explore the wonders of science and nature',
      'questions': 10,
      'difficulty': 'Hard',
    },
    {
      'name': 'History',
      'icon': Icons.history_edu,
      'color': Colors.brown,
      'description': 'Journey through historical events and figures',
      'questions': 10,
      'difficulty': 'Medium',
    },
    {
      'name': 'Geography',
      'icon': Icons.map,
      'color': Colors.teal,
      'description': 'Discover countries, capitals, and landmarks',
      'questions': 10,
      'difficulty': 'Easy',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Quiz'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Header Card
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Card(
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [Colors.amber.shade400, Colors.orange.shade600],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(
                                  Icons.today,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Daily Quiz Challenge',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Today: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Take on today\'s special quiz challenge! Test your knowledge with a mix of questions from different categories.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Questions:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                        Text('10', style: TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Category:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                        Text('Mixed', style: TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Difficulty:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                        Text('Medium', style: TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Reward:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                        Text('50 Coins', style: TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Category Selection Tabs
                              Container(
                                height: 50,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _dailyCategories.length,
                                  itemBuilder: (context, index) {
                                    final isSelected = _selectedCategoryIndex == index;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedCategoryIndex = index;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 12),
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: isSelected ? Colors.white : Colors.white24,
                                          borderRadius: BorderRadius.circular(25),
                                          border: Border.all(
                                            color: isSelected ? Colors.orange.shade700 : Colors.white54,
                                            width: 2,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              _dailyCategories[index]['icon'],
                                              color: isSelected ? Colors.orange.shade700 : Colors.white,
                                              size: 20,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              _dailyCategories[index]['name'],
                                              style: TextStyle(
                                                color: isSelected ? Colors.orange.shade700 : Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),
                              GetX<DataController>(
                                builder: (dataController) {
                                  final isCompletedToday = dataController.isDailyQuizCompletedToday();

                                  return SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: isCompletedToday ? null : () {
                                        final selectedCategory = _dailyCategories[_selectedCategoryIndex]['name'];
                                        dataController.initCategory(selectedCategory, isDailyQuiz: true);
                                        Get.to(() => QuizScreen(isDailyQuiz: true));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isCompletedToday ? Theme.of(context).disabledColor : Theme.of(context).cardColor,
                                        foregroundColor: isCompletedToday ? Theme.of(context).colorScheme.onSurface : Colors.orange.shade700,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        elevation: 4,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            isCompletedToday ? Icons.check_circle : Icons.play_arrow,
                                            size: 24
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            isCompletedToday ? 'Quiz Completed Today!' : 'Start Daily Quiz',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Categories Grid
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.category,
                                color: Colors.blue.shade700,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Quick Categories',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.2,
                            ),
                            itemCount: _dailyCategories.length,
                            itemBuilder: (context, index) {
                              final category = _dailyCategories[index];
                              return _buildCategoryCard(category);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Streak Card
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark ? [
                          Colors.white.withValues(alpha: 0.05),
                          Colors.white.withValues(alpha: 0.1),
                        ] : [
                          Colors.white.withValues(alpha: 0.9),
                          Colors.white.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.grey.withValues(alpha: 0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.3)
                              : Colors.grey.withValues(alpha: 0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.orange.shade600, Colors.deepOrange.shade500],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.orange.withValues(alpha: 0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.local_fire_department,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    'Daily Quiz Streak',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? Colors.white
                                          : Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                          const SizedBox(height: 16),
                          GetX<DataController>(
                            builder: (dataController) {
                              final weekStatus = dataController.getWeeklyStreakStatus();
                              final today = DateTime.now();
                              final dayNames = <String>[];

                              // Generate actual day names for the past 7 days
                              for (int i = 6; i >= 0; i--) {
                                final date = today.subtract(Duration(days: i));
                                final dayName = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date.weekday % 7];
                                dayNames.add(dayName);
                              }

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: List.generate(7, (index) {
                                  return _buildStreakDay(dayNames[index], weekStatus[index]);
                                }),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          GetX<DataController>(
                            builder: (dataController) {
                              final streak = dataController.dailyQuizStreak.value;
                              final isCompletedToday = dataController.isDailyQuizCompletedToday();

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isCompletedToday
                                        ? [Colors.green.shade100, Colors.green.shade50]
                                        : [Colors.orange.shade100, Colors.orange.shade50],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isCompletedToday
                                        ? Colors.green.shade300
                                        : Colors.orange.shade300,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (isCompletedToday ? Colors.green : Colors.orange).withValues(alpha: 0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isCompletedToday ? Icons.check_circle : Icons.local_fire_department,
                                      color: isCompletedToday ? Colors.green.shade700 : Colors.orange.shade700,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      isCompletedToday
                                        ? 'Today\'s Quiz Complete! Streak: $streak days 🔥'
                                        : 'Current Streak: $streak days 🔥',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: isCompletedToday ? Colors.green.shade700 : Colors.orange.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
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

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Get.put(DataController());
        Get.find<DataController>().initCategory(category['name']);
        Get.to(() => QuizScreen());
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark ? [
              Colors.white.withValues(alpha: 0.05),
              Colors.white.withValues(alpha: 0.1),
            ] : [
              Colors.white.withValues(alpha: 0.9),
              Colors.white.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.grey.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Get.put(DataController());
                Get.find<DataController>().initCategory(category['name']);
                Get.to(() => QuizScreen());
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon with gradient background
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            category['color'],
                            category['color'].withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: category['color'].withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        category['icon'],
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Category name
                    Text(
                      category['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Difficulty badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(category['difficulty']).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getDifficultyColor(category['difficulty']).withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        category['difficulty'],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _getDifficultyColor(category['difficulty']),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Questions count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.quiz_outlined,
                          size: 14,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.7)
                              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${category['questions']} questions',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.7)
                                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Widget _buildStreakDay(String day, bool completed) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: completed
                ? Colors.green
                : isDark
                    ? Theme.of(context).disabledColor
                    : Colors.grey.shade300,
            shape: BoxShape.circle,
            border: Border.all(
              color: completed
                  ? Colors.green.shade700
                  : isDark
                      ? Colors.grey.shade600
                      : Colors.grey.shade400,
              width: 2,
            ),
            boxShadow: completed
                ? [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Icon(
            completed ? Icons.check : Icons.close,
            color: completed
                ? Colors.white
                : isDark
                    ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)
                    : Colors.grey.shade600,
            size: 20,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          day,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: completed
                ? Colors.green.shade700
                : isDark
                    ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)
                    : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
