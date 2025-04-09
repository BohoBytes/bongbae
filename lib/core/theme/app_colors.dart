import 'package:flutter/material.dart';

abstract class AppColors {
  // Define your color scheme here
  static const Color primary = Color(0xFFF1BD38);
  static const Color secondary = Color(0xFF680506); // Dark Red/Brownish
  static const Color tertiary = Color(0xFFE4D2BB); // Beige/Light Tan
  static const Color buttonBackground = Color(0xFFC28036);
  static const Color inputBackground = Color(0xFFC58D64); // Tan/Brown
  // Define contrast colors (adjust as needed!)
  static const Color textOnPrimary = Color(0xFF680506);
  static const Color textOnSecondary = Color(0xFFE4D2BB);
  static const Color textOnTertiary = Color(0xFF680506); // Text on beige
  static const Color textOnButton = Color(0xFF680506); // Text on golden brown
  static const Color textOnInput = Color(0xFFE4D2BB);
}
