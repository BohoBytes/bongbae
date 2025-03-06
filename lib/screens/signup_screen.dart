import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  String _language = 'English';
  String _bio = '';
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _signup() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: _email, password: _password);
      // Save profile data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': _name,
        'email': _email,
        'language': _language,
        'bio': _bio,
        'profilePictureUrl': '', // later you can add image upload support
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Signup failed: ${e.toString()}')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BongBae Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Full Name'),
                  onSaved: (value) => _name = value!.trim(),
                  validator:
                      (value) =>
                          (value == null || value.isEmpty)
                              ? 'Enter your name'
                              : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  onSaved: (value) => _email = value!.trim(),
                  validator:
                      (value) =>
                          (value == null || !value.contains('@'))
                              ? 'Enter a valid email'
                              : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onSaved: (value) => _password = value!.trim(),
                  validator:
                      (value) =>
                          (value == null || value.length < 6)
                              ? 'Password too short'
                              : null,
                ),
                DropdownButtonFormField<String>(
                  value: _language,
                  decoration: InputDecoration(labelText: 'Preferred Language'),
                  items:
                      ['English', 'Bengali'].map((lang) {
                        return DropdownMenuItem(value: lang, child: Text(lang));
                      }).toList(),
                  onChanged: (value) {
                    setState(() => _language = value!);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Bio'),
                  onSaved: (value) => _bio = value!.trim(),
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: _signup,
                      child: Text('Sign Up'),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
