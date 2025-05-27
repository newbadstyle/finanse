import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'login_page.dart';
import 'register_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NINJA',
              style: TextStyle(
                fontFamily: 'JosefinSans',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Lottie.asset('assets/lotties/hello.json'),
            Text(
              'Witaj!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('Twój osobisty przewodnik po finansach Ninja'),
            SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Logowanie'),
            ),
            SizedBox(height: 10),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text('Rejestracja'),
            ),
          ],
        ),
      ),
    );
  }
}
