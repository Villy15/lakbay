import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/loader.dart';

class LoginPage extends ConsumerStatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      await ref
          .read(authControllerProvider.notifier)
          .signInWithEmailAndPassword(
            context: context,
            email: email,
            password: password,
          );

      //user successfully signed in
      final token = await _fcm.getToken();
      if (token != null) {
        debugPrint('this is the token when user logs in:: $token');
        saveDeviceToken(token);
      }
    }
  }

  void signInWithGoogle(BuildContext context) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  void signInWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) {
    ref.read(authControllerProvider.notifier).signInWithEmailAndPassword(
          context: context,
          email: email,
          password: password,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    double mqheight = MediaQuery.of(context).size.height;
    double mqwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/core/images/login_bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: mqwidth * 0.1,
              right: mqwidth * 0.1,
              top: mqheight * 0.1,
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    greetingText(),
                    SizedBox(height: mqheight * 0.05),
                    if (isLoading) ...[
                      const Loader(),
                      SizedBox(height: mqheight * 0.5),
                    ] else ...[
                      emailTextField(),
                      SizedBox(height: mqheight * 0.025),
                      passwordTextField(),
                      SizedBox(height: mqheight * 0.025),
                      loginButton(),
                      SizedBox(height: mqheight * 0.05),
                      loginWithText(),
                      SizedBox(height: mqheight * 0.025),
                      loginOptions(),
                      SizedBox(height: mqheight * 0.025),
                    ],
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
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Kamusta? Tara,",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 20,
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
                fontSize: MediaQuery.of(context).size.height / 20,
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
        color: Colors.white,
      ),
    );
  }

  Row loginOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton.filled(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.background),
          icon: Image.asset("lib/core/images/google.png"),
          onPressed: () => signInWithGoogle(context),
        ),
        IconButton.filled(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.background),
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
          onPressed: () {
            widget.onTap?.call();
          },
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
        login();
      },
      child: const Text(
        "Login",
      ),
    );
  }

  TextFormField passwordTextField() {
    return TextFormField(
      controller: _passwordController,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  TextFormField emailTextField() {
    return TextFormField(
      controller: _emailController,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }

  // get the token, then save it to the database for the current user
  Future<void> saveDeviceToken(String token) async {
    // get current user
    final user = FirebaseAuth.instance.currentUser;
    debugPrint('saving!!!!!');
    // better security here
    if (user != null) {
      // get the token for this device
      final fcmToken = await _fcm.getToken();

      // save it to Firestore
      if (fcmToken != null) {
        final tokens = _db
            .collection('users')
            .doc(user.uid)
            .collection('tokens')
            .doc(fcmToken);

        await tokens.set({
          'token': fcmToken,
          'createdAt': FieldValue.serverTimestamp(), // optional
          'platform': Platform.operatingSystem // optional
        });
      }
    }
  }
}
