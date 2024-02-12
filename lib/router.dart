import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/auth/login_or_register.dart';
import 'package:lakbay/features/calendar/calendar_page.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/fade_through.dart';
import 'package:lakbay/features/common/layout.dart';
import 'package:lakbay/features/common/shared_axis.dart';
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
import 'package:lakbay/features/events/crud/add_event.dart';
import 'package:lakbay/features/events/crud/confirm_event.dart';
import 'package:lakbay/features/events/crud/coop_read_event.dart';
import 'package:lakbay/features/events/crud/edit_event.dart';
import 'package:lakbay/features/events/crud/event_manager_tools.dart';
import 'package:lakbay/features/events/crud/join_event.dart';
import 'package:lakbay/features/events/crud/read_event.dart';
import 'package:lakbay/features/events/events_page.dart';
import 'package:lakbay/features/explore/customer_home_page.dart';
import 'package:lakbay/features/inbox/inbox_page.dart';
import 'package:lakbay/features/inbox/read_inbox.dart';
import 'package:lakbay/features/listings/accommodation_booking_details.dart';
import 'package:lakbay/features/listings/crud/add_accommodation.dart';
import 'package:lakbay/features/listings/crud/add_entertainment.dart';
import 'package:lakbay/features/listings/crud/add_food.dart';
import 'package:lakbay/features/listings/crud/add_tours.dart';
import 'package:lakbay/features/listings/crud/add_transport.dart';
import 'package:lakbay/features/listings/crud/choose_category.dart';
import 'package:lakbay/features/listings/crud/customer_accommodation.dart';
import 'package:lakbay/features/listings/crud/customer_entertainment.dart';
import 'package:lakbay/features/listings/crud/customer_food.dart';
import 'package:lakbay/features/listings/crud/customer_transportation.dart';
import 'package:lakbay/features/listings/listings_page.dart';
import 'package:lakbay/features/market/market_page.dart';
import 'package:lakbay/features/profile/crud/edit_profile.dart';
import 'package:lakbay/features/profile/profile_customer_page.dart';
import 'package:lakbay/features/tasks/event_tasks_add.dart';
import 'package:lakbay/features/tasks/event_tasks_edit.dart';
import 'package:lakbay/features/tasks/event_tasks_read.dart';
import 'package:lakbay/features/trips/plan/plan_page.dart';
import 'package:lakbay/features/trips/plan/screens/plan_add_activity.dart';
import 'package:lakbay/features/trips/plan/screens/plan_search_listing.dart';
import 'package:lakbay/features/trips/plan/screens/plan_select_date.dart';
import 'package:lakbay/features/trips/plan/screens/plan_select_location.dart';
import 'package:lakbay/features/trips/screens/trips_add_activity.dart';
import 'package:lakbay/features/trips/screens/trips_add_trip.dart';
import 'package:lakbay/features/trips/screens/trips_details.dart';
import 'package:lakbay/features/trips/screens/trips_edit_trip.dart';
import 'package:lakbay/features/trips/screens/trips_info.dart';
import 'package:lakbay/features/trips/trips_page.dart';
import 'package:lakbay/features/wiki/crud/add_wiki.dart';
import 'package:lakbay/features/wiki/crud/edit_wiki.dart';
import 'package:lakbay/features/wiki/crud/read_wiki.dart';
import 'package:lakbay/features/wiki/wiki_page.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/event_model.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/plan_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/task_model.dart';
import 'package:lakbay/models/user_model.dart';
import 'package:lakbay/models/wiki_model.dart';

// import 'package:lakbay/features/trips/trips_page.dart';
typedef WidgetBuilderWithParams = Widget Function(
    BuildContext context, Map<String, String> pathParameters, dynamic extra);

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
      return '/trips';
    }
    // Authenticated
    return null;
  }

  // Route without extras or path parameters
  GoRoute buildMainRoute(String path, Widget page, [List<GoRoute>? subRoutes]) {
    return GoRoute(
      path: path,
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
        context: context,
        state: state,
        child: page,
      ),
      routes: subRoutes ?? [],
    );
  }

  // Route with extras and path parameters
  GoRoute buildSubRoute(String path, WidgetBuilderWithParams pageBuilder,
      {String? name, List<GoRoute>? subRoutes}) {
    return GoRoute(
      path: path,
      name: name,
      pageBuilder: (context, state) {
        var extra = state.extra; // Adjust this as per your data type
        var pathParameters = state.pathParameters;
        return buildPageWithSharedAxisTransition<void>(
          context: context,
          state: state,
          child: pageBuilder(context, pathParameters, extra),
          transitionType: SharedAxisTransitionType.vertical,
        );
      },
      routes: subRoutes ?? [],
    );
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
              // * DRAWER VIEW

              // Profile Page
              buildSubRoute('/profile/id/:userId',
                  (context, pathParameters, extra) {
                return ProfilePage(userId: pathParameters['userId']!);
              }),

              // Edit Profile Page
              buildSubRoute('/profile/edit', (context, pathParameters, extra) {
                UserModel user = extra as UserModel;

                return EditProfilePage(
                  user: user,
                );
              }),

              // My Coop Dashboard
              buildSubRoute('/my_coop/dashboard/:uid',
                  (context, pathParameters, extra) {
                return CoopDashboard(coopId: pathParameters['uid']!);
              }),

              // * CUSTOMER VIEW
              // Plan Page
              buildMainRoute('/plan', const PlanPage(), [
                // Calendar Page
                buildSubRoute(
                  'calendar',
                  (context, pathParameters, extra) {
                    return const PlanSelectDate();
                  },
                ),

                // Location Page
                buildSubRoute(
                  'location',
                  (context, pathParameters, extra) {
                    return const PlanSelectLocation();
                  },
                ),

                // Add Activity Page
                buildSubRoute(
                  'add_activity',
                  (context, pathParameters, extra) {
                    return const PlanAddActivity();
                  },
                  subRoutes: [
                    // Search Listing Page
                    buildSubRoute(
                      'search_listing/:category',
                      (context, pathParameters, extra) {
                        return PlanSearchListing(
                          category: pathParameters['category']!,
                        );
                      },
                    ),
                  ],
                ),
              ]),

              // Home Page
              buildMainRoute('/customer_home', const CustomerHomePage()),

              // Trips Page
              buildMainRoute(
                '/trips',
                const TripsPage(),
                [
                  // Add Trip
                  buildSubRoute(
                    'add',
                    (context, pathParameters, extra) {
                      return const TripsAddTrip();
                    },
                  ),

                  // Edit Trip
                  buildSubRoute(
                    'edit',
                    (context, pathParameters, extra) {
                      PlanModel plan = extra as PlanModel;
                      return TripsEditTrip(
                        plan: plan,
                      );
                    },
                    name: 'edit_trip',
                  ),

                  // Details
                  buildSubRoute(
                    'details/:planUid',
                    (context, pathParameters, extra) {
                      return TripDetailsPlan(
                        planUid: pathParameters['planUid']!,
                      );
                    },
                    name: 'trips_details',
                  ),

                  // Info
                  buildSubRoute(
                    'info',
                    (context, pathParameters, extra) {
                      PlanModel plan = extra as PlanModel;
                      return TripsInfo(
                        plan: plan,
                      );
                    },
                  ),

                  // Add activity
                  buildSubRoute(
                    'add_activity',
                    (context, pathParameters, extra) {
                      PlanModel plan = extra as PlanModel;
                      return TripsAddActivity(
                        plan: plan,
                      );
                    },
                  ),
                ],
              ),

              // Events Page
              buildMainRoute('/events', const EventsPage()),

              // Coops Page
              buildMainRoute(
                '/coops',
                const CoopsPage(),
                [
                  // Add Cooperative
                  buildSubRoute('register',
                      (context, pathParameters, extra) => const AddCoopPage()),
                  // Read Cooperative
                  buildSubRoute(
                      'id/:coopId',
                      (context, pathParameters, extra) =>
                          ReadCoopPage(coopId: pathParameters['coopId']!)),
                  // Edit Cooperative
                  buildSubRoute(
                    'edit',
                    (context, pathParameters, extra) {
                      CooperativeModel coop = extra as CooperativeModel;

                      return EditCoopPage(
                        coop: coop,
                      );
                    },
                    name: 'edit_coop',
                  ),
                  // Join Cooperative
                  buildSubRoute(
                    'join',
                    (context, pathParameters, extra) {
                      CooperativeModel coop = extra as CooperativeModel;

                      return JoinCoopPage(
                        coop: coop,
                      );
                    },
                    name: 'join_coop',
                  ),
                  // Join Cooperative With Code
                  buildSubRoute(
                    'join_code',
                    (context, pathParameters, extra) {
                      CooperativeModel coop = extra as CooperativeModel;

                      return JoinCoopPage(
                        coop: coop,
                        isMember: true,
                      );
                    },
                    name: 'join_coop_with_code',
                  ),
                  // Leave Cooperative
                  buildSubRoute(
                    'leave',
                    (context, pathParameters, extra) {
                      CooperativeModel coop = extra as CooperativeModel;

                      return LeaveCoopPage(
                        coop: coop,
                      );
                    },
                    name: 'leave_coop',
                  ),
                  // Manage Committess
                  buildSubRoute(
                    'manage_committees/:committeeName',
                    (context, pathParameters, extra) {
                      CooperativeModel coop = extra as CooperativeModel;

                      return ManageCommitteesPage(
                        coop: coop,
                        committeeName: pathParameters['committeeName']!,
                      );
                    },
                    name: 'manage_committees',
                  ),
                  // Manage Privileges
                  buildSubRoute(
                    'manage_privileges',
                    (context, pathParameters, extra) {
                      CooperativeModel coop = extra as CooperativeModel;

                      return ManagePrivileges(
                        coop: coop,
                      );
                    },
                    name: 'manage_privileges',
                  ),
                  // Join Cooperative Code
                  buildSubRoute(
                    'join_coop_code',
                    (context, pathParameters, extra) {
                      CooperativeModel coop = extra as CooperativeModel;

                      return JoinCoopCodePage(
                        coop: coop,
                      );
                    },
                    name: 'join_coop_code',
                  ),
                  // Add Committee Members
                  buildSubRoute(
                    'add_committee_members/:committeeName',
                    (context, pathParameters, extra) {
                      CooperativeModel coop = extra as CooperativeModel;

                      return AddCommitteeMembersPage(
                        coop: coop,
                        committeeName: pathParameters['committeeName']!,
                      );
                    },
                    name: 'add_committee_members',
                  ),
                ],
              ),

              // Inbox Page
              buildMainRoute(
                '/inbox',
                const InboxPage(),
                [
                  // Read Inbox
                  buildSubRoute(
                    'id/:senderId',
                    (context, pathParameters, extra) {
                      types.Room room = extra as types.Room;

                      return ReadInboxPage(
                        senderId: pathParameters['senderId']!,
                        room: room,
                      );
                    },
                    name: 'read_inbox',
                  ),
                ],
              ),

              // * COOP VIEW

              // Today Page
              buildMainRoute('/today', const TodayPage()),

              // Calendar Page
              buildMainRoute('/calendar', const CalendarPage()),

              // Community Hub Page
              buildSubRoute('/my_coop/listings/:coopId',
                  (context, pathParameters, extra) {
                return ListingsPage(coopId: pathParameters['coopId']!);
              }),

              // My Coop Page
              buildSubRoute('/my_coop/:coopId',
                  (context, pathParameters, extra) {
                return MyCoopPage(coopId: pathParameters['coopId']!);
              }),

              // * LISTINGS VIEW
              // Read Listing
              buildMainRoute(
                '/market',
                const MarketPage(),
                [
                  buildSubRoute(
                    ':category',
                    (context, pathParameters, extra) {
                      ListingModel listing = extra as ListingModel;

                      switch (pathParameters['category']) {
                        case 'Accommodation':
                          return CustomerAccomodation(
                            listing: listing,
                          );
                        case 'Transport':
                          return CustomerTransportation(
                            listing: listing,
                          );
                        case 'Food':
                          return CustomerFood(
                            listing: listing,
                          );
                        case 'Entertainment':
                          return CustomerEntertainment(
                            listing: listing,
                          );
                        // case 'Touring':
                        //   return SelectedTouringPage(
                        //     listing: listing,
                        //   );
                        default:
                          return CustomerAccomodation(
                            listing: listing,
                          );
                      }
                    },
                    subRoutes: [
                      buildSubRoute(
                        'booking_details',
                        (context, pathParameters, extra) {
                          final Map<String, dynamic> bookingDetails =
                              extra as Map<String, dynamic>;
                          final ListingBookings booking =
                              bookingDetails['booking'] as ListingBookings;
                          final ListingModel listing =
                              bookingDetails['listing'] as ListingModel;

                          switch (pathParameters['category']) {
                            case 'Accommodation':
                              return AccommodationBookingsDetails(
                                booking: booking,
                                listing: listing,
                              );

                            // case 'Transport':
                            //   return CustomerTransportation(
                            //     listing: listing,
                            //   );
                            // case 'Food':
                            //   return CustomerFood(
                            //     listing: listing,
                            //   );
                            // case 'Entertainment':
                            //   return CustomerEntertainment(
                            //     listing: listing,
                            //   );
                            // case 'Touring':
                            //   return SelectedTouringPage(
                            //     listing: listing,
                            //   );
                            default:
                              return AccommodationBookingsDetails(
                                booking: booking,
                                listing: listing,
                              );
                          }
                        },
                        name: 'booking_details',
                      ),
                    ],
                  )
                ],
              ),
              // Add Listing to Cooperative
              buildSubRoute(
                '/my_coop/listings/functions/add_listing',
                (context, pathParameters, extra) {
                  CooperativeModel coop = extra as CooperativeModel;

                  return ChooseCategory(
                    coop: coop,
                  );
                },
                name: 'add_listing',
                subRoutes: [
                  buildSubRoute(
                    'accommodation',
                    (context, pathParameters, extra) {
                      CooperativeModel coop = extra as CooperativeModel;

                      return AddAccommodation(
                          coop: coop, category: "Accommodation");
                    },
                    name: 'add_accommodation',
                  ),
                  buildSubRoute(
                    'transport',
                    (context, pathParameters, extra) {
                      CooperativeModel coop = extra as CooperativeModel;

                      return AddTransport(coop: coop, category: "Transport");
                    },
                    name: 'add_transport',
                  ),
                  buildSubRoute(
                    'food',
                    (context, pathParameters, extra) {
                      CooperativeModel coop = extra as CooperativeModel;

                      return AddFood(coop: coop, category: 'Food');
                    },
                    name: 'add_food',
                  ),
                  buildSubRoute(
                    'entertainment',
                    (context, pathParameters, extra) {
                      CooperativeModel coop = extra as CooperativeModel;

                      return AddEntertainment(
                          coop: coop, category: 'Entertainment');
                    },
                    name: 'add_entertainment',
                  ),
                  buildSubRoute(
                    'tour',
                    (context, pathParameters, extra) {
                      CooperativeModel coop = extra as CooperativeModel;

                      return AddTour(coop: coop);
                    },
                    name: 'add_tour',
                  ),
                ],
              ),

              // * EVENTS VIEW
              // Edit Event
              buildSubRoute(
                '/edit_event',
                (context, pathParameters, extra) {
                  EventModel event = extra as EventModel;

                  return EditEventPage(
                    event: event,
                  );
                },
                name: 'edit_event',
              ),

              // Read Event
              buildSubRoute('/read_event/:eventId',
                  (context, pathParameters, extra) {
                return ReadEventPage(eventId: pathParameters['eventId']!);
              }),

              // Event Manager Tools
              buildSubRoute(
                '/read_event/functions/manager_tools',
                (context, pathParameters, extra) {
                  EventModel event = extra as EventModel;

                  return EventManagerToolsPage(
                    event: event,
                  );
                },
                name: 'event_manager_tools',
              ),

              // Join Event
              buildSubRoute(
                '/join_event',
                (context, pathParameters, extra) {
                  EventModel event = extra as EventModel;

                  return JoinEventPage(
                    event: event,
                  );
                },
                name: 'join_event',
              ),

              // Confirm Event
              buildSubRoute(
                '/confirm_event',
                (context, pathParameters, extra) {
                  EventModel event = extra as EventModel;

                  return ConfirmEventPage(
                    event: event,
                  );
                },
                name: 'confirm_event',
              ),

              // Read Event from my coop
              buildSubRoute('/my_coop/event/:eventId',
                  (context, pathParameters, extra) {
                return CoopReadEventPage(eventId: pathParameters['eventId']!);
              }),

              // Add tasks for event
              buildSubRoute(
                '/my_coop/event/task/functions/add',
                (context, pathParameters, extra) {
                  EventModel event = extra as EventModel;

                  return AddEventTask(
                    event: event,
                  );
                },
                name: 'add_event_task',
              ),

              // Edit tasks for event
              buildSubRoute(
                '/my_coop/event/task/functions/edit',
                (context, pathParameters, extra) {
                  TaskModel task = extra as TaskModel;

                  return EditEventTask(
                    task: task,
                  );
                },
                name: 'edit_event_task',
              ),

              // Read tasks for event
              buildSubRoute(
                '/my_coop/event/task/functions/read/:taskId',
                (context, pathParameters, extra) {
                  return ReadEventTask(
                    taskId: pathParameters['taskId']!,
                  );
                },
                name: 'read_event_task',
              ),

              // Add Event to Cooperative
              buildSubRoute(
                '/my_coop/events/functions/add',
                (context, pathParameters, extra) {
                  CooperativeModel coop = extra as CooperativeModel;

                  return AddEventPage(
                    coop: coop,
                  );
                },
                name: 'add_event',
              ),

              buildSubRoute('/my_coop/functions/events',
                  (context, pathParameters, extra) {
                return const EventsPage();
              }),

              // Manager Tools
              buildSubRoute(
                '/my_coop/functions/manager_tools',
                (context, pathParameters, extra) {
                  CooperativeModel coop = extra as CooperativeModel;

                  return ManagerToolsPage(
                    coop: coop,
                  );
                },
                name: 'manager_tools',
              ),

              // View My Coop Members
              buildSubRoute(
                '/my_coop/functions/members',
                (context, pathParameters, extra) {
                  CooperativeModel coop = extra as CooperativeModel;

                  return MembersPage(
                    coop: coop,
                  );
                },
                name: 'coop_members',
                subRoutes: [
                  buildSubRoute(
                    ':userId',
                    (context, pathParameters, extra) {
                      return ReadMemberPage(userId: pathParameters['userId']!);
                    },
                    name: 'read_member',
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
                  child:
                      const AddWikiPage(), // Replace with your actual AddWikiPage widget
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
                    transitionType: SharedAxisTransitionType.vertical,
                  );
                },
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
