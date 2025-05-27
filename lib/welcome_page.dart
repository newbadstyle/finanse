import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'login_page.dart';
import 'register_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Text(
                'NINJA',
                style: TextStyle(
                  fontFamily: 'JosefinSans',
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Lottie.asset(
                'assets/lotties/hello.json',
                width: 600,
                height: 450,
              ),
              Text(
                'Witaj w Ninja!',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text('Twój osobisty przewodnik po finansach'),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFB0F1D4), Color(0xFF2A6F5B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: Size(300, 40),
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text('Logowanie'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFB0F1D4), Color(0xFF2A6F5B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: Size(300, 40),
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: Text('Rejestracja'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
