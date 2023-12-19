import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String error;
  const ErrorText({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
