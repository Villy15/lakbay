import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class Pallete {
  static const primaryColor = Colors.deepOrangeAccent;
  static const secondaryColor = Colors.deepOrangeAccent;
  static const white = Colors.white;
  static const black = Colors.black;

  // Light mode app theme
  static final lightTheme = ThemeData(
    useMaterial3: true,
    // Drawer theme
    drawerTheme: const DrawerThemeData(
      backgroundColor: black,
      elevation: 0,
    ),

    navigationDrawerTheme: const NavigationDrawerThemeData(
      backgroundColor: black,
      elevation: 0,
    ),

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
      titleTextStyle: TextStyle(
          color: primaryColor, fontSize: 24, fontWeight: FontWeight.bold),
    ),

    // Scaffold Theme
    scaffoldBackgroundColor: white,
  );

  // Dark mode app theme
  static final darkTheme = ThemeData(
    useMaterial3: true,

    // Color Theme
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepOrange,
      brightness: Brightness.dark,
    ),
  );
}

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode _mode;
  ThemeNotifier({ThemeMode mode = ThemeMode.light})
      : _mode = mode,
        super(
          Pallete.darkTheme,
        ) {
    getTheme();
  }

  ThemeMode get mode => _mode;

  void getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');

    if (theme == 'light') {
      _mode = ThemeMode.light;
      state = Pallete.lightTheme;
    } else {
      _mode = ThemeMode.dark;
      state = Pallete.darkTheme;
    }
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_mode == ThemeMode.dark) {
      _mode = ThemeMode.light;
      state = Pallete.lightTheme;
      prefs.setString('theme', 'light');
    } else {
      _mode = ThemeMode.dark;
      state = Pallete.darkTheme;
      prefs.setString('theme', 'dark');
    }
  }
}
