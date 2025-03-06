import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import for logout redirection
import 'edit_profile_screen.dart'; // Import for edit profile screen

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  HomeScreen({super.key});

  Future<List<QueryDocumentSnapshot>> _getUsers() async {
    final currentUser = _auth.currentUser;

    // Ensure user is authenticated before querying Firestore
    if (currentUser == null) {
      return [];
    }

    // Query Firestore to fetch all users except the logged-in user
    QuerySnapshot snapshot = await _firestore.collection('users').get();

    return snapshot.docs;
  }

  void _logout(BuildContext context) async {
    await _auth.signOut(); // Sign out from Firebase
    Navigator.pushReplacement(
      // Navigate back to LoginScreen
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BongBae - Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit), // Edit Profile Button
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context), // Corrected logout behavior
          ),
        ],
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No Users Found',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(userData['name'] ?? 'No Name'),
                subtitle: Text(userData['bio'] ?? 'No Bio'),
                trailing: Text(userData['language'] ?? 'N/A'),
              );
            },
          );
        },
      ),
    );
  }
}
