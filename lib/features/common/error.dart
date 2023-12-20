import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String error;
  final String stackTrace;
  const ErrorText({super.key, required this.error, required this.stackTrace});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$error\n$stackTrace',
        style: const TextStyle(
          color: Colors.red,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
