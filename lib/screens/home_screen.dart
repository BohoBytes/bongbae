import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot> _getUsers() {
    final currentUser = _auth.currentUser;
    return _firestore
        .collection('users')
        .where('email', isNotEqualTo: currentUser?.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BongBae - Profiles'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return Center(child: Text('No users found.'));
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(userData['name'] ?? 'No Name'),
                subtitle: Text(userData['bio'] ?? ''),
                trailing: Text(userData['language'] ?? ''),
                // Tapping can later navigate to a detailed profile view
              );
            },
          );
        },
      ),
    );
  }
}
