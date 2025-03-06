import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _bio = '';
  String _language = 'English';
  File? _imageFile;
  String? _profileImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final userDoc =
        await _firestore.collection('users').doc(currentUser.uid).get();
    if (userDoc.exists) {
      setState(() {
        _name = userDoc['name'] ?? '';
        _bio = userDoc['bio'] ?? '';
        _language = userDoc['language'] ?? 'English';
        _profileImageUrl = userDoc['profilePictureUrl'];
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future<void> _uploadProfilePicture() async {
    if (_imageFile == null) return;

    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final ref = _storage.ref().child(
        'profile_pictures/${currentUser.uid}.jpg',
      );
      await ref.putFile(_imageFile!);
      final imageUrl = await ref.getDownloadURL();

      await _firestore.collection('users').doc(currentUser.uid).update({
        'profilePictureUrl': imageUrl,
      });

      setState(() {
        _profileImageUrl = imageUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile picture updated successfully!')),
      );
    } catch (e) {
      print('🔥 Error uploading image: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to upload image')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _firestore.collection('users').doc(currentUser.uid).update({
        'name': _name,
        'bio': _bio,
        'language': _language,
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Profile updated successfully!')));
      Navigator.pop(context); // Go back to previous screen
    } catch (e) {
      print('🔥 Error saving profile: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update profile')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _imageFile != null
                          ? FileImage(_imageFile!)
                          : (_profileImageUrl != null
                                  ? NetworkImage(_profileImageUrl!)
                                  : AssetImage('assets/default_avatar.png'))
                              as ImageProvider,
                  child:
                      _isLoading
                          ? CircularProgressIndicator()
                          : Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: Colors.white70,
                          ),
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _name,
                      decoration: InputDecoration(labelText: 'Full Name'),
                      onSaved: (value) => _name = value!.trim(),
                      validator:
                          (value) =>
                              (value == null || value.isEmpty)
                                  ? 'Enter your name'
                                  : null,
                    ),
                    TextFormField(
                      initialValue: _bio,
                      decoration: InputDecoration(labelText: 'Bio'),
                      onSaved: (value) => _bio = value!.trim(),
                    ),
                    DropdownButtonFormField<String>(
                      value: _language,
                      decoration: InputDecoration(
                        labelText: 'Preferred Language',
                      ),
                      items:
                          ['English', 'Bengali'].map((lang) {
                            return DropdownMenuItem(
                              value: lang,
                              child: Text(lang),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() => _language = value!);
                      },
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                          onPressed: _saveProfile,
                          child: Text('Save Profile'),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
