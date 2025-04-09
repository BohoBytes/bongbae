// lib/core/router.dart

import 'dart:async'; // For Completer, StreamSubscription
import 'package:flutter/material.dart'; // For BuildContext, ValueNotifier, Widgets
import 'package:go_router/go_router.dart'; // For GoRouter, GoRouterState
import 'package:shared_preferences/shared_preferences.dart'; // For checking onboarding status
import 'package:firebase_auth/firebase_auth.dart'; // For FirebaseAuth, User
import 'package:firebase_core/firebase_core.dart'; // For Firebase class (Firebase.apps check)

// Import screen widgets (adjust paths if your structure is different)
import '../features/splash/presentation/screens/splash_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/signup_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';

// Placeholder widget for routes that are not yet built
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Placeholder for $title')),
    );
  }
}

// --- AppRouter Class ---
class AppRouter {
  // --- Configuration ---
  // Set to true to always show onboarding (for testing). Set to false for production.
  final bool _forceShowOnboarding = true;
  // Minimum duration the splash screen should be visible.
  final Duration _minSplashDuration = const Duration(seconds: 2);

  // --- State Management ---
  // Holds SharedPreferences instance after loading. Nullable initially.
  SharedPreferences? _prefs;
  // Signals when the asynchronous _initializeApp method is complete.
  final Completer<void> _initCompleter = Completer<void>();
  // Notifies GoRouter when the user's login state changes.
  final ValueNotifier<bool> _isLoggedIn = ValueNotifier<bool>(false);
  // Holds the subscription to Firebase Auth state changes to allow cancellation.
  StreamSubscription<User?>? _authStateSubscription;

  // --- GoRouter Instance ---
  // Declared late final, initialized in the constructor.
  late final GoRouter router;

  // --- Constructor ---
  AppRouter() {
    // Initialize GoRouter SYNCHRONOUSLY
    router = GoRouter(
      // Listen for login state changes to trigger route re-evaluation.
      refreshListenable: _isLoggedIn,
      // Start the app at the splash screen.
      initialLocation: '/splash',
      // Enable detailed logging for routing events in the debug console.
      debugLogDiagnostics: true,
      // --- Route Definitions ---
      routes: [
        GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
        GoRoute(
          path: '/onboarding',
          builder: (_, __) => const OnboardingScreen(),
        ),
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
        GoRoute(path: '/signup', builder: (_, __) => const SignupScreen()),
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        // TODO: Replace Placeholders with actual screen widgets later
        GoRoute(
          path: '/profile-setup',
          builder: (_, __) => const PlaceholderScreen(title: 'Profile Setup'),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (_, __) => const PlaceholderScreen(title: 'Forgot Password'),
        ),
      ],
      // --- Redirection Logic ---
      // This function runs before every navigation attempt.
      redirect: _redirectLogic,
    );
    // Start the asynchronous initialization process immediately after router setup.
    _initializeApp();
  }

  // --- Public Methods ---
  // A Future that completes when _initializeApp is done. Used by main.dart.
  Future<void> waitForInitialization() => _initCompleter.future;

  // Cleans up resources like stream subscriptions and notifiers.
  void dispose() {
    print("AppRouter: Disposing...");
    _authStateSubscription
        ?.cancel(); // Important: Cancel listener to prevent memory leaks
    _isLoggedIn.dispose();
  }

  // --- Private Initialization Logic ---
  // Performs asynchronous setup tasks.
  Future<void> _initializeApp() async {
    print("AppRouter: Initializing...");
    try {
      // Safeguard: Ensure Firebase was initialized in main.dart first.
      if (Firebase.apps.isEmpty) {
        throw Exception(
          "Firebase not initialized before AppRouter initialization.",
        );
      }
      print("AppRouter: Firebase core check passed.");

      final startTime = DateTime.now();

      // Load SharedPreferences to check onboarding status.
      _prefs = await SharedPreferences.getInstance();
      print("AppRouter: SharedPreferences loaded.");

      // Subscribe to Firebase Authentication state changes.
      _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen(
        (User? user) {
          final bool currentlyLoggedIn = user != null;
          // Only update and trigger refresh if the state actually changed.
          if (_isLoggedIn.value != currentlyLoggedIn) {
            print(
              "AppRouter: Auth state changed via Listener. LoggedIn = $currentlyLoggedIn",
            );
            _isLoggedIn.value =
                currentlyLoggedIn; // Update notifier, triggers router refresh
          }
        },
        onError: (error) {
          // Handle errors fetching auth state. Assume logged out on error.
          print("AppRouter: Error listening to auth state: $error");
          if (_isLoggedIn.value) {
            // Only update if state changes
            _isLoggedIn.value = false;
          }
        },
      );

      // Set the initial login state based on the current user when starting the listener.
      _isLoggedIn.value = FirebaseAuth.instance.currentUser != null;
      print("AppRouter: Initial login state check: ${_isLoggedIn.value}");

      // Enforce a minimum display time for the splash screen.
      final elapsedTime = DateTime.now().difference(startTime);
      final remainingTime = _minSplashDuration - elapsedTime;
      if (remainingTime > Duration.zero) {
        print(
          "AppRouter: Delaying for $remainingTime to meet min splash duration.",
        );
        await Future.delayed(remainingTime);
      }

      print("AppRouter: Initialization complete.");
      // Signal that initialization has successfully finished.
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }
    } catch (e) {
      print("AppRouter: Initialization failed: $e");
      // Signal that initialization failed.
      if (!_initCompleter.isCompleted) {
        _initCompleter.completeError(e);
      }
    }
  }

  // --- Private Redirect Logic ---
  // Determines if navigation should be redirected based on app state.
  String? _redirectLogic(BuildContext context, GoRouterState state) {
    final String currentLocation = state.uri.toString();

    // 1. Wait for Initialization
    // If async initialization isn't finished OR SharedPreferences failed to load,
    // stay on the splash screen. Allow navigation *only* to '/splash'.
    if (!_initCompleter.isCompleted || _prefs == null) {
      print(
        "Redirect check: Waiting for initialization. Location=$currentLocation",
      );
      return currentLocation == '/splash' ? null : '/splash';
    }

    // --- Initialization IS Complete ---
    // Safely access state variables now. Use '!' because we checked _prefs != null above.
    final bool onboardingComplete =
        _prefs!.getBool('onboarding_complete') ?? false;
    final bool loggedIn = _isLoggedIn.value;

    print(
      "Redirect check: Initialized=true, OnboardingComplete=$onboardingComplete, LoggedIn=$loggedIn, Location=$currentLocation",
    );

    // --- Handle Splash Screen Post-Initialization ---
    // If we are still on splash after init, decide where to go next.
    if (currentLocation == '/splash') {
      if (_forceShowOnboarding) {
        // Check debug flag first
        print("Redirecting from /splash -> /onboarding (Forced)");
        return '/onboarding';
      }
      if (!onboardingComplete) {
        // Not complete? Go to onboarding.
        print("Redirecting from /splash -> /onboarding (Not Complete)");
        return '/onboarding';
      }
      // Onboarding complete? Go to home if logged in, else login.
      final target = loggedIn ? '/home' : '/login';
      print("Redirecting from /splash -> $target (Onboarding Complete)");
      return target;
    }

    // --- Handle Onboarding Route ---
    // If onboarding is NOT complete:
    if (!onboardingComplete) {
      // Allow only '/splash' (which redirects away anyway) or '/onboarding'.
      // Force redirect to '/onboarding' if trying to access anything else.
      if (currentLocation != '/onboarding') {
        print(
          "Redirecting to /onboarding (Not Complete, tried $currentLocation)",
        );
        return '/onboarding';
      }
      // If already on '/onboarding', stay there.
      print(
        "No redirect needed (Onboarding Not Complete, Location: /onboarding)",
      );
      return null;
    }

    // --- Onboarding IS Complete ---
    // From here, onboardingComplete is true. Base decisions on login status.

    final bool isGoingToAuthRoute =
        currentLocation == '/login' || currentLocation == '/signup';
    final bool isGoingToOnboarding =
        currentLocation == '/onboarding'; // Should redirect away

    // Handle Logged OUT State (Onboarding Complete)
    if (!loggedIn) {
      // If logged out, allow only auth routes. Redirect everything else to login.
      // We don't need to check for splash here because the splash redirect logic above handles it.
      // We also redirect away from onboarding explicitly.
      if (!isGoingToAuthRoute && !isGoingToOnboarding) {
        print("Redirecting to /login (Not logged in, tried $currentLocation)");
        return '/login';
      }
      // Allow navigation to auth routes if logged out.
      print("No redirect needed (Logged Out, Location: $currentLocation)");
      return null;
    }

    // Handle Logged IN State (Onboarding Complete)
    if (loggedIn) {
      // If logged IN, redirect away from onboarding and auth routes.
      if (isGoingToOnboarding || isGoingToAuthRoute) {
        print(
          "Redirecting to /home (Already logged in, tried $currentLocation)",
        );
        return '/home'; // Or '/profile-setup' etc.
      }
      // Allow navigation to other routes (like /home) if logged in.
      print("No redirect needed (Logged In, Location: $currentLocation)");
      return null;
    }

    // Fallback: Should generally not be reached if logic is sound.
    print("Redirect fallback: No redirect needed for $currentLocation");
    return null;
  }
}

// REMOVED Global instance: 'main' now creates and manages the AppRouter instance.
