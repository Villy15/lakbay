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
import 'package:lakbay/features/cooperatives/my_coop/members/members.dart';
import 'package:lakbay/features/cooperatives/my_coop/members/read_member.dart';
import 'package:lakbay/features/cooperatives/my_coop/my_coop.dart';
import 'package:lakbay/features/dashboard/manager/dashboard_page.dart';
import 'package:lakbay/features/events/events_page.dart';
import 'package:lakbay/features/home/customer/customer_home_page.dart';
import 'package:lakbay/features/inbox/inbox_page.dart';
import 'package:lakbay/features/inbox/read_inbox.dart';
import 'package:lakbay/features/listings/crud/add_listing.dart';
import 'package:lakbay/features/listings/crud/read_listing.dart';
import 'package:lakbay/features/listings/listings_page.dart';
import 'package:lakbay/features/listings/crud/customer_accommodation.dart';
import 'package:lakbay/features/listings/crud/customer_entertainment.dart';
import 'package:lakbay/features/listings/crud/customer_food.dart';
import 'package:lakbay/features/listings/crud/customer_transportation.dart';
import 'package:lakbay/features/market/market_page.dart';
import 'package:lakbay/features/profile/crud/edit_profile.dart';
import 'package:lakbay/features/profile/profile_customer_page.dart';
import 'package:lakbay/features/trips/trips_page.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/user_model.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:lakbay/models/listing_model.dart';
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
                    path: ':category',
                    builder: (BuildContext context, GoRouterState state) {
                      ListingModel listing = state.extra as ListingModel;
                      switch (state.pathParameters["category"]) {
                        case "Accommodation":
                          return CustomerAccomodation(
                            listing: listing,
                          );
                        case "Transportation":
                          return CustomerTransportation(
                            listing: listing,
                          );
                        case "Food Service":
                          return CustomerFood(
                            listing: listing,
                          );
                        case "Entertainment":
                          return CustomerEntertainment(
                            listing: listing,
                          );
                        // case "Touring":
                        //   return SelectedTouringPage(
                        //     listing: listing,
                        //   );
                        default:
                          return CustomerAccomodation(
                            listing: listing,
                          );
                      }
                    },
                    routes: const [
                      // GoRoute(
                      //     path: 'listing_messages_inbox',
                      //     builder: (BuildContext context, GoRouterState state) {
                      //       return ListingMessagesInbox(
                      //           listingId: state.pathParameters["listingId"]!);
                      //     },
                      //     routes: [
                      //       GoRoute(
                      //         path: ':docId',
                      //         builder:
                      //             (BuildContext context, GoRouterState state) {
                      //           return ListingMessages(
                      //               docId: state.pathParameters["docId"]!,
                      //               listingId:
                      //                   state.pathParameters["listingId"]!);
                      //         },
                      //       ),
                      //     ]),
                    ],
                  ),
                  GoRoute(
                    path: 'id/:listingId',
                    pageBuilder: (context, state) =>
                        buildPageWithSharedAxisTransition<void>(
                      context: context,
                      state: state,
                      child: ReadListingPage(
                          listingId: state.pathParameters['listingId']!),
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
                  routes: [
                    GoRoute(
                      path: ':userId',
                      name: 'read_member',
                      pageBuilder: (context, state) {
                        return buildPageWithSharedAxisTransition<void>(
                          context: context,
                          state: state,
                          child: ReadMemberPage(
                              userId: state.pathParameters['userId']!),
                          transitionType: SharedAxisTransitionType.vertical,
                        );
                      },
                    ),
                  ]),

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

              // Profile Page
              GoRoute(
                path: '/profile/id/:userId',
                pageBuilder: (context, state) {
                  return buildPageWithSharedAxisTransition<void>(
                    context: context,
                    state: state,
                    child: ProfilePage(userId: state.pathParameters['userId']!),
                    transitionType: SharedAxisTransitionType.vertical,
                  );
                },
                routes: const [],
              ),

              // Edit Profile Page
              GoRoute(
                path: '/profile/edit',
                name: 'edit_profile',
                pageBuilder: (context, state) {
                  UserModel user = state.extra as UserModel;

                  return buildPageWithSharedAxisTransition<void>(
                    context: context,
                    state: state,
                    child: EditProfilePage(
                      user: user,
                    ),
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
                routes: [
                  GoRoute(
                    path: 'id/:senderId',
                    pageBuilder: (context, state) {
                      types.Room room = state.extra as types.Room;

                      return buildPageWithSharedAxisTransition<void>(
                        context: context,
                        state: state,
                        child: ReadInboxPage(
                          senderId: state.pathParameters['senderId']!,
                          room: room,
                        ),
                        transitionType: SharedAxisTransitionType.vertical,
                      );
                    },
                  ),
                ],
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
