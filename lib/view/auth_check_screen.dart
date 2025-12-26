// In main.dart or view/main_screens/auth_check_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase User
import 'package:ubwinza_admin_dashboard/core/services/auth_service.dart';
import 'package:ubwinza_admin_dashboard/features/auth/login_screen.dart'; // Your login screen
import 'package:ubwinza_admin_dashboard/view/main_screens/home_screen.dart'; // Your main content screen

class AuthCheckScreen extends StatelessWidget {
  const AuthCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Listen to the auth state stream
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        // 2. Show a loading indicator while connecting to Firebase
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 3. Check the data (the User object)
        final user = snapshot.data;

        if (user == null) {
          // If the user is NULL, they are NOT logged in.
          // Show the Login screen.
          return const LoginScreen();
        } else {
          // If the user is NOT NULL, they ARE logged in.
          // Show the main content screen.
          return const HomeScreen();
        }
      },
    );
  }
}