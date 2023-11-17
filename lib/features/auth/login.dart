import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/core/images/login_bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 8,
            left: MediaQuery.of(context).size.width / 12,
            right: MediaQuery.of(context).size.width / 12,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    greetingText(),
                    const SizedBox(height: 80),
                    emailTextField(),
                    const SizedBox(height: 20),
                    passwordTextField(),
                    const SizedBox(height: 20),
                    loginButton(),
                    const SizedBox(height: 60),
                    loginWithText(),
                    const SizedBox(height: 20),
                    loginOptions(),
                    const SizedBox(height: 80),
                    extraFunctions(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column greetingText() {
    return const Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Kamusta? Tara,",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w500,
              fontFamily: 'Satisfy',
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Lakbay!",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'Satisfy'),
          ),
        ),
      ],
    );
  }

  Text loginWithText() {
    return const Text(
      "Or login with",
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }

  Row loginOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton.filled(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          icon: Image.asset("lib/core/images/google.png"),
          onPressed: () {},
        ),
        IconButton.filled(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          icon: Image.asset("lib/core/images/facebook.png"),
          onPressed: () {},
        ),
      ],
    );
  }

  Row extraFunctions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {},
          child: const Text(
            "Create Account",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        const Text(
          "|",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            "Forgot Password",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  FilledButton loginButton() {
    return FilledButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: () {
        context.go('/customer_home');
      },
      child: const Text("Login"),
    );
  }

  TextFormField passwordTextField() {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      obscureText: _obscureText,
      decoration: InputDecoration(
        fillColor: Colors.white54,
        filled: true,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: _togglePasswordVisibility,
          ),
        ),
        contentPadding: const EdgeInsets.all(20),
        hintText: "Password",
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
      ),
    );
  }

  TextFormField emailTextField() {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      decoration: const InputDecoration(
        fillColor: Colors.white54,
        filled: true,
        prefixIcon: Icon(Icons.email),
        contentPadding: EdgeInsets.all(20),
        hintText: "Email",
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
      ),
    );
  }
}
