import 'package:firebase_auth/firebase_auth.dart'; // Add import
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Add import for context.go

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          // TEMP LOGOUT BUTTON
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () async {
              print("Signing out...");
              await FirebaseAuth.instance.signOut();
              print("Signed out. Router should redirect.");
              // GoRouter's listener will automatically redirect to /login
              // You could add context.go('/login'); but it's often redundant
            },
          ),
        ],
      ),
      body: Center(child: Text('Welcome!')),
    );
  }
}
