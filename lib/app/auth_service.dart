import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

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
    try {
      return await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Sign in error: $e');
      throw FirebaseAuthException(
        code: 'sign-in-failed',
        message: 'Błąd logowania: ${e.toString()}',
      );
    }
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
    try {
      return await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Create account error: $e');
      throw FirebaseAuthException(
        code: 'create-account-failed',
        message: 'Błąd rejestracji: ${e.toString()}',
      );
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
      print('Sign out successful');
    } catch (e) {
      print('Sign out error: $e');
      throw FirebaseAuthException(
        code: 'sign-out-failed',
        message: 'Błąd wylogowania: ${e.toString()}',
      );
    }
  }

  Future<void> resetPassword({required String email}) async {
    if (email.isEmpty) {
      throw FirebaseAuthException(
        code: 'empty-email',
        message: 'Email nie może być pusty.',
      );
    }
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      print('Password reset email sent');
    } catch (e) {
      print('Reset password error: $e');
      throw FirebaseAuthException(
        code: 'reset-password-failed',
        message: 'Błąd resetowania hasła: ${e.toString()}',
      );
    }
  }

  Future<void> updateUsername({required String username}) async {
    if (currentUser == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'Brak zalogowanego użytkownika.',
      );
    }
    try {
      await currentUser!.updateDisplayName(username);
      print('Username updated successfully');
    } catch (e) {
      print('Update username error: $e');
      throw FirebaseAuthException(
        code: 'update-username-failed',
        message: 'Błąd aktualizacji nazwy użytkownika: ${e.toString()}',
      );
    }
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
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await currentUser!.reauthenticateWithCredential(credential);
      await currentUser!.delete();
      await firebaseAuth.signOut();
      print('Account deleted successfully');
    } catch (e) {
      print('Delete account error: $e');
      throw FirebaseAuthException(
        code: 'delete-account-failed',
        message: 'Błąd usuwania konta: ${e.toString()}',
      );
    }
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
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );
      await currentUser!.reauthenticateWithCredential(credential);
      await currentUser!.updatePassword(newPassword);
      print('Password updated successfully');
    } catch (e) {
      print('Reset password from current password error: $e');
      throw FirebaseAuthException(
        code: 'reset-password-failed',
        message: 'Błąd resetowania hasła: ${e.toString()}',
      );
    }
  }
}
