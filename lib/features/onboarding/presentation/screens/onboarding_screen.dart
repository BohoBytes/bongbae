import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import the single page widget
import '../widgets/onboarding_page.dart';

// Temporary placeholder for the screen after onboarding
// TODO: Later, replace this with your actual Authentication Screen import
class PlaceholderAuthScreen extends StatelessWidget {
  const PlaceholderAuthScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor:
          Colors.tealAccent, // Make it obvious it's the placeholder
      body: Center(child: Text("PLACEHOLDER\nAuthentication Screen Goes Here")),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Controller to manage the PageView
  final PageController _pageController = PageController();

  // State variable to track the current page index
  int _currentPageIndex = 0;

  // ***** IMPORTANT: UPDATE THIS LIST WITH YOUR CONTENT *****
  // Define the data for each onboarding page
  final List<Map<String, String>> onboardingContent = [
    {
      'imagePath':
          'assets/images/onboarding_1.png', // <-- Make sure this file exists!
      'title': 'Welcome to BongBae!', // <-- Use your text
      'description': 'Find your perfect Bengali match.', // <-- Use your text
    },
    {
      'imagePath':
          'assets/images/onboarding_2.png', // <-- Make sure this file exists!
      'title': 'Discover & Connect', // <-- Use your text
      'description':
          'Swipe through profiles, express interest, and connect safely.', // <-- Use your text
    },
    {
      'imagePath':
          'assets/images/onboarding_3.png', // <-- Make sure this file exists!
      'title': 'Start Your Journey', // <-- Use your text
      'description':
          'Create your profile and begin your search for love today.', // <-- Use your text
    },
    // Add more maps here if you have more onboarding pages
  ];
  // **********************************************************

  Future<void> _completeOnboarding() async {
    // Make it async
    print("Completing onboarding...");
    try {
      // Save the flag indicating onboarding is done
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_complete', true);
      print("Onboarding complete flag saved.");

      if (mounted) {
        // Navigate to the Login screen using GoRouter's context.go
        // 'go' replaces the entire stack, suitable after onboarding/login
        context.go('/login');
        print("Navigating to /login");
      }
    } catch (e) {
      print("Error saving preferences or navigating: $e");
      // Optionally show an error message to the user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error saving settings. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose(); // IMPORTANT: Clean up the controller!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLastPage = _currentPageIndex == onboardingContent.length - 1;
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    // final Color secondaryColor = Theme.of(context).colorScheme.secondary;
    final Color buttonTextColor = Theme.of(context).colorScheme.onPrimary;
    final EdgeInsets safePadding = MediaQuery.of(context).padding;

    // ***** Make sure this path points to your COMMON background *****
    const String commonBackgroundPath = 'assets/images/splash_bg.png';
    // *****************************************************************

    return Scaffold(
      // Scaffold is just a container now, background is inside the Stack
      body: Stack(
        // Use Stack for layering: Background -> PageView -> Controls
        fit: StackFit.expand, // Make Stack fill the Scaffold body
        children: [
          // 1. Common Background Image (Bottom layer)
          Image.asset(
            commonBackgroundPath,
            fit: BoxFit.cover, // Cover the whole screen
            width: double.infinity,
            height: double.infinity,
          ),

          // 2. PageView (Middle layer - shows transparent images/text)
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingContent.length,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final item = onboardingContent[index];
              // OnboardingPage now only contains the foreground image and text
              return OnboardingPage(
                // Ensure 'imagePath' in your onboardingContent list
                // now points to the TRANSPARENT SQUARE images
                imagePath: item['imagePath']!,
                title: item['title']!,
                description: item['description']!,
              );
            },
          ),

          // 3. Skip Button (Top Right - Overlay)
          Positioned(
            top: safePadding.top + 10,
            right: 16,
            child: TextButton(
              onPressed: _completeOnboarding,
              // Optional: Add subtle background for better visibility on varied backgrounds
              style: TextButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
              ),
              child: Text(
                'Skip',
                style: TextStyle(
                  // ** Ensure contrast against your common background **
                  color: Colors.white, // Example: White for dark background
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          // 4. Bottom Controls Area (Indicator and Button - Overlay)
          Positioned(
            bottom: safePadding.bottom + 20,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Page Indicator
                SmoothPageIndicator(
                  controller: _pageController,
                  count: onboardingContent.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: primaryColor,
                    // ** Choose inactive color contrasting with common background **
                    dotColor: Colors.white.withOpacity(
                      0.6,
                    ), // Example for dark background
                  ),
                  onDotClicked: (index) {
                    /* ... */
                  },
                ),

                // Next / Get Started Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: buttonTextColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    if (isLastPage) {
                      _completeOnboarding();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  }, // Logic remains the same
                  child: Text(
                    isLastPage ? 'Get Started' : 'Next',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
