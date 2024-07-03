import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/calendar/components/event_card.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/events/events_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/listings/widgets/listing_card.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/event_model.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/user_model.dart';
import 'package:lakbay/models/wrappers/join_coop_params.dart';

class ReadCoopPage extends ConsumerStatefulWidget {
  final String coopId;
  const ReadCoopPage({super.key, required this.coopId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReadCoopPageState();
}

class _ReadCoopPageState extends ConsumerState<ReadCoopPage> {
  late final UserModel user;
  bool applicationPending = false;

  @override
  void initState() {
    super.initState();
    user = ref.read(userProvider)!;
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkPending();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  void checkPending() async {
    Query query = FirebaseFirestore.instance
        .collection("cooperatives")
        .doc(widget.coopId)
        .collection("applications")
        .where('userUid', isEqualTo: user.uid)
        .where("status", isEqualTo: "pending");
    final List<JoinCoopParams> application =
        await ref.watch(getApplicationByProperties(query).future);

    debugPrint("application: $application");
    setState(() {
      applicationPending = application.isNotEmpty;
    });
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

  void joinCoop(BuildContext context, CooperativeModel coop) async {
    final result = await context.pushNamed(
      'join_coop',
      extra: coop,
    );

    if (result == true) {
      checkPending();
    }
  }

  void joinCoopWithCode(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'join_coop_with_code',
      extra: coop,
    );
  }

  List<Widget> tabs = [
    const SizedBox(
      width: 150.0,
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_outlined),
            SizedBox(width: 4.0),
            Text('Events'),
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
            Icon(Icons.travel_explore_outlined),
            SizedBox(width: 4.0),
            Text('Listings'),
          ],
        ),
      ),
    ),
  ];

  // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< RENDER UI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  @override
  Widget build(BuildContext context) {
    // ref.read(navBarVisibilityProvider.notifier).hide();
    return ref.watch(getCooperativeProvider(widget.coopId)).when(
          data: (CooperativeModel coop) {
            return DefaultTabController(
              initialIndex: 0,
              length: tabs.length,
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    sliverAppBar(coop, context),
                    // sliverPaddingHeader(coop, user, context),
                    sliverAppBarHeaderWithTabs(coop, user, context),
                  ];
                },
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TabBarView(
                    children: [
                      // Events
                      buildListViewEvents(
                          ref.watch(getEventsByCoopIdProvider(coop.uid!))),
                      // Listings
                      buildListViewListings(
                          ref.watch(getListingsByCoopProvider(coop.uid!))),
                    ],
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

  Widget buildListViewEvents(AsyncValue<List<EventModel>> events) {
    return events.when(
      data: (data) {
        if (data.isEmpty) {
          return emptyEvents();
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final event = data[index];
              return Card(
                clipBehavior: Clip.hardEdge,
                elevation: 1,
                surfaceTintColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: InkWell(
                  splashColor: Colors.orange.withAlpha(30),
                  onTap: ()  =>   readEvent(context, event.uid!),
                  child: SizedBox(
                    width: double.infinity,
                    // height: 290,
                    child: Column(
                      children: [
                        // Random Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                              20), // round the corners of the image
                          child: Image(
                            image: NetworkImage(event.imageUrl!),
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Card Title
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text(
                                  event.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Card Start Date - End Date
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 1.0, 1.0, 1.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  1.0, 12.0, 8.0, 8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${DateFormat('d MMM yyyy').format(event.startDate!)} - ${DateFormat('d MMM yyyy').format(event.endDate!)}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
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
        if (data.isEmpty) {
          return emptyListings();
        } else {
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
        }
      },
      error: (error, stackTrace) =>
          ErrorText(error: error.toString(), stackTrace: stackTrace.toString()),
      loading: () => const Scaffold(
        body: Loader(),
      ),
    );
  }

  void readEvent(BuildContext context, String eventId) {
    context.push("/read_event/$eventId").then((onValue) {
      ref.read(navBarVisibilityProvider.notifier).hide();
    }) ;
  }

  SliverAppBar sliverAppBarHeaderWithTabs(
      CooperativeModel coop, UserModel? user, BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      collapsedHeight: kToolbarHeight,
      floating: true,
      snap: true,
      automaticallyImplyLeading: false,
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
                  applicationPending == true
                      ? OutlinedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                            ),
                          ),
                          child: const Text("Pending"))
                      : OutlinedButton(
                          onPressed: () {
                            if (coop.members.contains(user?.uid)) {
                              showSnackBar(
                                  context, "Switch to Coop View to leave");
                            } else {
                              // showDialog(
                              //     context: context,
                              //     builder: (context) {
                              //       return AlertDialog(
                              //         title: const Text('Join Cooperative'),
                              //         content: const Text(
                              //             'Are you already a member of this cooperetive?'),
                              //         actions: [
                              //           // Cancel
                              //           TextButton(
                              //             onPressed: () {
                              //               context.pop();
                              //               joinCoop(context, coop);
                              //             },
                              //             child: const Text('No'),
                              //           ),
                              //           TextButton(
                              //             onPressed: () {
                              //               context.pop();
                              //               joinCoopWithCode(context, coop);
                              //             },
                              //             child: const Text('Yes'),
                              //           ),
                              //         ],
                              //       );
                              //     });

                              joinCoop(context, coop);
                            }
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
              Text(
                coop.description ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
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
              const SizedBox(height: 5),
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

  Widget emptyListings() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'lib/core/images/SleepingCatFromGlitch.svg',
                  height: 100, // Adjust height as desired
                ),
                const SizedBox(height: 20),
                const Text(
                  'No listings so far!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Stay tuned for more updates!',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget emptyEvents() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'lib/core/images/SleepingCatFromGlitch.svg',
                  height: 100, // Adjust height as desired
                ),
                const SizedBox(height: 20),
                const Text(
                  'No events so far!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Stay tuned for more updates!',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

  // Future<dynamic> _showModalBottomSheet(
  //     BuildContext context, CooperativeModel coop) {
  //   return showModalBottomSheet(
  //       isScrollControlled: true,
  //       showDragHandle: true,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return SizedBox(
  //           height: MediaQuery.of(context).size.height * 0.2,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               ListTile(
  //                 onTap: () => leaveCoop(context, coop),
  //                 leading: const Icon(Icons.warning),
  //                 title: const Text('Leave Cooperative'),
  //                 subtitle: const Text(
  //                     'Are you sure you want to leave this cooperative?'),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  SliverAppBar sliverAppBar(CooperativeModel coop, BuildContext context) {
    return SliverAppBar(
      expandedHeight: 150,
      collapsedHeight: kToolbarHeight,
      pinned: true,
      floating: true,
      snap: true,
      leading: IconButton(
        onPressed: () {
          ref.read(navBarVisibilityProvider.notifier).show();
          context.pop();
        },
        icon: const Icon(Icons.arrow_back),
      ),
      actionsIconTheme: const IconThemeData(
        opacity: 1,
      ),
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Calculate the percentage of the expanded height
          double percent = ((constraints.maxHeight - kToolbarHeight) /
              (150 - kToolbarHeight));
          return FlexibleSpaceBar(
            titlePadding: const EdgeInsets.fromLTRB(70, 40, 16, 0),
            title: percent < 0.36 // Show title when the appBar is 50% collapsed
                ? Row(
                    children: [
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
    );
  }
}
