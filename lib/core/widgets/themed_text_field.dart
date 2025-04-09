import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart'; // Import your AppColors

class ThemedTextField extends StatelessWidget {
  // Define the default style for the typed text
  static const TextStyle _defaultTextStyle = TextStyle(
    color: AppColors.secondary, // Your desired color
    fontSize: 20,
    fontWeight: FontWeight.w500, // Corresponds to semi-bold usually
    fontFamily: 'Maitree', // Ensure font is included
  );

  // Pass through common TextFormField properties
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final bool? enabled;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final int? maxLines;
  final int? minLines;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  // Add any other TextFormField properties you commonly use

  const ThemedTextField({
    super.key,
    this.controller,
    this.decoration,
    this.keyboardType,
    this.obscureText = false, // Default to false
    this.validator,
    this.inputFormatters,
    this.initialValue,
    this.enabled,
    this.onChanged,
    this.onTap,
    this.onFieldSubmitted,
    this.onSaved,
    this.maxLines = 1, // Default for standard text field
    this.minLines,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    // Get the theme's Input Decoration settings
    final effectiveDecoration = (decoration ?? const InputDecoration())
        .applyDefaults(Theme.of(context).inputDecorationTheme);

    return TextFormField(
      // Apply the default style HERE
      style: _defaultTextStyle,

      // Pass through all the properties
      controller: controller,
      decoration: effectiveDecoration, // Use the merged decoration
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      inputFormatters: inputFormatters,
      initialValue: initialValue,
      enabled: enabled,
      onChanged: onChanged,
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      maxLines: maxLines,
      minLines: minLines,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      focusNode: focusNode,
    );
  }
}
