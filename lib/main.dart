import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/core/firebase_notif_api.dart';
import 'package:lakbay/core/theme/theme.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/notifications/notifications_controller.dart';
import 'package:lakbay/firebase_options.dart';
import 'package:lakbay/models/notifications_model.dart';
import 'package:lakbay/models/user_model.dart';
import 'package:lakbay/router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await FlutterConfig.loadEnvVariables();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  debugPrint('User granted permission: ${settings.authorizationStatus == AuthorizationStatus.authorized}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification!.android;

    if (notification != null && android != null) {
      // Display the notification
      debugPrint('Title: ${notification.title}');
      debugPrint('Body: ${notification.body}');
      
      FirebaseApi().sendNotification(
        title: notification.title!,
        body: notification.body!,
        data: message.data,
      );
    }
  });

  // await FirebaseApi().initNotifications();

  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);


  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  // If you're going to use other services that set up by the `main()` function,
  // You need to call `WidgetsFlutterBinding.ensureInitialized()` in the top level of your background handler to initialize them.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the Flutter local notifications plugin.
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Android-specific initialization
  var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  debugPrint("Handling a background message: ${message.messageId}");

  // Create a notification
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
    styleInformation: BigTextStyleInformation('')
  );
  var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
    payload: 'Default_Sound'
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;



  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((token) {
      debugPrint('Token: $token');
      saveDeviceToken(token!);
      debugPrint('the device token is saved!!!');
    });

  }

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
          error: (error, stackTrace) => ErrorText(
              error: error.toString(), stackTrace: stackTrace.toString()),
          loading: () => const Loader(),
        );
  }

  // get the token, then save it to the database for the current user
  Future<void> saveDeviceToken(String token) async {
    // get current user
    final user = FirebaseAuth.instance.currentUser;



    // better security here
    if (user != null) {
      // get the token for this device
      final fcmToken = await _fcm.getToken();

      // save it to Firestore
      if (fcmToken != null) {
        final tokens = _db
            .collection('users')
            .doc(user.uid)
            .collection('tokens')
            .doc(fcmToken);

        await tokens.set({
          'token': fcmToken,
          'createdAt': FieldValue.serverTimestamp(), // optional
          'platform': Platform.operatingSystem // optional
        });
      }
    }
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
