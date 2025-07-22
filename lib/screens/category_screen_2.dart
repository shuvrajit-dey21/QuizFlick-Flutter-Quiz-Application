import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../controllers/data_controller.dart';
import 'quiz_screen_2.dart';
import 'sidenavbar.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';

class CategoryScreen extends StatelessWidget {
  final List<String> categories = [
    'General Knowledge',
    'Science',
    'History',
    'Geography',
    'Computer',
    'NEET\ncomming soon...'
  ];

  final List<String> categoryImages = [
    'assets/gk_img-min.png', // Add your image paths here
    'assets/science_img.png',
    'assets/history_img-min.png',
    'assets/geography_img-min.png',
    'assets/computer_img-min.png',
    'assets/Neet_img.jpg'
  ];

  CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
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
          title: const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              'HOME',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => const NotificationsScreen());
              },
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              tooltip: 'Notifications',
            ),
            IconButton(
              onPressed: () {
                Get.to(() => const SettingsScreen());
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              tooltip: 'Settings',
            ),
          ],
        ),
      ),
      drawer: const SideNav(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Carousel Slider Section
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.transparent,
                      blurRadius: 0,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CarouselSlider(
                        items: categories.asMap().entries.map((entry) {
                          int index = entry.key;
                          String category = entry.value;
                          return InkWell(
                            onTap: () {
                              if (index != 5) {
                                Get.put(DataController());
                                Get.find<DataController>()
                                    .initCategory(categories[index]);
                                Get.to(
                                  () => QuizScreen(),
                                );
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: AssetImage(categoryImages[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  category,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 200.0,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: Text(
                          'Select Section',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                isDarkMode ? Colors.yellow : Colors.blueAccent,
                            shadows: [
                              Shadow(
                                blurRadius: 3,
                                color: Colors.black.withOpacity(0.4),
                                offset: const Offset(1, 1),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Category Selection Cards
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1.2,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Get.to(() => QuizScreen(),
                      //     arguments: {'category': categories[index]});
                      if (index != 5) {
                        Get.put(DataController());
                        Get.find<DataController>()
                            .initCategory(categories[index]);
                        Get.to(
                          () => QuizScreen(),
                        );
                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 4,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: AssetImage(categoryImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  categories[index],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue.shade900,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        currentIndex: 0, // Default selected index
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on Home, do nothing
              break;
            case 1:
              Get.to(() => const SearchScreen());
              break;
            case 2:
              Get.to(() => const FavoritesScreen());
              break;
            case 3:
              Get.to(() => const ProfileScreen());
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
