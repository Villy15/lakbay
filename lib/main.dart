import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/router.dart';
import 'package:lakbay/core/theme/dark_theme.dart';
import 'package:lakbay/core/theme/light_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
  final router = ref.watch(goRouterProvider);

    return MaterialApp.router (
        debugShowCheckedModeBanner: false,
        title: 'Lakbay',
        theme: lightTheme,
        darkTheme: darkTheme,
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
      );
  }
}
