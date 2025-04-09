import 'package:bong_bae/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import '../../../../../core/widgets/themed_text_field.dart'; // Import your custom text field
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // For form validation later
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true; // To toggle password visibility
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // Check form validity first
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    // Set loading state
    setState(() {
      _isLoading = true;
    });

    try {
      // Attempt sign in using FirebaseAuth directly
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // GoRouter's redirect will handle navigation on successful login
      // No manual navigation needed here.

      // If login is very fast and widget is still mounted, stop loading
      // (though redirect usually handles this)
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        errorMessage = 'Incorrect email or password.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'This account has been disabled.';
      }
      // TODO: Handle 'too-many-requests' if needed
      print("Login Error Code: ${e.code}"); // Log the actual error code

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      // Handle unexpected errors
      print("Login Error: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An unexpected error occurred.'),
            backgroundColor: AppColors.tertiary,
          ),
        );
      }
    }
    // Ensure loading stops if login fails and widget is still mounted
    if (mounted && _isLoading) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access theme for colors/styles

    return Scaffold(
      // Optional: Add an AppBar if your design has one
      // appBar: AppBar(title: const Text('Login')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            // Use SafeArea
            child: Center(
              // Center the content
              child: SingleChildScrollView(
                // Allows scrolling if content overflows
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  // Wrap content in a Form
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch, // Stretch buttons
                    children: [
                      Image.asset(
                        'assets/images/logo.png', // Make sure path is correct
                        height: 200,
                      ),
                      const SizedBox(height: 50),

                      // Email Field
                      ThemedTextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Email / Phone Number',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          // Basic validation
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            // Very basic check
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      ThemedTextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword, // Hide/show password
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            // Example minimum length
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 50),

                      // Login Button
                      ElevatedButton(
                        onPressed:
                            _isLoading
                                ? null
                                : _login, // Call the login function
                        child:
                            _isLoading
                                ? const SizedBox(
                                  // Show progress indicator when loading
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color:
                                        AppColors
                                            .primary, // Or your desired color
                                  ),
                                )
                                : const Text(
                                  'Log In',
                                ), // Text already styled by theme
                      ),
                      const SizedBox(height: 14),

                      // Link to Sign Up Screen
                      TextButton(
                        onPressed:
                            _isLoading ? null : () => context.push('/signup'),
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              color: AppColors.tertiary,
                              fontFamily: 'Maitree',
                              fontSize: 18,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      theme
                                          .colorScheme
                                          .primary, // Highlight link
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // TODO: Add 'Forgot Password?' TextButton here if needed
                      // TextButton(onPressed: () { context.push('/forgot-password'); }, child: Text('Forgot Password?')),

                      // TODO: Add Social Login Buttons (Google, Facebook, etc.) here if needed
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
