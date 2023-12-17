import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/core/theme/theme.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/firebase_options.dart';
import 'package:lakbay/models/user_model.dart';
import 'package:lakbay/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterConfig.loadEnvVariables();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeNotifierProvider);

    return ref.watch(authStateChangeProvider).when(
        data: (data) {
          if (data != null) {
            checkAndUpdateUserData(ref, data);

            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Lakbay',
              theme: theme,
              routerDelegate: ref.watch(goRouterProvider).routerDelegate,
              routeInformationParser:
                  ref.watch(goRouterProvider).routeInformationParser,
              routeInformationProvider:
                  ref.watch(goRouterProvider).routeInformationProvider,
            );
          }

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Lakbay',
            theme: theme,
            routerDelegate: ref.watch(goRouterProvider).routerDelegate,
            routeInformationParser:
                ref.watch(goRouterProvider).routeInformationParser,
            routeInformationProvider:
                ref.watch(goRouterProvider).routeInformationProvider,
          );
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }

  // This will determine if we should refetch the user data
  void checkAndUpdateUserData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;

    ref.read(userProvider.notifier).setUser(userModel!);
  }
}
