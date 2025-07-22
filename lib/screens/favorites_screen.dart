import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/data_controller.dart';
import 'quiz_screen_2.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample favorite items - in a real app, this would come from a controller
    final List<FavoriteItem> favoriteItems = [
      FavoriteItem(
        title: 'Science Quiz',
        subtitle: 'Your best category with 85% average score',
        category: 'Science',
        icon: Icons.science,
        color: Colors.green,
        averageScore: 85,
        timesPlayed: 12,
      ),
      FavoriteItem(
        title: 'Computer Programming',
        subtitle: 'Recently played with great results',
        category: 'Computer',
        icon: Icons.computer,
        color: Colors.purple,
        averageScore: 78,
        timesPlayed: 8,
      ),
      FavoriteItem(
        title: 'World Geography',
        subtitle: 'Challenging but fun geography questions',
        category: 'Geography',
        icon: Icons.public,
        color: Colors.blue,
        averageScore: 72,
        timesPlayed: 15,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.blue.shade900],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _showFavoritesInfo(context);
            },
            icon: const Icon(Icons.info_outline),
            tooltip: 'About Favorites',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: favoriteItems.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No favorites yet',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Play some quizzes to add them to favorites!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  // Stats Header
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink.shade400, Colors.purple.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Your Favorites',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${favoriteItems.length} favorite categories',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${favoriteItems.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Favorites List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: favoriteItems.length,
                      itemBuilder: (context, index) {
                        final item = favoriteItems[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [
                                  item.color.withOpacity(0.1),
                                  Colors.white,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(20),
                              leading: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: item.color.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  item.icon,
                                  color: item.color,
                                  size: 28,
                                ),
                              ),
                              title: Text(
                                item.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                    item.subtitle,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      _buildStatChip(
                                        icon: Icons.star,
                                        label: '${item.averageScore}%',
                                        color: Colors.orange,
                                      ),
                                      const SizedBox(width: 8),
                                      _buildStatChip(
                                        icon: Icons.play_arrow,
                                        label: '${item.timesPlayed} plays',
                                        color: Colors.blue,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _removeFavorite(context, item);
                                    },
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ),
                                    tooltip: 'Remove from favorites',
                                  ),
                                  const Icon(Icons.arrow_forward_ios, size: 16),
                                ],
                              ),
                              onTap: () {
                                // Navigate to quiz for this category
                                Get.put(DataController());
                                Get.find<DataController>().initCategory(item.category);
                                Get.to(() => QuizScreen());
                              },
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

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _removeFavorite(BuildContext context, FavoriteItem item) {
    Get.dialog(
      AlertDialog(
        title: const Text('Remove Favorite'),
        content: Text('Remove "${item.title}" from your favorites?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Removed',
                '${item.title} removed from favorites',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showFavoritesInfo(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('About Favorites'),
        content: const Text(
          'Your favorite quiz categories are automatically saved based on your performance and frequency of play. Categories with high scores and frequent plays appear here.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class FavoriteItem {
  final String title;
  final String subtitle;
  final String category;
  final IconData icon;
  final Color color;
  final int averageScore;
  final int timesPlayed;

  FavoriteItem({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.icon,
    required this.color,
    required this.averageScore,
    required this.timesPlayed,
  });
}
