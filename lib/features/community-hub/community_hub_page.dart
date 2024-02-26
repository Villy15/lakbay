import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/app_bar_provider.dart';
import 'package:lakbay/features/community-hub/components/community_listing_card.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/events/events_controller.dart';
import 'package:lakbay/features/events/widgets/event_card.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';
import 'package:lakbay/models/subcollections/coop_privileges_model.dart';
import 'package:lakbay/models/user_model.dart';

class ListingsPage extends ConsumerStatefulWidget {
  final String coopId;
  const ListingsPage({super.key, required this.coopId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListingsPageState();
}

class _ListingsPageState extends ConsumerState<ListingsPage> {
  void addListing(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'add_listing',
      extra: coop,
    );
  }

  void addEvent(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'add_event',
      extra: coop,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final member = ref.watch(getMemberProvider(user!.uid)).asData?.value;
    final privilege = ref.watch(getPrivilegeProvider("Tourism")).asData?.value;
    final scaffoldKey = ref.watch(scaffoldKeyProvider);

    return ref.watch(getCooperativeProvider(widget.coopId)).when(
          data: (CooperativeModel coop) {
            // Get all listings by the cooperative
            debugPrintJson("File Name: listings_page.dart");
            return DefaultTabController(
              initialIndex: 0,
              length: 2,
              child: Scaffold(
                appBar: _appBar(
                  scaffoldKey,
                  user,
                  context,
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TabBarView(
                    children: [
                      ref
                          .watch(getListingsByCoopProvider(widget.coopId))
                          .maybeWhen(
                            data: (List<ListingModel> listings) {
                              return ListView.builder(
                                itemCount: listings.length,
                                itemBuilder: (context, index) {
                                  final listing = listings[index];
                                  return CommunityHubListingCard(
                                      listing: listing);
                                },
                              );
                            },
                            orElse: () => const SizedBox.shrink(),
                          ),

                      ref
                          .watch(getEventsByCoopIdProvider(widget.coopId))
                          .maybeWhen(
                            data: (events) {
                              return ListView.builder(
                                itemCount: events.length,
                                itemBuilder: (context, index) {
                                  final event = events[index];
                                  return EventCard(event: event);
                                },
                              );
                            },
                            orElse: () => const SizedBox.shrink(),
                          ),

                      // ref.watch(getEventsByCoopProvider(widget.coopId)).maybeWhen(
                      //   data: (List<ListingModel> listings) {
                      //     return ListView.builder(
                      //       itemCount: listings.length,
                      //       itemBuilder: (context, index) {
                      //         final listing = listings[index];
                      //         return ListingCard(
                      //           listing: listing,
                      //         );
                      //       },
                      //     );
                      //   },
                      //   orElse: () => const SizedBox.shrink(),
                      // ),
                    ],
                  ),
                ),
                floatingActionButton:
                    buildAddListingButton(member, privilege, context, coop),
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

  PreferredSize _appBar(GlobalKey<ScaffoldState> scaffoldKey, UserModel? user,
      BuildContext context) {
    List<Widget> tabs = [
      const SizedBox(
        width: 100.0,
        child: Tab(
          icon: Icon(Icons.event_outlined),
          child: Flexible(child: Text('Listings')),
        ),
      ),
      const SizedBox(
        width: 100.0,
        child: Tab(
          icon: Icon(Icons.travel_explore_outlined),
          child: Flexible(child: Text('Events')),
        ),
      ),
    ];

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 75),
      child: AppBar(
        title: const Text(
          'Community Hub',
        ),
        // Add icon on the right side of the app bar of a person
        actions: [
          IconButton(
            onPressed: () {
              context.push('/inbox');
            },
            icon: const Badge(
              isLabelVisible: true,
              label: Text('3'),
              child: Icon(Icons.inbox_outlined),
            ),
          ),
          IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openEndDrawer();
            },
            icon: CircleAvatar(
              radius: 20.0,
              backgroundImage:
                  user?.profilePic != null && user?.profilePic != ''
                      ? NetworkImage(user!.profilePic)
                      : null,
              backgroundColor: Theme.of(context).colorScheme.onBackground,
              child: user?.profilePic == null || user?.profilePic == ''
                  ? Text(
                      user?.name[0].toUpperCase() ?? 'L',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                      ),
                    )
                  : null,
            ),
          ),
        ],
        bottom: TabBar(
          tabs: tabs,
        ),
      ),
    );
  }

  Widget buildAddListingButton(
      CooperativeMembers? member,
      CooperativePrivileges? privilege,
      BuildContext context,
      CooperativeModel coop) {
    bool isMemberNotNull = member != null;
    bool isPrivilegeNotNull = privilege != null;
    bool isRoleValid = member?.committeeRole("Tourism") == "Manager" ||
        member?.committeeRole("Tourism") == "Member";
    bool isPrivilegeAllowed =
        privilege?.isManagerPrivilegeAllowed("Add listing") ?? false;

    if (!isMemberNotNull ||
        !isPrivilegeNotNull ||
        !isRoleValid ||
        !isPrivilegeAllowed) {
      return const SizedBox.shrink();
    }

    return SpeedDial(
      icon: Icons.more_vert,
      activeIcon: Icons.close,
      renderOverlay: false,
      overlayOpacity: 0.5,
      elevation: 8.0,
      shape: const CircleBorder(),
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.add),
          label: 'Add Listing',
          labelStyle: const TextStyle(fontSize: 18.0),
          onTap: () => addListing(context, coop),
        ),

        // Add event
        SpeedDialChild(
          child: const Icon(Icons.add),
          label: 'Add Event',
          labelStyle: const TextStyle(fontSize: 18.0),
          onTap: () => addEvent(context, coop),
        ),
      ],
    );
  }
}
