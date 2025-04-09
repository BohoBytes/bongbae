import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for system UI overlay style
import 'package:bong_bae/core/theme/app_colors.dart'; // Assuming AppColors is defined here

// No longer need PlaceholderNextScreen or OnboardingScreen import here

class SplashScreen extends StatelessWidget {
  // Change to StatelessWidget
  const SplashScreen({super.key});

  // No initState or _navigateToNextScreen needed anymore

  @override
  Widget build(BuildContext context) {
    // Optional: Set status bar style if needed
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    // Access theme colors if needed (though you used AppColors directly)
    // final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            // *** Make sure this path is correct ***
            image: AssetImage('assets/images/splash_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png', // Make sure path is correct
                height: 236, // Your desired logo height
              ),
              const SizedBox(height: 5),
              Text(
                'BongBae',
                style: TextStyle(
                  fontSize: 64, // Your desired font size
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary, // Use your primary color
                ),
              ),
              const SizedBox(height: 20), // Spacing before indicator
              CircularProgressIndicator(
                color: AppColors.primary, // Use your primary color
                strokeWidth: 3.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
