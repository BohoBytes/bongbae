import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bongbae/screens/login_screen.dart';
import 'package:bongbae/screens/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(BongbaeApp());
}

class BongbaeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BongBae MVP',
      theme: ThemeData(primarySwatch: Colors.teal),
      home:
          LoginScreen(), // Start with login screen; later add auth state handling
      routes: {'/home': (context) => HomeScreen()},
    );
  }
}
