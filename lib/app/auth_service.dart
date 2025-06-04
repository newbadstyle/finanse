import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

ValueNotifier<AuthService> authService = ValueNotifier<AuthService>(
  AuthService(),
);

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signIn({required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      throw FirebaseAuthException(
        code: 'empty-fields',
        message: 'Email and Password cannot be empty.',
      );
    }
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<void> createAccount({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw FirebaseAuthException(
        code: 'empty-fields',
        message: 'Email and Password cannot be empty.',
      );
    }
    if (password.length < 6) {
      throw FirebaseAuthException(
        code: 'weak-password',
        message: 'Password must have at least 6 characters.',
      );
    }
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<void> resetPassword({required String email}) async {
    if (email.isEmpty) {
      throw FirebaseAuthException(
        code: 'empty-email',
        message: 'Email cannot be empty.',
      );
    }
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
