import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _civilStatusController = TextEditingController();
  final TextEditingController _religionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final nationality = _nationalityController.text.trim();
      final civilStatus = _civilStatusController.text.trim();
      final religion = _religionController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      DateTime birthDateFormatted = DateTime.now();
      try {
        birthDateFormatted = DateTime.parse(_birthDateController.text.trim());
        // Proceed with using birthDate as a DateTime object
      } catch (e) {
        // Handle the error if the string is not in a valid format
        debugPrint('Invalid date format: ${_birthDateController.text.trim()}');
      }

      ref.read(authControllerProvider.notifier).register(
            context: context,
            firstName: firstName,
            lastName: lastName,
            birthDate: birthDateFormatted,
            nationality: nationality,
            civilStatus: civilStatus,
            religion: religion,
            email: email,
            password: password,
          );
    }
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
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: mqwidth * 0.05,
              right: mqwidth * 0.05,
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
                      TextFormField(
                        controller: _firstNameController,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          fillColor: Colors.white54,
                          filled: true,
                          prefixIcon: Icon(Icons.person),
                          contentPadding: EdgeInsets.all(20),
                          hintText: "First Name",
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: mqheight * 0.025),
                      TextFormField(
                        controller: _lastNameController,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          fillColor: Colors.white54,
                          filled: true,
                          prefixIcon: Icon(Icons.person),
                          contentPadding: EdgeInsets.all(20),
                          hintText: "Last Name",
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: mqheight * 0.025),
                      GestureDetector(
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            _birthDateController.text =
                                formattedDate; // Use your date format here
                          }
                        },
                        child: AbsorbPointer(
                          // This makes the TextFormField not focusable
                          child: TextFormField(
                            controller: _birthDateController,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              fillColor: Colors.white54,
                              filled: true,
                              prefixIcon: Icon(Icons.calendar_today),
                              contentPadding: EdgeInsets.all(20),
                              hintText: "Birth Date",
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your birth date';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: mqheight * 0.025),
                      TextFormField(
                        controller: _nationalityController,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          fillColor: Colors.white54,
                          filled: true,
                          prefixIcon: Icon(Icons.flag),
                          contentPadding: EdgeInsets.all(20),
                          hintText: "Nationality",
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your nationality';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: mqheight * 0.025),
                      TextFormField(
                        controller: _civilStatusController,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          fillColor: Colors.white54,
                          filled: true,
                          prefixIcon: Icon(Icons.people),
                          contentPadding: EdgeInsets.all(20),
                          hintText: "Civil Status",
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your civil status';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: mqheight * 0.025),
                      TextFormField(
                        controller: _religionController,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          fillColor: Colors.white54,
                          filled: true,
                          prefixIcon: Icon(Icons.people),
                          contentPadding: EdgeInsets.all(20),
                          hintText: "Religion",
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your religion';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: mqheight * 0.025),
                      emailTextField(),
                      SizedBox(height: mqheight * 0.025),
                      passwordTextField(),
                      SizedBox(height: mqheight * 0.025),
                      registerButton(),
                      SizedBox(height: mqheight * 0.075),
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
            "Register to Lakbay",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w500,
            ),
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
        _register();
      },
      child: const Text("Register"),
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
