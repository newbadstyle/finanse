import 'package:finanse/app/auth_service.dart';
import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Witaj w Ninja!',
                style: TextStyle(
                  fontFamily: 'JosefinSans',
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2A6F5B),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Jesteś zalogowany. Rozpocznij zarządzanie finansami!',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await authService.value.signOut();
                    print('User signed out from StartPage');
                  } catch (e) {
                    print('Error signing out: $e');
                  }
                },
                child: const Text('Wyloguj się'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
