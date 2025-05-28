import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  AuthService? get value => null;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw FirebaseAuthException(
        code: 'empty-fields',
        message: 'Email i hasło nie mogą być puste.',
      );
    }
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw FirebaseAuthException(
        code: 'empty-fields',
        message: 'Email i hasło nie mogą być puste.',
      );
    }
    if (password.length < 6) {
      throw FirebaseAuthException(
        code: 'weak-password',
        message: 'Hasło musi mieć co najmniej 6 znaków.',
      );
    }
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    if (email.isEmpty) {
      throw FirebaseAuthException(
        code: 'empty-email',
        message: 'Email nie może być pusty.',
      );
    }
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUsername({required String username}) async {
    if (currentUser == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'Brak zalogowanego użytkownika.',
      );
    }
    await currentUser!.updateDisplayName(username);
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    if (currentUser == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'Brak zalogowanego użytkownika.',
      );
    }
    if (email.isEmpty || password.isEmpty) {
      throw FirebaseAuthException(
        code: 'empty-fields',
        message: 'Email i hasło nie mogą być puste.',
      );
    }
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.delete();
    await firebaseAuth.signOut();
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    if (currentUser == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'Brak zalogowanego użytkownika.',
      );
    }
    if (email.isEmpty || currentPassword.isEmpty || newPassword.isEmpty) {
      throw FirebaseAuthException(
        code: 'empty-fields',
        message: 'Email, obecne hasło i nowe hasło nie mogą być puste.',
      );
    }
    if (newPassword.length < 6) {
      throw FirebaseAuthException(
        code: 'weak-password',
        message: 'Nowe hasło musi mieć co najmniej 6 znaków.',
      );
    }
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);
  }
}
