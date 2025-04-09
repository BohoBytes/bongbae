import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String imagePath; // Path to the TRANSPARENT foreground image
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // *** IMPORTANT: Set text colors that contrast with your COMMON BACKGROUND ***
    // Adjust these based on whether your common background is light or dark.
    final titleStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontSize: 52,
      letterSpacing: -2,
      height: 0.9,
      color:
          Theme.of(
            context,
          ).colorScheme.primary, // Example: White text for a dark background
      // Remove shadows if the common background is simple
    );
    final descriptionStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      color: Colors.white, // Example: White text for a dark background
      fontSize: 22,
      letterSpacing: 0.4,
      fontWeight: FontWeight.w400,
      height: 1.5,
    );
    const String logoPath = 'assets/images/logo.png';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: screenHeight * 0.005),
          Image.asset(
            logoPath,
            height: 120, // <-- Adjust logo height as desired
            // Width will scale automatically based on height and aspect ratio
          ),
          // ** NEW: Spacing below logo **
          SizedBox(height: screenHeight * 0.005),
          // 1. Transparent Foreground Image
          Flexible(
            // Use Flexible to allow image to size naturally within limits
            flex: 3, // Give image more space
            child: Image.asset(
              imagePath, // This is the SQUARE TRANSPARENT image
              height:
                  screenHeight * 0.30, // Adjust size as needed for square image
              fit:
                  BoxFit
                      .contain, // Use contain to see the whole transparent image
            ),
          ),
          SizedBox(height: screenHeight * 0.02), // Spacing
          // 2. Text Content below the image
          Flexible(
            flex: 1, // Give text less space
            child: Column(
              children: [
                Text(title, textAlign: TextAlign.center, style: titleStyle),
                const SizedBox(height: 16.0),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: descriptionStyle,
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.08), // Spacer at the bottom
        ],
      ),
    );
  }
}
