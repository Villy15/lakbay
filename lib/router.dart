import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/login.dart';
import 'package:lakbay/features/common/shared_axis.dart';
import 'package:lakbay/features/common/fade_through.dart';
import 'package:lakbay/features/common/layout.dart';
import 'package:lakbay/features/cooperatives/coops_page.dart';
import 'package:lakbay/features/events/events_page.dart';
import 'package:lakbay/features/home/customer/customer_home_page.dart';
import 'package:lakbay/features/inbox/inbox_page.dart';
import 'package:lakbay/features/market/crud/read_market.dart';
import 'package:lakbay/features/market/market_page.dart';

final GlobalKey<NavigatorState> _rootNavigator = GlobalKey(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigator =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
      debugLogDiagnostics: true,
      navigatorKey: _rootNavigator,
      initialLocation: '/customer_home',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginPage(key: state.pageKey),
        ),
        ShellRoute(
            navigatorKey: _shellNavigator,
            builder: (context, state, child) =>
                Layout(key: state.pageKey, child: child),
            routes: [
              GoRoute(
                path: '/customer_home',
                pageBuilder: (context, state) =>
                    buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: const CustomerHomePage(),
                ),
              ),
              GoRoute(
                path: '/market',
                pageBuilder: (context, state) =>
                    buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: const MarketPage(),
                ),
                routes: [
                  GoRoute(
                    path: ':id',
                    pageBuilder: (context, state) =>
                        buildPageWithSharedAxisTransition<void>(
                      context: context,
                      state: state,
                      child: const ReadMarketPage(),
                      transitionType: SharedAxisTransitionType.vertical,
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: '/events',
                pageBuilder: (context, state) =>
                    buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: const EventsPage(),
                ),
              ),
              GoRoute(
                path: '/coops',
                pageBuilder: (context, state) =>
                    buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: const CoopsPage(),
                ),
              ),
              GoRoute(
                path: '/inbox',
                pageBuilder: (context, state) =>
                    buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: const InboxPage(),
                ),
              ),
            ])
      ]);
});
