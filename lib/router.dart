import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/auth/login_or_register.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/shared_axis.dart';
import 'package:lakbay/features/common/fade_through.dart';
import 'package:lakbay/features/common/layout.dart';
import 'package:lakbay/features/cooperatives/coops_page.dart';
import 'package:lakbay/features/cooperatives/crud/add_coop.dart';
import 'package:lakbay/features/cooperatives/crud/edit_coop.dart';
import 'package:lakbay/features/cooperatives/crud/read_coop.dart';
import 'package:lakbay/features/cooperatives/join_coop.dart';
import 'package:lakbay/features/cooperatives/leave_coop.dart';
import 'package:lakbay/features/cooperatives/my_coop/members.dart';
import 'package:lakbay/features/cooperatives/my_coop/my_coop.dart';
import 'package:lakbay/features/dashboard/manager/dashboard_page.dart';
import 'package:lakbay/features/events/events_page.dart';
import 'package:lakbay/features/home/customer/customer_home_page.dart';
import 'package:lakbay/features/inbox/inbox_page.dart';
import 'package:lakbay/features/listings/crud/add_listing.dart';
import 'package:lakbay/features/listings/listings_page.dart';
import 'package:lakbay/features/market/crud/read_market.dart';
import 'package:lakbay/features/market/market_page.dart';
import 'package:lakbay/features/trips/trips_page.dart';
import 'package:lakbay/models/coop_model.dart';
// import 'package:lakbay/features/trips/trips_page.dart';

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
          builder: (context, state) => LoginOrRegister(key: state.pageKey),
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

              GoRoute(
                path: '/trips',
                pageBuilder: (context, state) =>
                    buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: const TripsPage(),
                ),
              ),

              GoRoute(
                path: '/my_coop/:coopId',
                pageBuilder: (context, state) =>
                    buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: MyCoopPage(coopId: state.pathParameters['coopId']!),
                ),
              ),

              GoRoute(
                path: '/my_coop/listings/:coopId',
                pageBuilder: (context, state) =>
                    buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: ListingsPage(coopId: state.pathParameters['coopId']!),
                ),
              ),

              // Add Listing to Cooperative
              GoRoute(
                path: '/my_coop/listings/functions/add',
                name: 'add_listing',
                pageBuilder: (context, state) {
                  CooperativeModel coop = state.extra as CooperativeModel;

                  return buildPageWithSharedAxisTransition<void>(
                    context: context,
                    state: state,
                    child: AddListing(
                      coop: coop,
                    ),
                    transitionType: SharedAxisTransitionType.vertical,
                  );
                },
              ),

              // View My Coop Members
              GoRoute(
                path: '/my_coop/functions/members',
                name: 'coop_members',
                pageBuilder: (context, state) {
                  CooperativeModel coop = state.extra as CooperativeModel;

                  return buildPageWithSharedAxisTransition<void>(
                    context: context,
                    state: state,
                    child: MembersPage(
                      coop: coop,
                    ),
                    transitionType: SharedAxisTransitionType.vertical,
                  );
                },
              ),

              // View My Coop Events
              GoRoute(
                path: '/my_coop/functions/events',
                name: 'coop_events',
                pageBuilder: (context, state) {
                  // CooperativeModel coop = state.extra as CooperativeModel;

                  return buildPageWithSharedAxisTransition<void>(
                    context: context,
                    state: state,
                    child: const EventsPage(),
                    transitionType: SharedAxisTransitionType.vertical,
                  );
                },
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
                  // Edit Cooperative
                  GoRoute(
                    path: 'edit',
                    name: 'edit_coop',
                    pageBuilder: (context, state) {
                      CooperativeModel coop = state.extra as CooperativeModel;

                      return buildPageWithSharedAxisTransition<void>(
                        context: context,
                        state: state,
                        child: EditCoopPage(
                          coop: coop,
                        ),
                        transitionType: SharedAxisTransitionType.vertical,
                      );
                    },
                  ),

                  // Join Cooperative
                  GoRoute(
                    path: 'join',
                    name: 'join_coop',
                    pageBuilder: (context, state) {
                      CooperativeModel coop = state.extra as CooperativeModel;

                      return buildPageWithSharedAxisTransition<void>(
                        context: context,
                        state: state,
                        child: JoinCoopPage(
                          coop: coop,
                        ),
                        transitionType: SharedAxisTransitionType.vertical,
                      );
                    },
                  ),

                  // Leave Cooperative
                  GoRoute(
                    path: 'leave',
                    name: 'leave_coop',
                    pageBuilder: (context, state) {
                      CooperativeModel coop = state.extra as CooperativeModel;

                      return buildPageWithSharedAxisTransition<void>(
                        context: context,
                        state: state,
                        child: LeaveCoopPage(
                          coop: coop,
                        ),
                        transitionType: SharedAxisTransitionType.vertical,
                      );
                    },
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
