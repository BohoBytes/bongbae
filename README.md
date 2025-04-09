# BongBae - Bengali Matchmaking App (Flutter)

<p align="center">
  <img src="assets/images/logo.png" alt="BongBae Logo" width="150"/>
</p>

A cross-platform matchmaking application built with Flutter, specifically targeting Bengali users from Bangladesh and West Bengal.

<!-- Optional: Add badges for build status, license etc. later -->
<!-- ![Build Status](...) ![License](...) -->

## ✨ Features

- **Splash Screen:** Custom entry screen.
- **Onboarding:** Multi-page introduction flow.
- **Firebase Authentication:** Secure Email/Password signup and login.
- **Firestore Integration:** User data storage (initial setup).
- **Profile Setup (WIP):** Screen for users to input basic profile details (Name, DOB, Location, Photos, etc.).
- **GoRouter Navigation:** Robust routing solution.
- **Custom Theming:** Defined color scheme and typography.
- _(Add more features as you build them: Profile Viewing, Matching/Swiping, Chat, Settings, etc.)_

## 📸 Screenshots (Coming Soon!)

## 🚀 Tech Stack

- **Framework:** Flutter (v3.x.x - Specify your version)
- **Language:** Dart (v3.x.x - Specify your version)
- **Backend:** Firebase
  - Firebase Authentication
  - Cloud Firestore (Database)
  - Firebase Storage (for Images)
- **State Management:** Provider (implicitly used via `ChangeNotifierProvider` for potential future services, although Auth state is currently handled via `ValueNotifier` in router)
- **Routing:** GoRouter
- **Key Packages:**
  - `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`
  - `provider`
  - `go_router`
  - `shared_preferences` (for onboarding status)
  - `image_picker` (for profile photos)
  - `intl` (for date formatting)
  - `geolocator`, `permission_handler` (for location)
  - `smooth_page_indicator` (for onboarding)

## 📋 Prerequisites

- **Flutter SDK:** Ensure you have Flutter installed. Check with `flutter --version`. See [Flutter Installation Guide](https://flutter.dev/docs/get-started/install).
- **IDE:** Android Studio or Visual Studio Code (with Flutter/Dart extensions).
- **Firebase Project:** You need a Firebase project set up.
- **Firebase CLI:** Install via `npm install -g firebase-tools` or standalone binary. Login using `firebase login`.
- **FlutterFire CLI:** Install via `dart pub global activate flutterfire_cli`.
- **(iOS Setup):** Xcode installed, CocoaPods (`sudo gem install cocoapods`).

## ⚙️ Setup & Configuration

1.  **Clone the Repository:**

    ```bash
    git clone https://github.com/BohoBytes/bongbae.git
    cd bongbae
    ```

2.  **Firebase Setup (IMPORTANT):**

    - This project requires Firebase backend services (Auth, Firestore, Storage).
    - **For Contributors:** It is highly recommended to **create your own Firebase project** for development to avoid interfering with any shared development/production project.
    - Once you have your Firebase project created:
      - Run `flutterfire configure` in the project root.
      - Select your Firebase project.
      - Select the platforms (android, ios, web).
      - This will generate a `lib/firebase_options.dart` file specific to _your_ Firebase project. **The default generated `firebase_options.dart` is generally safe to commit, but if you manually add API keys or other sensitive info, ensure it's in your `.gitignore`.**
      - Enable **Email/Password Authentication** in your Firebase project console (Authentication -> Sign-in method).
      - Enable **Firestore Database** (Build -> Firestore Database -> Create database -> Start in test mode). Choose an appropriate region.
      - Enable **Firebase Storage** (Build -> Storage -> Get started -> Start in test mode).

3.  **Install Dependencies:**

    ```bash
    flutter pub get
    ```

4.  **(iOS Only) Install Pods:**
    ```bash
    cd ios
    pod install --repo-update
    cd ..
    ```
    _(Ensure your iOS deployment target is set to 13.0 or higher in `ios/Podfile`)_

## ▶️ Running the App

1.  Ensure you have an emulator running or a physical device connected.
2.  Run the app from your IDE or using the terminal:
    ```bash
    flutter run
    ```

## 🏗️ Project Structure (Brief Overview)

- `lib/`: Contains all the Dart code.
  - `core/`: Shared utilities, constants, widgets, theme, routing (`router.dart`).
  - `features/`: Feature-based organization (e.g., `auth`, `onboarding`, `splash`, `profile`).
    - `<feature_name>/data/`: Data sources, repositories, services (e.g., Firestore interaction).
    - `<feature_name>/domain/`: Business logic, models, use cases (optional for smaller apps).
    - `<feature_name>/presentation/`: UI related code (screens, widgets, state management specific to the feature).
  - `main.dart`: App entry point, Firebase initialization, `MaterialApp` setup.
  - `firebase_options.dart`: Generated Firebase configuration.
- `assets/`: Static assets like images and fonts.
