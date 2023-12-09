import 'package:flutter/material.dart';
import 'package:lakbay/features/auth/login.dart';
import 'package:lakbay/features/auth/register.dart';

enum AuthPage { login, register }

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  AuthPage currentPage = AuthPage.login;

  void togglePages() {
    setState(() {
      currentPage =
          currentPage == AuthPage.login ? AuthPage.register : AuthPage.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (currentPage) {
      case AuthPage.login:
        return LoginPage(
          onTap: togglePages,
        );
      case AuthPage.register:
        return RegisterPage(
          onTap: togglePages,
        );
      default:
        throw Exception('Unknown page');
    }
  }
}
