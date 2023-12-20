import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
}

void debugPrintJson(Object object) {
  var logger = Logger(
    filter: null, // Use the default LogFilter (-> only log in debug mode)
    printer: PrettyPrinter(
        methodCount: 2, // Number of method calls to be displayed
        errorMethodCount: 8, // Number of method calls if stacktrace is provided
        // lineLength: 120, // Width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        printTime: false // Should each log print contain a timestamp
        ),
    output: null, // Use the default LogOutput (-> send everything to console)
  );

  // Convert the object to a JSON string
  String rawJson = jsonEncode(object);

  // Decode the string to a Dart object
  final decodedObject = json.decode(rawJson);

  // Convert the Dart object to a pretty JSON string with indentation
  final prettyString =
      const JsonEncoder.withIndent('  ').convert(decodedObject);

  // Use the logger to print the pretty JSON string
  logger.d(prettyString);
}

class TimestampSerializer implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampSerializer();

  @override
  DateTime? fromJson(Timestamp? timestamp) {
    return timestamp?.toDate();
  }

  @override
  Timestamp? toJson(DateTime? dateTime) {
    return dateTime != null ? Timestamp.fromDate(dateTime) : null;
  }
}
