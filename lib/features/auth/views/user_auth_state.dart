import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/core/manager/user/user_manager.dart';
import 'package:news_app/features/auth/views/login_view.dart';
import 'package:news_app/features/views/home_view.dart';

class UserAuthState extends StatelessWidget {
  const UserAuthState({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // While checking authentication state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // If user is authenticated, initialize UserManager and show home
        if (snapshot.hasData && snapshot.data != null) {
          // Initialize user manager when user is authenticated
          UserManager.instance.initializeUser();
          return const HomeView();
        }
        
        // If user is not authenticated, show login
        return const LoginView();
      },
    );
  }
}