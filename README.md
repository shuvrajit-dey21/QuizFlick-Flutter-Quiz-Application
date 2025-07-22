# 🧠 QuizFlick - Flutter Quiz Application

<div align="center">
  <img src="assets/QuizFlick_logo.png" alt="QuizFlick Logo" width="200"/>

  [![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
  [![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)
</div>

## 📖 About

QuizFlick is an engaging and interactive quiz application built with Flutter that challenges users across multiple knowledge categories. With a beautiful UI, smooth animations, and comprehensive features, it provides an excellent learning and entertainment experience.

## ✨ Features

### 🎯 Core Features
- **Multiple Quiz Categories**: General Knowledge, Science, History, Geography, Computer Science, and more
- **Interactive Quiz Interface**: Beautiful card-based question display with smooth animations
- **Real-time Scoring**: Track your performance with instant feedback
- **Timer System**: Time-based challenges to add excitement
- **Progress Tracking**: Monitor your quiz completion and accuracy

### 🎨 User Experience
- **Splash Screen**: Animated welcome experience
- **Dark/Light Theme**: Toggle between themes for comfortable viewing
- **Responsive Design**: Optimized for different screen sizes
- **Smooth Animations**: Engaging transitions and visual effects
- **Sound Effects**: Audio feedback for interactions (optional)
- **Haptic Feedback**: Vibration feedback for better user experience

### 📊 Advanced Features
- **Leaderboard System**: Compete with other users and track rankings
- **User Profiles**: Personalized avatars and user data management
- **Favorites System**: Save and revisit your favorite questions
- **Search Functionality**: Find specific topics or questions
- **Daily Quiz**: Special daily challenges
- **Statistics**: Detailed performance analytics
- **Share Results**: Share your achievements on social platforms

### 🔧 Additional Features
- **Settings Panel**: Customize app behavior and preferences
- **Notifications**: Stay updated with new quizzes and challenges
- **About & Contact**: Information and support pages
- **Terms & Conditions**: Legal and usage information
- **How to Use**: Built-in tutorial and help system

## 🏗️ Architecture

QuizFlick follows a **clean architecture pattern** with **GetX state management** for optimal performance and maintainability.

### 📁 Project Structure

<details>
<summary>📂 <strong>Click to expand project structure</strong></summary>

```
flutter_quiz_app_project/
│
├── 📱 lib/
│   ├── 🎮 controllers/              # State Management Layer
│   │   ├── data_controller.dart     # Global data management
│   │   ├── quiz_controller.dart     # Quiz logic & question handling
│   │   ├── result_controller.dart   # Result processing & analytics
│   │   ├── theme_provider.dart      # Theme switching & preferences
│   │   ├── timer_controller.dart    # Quiz timer management
│   │   └── welcome_controller.dart  # Welcome screen animations
│   │
│   ├── 📊 models/                   # Data Models Layer
│   │   ├── question.dart           # Question data structure
│   │   └── user_data.dart          # User profile & statistics
│   │
│   ├── 📱 screens/                  # Presentation Layer
│   │   ├── 🚀 splash_screen.dart           # App initialization
│   │   ├── 👋 welcome_screen_2.dart        # User onboarding
│   │   ├── 📋 category_screen_2.dart       # Quiz category selection
│   │   ├── ❓ quiz_screen_2.dart           # Main quiz interface
│   │   ├── 📊 result_screen_2.dart         # Results & performance
│   │   ├── 🏆 leaderboard_screen.dart      # Global rankings
│   │   ├── 👤 profile_screen.dart          # User profile management
│   │   ├── ⚙️ settings_screen.dart         # App configuration
│   │   ├── 🔍 search_screen.dart           # Question search
│   │   ├── ❤️ favorites_screen.dart        # Saved questions
│   │   ├── 📅 daily_quiz_screen.dart       # Daily challenges
│   │   ├── 🔔 notifications_screen.dart    # App notifications
│   │   ├── 📞 contact_us_screen.dart       # Support & feedback
│   │   ├── ℹ️ about_us_screen.dart         # App information
│   │   ├── 📜 terms_conditions_screen.dart # Legal information
│   │   ├── ❓ how_to_use_screen.dart       # User guide
│   │   └── 🧭 sidenavbar.dart              # Navigation drawer
│   │
│   ├── 🔧 services/                 # Business Logic Layer
│   │   └── leaderboard_service.dart # Ranking & user data management
│   │
│   ├── 🧩 widgets/                  # Reusable Components
│   │   ├── answer_card.dart        # Interactive answer options
│   │   └── next_button.dart        # Navigation controls
│   │
│   └── 🎯 main.dart                 # Application entry point
│
├── 🎨 assets/                       # Static Resources
│   ├── 🖼️ images/                   # UI graphics & illustrations
│   ├── 🔊 sounds/                   # Audio effects & feedback
│   └── 📄 *.json                    # Question databases
│
├── 🤖 android/                      # Android platform files
├── 🍎 ios/                          # iOS platform files
├── 🌐 web/                          # Web platform files
├── 🐧 linux/                        # Linux platform files
├── 🪟 windows/                      # Windows platform files
└── 🍎 macos/                        # macOS platform files
```

</details>

### 🔄 Architecture Patterns

| Layer | Technology | Purpose |
|-------|------------|---------|
| **🎨 Presentation** | Flutter Widgets | UI rendering and user interactions |
| **🎮 State Management** | GetX Controllers | Reactive state management and dependency injection |
| **📊 Data Models** | Dart Classes | Data structure definitions and serialization |
| **🔧 Business Logic** | Services | Core app logic and data processing |
| **💾 Data Persistence** | SharedPreferences | Local storage for user data and preferences |
| **🌐 External APIs** | HTTP Client | Future integration with online services |

### 🎯 Key Design Principles

- **🔄 Reactive Programming**: GetX observables for real-time UI updates
- **🧩 Modular Design**: Separated concerns for easy maintenance
- **♻️ Reusable Components**: Custom widgets for consistent UI
- **📱 Responsive Layout**: Adaptive design for all screen sizes
- **🎨 Theme Support**: Dynamic light/dark mode switching
- **⚡ Performance Optimized**: Efficient state management and lazy loading

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.4.1)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/shuvrajit-dey21/QuizFlick-Flutter-Quiz-Application.git
   cd QuizFlick-Flutter-Quiz-Application
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate launcher icons** (optional)
   ```bash
   flutter pub run flutter_launcher_icons:main
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

## 📱 Screenshots

| Welcome Screen | Categories | Quiz Interface | Results |
|:--------------:|:----------:|:--------------:|:-------:|
| ![Welcome](assets/welcome_img.png) | ![Categories](assets/quiz_screen.jpg) | ![Quiz](assets/background.png) | ![Results](assets/result_image.png) |

## 🛠️ Dependencies

### Core Dependencies
- **flutter**: SDK framework
- **get**: State management and navigation (^4.6.6)
- **shared_preferences**: Local data persistence (^2.5.3)

### UI & Animation
- **carousel_slider**: Image carousels (^5.1.1)
- **simple_animations**: Smooth animations (^5.0.2)
- **confetti**: Celebration effects (^0.7.0)

### Media & Interaction
- **audioplayers**: Sound effects (^6.5.0)
- **flutter_vibrate**: Haptic feedback (^1.3.0)

### Networking & Sharing
- **http**: API communication (^1.4.0)
- **share_plus**: Social sharing (^11.0.0)

### Development
- **flutter_launcher_icons**: Custom app icons (^0.13.1)
- **flutter_lints**: Code quality (^4.0.0)

## 🎮 How to Play

1. **Launch the App**: Start with the animated splash screen
2. **Choose Category**: Select from available quiz categories
3. **Answer Questions**: Tap on your chosen answer
4. **Track Progress**: Monitor your score and time
5. **View Results**: See detailed performance analysis
6. **Check Leaderboard**: Compare with other players
7. **Customize**: Adjust settings and themes to your preference

## 📊 Quiz Categories

- **🧠 General Knowledge**: Broad range of topics
- **🔬 Science**: Physics, Chemistry, Biology
- **📚 History**: World history and events
- **🌍 Geography**: Countries, capitals, landmarks
- **💻 Computer**: Programming and technology
- **🏥 NEET**: Medical entrance preparation (Coming Soon)

## 🎨 Customization

### Adding New Categories
1. Create a new JSON file in `assets/` directory
2. Update the category list in `category_screen_2.dart`
3. Add corresponding images to `assets/` folder
4. Update the quiz controller to handle the new category

### Modifying Questions
Edit the JSON files in the `assets/` directory:
```json
{
  "question": "Your question here?",
  "options": ["Option 1", "Option 2", "Option 3", "Option 4"],
  "correctAnswerIndex": 1
}
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Author

- **Shuvrajit Dey** - *Developer* - [GitHub](https://github.com/shuvrajit-dey21)

### 🌟 About the Developer
Passionate about creating beautiful and functional mobile applications with Flutter. Dedicated to delivering high-quality user experiences through clean code and innovative design.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- GetX package for state management
- All contributors and testers
- Icon and image resources from various sources

## 

## 🔄 Version History

- **v1.0.0** - Initial release with core quiz functionality
- More versions coming soon...

---

<div align="center">
  <p>Made with ❤️ using Flutter</p>
  <p>⭐ Star this repo if you found it helpful!</p>
</div>
