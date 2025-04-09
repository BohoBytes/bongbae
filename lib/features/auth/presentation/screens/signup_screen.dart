import 'package:bong_bae/core/theme/app_colors.dart'; // Ensure AppColors is defined correctly
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/widgets/themed_text_field.dart'; // Import your custom text field
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- Signup Logic ---
  Future<void> _signup() async {
    // 1. Validate Form
    if (!(_formKey.currentState?.validate() ?? false)) {
      return; // Stop if form is not valid
    }

    // 2. Set Loading State
    setState(() {
      _isLoading = true;
    });

    try {
      // 3. Create User in Firebase Authentication
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password:
                _passwordController.text
                    .trim(), // Firebase validates password strength
          );

      print("Firebase Auth User Created: ${userCredential.user?.uid}");

      // 4. Save User Data to Firestore (if Auth succeeded)
      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        try {
          // Prepare data for Firestore
          final Map<String, dynamic> userData = {
            'uid': firebaseUser.uid,
            'email': firebaseUser.email, // Save email (can be useful)
            'name': _nameController.text.trim(), // Save name from form
            'createdAt': Timestamp.now(), // Use server timestamp
            'profileComplete': false, // Example flag for profile setup status
            // 'profilePhotoUrl': null, // Placeholder for photo later
          };

          // Write data to 'users' collection with UID as document ID
          await FirebaseFirestore.instance
              .collection('users')
              .doc(firebaseUser.uid)
              .set(userData);

          print("User data saved to Firestore for UID: ${firebaseUser.uid}");

          // NOTE: Navigation is handled by GoRouter listening to Auth state changes.
          // No explicit navigation here after successful signup/login.
        } catch (firestoreError) {
          print("Error saving user data to Firestore: $firestoreError");
          // Show a warning, but let the user proceed (they are logged in)
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Account created, but failed to save profile details.',
                  style: TextStyle(
                    color: Colors.black,
                  ), // Ensure text is visible
                ),
                backgroundColor: Colors.orangeAccent,
              ),
            );
          }
          // In a production app, consider more robust error handling here.
        }
      } else {
        // This case should be rare if createUser succeeded.
        print("Error: Firebase user object was null after creation.");
        throw Exception("User creation failed unexpectedly.");
      }

      // 5. Reset Loading State (only if signup succeeded AND still mounted)
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      // 6. Handle Firebase Auth Errors
      String errorMessage = 'An error occurred. Please try again.';
      // Provide specific user-friendly messages
      if (e.code == 'email-already-in-use') {
        errorMessage =
            'This email address is already registered. Please Log In.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak (minimum 6 characters).';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      }
      // Log the actual error code for debugging
      print("Signup Auth Error Code: ${e.code}");

      if (mounted) {
        setState(() {
          _isLoading = false;
        }); // Stop loading on error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ), // Set text color
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      // 7. Handle Other Unexpected Errors
      print("Signup General Error: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        }); // Stop loading on error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'An unexpected error occurred during signup.',
              style: TextStyle(color: Colors.white),
            ), // Set text color
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      // 8. Ensure loading is always reset if widget is still mounted
      // This handles cases where an error occurred but wasn't caught above,
      // or if setState wasn't called due to timing.
      if (mounted && _isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // ** Potential Contrast Issue Check **
    // Verify these colors contrast well with 'assets/images/splash_bg.png'
    final Color titleColor =
        theme.colorScheme.primary; // Yellow/Gold might be hard to read?
    final Color linkTextColor =
        AppColors.tertiary; // Beige might be hard to read?
    final Color loginLinkColor = theme.colorScheme.primary; // Yellow/Gold

    return Scaffold(
      // Removed AppBar based on previous request
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                // Ensure this background allows text contrast
                image: AssetImage('assets/images/splash_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content Area
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo
                      Image.asset(
                        'assets/images/logo.png',
                        height: 150, // Adjust size as needed
                      ),
                      const SizedBox(height: 20),

                      // Title
                      Text(
                        'Create your BongBae account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: titleColor, // ** CHECK CONTRAST **
                          fontFamily: 'Maitree',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),

                      // Name Field
                      ThemedTextField(
                        controller: _nameController,
                        // Uses theme's InputDecoration for fill, border, etc.
                        // Uses ThemedTextField's default style for typed text.
                        decoration: const InputDecoration(
                          hintText: 'Full Name',
                          // Hint style comes from theme
                          // Prefix icon can be added here if needed
                        ),
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email Field
                      ThemedTextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email Address',
                          // prefixIcon: Icon(Icons.email_outlined), // Icon color from theme
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      ThemedTextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          // prefixIcon: Icon(Icons.lock_outline), // Icon color from theme
                          suffixIcon: IconButton(
                            // Icon color relies on theme's iconTheme or decoration's iconColor
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed:
                                () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password Field
                      ThemedTextField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          // prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed:
                                () => setState(
                                  () =>
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword,
                                ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Signup Button
                      ElevatedButton(
                        // Style comes from theme's elevatedButtonTheme
                        onPressed: _isLoading ? null : _signup,
                        child:
                            _isLoading
                                ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    // ** CHECK CONTRAST ** Use color that shows on button background
                                    color:
                                        AppColors
                                            .textOnButton, // Likely White or Black
                                  ),
                                )
                                : const Text(
                                  'Sign Up',
                                ), // Text style from theme
                      ),
                      const SizedBox(height: 16),

                      // Link back to Login
                      TextButton(
                        onPressed:
                            _isLoading
                                ? null
                                : () {
                                  // Disable button when loading
                                  if (context.canPop()) {
                                    context
                                        .pop(); // Use pop if possible (standard back behavior)
                                  } else {
                                    context.go(
                                      '/login',
                                    ); // Fallback if cannot pop
                                  }
                                },
                        child: RichText(
                          textAlign:
                              TextAlign.center, // Center align the text link
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(
                              color: linkTextColor, // ** CHECK CONTRAST **
                              fontFamily: 'Maitree',
                              fontSize: 16, // Adjusted size slightly
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Log In',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: loginLinkColor, // ** CHECK CONTRAST **
                                  // Inherits family and size unless overridden
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
