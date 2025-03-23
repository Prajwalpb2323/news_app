📢 News App
A Flutter-powered news application that fetches and displays news articles from NewsAPI.

🚀 Features
✔ Display a list of top headlines
✔ View detailed news articles
✔ Search for specific news topics
✔ Pull-to-refresh functionality
✔ Dark mode support
✔ Theme toggle (Light & Dark mode)
✔ Optimized API calls with error handling
✔ Tested on mobile devices 📱 ✅

📦 Setup Instructions
1️⃣ Clone the Repository

git clone https://github.com/Prajwalpb2323/news_app.git
cd news_app

2️⃣ Add API Key
Create a .env file in the project root and add your NewsAPI key:
NEWS_API_KEY=your_api_key_here/// you can take it from any news API 
Get your API key from NewsAPI.

3️⃣ Install Dependenciest
flutter pub get

4️⃣ Run the App
flutter run
Ensure your emulator or physical device is connected.

📲 Build & Install the App on Mobile

🔹 For Android
Generate an APK to install on an Android device:
flutter build apk
Find the APK in:
/build/app/outputs/flutter-apk/app-release.apk
Transfer it to your phone and install it.

🔹 For iOS (Mac Required)
flutter build ios
Requires an Apple Developer account for real device installation.

📌 Requirements
Flutter 3.5.0 or higher

Dart 3.0.0 or higher

NewsAPI key

🏗 Implementation Details
🎯 Architecture
✔ State Management: Provider
✔ Folder Structure: Models, Services, Providers, Screens, Widgets
✔ Separation of Concerns

🎨 UI Features
✔ Minimalistic card-based design
✔ Cached images for efficiency
✔ Interactive pull-to-refresh
✔ Search bar for filtering news
✔ Light & Dark mode toggle

🌍 API Integration
✔ NewsAPI for fetching latest headlines
✔ Handles search queries
✔ Error handling & offline support

