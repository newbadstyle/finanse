import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finanse/app/auth_service.dart';
import 'theme_provider.dart';
import 'welcome_page.dart';

class SettingsPage extends StatefulWidget {
  final ThemeProvider themeProvider;

  const SettingsPage({super.key, required this.themeProvider});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _signOut(BuildContext context) async {
    try {
      await authService.value.signOut();
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Błąd wylogowania: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color(0xFF2A6F5B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Konto',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2A6F5B),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFF2A6F5B)),
              title: Text(
                user != null ? user.email ?? 'Brak emaila' : 'Nie zalogowano',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
            const SizedBox(height: 20),
            const Text(
              'Wygląd',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2A6F5B),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.brightness_6, color: Color(0xFF2A6F5B)),
              title: const Text('Motyw'),
              trailing: Switch(
                value: widget.themeProvider.isDarkMode,
                onChanged: (value) {
                  widget.themeProvider.toggleTheme();
                  setState(() {});
                },
                activeColor: const Color(0xFF2A6F5B),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFB0F1D4), Color(0xFF2A6F5B)],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                  ),
                  onPressed: () => _signOut(context),
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
