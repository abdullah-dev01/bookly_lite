# 📚 Bookly Lite

A modern Flutter app for discovering and exploring books using the Google Books API, featuring a beautiful dashboard UI with trending books, recommendations, and detailed book information.

## ✨ Features

- 🔍 **Book Search** - Search for books using Google Books API
- 📊 **Dashboard UI** - Beautiful dashboard with multiple sections:
  - Trending Books (horizontal scroll)
  - Popular Programming Books
  - Recommended for You
  - All Books (vertical list)
- 📖 **Book Details** - Detailed book information with:
  - Book cover with enhanced visuals
  - Author and publisher information
  - Categories and metadata
  - Price and purchase links
  - Book description
- 🎨 **Modern UI** - Enhanced visual design with:
  - Rounded corners and shadows
  - Gradient backgrounds
  - Card-based layouts
  - Responsive design
- 🔗 **URL Launcher** - Direct links to preview and buy books
- 🔐 **Firebase Authentication** - User authentication support

## 🛠️ Tech Stack

- **Flutter** - Cross-platform mobile framework
- **Riverpod** - State management
  - `Provider` - Simple providers
  - `NotifierProvider` - State notifiers
  - `AsyncNotifierProvider` - Async state management
- **Firebase** - Authentication and backend services
- **Dio** - HTTP client for API calls
- **Google Books API** - Book data source
- **Cached Network Image** - Image caching
- **URL Launcher** - External link handling
- **HTML Parser** - HTML content parsing

## 📦 Dependencies

```yaml
dependencies:
  flutter_riverpod: ^3.0.3
  firebase_core: ^4.2.1
  firebase_auth: ^6.1.2
  dio: ^5.4.0
  cached_network_image: ^3.4.1
  url_launcher: ^6.3.1
  html: ^0.15.4
  shared_preferences: ^2.5.3
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Firebase project setup
- Google Books API access

### Installation

1. Clone the repository:
```bash
git clone https://github.com/YOUR_USERNAME/bookly_lite.git
cd bookly_lite
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files
   - Update Firebase configuration in `lib/main.dart`

4. Run the app:
```bash
flutter run
```

## 📱 Screenshots

- **Dashboard Screen** - Browse books in organized sections
- **Book Details** - View comprehensive book information
- **Search** - Find books quickly

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── constants/     # API constants
│   ├── services/      # API service, Firebase service
│   └── models/        # Core models
├── features/
│   ├── auth/         # Authentication feature
│   ├── books/        # Books feature
│   │   ├── application/  # State management (Notifiers)
│   │   ├── data/        # Repository, models
│   │   └── presentation/ # UI screens and widgets
│   ├── favorites/    # Favorites feature
│   ├── settings/     # Settings feature
│   └── splash/       # Splash screen
├── providers/        # Riverpod providers
└── main.dart        # App entry point
```

## 🎯 Key Features Implementation

### State Management with Riverpod

- **Provider** - For simple dependencies (repositories, services)
- **NotifierProvider** - For synchronous state (SplashNotifier)
- **AsyncNotifierProvider** - For async operations (BooksNotifier, AuthNotifier)

### UI Components

- **BookDashboard** - Main dashboard with horizontal and vertical scrolling sections
- **BookDetailsScreen** - Detailed book view with card-based layout
- **BookItem** - Reusable book card component
- **BookCardHorizontal** - Horizontal scrolling card for dashboard sections

## 🔧 Configuration

### Firebase Setup

1. Create a Firebase project
2. Enable Authentication
3. Add your app to Firebase console
4. Download configuration files
5. Place them in the appropriate directories

### API Configuration

The app uses Google Books API. No API key required for basic usage.

## 📝 License

This project is open source and available under the MIT License.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

## 👤 Author

Your Name

---

Made with ❤️ using Flutter
