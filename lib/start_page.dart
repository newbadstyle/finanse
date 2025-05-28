import 'package:finanse/app/auth_service.dart';
import 'package:finanse/welcome_page.dart';
import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Witaj w Ninja!',
              style: TextStyle(
                fontFamily: 'JosefinSans',
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2A6F5B),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Jesteś zalogowany. Rozpocznij zarządzanie finansami!',
              style: TextStyle(
                fontFamily: 'JosefinSans',
                fontSize: 18,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB0F1D4), Color(0xFF2A6F5B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    print('Sign out button pressed');
                    try {
                      await authService.value.signOut();
                      print('Sign out completed successfully');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Pomyślnie wylogowano')),
                        );
                        // Ręczne przekierowanie na WelcomePage
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WelcomePage(),
                          ),
                        );
                      }
                    } catch (e) {
                      print('Error during sign out: $e');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Błąd wylogowania: $e')),
                        );
                      }
                    }
                  },
                  child: const Text('Wyloguj się'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
