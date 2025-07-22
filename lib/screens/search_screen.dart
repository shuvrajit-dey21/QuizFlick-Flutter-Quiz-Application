import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/data_controller.dart';
import 'quiz_screen_2.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchResult> _searchResults = [];
  bool _isSearching = false;

  final List<SearchResult> _allContent = [
    // Categories
    SearchResult(
      title: 'General Knowledge',
      subtitle: 'Test your general knowledge with diverse questions',
      type: SearchResultType.category,
      icon: Icons.lightbulb,
      color: Colors.orange,
      category: 'General Knowledge',
    ),
    SearchResult(
      title: 'Science',
      subtitle: 'Explore physics, chemistry, and biology questions',
      type: SearchResultType.category,
      icon: Icons.science,
      color: Colors.green,
      category: 'Science',
    ),
    SearchResult(
      title: 'History',
      subtitle: 'Journey through historical events and figures',
      type: SearchResultType.category,
      icon: Icons.history_edu,
      color: Colors.brown,
      category: 'History',
    ),
    SearchResult(
      title: 'Geography',
      subtitle: 'Discover countries, capitals, and landmarks',
      type: SearchResultType.category,
      icon: Icons.public,
      color: Colors.blue,
      category: 'Geography',
    ),
    SearchResult(
      title: 'Computer',
      subtitle: 'Programming, algorithms, and technology',
      type: SearchResultType.category,
      icon: Icons.computer,
      color: Colors.purple,
      category: 'Computer',
    ),
    
    // Topics
    SearchResult(
      title: 'World Capitals',
      subtitle: 'Learn about capital cities around the world',
      type: SearchResultType.topic,
      icon: Icons.location_city,
      color: Colors.teal,
      category: 'Geography',
    ),
    SearchResult(
      title: 'Programming Languages',
      subtitle: 'Test your knowledge of various programming languages',
      type: SearchResultType.topic,
      icon: Icons.code,
      color: Colors.indigo,
      category: 'Computer',
    ),
    SearchResult(
      title: 'World Wars',
      subtitle: 'Questions about major world conflicts',
      type: SearchResultType.topic,
      icon: Icons.military_tech,
      color: Colors.red,
      category: 'History',
    ),
    SearchResult(
      title: 'Human Body',
      subtitle: 'Anatomy and physiology questions',
      type: SearchResultType.topic,
      icon: Icons.accessibility,
      color: Colors.pink,
      category: 'Science',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchResults = _allContent;
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _searchResults = _allContent;
      } else {
        _searchResults = _allContent
            .where((item) =>
                item.title.toLowerCase().contains(query.toLowerCase()) ||
                item.subtitle.toLowerCase().contains(query.toLowerCase()) ||
                item.category.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
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
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: _performSearch,
                decoration: InputDecoration(
                  hintText: 'Search categories, topics, or questions...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _performSearch('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),
            
            // Search Results
            Expanded(
              child: _searchResults.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isSearching ? Icons.search_off : Icons.search,
                            size: 80,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _isSearching 
                                ? 'No results found'
                                : 'Start typing to search',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final result = _searchResults[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: result.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                result.icon,
                                color: result.color,
                                size: 24,
                              ),
                            ),
                            title: Text(
                              result.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  result.subtitle,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: result.color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    result.type == SearchResultType.category
                                        ? 'Category'
                                        : 'Topic',
                                    style: TextStyle(
                                      color: result.color,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              if (result.type == SearchResultType.category) {
                                // Navigate to quiz for this category
                                Get.put(DataController());
                                Get.find<DataController>().initCategory(result.category);
                                Get.to(() => QuizScreen());
                              } else {
                                // For topics, show a message or navigate to specific content
                                Get.snackbar(
                                  'Coming Soon',
                                  'Topic-specific quizzes will be available soon!',
                                  backgroundColor: result.color,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            },
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

enum SearchResultType {
  category,
  topic,
}

class SearchResult {
  final String title;
  final String subtitle;
  final SearchResultType type;
  final IconData icon;
  final Color color;
  final String category;

  SearchResult({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.icon,
    required this.color,
    required this.category,
  });
}
