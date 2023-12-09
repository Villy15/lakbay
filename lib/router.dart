import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/auth/login.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/shared_axis.dart';
import 'package:lakbay/features/common/fade_through.dart';
import 'package:lakbay/features/common/layout.dart';
import 'package:lakbay/features/cooperatives/coops_page.dart';
import 'package:lakbay/features/cooperatives/crud/add_coop.dart';
import 'package:lakbay/features/cooperatives/crud/read_coop.dart';
import 'package:lakbay/features/dashboard/manager/dashboard_page.dart';
import 'package:lakbay/features/events/events_page.dart';
import 'package:lakbay/features/home/customer/customer_home_page.dart';
import 'package:lakbay/features/inbox/inbox_page.dart';
import 'package:lakbay/features/market/crud/read_market.dart';
import 'package:lakbay/features/market/market_page.dart';

final GlobalKey<NavigatorState> _rootNavigator = GlobalKey(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigator =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangeProvider);

  String? determineRedirectPath(GoRouterState state) {
    final isAuth = authState.valueOrNull != null;
    final isLoggingIn = state.matchedLocation == '/login';

    if (!isAuth) {
      // Not authenticated
      return isLoggingIn ? null : '/login';
    }
    if (isLoggingIn) {
      return '/customer_home';
    }
    // Authenticated
    return null;
  }

  return GoRouter(
      debugLogDiagnostics: true,
      navigatorKey: _rootNavigator,
      initialLocation: '/login',
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
              // Customer Home
              GoRoute(
                path: '/customer_home',
                pageBuilder: (context, state) =>
                    buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: const CustomerHomePage(),
                ),
              ),

              // Market
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

              // Events
              GoRoute(
                path: '/events',
                pageBuilder: (context, state) =>
                    buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: const EventsPage(),
                ),
              ),

              // Coops
              GoRoute(
                path: '/coops',
                pageBuilder: (context, state) =>
                    buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: const CoopsPage(),
                ),
                routes: [
                  GoRoute(
                    path: 'id/:coopId',
                    pageBuilder: (context, state) =>
                        buildPageWithSharedAxisTransition<void>(
                      context: context,
                      state: state,
                      child:
                          ReadCoopPage(coopId: state.pathParameters['coopId']!),
                      transitionType: SharedAxisTransitionType.vertical,
                    ),
                  ),
                  GoRoute(
                    path: 'register',
                    pageBuilder: (context, state) =>
                        buildPageWithSharedAxisTransition<void>(
                      context: context,
                      state: state,
                      child: const AddCoopPage(),
                      transitionType: SharedAxisTransitionType.vertical,
                    ),
                  ),
                ],
              ),

              // Inbox
              GoRoute(
                path: '/inbox',
                pageBuilder: (context, state) =>
                    buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: const InboxPage(),
                ),
              ),

              // Manager dashboard
              GoRoute(
                path: '/manager_dashboard',
                pageBuilder: (context, state) =>
                    buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: const ManagerDashboardPage(),
                ),
              ),
            ])
      ],
      redirect: (context, state) {
        if (authState.isLoading || authState.hasError) return null;
        return determineRedirectPath(state);
      },
      errorBuilder: (context, state) {
        return Scaffold(
          body: ErrorText(error: state.error.toString()),
        );
      });
});
