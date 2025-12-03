import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManager {
  /// User Manager will handle user authentication state and profile info
  /// So that we should handle all user information through only one instance of this class
  /// UserManager inastance will be used throughout any operation in UserManager to get the current user info
  static const String _userNameKey = 'user_display_name';

  static UserManager? _instance;
  static UserManager get instance => _instance ??= UserManager._();
  // Private constructor
  UserManager._();

  String? _currentUserId;
  String? _currentUserName;

  String? get currentUserId => _currentUserId;
  String? get currentUserName => _currentUserName;

  /// Force re-initialization if user ID is null
  Future<void> ensureUserInitialized() async {
    if (_currentUserId == null) {
      log('UserManager: Current user ID is null, forcing re-initialization...');
      await initializeUser();
    }
  }

  /// Initialize user system with Firebase Auth
  /// Firebase and SharedPreferences synchronization
  Future<void> initializeUser() async {
    final user = FirebaseAuth.instance.currentUser;
    
    log('UserManager: Initializing user...');
    log('UserManager: Firebase currentUser = ${user?.uid ?? 'null'}');

    if (user != null) {
      // Get the userId and userName from Firebase
      _currentUserId = user.uid;
      _currentUserName = user.displayName;
      
      log('UserManager: Authenticated user initialized - ID: $_currentUserId, Name: $_currentUserName');
      
      // If displayName doesn't exist in firebase, check SharedPreferences, then generate from email
      if (_currentUserName == null || _currentUserName!.isEmpty) {
        final prefs = await SharedPreferences.getInstance();
        _currentUserName = prefs.getString(_userNameKey);

        if (_currentUserName == null || _currentUserName!.isEmpty) {
          _currentUserName = _getDisplayNameFromEmail(user.email);
          await prefs.setString(_userNameKey, _currentUserName!);
        }
        
        log('UserManager: Display name updated to: $_currentUserName');
      }
    } else {
      // User is not logged in - clear user data
      _currentUserId = null;
      _currentUserName = null;
      
      log('UserManager: No authenticated user found');
    }
    
    log('UserManager: Final state - ID: $_currentUserId, Name: $_currentUserName, Authenticated: $isAuthenticated');
  }



  /// Extract display name from email
  String _getDisplayNameFromEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'User${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    }

    final name = email.split('@')[0];
    return name.substring(0, 1).toUpperCase() + name.substring(1);
  }

  /// Update user name (sync with Firebase if authenticated)
  Future<void> updateUserName(String newName) async {
    if (newName.trim().isEmpty) return;

    _currentUserName = newName;

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, newName);

    // If user is authenticated with Firebase, update display name
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.updateDisplayName(newName);

        // Also update in Firestore if user document exists
        final userDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);
        final docSnapshot = await userDoc.get();
        if (docSnapshot.exists) {
          await userDoc.update({'displayName': newName});
        }
      } catch (e) {
        // If Firebase update fails, we still have it in SharedPreferences
      }
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated => FirebaseAuth.instance.currentUser != null;

  /// Get user email (only for authenticated users)
  String? get userEmail => FirebaseAuth.instance.currentUser?.email;



}
