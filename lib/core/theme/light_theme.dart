import 'package:flutter/material.dart';

const primaryColor = Colors.deepOrangeAccent;
const secondaryColor = Colors.deepOrangeAccent;
const white = Colors.white;
const black = Colors.black;

ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    // Color Theme
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),

    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(primaryColor),
          backgroundColor: MaterialStateProperty.all(white)),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: white,
      foregroundColor: primaryColor,
      iconTheme: IconThemeData(color: primaryColor),
      titleTextStyle: TextStyle(color: primaryColor, fontSize: 24, fontWeight: FontWeight.bold),
    ),

    // Scaffold Theme
    scaffoldBackgroundColor: white,
);
