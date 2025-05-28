import 'package:finanse/app/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'welcome_page.dart';
import 'start_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
    return;
  }

  authService.value = AuthService();
  print('authService initialized');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moja Aplikacja',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StreamBuilder<User?>(
        stream: authService.value.authStateChanges,
        builder: (context, snapshot) {
          print(
            'StreamBuilder snapshot: connectionState=${snapshot.connectionState}, hasData=${snapshot.hasData}, data=${snapshot.data}',
          );

          if (snapshot.connectionState == ConnectionState.waiting) {
            print('Waiting for auth state...');
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            print('User is logged in: ${snapshot.data?.uid}');
            return StartPage();
          }

          print('User is not logged in, showing WelcomePage');
          return WelcomePage();
        },
      ),
    );
  }
}
