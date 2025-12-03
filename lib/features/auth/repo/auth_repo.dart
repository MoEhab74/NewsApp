import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app/features/auth/models/user_model.dart';

class AuthRepo {
  // Users Collection
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );

  // Get current uid
  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  Future<UserModel?> login(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;
      

      final doc = await users.doc(uid).get();

      if (!doc.exists) {
        log("User exists in auth but missing in Firestore.");
        return null;
      }

      // 3) Convert Firestore data → UserModel
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    } on FirebaseAuthException catch (e) {
      log("Auth error: ${e.code}");
      return null;
    } catch (e) {
      log("Unknown error: $e");
      return null;
    }
  }

  Future<UserModel?> signUp(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = credential.user!.uid;

      final userModel = UserModel(id: uid, email: email);

      // Write to Firestore
      await users.doc(uid).set(userModel.toJson());

      // Return the user model
      return userModel;
    } on FirebaseAuthException catch (e) {
      log("Signup error: ${e.code}");
      return null;
    } catch (e) {
      log("Unknown error: $e");
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      log("Logout error: ${e.code}");
    } catch (e) {
      log("Unknown error: $e");
    }
  }
}
