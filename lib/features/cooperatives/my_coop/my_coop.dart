import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/cooperatives/my_coop/components/announcement_card.dart';
import 'package:lakbay/features/cooperatives/my_coop/components/goal_card.dart';
import 'package:lakbay/features/events/events_controller.dart';
import 'package:lakbay/features/events/widgets/event_card.dart';
import 'package:lakbay/features/listings/widgets/listing_card.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/event_model.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/coop_announcements_model.dart';
import 'package:lakbay/models/subcollections/coop_goals_model.dart';
import 'package:lakbay/models/user_model.dart';

class MyCoopPage extends ConsumerStatefulWidget {
  final String coopId;
  const MyCoopPage({super.key, required this.coopId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyCoopPageState();
}

class _MyCoopPageState extends ConsumerState<MyCoopPage> {
  late List<CoopAnnouncements> coopAnnouncements;
  late List<CoopGoals> coopGoals;

  @override
  void initState() {
    super.initState();
    coopAnnouncements = [
      CoopAnnouncements(
        title:
            'Cooperative Partners with [Coop_Name] Cooperative for Sustainable Tourism',
        description:
            'We\'re excited to announce a partnership with [Coop_Name] to promote eco-conscious travel practices. Get access to training resources, best practices, and potential funding.',
        timestamp: DateTime.now(),
        category: 'Sustainability',
      ),

      // New Announcement Examples:

      CoopAnnouncements(
        title:
            'Experience the Flavors of [Region]: Culinary Festival Announced!',
        description:
            'Join us for a celebration of local cuisine on [dates]. Sample food from our member restaurants, attend cooking demonstrations, and enjoy live music!',
        timestamp: DateTime.now()
            .subtract(const Duration(days: 3)), // Set to a few days ago
        category: 'Event',
      ),

      CoopAnnouncements(
        title: 'Grant Program for Tourism Businesses Now Open',
        description:
            'The [program name] is accepting applications to support [types of projects]. Find eligibility details and the application deadline on [website]. ',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        category: 'Funding',
      ),

      CoopAnnouncements(
        title: 'Member Spotlight: [Business Name] Wins Prestigious Award',
        description:
            'Congratulations to [Business Name] for their recognition at the [award name]! Their commitment to quality tourism strengthens our community.',
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        category: 'Member News',
      ),
    ];

    coopGoals = [
      CoopGoals(
        title: 'Increase Overall Bookings',
        description:
            'Achieve a 10% increase in bookings across all categories within the next year.',
        targetDate: DateTime.now().add(const Duration(days: 365)),
        category: 'Economic Development',
        metrics: ['% increase in overall bookings'], // Adjust metrics as needed
        progress: 0.5, // Example progress
      ),
      CoopGoals(
        title: 'Boost Shoulder-Season Tourism',
        description:
            'Increase bookings during Q4 by 15% through targeted promotions and packages.',
        targetDate:
            DateTime(2024, 6, 30), // Example target within shoulder season
        category: 'Economic Development',
        metrics: [
          '% increase in shoulder-season bookings',
          'Number of promotions'
        ],
        progress: 0.3, // Example progress
      ),
      CoopGoals(
        title: 'Promote Multi-Offering Packages',
        description:
            'Develop and sell 5 new package deals that combine multiple cooperative offerings (e.g., lodging + tour + food experience), increasing average revenue per customer.',
        targetDate: DateTime(2023, 12, 31),
        category: 'Economic Development',
        metrics: [
          'Number of package deals created',
          'Average revenue per customer'
        ],
        progress: 0.7, // Example progress
      ),
    ];
  }

  void viewMembers(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'coop_members',
      extra: coop,
    );
  }

  void viewEvents(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'coop_events',
      extra: coop,
    );
  }

  void managerTools(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'manager_tools',
      extra: coop,
    );
  }

  void leaveCoop(BuildContext context, CooperativeModel coop) {
    context.pop();
    context.pushNamed(
      'leave_coop',
      extra: coop,
    );
  }

  List<Widget> tabs = [
    const SizedBox(
      width: 160.0,
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_outlined),
            SizedBox(width: 4.0),
            Text('Announcements'),
          ],
        ),
      ),
    ),
    const SizedBox(
      width: 150.0,
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Recommend a goals icon
            Icon(Icons.emoji_events_outlined),
            SizedBox(width: 4.0),
            Text('Goals'),
          ],
        ),
      ),
    ),
    const SizedBox(
      width: 150.0,
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Recommend a election icon
            Icon(Icons.how_to_vote_outlined),
            SizedBox(width: 4.0),
            Text('Voting'),
          ],
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return ref.watch(getCooperativeProvider(widget.coopId)).when(
          data: (CooperativeModel coop) {
            return DefaultTabController(
              initialIndex: 0,
              length: tabs.length,
              child: Scaffold(
                body: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      sliverAppBar(coop),
                      // sliverPaddingHeader(coop, user, context),
                      sliverAppBarHeaderWithTabs(coop, user, context),
                    ];
                  },
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TabBarView(
                      children: [
                        // Announcements
                        _coopAnnouncements(),

                        _coopGoals(),

                        buildListViewEvents(
                            ref.watch(getEventsByCoopIdProvider(coop.uid!))),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          error: (error, stackTrace) => Scaffold(
            body: ErrorText(
              error: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          ),
          loading: () => const Scaffold(
            body: Loader(),
          ),
        );
  }

  Widget _coopGoals() {
    return ListView.separated(
      separatorBuilder: (context, index) => const Padding(
        padding: EdgeInsets.only(bottom: 16.0),
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: coopGoals.length,
      itemBuilder: (context, index) {
        final coopGoal = coopGoals[index];

        return GoalCard(
          goal: coopGoal,
        );
      },
    );
  }

  ListView _coopAnnouncements() {
    return ListView.separated(
      separatorBuilder: (context, index) => const Padding(
        padding: EdgeInsets.only(bottom: 16.0),
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: coopAnnouncements.length,
      itemBuilder: (context, index) {
        final announcement = coopAnnouncements[index];

        return AnnouncementCard(
          announcement: announcement,
        );
      },
    );
  }

  // Build Events
  Widget buildListViewEvents(AsyncValue<List<EventModel>> events) {
    return events.when(
      data: (data) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final event = data[index];
            return EventCard(event: event);
          },
        );
      },
      error: (error, stackTrace) =>
          ErrorText(error: error.toString(), stackTrace: stackTrace.toString()),
      loading: () => const Scaffold(
        body: Loader(),
      ),
    );
  }

  Widget buildListViewListings(AsyncValue<List<ListingModel>> listings) {
    return listings.when(
      data: (data) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final listing = data[index];
            return ListingCard(
              listing: listing,
            );
          },
        );
      },
      error: (error, stackTrace) =>
          ErrorText(error: error.toString(), stackTrace: stackTrace.toString()),
      loading: () => const Scaffold(
        body: Loader(),
      ),
    );
  }

  SliverAppBar sliverAppBarHeaderWithTabs(
      CooperativeModel coop, UserModel? user, BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      collapsedHeight: kToolbarHeight,
      floating: true,
      snap: true,
      actions: const [
        Icon(Icons.search, color: Colors.transparent),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      coop.imageUrl!,
                    ),
                    radius: 35,
                  ),
                  coop.managers.contains(user?.uid)
                      ? OutlinedButton(
                          onPressed: () {
                            managerTools(context, coop);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                            ),
                          ),
                          child: const Text('Manager Tools'),
                        )
                      : OutlinedButton(
                          onPressed: () {
                            _showModalBottomSheet(context, coop);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                            ),
                          ),
                          child: Text(
                            coop.members.contains(user?.uid)
                                ? 'Joined'
                                : 'Join',
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                coop.name,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),

              // Joined Date
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 14,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Joined December 2023',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${coop.members.length}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text('Members'),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      viewMembers(context, coop);
                    },
                    child: const Text('View Members'),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ),
      ),
      bottom: TabBar(
        tabAlignment: TabAlignment.start,
        labelPadding: EdgeInsets.zero,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: tabs,
      ),
    );
  }

  // SliverPadding sliverPaddingHeader(
  //     CooperativeModel coop, UserModel? user, BuildContext context) {
  //   return SliverPadding(
  //     padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
  //     sliver: SliverList(
  //       delegate: SliverChildListDelegate(
  //         [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               CircleAvatar(
  //                 backgroundImage: NetworkImage(
  //                   coop.imageUrl!,
  //                 ),
  //                 radius: 35,
  //               ),
  //               coop.managers.contains(user?.uid)
  //                   ? OutlinedButton(
  //                       onPressed: () {
  //                         managerTools(context, coop);
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(20),
  //                         ),
  //                         padding: const EdgeInsets.symmetric(
  //                           horizontal: 25,
  //                         ),
  //                       ),
  //                       child: const Text('Manager Tools'),
  //                     )
  //                   : OutlinedButton(
  //                       onPressed: () {
  //                         _showModalBottomSheet(context, coop);
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(20),
  //                         ),
  //                         padding: const EdgeInsets.symmetric(
  //                           horizontal: 25,
  //                         ),
  //                       ),
  //                       child: Text(coop.members.contains(user?.uid)
  //                           ? 'Joined'
  //                           : 'Join'),
  //                     ),
  //             ],
  //           ),
  //           const SizedBox(height: 5),
  //           Text(
  //             coop.name,
  //             style: const TextStyle(
  //               fontSize: 19,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           const SizedBox(height: 5),
  //           Text(
  //             coop.description ?? '',
  //             maxLines: 2,
  //             overflow: TextOverflow.ellipsis,
  //             style: const TextStyle(
  //               fontSize: 14,
  //             ),
  //           ),
  //           const SizedBox(height: 5),
  //           // Joined Date
  //           Row(
  //             children: [
  //               const Icon(
  //                 Icons.calendar_today,
  //                 size: 14,
  //               ),
  //               const SizedBox(width: 5),
  //               Text(
  //                 'Joined April 2015 !! Constant',
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   color: Theme.of(context)
  //                       .colorScheme
  //                       .onSurface
  //                       .withOpacity(0.5),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 5),
  //           Row(
  //             children: [
  //               Text(
  //                 '${coop.members.length}',
  //                 style: const TextStyle(
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               const SizedBox(width: 5),
  //               const Text('Members'),
  //               const SizedBox(width: 10),
  //               TextButton(
  //                 onPressed: () {
  //                   viewMembers(context, coop);
  //                 },
  //                 child: const Text('View Members'),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<dynamic> _showModalBottomSheet(
      BuildContext context, CooperativeModel coop) {
    return showModalBottomSheet(
        isScrollControlled: true,
        showDragHandle: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  onTap: () => leaveCoop(context, coop),
                  leading: const Icon(Icons.warning),
                  title: const Text('Leave Cooperative'),
                  subtitle: const Text(
                      'Are you sure you want to leave this cooperative?'),
                ),
              ],
            ),
          );
        });
  }

  SliverAppBar sliverAppBar(CooperativeModel coop) {
    return SliverAppBar(
      expandedHeight: 100,
      collapsedHeight: kToolbarHeight,
      pinned: true,
      floating: true,
      snap: true,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Calculate the percentage of the expanded height
          double percent = ((constraints.maxHeight - kToolbarHeight) /
              (100 - kToolbarHeight));
          return FlexibleSpaceBar(
            titlePadding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
            title: percent < 0.8 // Show title when the appBar is 50% collapsed
                ? Row(
                    children: [
                      // CircleAvatar
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          coop.imageUrl!,
                        ),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            coop.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            '${coop.members.length} Members',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : null,
            background: DisplayImage(
              imageUrl: coop.imageUrl,
              height: 150,
              width: double.infinity,
              radius: BorderRadius.zero,
            ),
          );
        },
      ),
      actionsIconTheme: const IconThemeData(
        opacity: 0.5,
      ),
    );
  }
}
