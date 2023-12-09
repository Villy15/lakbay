import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/loader.dart';

class RegisterPage extends ConsumerStatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

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
                    if (isLoading) ...[
                      const Loader(),
                      const SizedBox(height: 429),
                    ] else ...[
                      emailTextField(),
                      const SizedBox(height: 20),
                      passwordTextField(),
                      const SizedBox(height: 20),
                      confirmPasswordTextField(),
                      const SizedBox(height: 20),
                      registerButton(),
                      const SizedBox(height: 140),
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

  Row extraFunctions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            widget.onTap!.call();
          },
          child: const Text(
            "Go back to login",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  FilledButton registerButton() {
    return FilledButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: () {
        context.go('/customer_home');
      },
      child: const Text("Register"),
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

  TextFormField confirmPasswordTextField() {
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
        hintText: "Confirm Password",
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
