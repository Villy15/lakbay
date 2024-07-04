import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

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

String formatDateMMDDYYYY(DateTime date) {
  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  String day = date.day.toString().padLeft(2, '0');
  String month = months[date.month - 1];
  String year = date.year.toString();

  return '$month $day, $year';
}

String capitalize(String text) {
  return text[0].toUpperCase() + text.substring(1);
}

String deCapitalize(String text) {
  return text.toLowerCase();
}

class BiWeightText extends StatelessWidget {
  final String title;
  final String content;
  const BiWeightText({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: content,
            style: const TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.normal, // Different font weight for user.name
            ),
          ),
        ],
      ),
    );
  }
}

Future<File> createFileOfPdfUrl(String getUrl) async {
  Completer<File> completer = Completer();
  try {
    final url = getUrl;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/$filename");

    await file.writeAsBytes(bytes, flush: true);
    completer.complete(file);
  } catch (e) {
    throw Exception('Error parsing asset file!');
  }

  return completer.future;
}
