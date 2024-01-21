import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/auth/login_or_register.dart';
import 'package:lakbay/features/calendar/calendar_page.dart';
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
import 'package:lakbay/features/cooperatives/my_coop/managers/add_committee_members.dart';
import 'package:lakbay/features/cooperatives/my_coop/managers/join_coop_code.dart';
import 'package:lakbay/features/cooperatives/my_coop/managers/manage_committees_page.dart';
import 'package:lakbay/features/cooperatives/my_coop/managers/manage_privileges_page.dart';
import 'package:lakbay/features/cooperatives/my_coop/managers/manager_tools_page.dart';
import 'package:lakbay/features/cooperatives/my_coop/members/members.dart';
import 'package:lakbay/features/cooperatives/my_coop/members/read_member.dart';
import 'package:lakbay/features/cooperatives/my_coop/my_coop.dart';
import 'package:lakbay/features/dashboard/coop_dashboard.dart';
import 'package:lakbay/features/dashboard/manager/dashboard_page.dart';
import 'package:lakbay/features/events/crud/confirm_event.dart';
import 'package:lakbay/features/events/crud/coop_read_event.dart';
import 'package:lakbay/features/events/crud/event_manager_tools.dart';
import 'package:lakbay/features/events/crud/join_event.dart';
import 'package:lakbay/features/events/events_page.dart';
import 'package:lakbay/features/events/crud/add_event.dart';
import 'package:lakbay/features/events/crud/edit_event.dart';
import 'package:lakbay/features/listings/accommodation_booking_details.dart';
import 'package:lakbay/features/tasks/event_tasks_add.dart';
import 'package:lakbay/features/home/customer/customer_home_page.dart';
import 'package:lakbay/features/inbox/inbox_page.dart';
import 'package:lakbay/features/inbox/read_inbox.dart';
import 'package:lakbay/features/listings/crud/add_accommodation.dart';
import 'package:lakbay/features/listings/crud/add_entertainment.dart';
import 'package:lakbay/features/listings/crud/add_food.dart';
import 'package:lakbay/features/listings/crud/add_tours.dart';
import 'package:lakbay/features/listings/crud/add_transport.dart';
import 'package:lakbay/features/listings/crud/choose_category.dart';
import 'package:lakbay/features/listings/crud/read_listing.dart';
import 'package:lakbay/features/listings/listings_page.dart';
import 'package:lakbay/features/listings/crud/customer_accommodation.dart';
import 'package:lakbay/features/listings/crud/customer_entertainment.dart';
import 'package:lakbay/features/listings/crud/customer_food.dart';
import 'package:lakbay/features/listings/crud/customer_transportation.dart';
import 'package:lakbay/features/market/market_page.dart';
import 'package:lakbay/features/profile/crud/edit_profile.dart';
import 'package:lakbay/features/profile/profile_customer_page.dart';
import 'package:lakbay/features/tasks/event_tasks_edit.dart';
import 'package:lakbay/features/tasks/event_tasks_read.dart';
import 'package:lakbay/features/trips/trips_page.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/task_model.dart';
import 'package:lakbay/models/user_model.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/event_model.dart';
import 'package:lakbay/features/events/crud/read_event.dart';
import 'package:lakbay/features/wiki/wiki_page.dart';
import 'package:lakbay/features/wiki/crud/add_wiki.dart';
import 'package:lakbay/features/wiki/crud/read_wiki.dart';
import 'package:lakbay/features/wiki/crud/edit_wiki.dart';
import 'package:lakbay/models/wiki_model.dart';
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
                        case "Transport":
                          return CustomerTransportation(
                            listing: listing,
                          );
                        case "Food":
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
                    routes: [
                      GoRoute(
                          path: "booking_details",
                          name: "booking_details",
                          builder: (BuildContext context, GoRouterState state) {
                            ListingBookings booking =
                                state.extra as ListingBookings;
                            switch (state.pathParameters["category"]) {
                              case "Accommodation":
                                return AccommodationBookingsDetails(
                                  booking: booking,
                                );

                              // case "Transport":
                              //   return CustomerTransportation(
                              //     listing: listing,
                              //   );
                              // case "Food":
                              //   return CustomerFood(
                              //     listing: listing,
                              //   );
                              // case "Entertainment":
                              //   return CustomerEntertainment(
                              //     listing: listing,
                              //   );
                              // case "Touring":
                              //   return SelectedTouringPage(
                              //     listing: listing,
                              //   );
                              default:
                                return AccommodationBookingsDetails(
                                  booking: booking,
                                );
                            }
                          })

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
                path: '/edit_event',
                name: 'edit_event',
                pageBuilder: (context, state) {
                  EventModel event = state.extra as EventModel;

                  return buildPageWithSharedAxisTransition<void>(
                    context: context,
                    state: state,
                    child: EditEventPage(
                      event: event,
                    ),
                    transitionType: SharedAxisTransitionType.vertical,
                  );
                },
              ),
              // GoRoute for the ReadEventPage
              GoRoute(
                path: '/read_event/:eventId',
                name: 'read_event',
                pageBuilder: (context, state) {
                  return buildPageWithSharedAxisTransition<void>(
                    context: context,
                    state: state,
                    child: ReadEventPage(
                        eventId: state.pathParameters['eventId']!),
                    transitionType: SharedAxisTransitionType.vertical,
                  );
                },
              ),

              GoRoute(
                path: '/read_event/functions/manager_tools',
                name: 'event_manager_tools',
                pageBuilder: (context, state) {
                  EventModel event = state.extra as EventModel;

                  return buildPageWithSharedAxisTransition<void>(
                    context: context,
                    state: state,
                    child: EventManagerToolsPage(
                      event: event,
                    ),
                    transitionType: SharedAxisTransitionType.vertical,
                  );
                },
              ),

              // Event Manager Tools

              // Join Event
              GoRoute(
                path: '/join_event',
                name: 'join_event',
                pageBuilder: (context, state) {
                  EventModel event = state.extra as EventModel;

                  return buildPageWithSharedAxisTransition<void>(
                    context: context,
                    state: state,
                    child: JoinEventPage(
                      event: event,
                    ),
                    transitionType: SharedAxisTransitionType.vertical,
                  );
                },
              ),

              // Confirm Event
              GoRoute(
                path: '/confirm_event',
                name: 'confirm_event',
                pageBuilder: (context, state) {
                  EventModel event = state.extra as EventModel;

                  return buildPageWithSharedAxisTransition<void>(
                    context: context,
                    state: state,
                    child: ConfirmEventPage(
                      event: event,
                    ),
                    transitionType: SharedAxisTransitionType.vertical,
                  );
                },
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
                path: '/calendar',
                pageBuilder: (context, state) =>
                    buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: const CalendarPage(),
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
                      child: ChooseCategory(
                        coop: coop,
                      ),
                      transitionType: SharedAxisTransitionType.vertical,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'accommodation',
                      name: 'add_accommodation',
                      pageBuilder: (context, state) {
                        CooperativeModel coop = state.extra as CooperativeModel;

                        return buildPageWithSharedAxisTransition<void>(
                          context: context,
                          state: state,
                          child: AddAccommodation(
                              coop: coop, category: "Accommodation"),
                          transitionType: SharedAxisTransitionType.vertical,
                        );
                      },
                    ),
                    GoRoute(
                      path: 'transport',
                      name: 'add_transport',
                      pageBuilder: (context, state) {
                        CooperativeModel coop = state.extra as CooperativeModel;

                        return buildPageWithSharedAxisTransition<void>(
                          context: context,
                          state: state,
                          child:
                              AddTransport(coop: coop, category: "Transport"),
                          transitionType: SharedAxisTransitionType.vertical,
                        );
                      },
                    ),
                    GoRoute(
                      path: 'food',
                      name: 'add_food',
                      pageBuilder: (context, state) {
                        CooperativeModel coop = state.extra as CooperativeModel;

                        return buildPageWithSharedAxisTransition<void>(
                          context: context,
                          state: state,
                          child: AddFood(coop: coop, category: 'Food'),
                          transitionType: SharedAxisTransitionType.vertical,
                        );
                      },
                    ),
                    GoRoute(
                      path: 'entertainment',
                      name: 'add_entertainment',
                      pageBuilder: (context, state) {
                        CooperativeModel coop = state.extra as CooperativeModel;

                        return buildPageWithSharedAxisTransition<void>(
                          context: context,
                          state: state,
                          child: AddEntertainment(
                              coop: coop, category: 'Entertainment'),
                          transitionType: SharedAxisTransitionType.vertical,
                        );
                      },
                    ),
                    GoRoute(
                        path: 'tour',
                        name: 'add_tour',
                        pageBuilder: (context, state) {
                          CooperativeModel coop =
                              state.extra as CooperativeModel;

                          return buildPageWithSharedAxisTransition<void>(
                            context: context,
                            state: state,
                            child: AddTour(coop: coop),
                            transitionType: SharedAxisTransitionType.vertical,
                          );
                        })
                  ]),

              GoRoute(
                path: '/my_coop/event/:eventId',
                pageBuilder: (context, state) {
                  return buildPageWithSharedAxisTransition<void>(
                    context: context,
                    state: state,
                    child: CoopReadEventPage(
                        eventId: state.pathParameters['eventId']!),
                    transitionType: SharedAxisTransitionType.vertical,
                  );
                },
              ),

              // Add tasks for event
              GoRoute(
                path: '/my_coop/event/task/functions/add',
                name: 'add_event_task',
                pageBuilder: (context, state) {
                  EventModel event = state.extra as EventModel;

                  return buildPageWithSharedAxisTransition<void>(
                    context: context,
                    state: state,
                    child: AddEventTask(
                      event: event,
                    ),
                    transitionType: SharedAxisTransitionType.vertical,
                  );
                },
              ),

              GoRoute(
                path: '/my_coop/event/task/functions/edit',
                name: 'edit_event_task',
                pageBuilder: (context, state) {
                  TaskModel task = state.extra as TaskModel;

                  return buildPageWithSharedAxisTransition<void>(
                    context: context,
                    state: state,
                    child: EditEventTask(
                      task: task,
                    ),
                    transitionType: SharedAxisTransitionType.vertical,
                  );
                },
              ),

              GoRoute(
                path: '/my_coop/event/task/functions/read/:taskId',
                name: 'read_event_task',
                pageBuilder: (context, state) {
                  // TaskModel task = state.extra as TaskModel;

                  return buildPageWithSharedAxisTransition<void>(
                    context: context,
                    state: state,
                    child: ReadEventTask(
                      taskId: state.pathParameters['taskId']!,
                    ),
                    transitionType: SharedAxisTransitionType.vertical,
                  );
                },
              ),

              // Add Event to Cooperative
              GoRoute(
                path: '/my_coop/events/functions/add',
                name: 'add_event',
                pageBuilder: (context, state) {
                  CooperativeModel coop = state.extra as CooperativeModel;

                  return buildPageWithSharedAxisTransition<void>(
                    context: context,
                    state: state,
                    child: AddEventPage(
                      coop: coop,
                    ),
                    transitionType: SharedAxisTransitionType.vertical,
                  );
                },
              ),

              // Manager Tools
              GoRoute(
                path: '/my_coop/functions/manager_tools',
                name: 'manager_tools',
                pageBuilder: (context, state) {
                  CooperativeModel coop = state.extra as CooperativeModel;

                  return buildPageWithSharedAxisTransition<void>(
                    context: context,
                    state: state,
                    child: ManagerToolsPage(
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

              // My Coop Dashboard
              GoRoute(
                path: '/my_coop/dashboard/:uid',
                pageBuilder: (context, state) {
                  return buildPageWithSharedAxisTransition<void>(
                    context: context,
                    state: state,
                    child: CoopDashboard(coopId: state.pathParameters['uid']!),
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

                  // Join Cooperative With Code
                  GoRoute(
                    path: 'join_code',
                    name: 'join_coop_with_code',
                    pageBuilder: (context, state) {
                      CooperativeModel coop = state.extra as CooperativeModel;

                      return buildPageWithSharedAxisTransition<void>(
                        context: context,
                        state: state,
                        child: JoinCoopPage(
                          coop: coop,
                          isMember: true,
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

                  // Manage Committess
                  GoRoute(
                    path: 'manage_committees/:committeeName',
                    name: 'manage_committees',
                    pageBuilder: (context, state) {
                      CooperativeModel coop = state.extra as CooperativeModel;

                      return buildPageWithSharedAxisTransition<void>(
                        context: context,
                        state: state,
                        child: ManageCommitteesPage(
                          coop: coop,
                          committeeName: state.pathParameters['committeeName']!,
                        ),
                        transitionType: SharedAxisTransitionType.vertical,
                      );
                    },
                  ),

                  // Manage Privileges
                  GoRoute(
                    path: 'manage_privileges',
                    name: 'manage_privileges',
                    pageBuilder: (context, state) {
                      CooperativeModel coop = state.extra as CooperativeModel;

                      return buildPageWithSharedAxisTransition<void>(
                        context: context,
                        state: state,
                        child: ManagePrivileges(
                          coop: coop,
                        ),
                        transitionType: SharedAxisTransitionType.vertical,
                      );
                    },
                  ),

                  // Join Cooperative Code
                  GoRoute(
                    path: 'join_coop_code',
                    name: 'join_coop_code',
                    pageBuilder: (context, state) {
                      CooperativeModel coop = state.extra as CooperativeModel;

                      return buildPageWithSharedAxisTransition<void>(
                        context: context,
                        state: state,
                        child: JoinCoopCodePage(
                          coop: coop,
                        ),
                        transitionType: SharedAxisTransitionType.vertical,
                      );
                    },
                  ),

                  // Add Committee Members
                  // Manage Committess
                  GoRoute(
                    path: 'add_committee_members/:committeeName',
                    name: 'add_committee_members',
                    pageBuilder: (context, state) {
                      CooperativeModel coop = state.extra as CooperativeModel;

                      return buildPageWithSharedAxisTransition<void>(
                        context: context,
                        state: state,
                        child: AddCommitteeMembersPage(
                          coop: coop,
                          committeeName: state.pathParameters['committeeName']!,
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

              //Wiki
              GoRoute(
                path: '/wiki',
                pageBuilder: (context, state) =>
                  buildPageWithSharedAxisTransition<void>(
                    context: context,
                    state: state,
                    child: const WikiPage(), 
                    transitionType: SharedAxisTransitionType.vertical,
                  ),
              ),

              // Add Wiki
              GoRoute(
                path: '/add_wiki',
                pageBuilder: (context, state) =>
                  buildPageWithSharedAxisTransition<void>(
                    context: context,
                    state: state,
                    child: const AddWikiPage(), // Replace with your actual AddWikiPage widget
                    transitionType: SharedAxisTransitionType.vertical,
                  ),
              ),

              // Read Wiki
              GoRoute(
                 path: '/wiki/:wikiId',
                  pageBuilder: (context, state) =>
                      buildPageWithSharedAxisTransition<void>(
                    context: context,
                    state: state,
                    child: ReadWikiPage(wikiId: state.pathParameters['wikiId']!),
                    transitionType: SharedAxisTransitionType.vertical,
                  ),
                ),
              
                // Edit Wiki
                GoRoute(
                  path: '/wiki/functions/edit',
                  name: 'edit_wiki',
                  pageBuilder: (context, state) {
                    WikiModel wiki = state.extra as WikiModel;

                    return buildPageWithSharedAxisTransition<void>(
                      context: context,
                      state: state,
                      child: EditWikiPage(
                        wiki: wiki,
                      ),
                    transitionType:SharedAxisTransitionType.vertical,
                  );
                },
              ),

              // Manager dashboard
              GoRoute(
                path: '/manager_dashboard',
                pageBuilder: (context, state) =>
                    buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: const TodayPage(),
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
          body: ErrorText(error: state.error.toString(), stackTrace: ''),
        );
      });
});
