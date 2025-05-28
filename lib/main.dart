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
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'JosefinSans'),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: StreamBuilder<User?>(
        stream: authService.value.authStateChanges,
        builder: (context, snapshot) {
          print(
            'StreamBuilder snapshot: connectionState=${snapshot.connectionState}, hasData=${snapshot.hasData}, data=${snapshot.data}',
          );

          if (snapshot.connectionState == ConnectionState.waiting) {
            print('Waiting for auth state...');
            return Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE0F2F1), Color(0xFFB2DFDB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ładowanie...',
                        style: TextStyle(
                          fontFamily: 'JosefinSans',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2A6F5B),
                        ),
                      ),
                      SizedBox(height: 20),
                      CircularProgressIndicator(color: Color(0xFF2A6F5B)),
                    ],
                  ),
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            print('StreamBuilder error: ${snapshot.error}');
            return Scaffold(
              body: Center(
                child: Text(
                  'Błąd: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
            );
          }

          if (snapshot.hasData) {
            print('User is logged in: ${snapshot.data?.uid}');
            return const StartPage();
          }

          print('User is not logged in, showing WelcomePage');
          return WelcomePage();
        },
      ),
    );
  }
}
