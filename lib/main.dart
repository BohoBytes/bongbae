import 'package:flutter/material.dart';
import 'core/router.dart'; // Import the router configuration
import 'core/theme/app_colors.dart'; // Import your color scheme
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Make main async to await Firebase and Router initialization
Future<void> main() async {
  // Ensure Flutter bindings are initialized first
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase Core and wait for it to complete
  // This MUST happen before any Firebase services are accessed
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Firebase Initialized in main.");

  // Instantiate the router AFTER Firebase is ready
  final AppRouter appRouter = AppRouter();

  // Wait for the router's internal asynchronous setup (prefs loading, listener setup)
  await appRouter.waitForInitialization();
  print("AppRouter Initialization Complete in main.");

  // Run the app, passing the fully initialized router
  runApp(BongBaeApp(appRouter: appRouter));
}

class BongBaeApp extends StatelessWidget {
  // Accept the appRouter instance
  final AppRouter appRouter;

  const BongBaeApp({
    super.key,
    required this.appRouter, // Require the router
  });

  @override
  Widget build(BuildContext context) {
    // Use MaterialApp.router and pass the routerConfig from the instance
    return MaterialApp.router(
      routerConfig:
          appRouter.router, // Use the router instance passed from main

      title: 'BongBae',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          tertiary: AppColors.tertiary,
          onPrimary: AppColors.textOnPrimary,
          onSecondary: AppColors.textOnSecondary,
          onTertiary: AppColors.textOnTertiary,
          // Consider setting background/surface colors if needed
          // background: Colors.white,
          // surface: Colors.white,
          error: Colors.redAccent, // Default error color
        ),
        // --- Consistent App Bar Theme ---
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor:
              Colors.black, // Color for icons/text on light background AppBar
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black,
          ), // Explicitly set back arrow color for light theme
        ),
        // --- Consistent Button Theme ---
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonBackground,
            foregroundColor: AppColors.textOnButton,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            // Apply text style directly for button text
            textStyle: const TextStyle(
              fontSize: 16, // Consistent font size for buttons
              fontWeight: FontWeight.w600, // Use SemiBold (w600)
              fontFamily: 'Maitree',
              // Color is set by foregroundColor above
            ),
          ),
        ),
        // --- Consistent Input Field Theme ---
        inputDecorationTheme: InputDecorationTheme(
          fillColor: AppColors.inputBackground,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14, // Match vertical padding for visual height
            horizontal: 16, // Padding inside the text field
          ),
          // Default style for hint text
          hintStyle: const TextStyle(
            fontSize: 16, // Font size for hint
            fontWeight: FontWeight.w400, // Regular weight for hint
            color: AppColors.tertiary, // Use hint text color
            fontFamily: 'Maitree',
          ),
          // Default border states (no border)
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none, // No border when focused either
            // Alternatively, show primary border on focus:
            // borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          // Error border (example: thin red border)
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.redAccent, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.redAccent, width: 2),
          ),
          // Style for error text below field
          errorStyle: const TextStyle(
            // fontSize: 12, // Smaller font for error text
            color: Colors.redAccent, // Use error color
            // fontFamily: 'Maitree', // Inherits global font
          ),
          prefixIconColor:
              AppColors.secondary, // Default color for prefix icons
        ),
        // --- Default Font ---
        fontFamily: 'Maitree',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // --- Consistent Snack Bar Theme ---
        snackBarTheme: const SnackBarThemeData(
          backgroundColor:
              AppColors.tertiary, // Default background for SnackBars
          contentTextStyle: TextStyle(
            // Default text style for SnackBar content
            color: AppColors.textOnTertiary, // Set default text color
            fontFamily: 'Maitree', // Ensures font consistency if needed
            fontSize: 14, // Optional: set font size
            fontWeight: FontWeight.w600,
          ),
          // You can also set 'actionTextColor', 'elevation', 'shape', etc.
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
