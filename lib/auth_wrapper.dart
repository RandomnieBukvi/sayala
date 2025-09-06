import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zhanashyr/login_page.dart';
import 'package:zhanashyr/main_page.dart';
import 'package:zhanashyr/register_page.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Загрузка
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // Пользователь вошёл
        if (snapshot.hasData) {
          return MainScreen();
        }

        // Пользователь не вошёл
        return AuthPagesSwitcher();
      },
    );
  }
}


class AuthPagesSwitcher extends StatefulWidget {
  @override
  _AuthPagesSwitcherState createState() => _AuthPagesSwitcherState();
}

class _AuthPagesSwitcherState extends State<AuthPagesSwitcher> {
  bool showLogin = true;

  void togglePages() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLogin
        ? LoginPage(onToggle: togglePages)
        : RegisterPage(onToggle: togglePages);
  }
}