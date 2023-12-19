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

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      ref.read(authControllerProvider.notifier).signInWithEmailAndPassword(
            context: context,
            email: email,
            password: password,
          );
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
                    SizedBox(height: MediaQuery.of(context).size.height / 15),
                    if (isLoading) ...[
                      const Loader(),
                      const SizedBox(height: 429),
                    ] else ...[
                      emailTextField(),
                      SizedBox(height: MediaQuery.of(context).size.height / 25),
                      passwordTextField(),
                      SizedBox(height: MediaQuery.of(context).size.height / 25),
                      loginButton(),
                      SizedBox(height: MediaQuery.of(context).size.height / 30),
                      loginWithText(),
                      SizedBox(height: MediaQuery.of(context).size.height / 30),
                      loginOptions(),
                      SizedBox(height: MediaQuery.of(context).size.height / 25),
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
      child: const Text("Login"),
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }
}
