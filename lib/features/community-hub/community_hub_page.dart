import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/app_bar_provider.dart';
import 'package:lakbay/features/community-hub/components/community_events_card.dart';
import 'package:lakbay/features/community-hub/components/community_listing_card.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/events/events_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';
import 'package:lakbay/models/subcollections/coop_privileges_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
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
                  padding: const EdgeInsets.all(16.0),
                  child: TabBarView(
                    children: [
                      _listings(),
                      _events(),
                    ],
                  ),
                ),
                floatingActionButton: buildAddListingButton(
                  member,
                  privilege,
                  context,
                  coop,
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

  Widget _events() {
    return ref.watch(getEventsByCoopIdProvider(widget.coopId)).maybeWhen(
          data: (events) {
            if (events.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'lib/core/images/SleepingCatFromGlitch.svg',
                      height: 100, // Adjust height as desired
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No events yet!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Create an event at the',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      'bottom right corner!',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: CommunityHubEventsCard(event: event),
                );
              },
            );
          },
          orElse: () => const SizedBox.shrink(),
        );
  }

  Widget _listings() {
    return ref.watch(getListingsByCoopProvider(widget.coopId)).maybeWhen(
          data: (List<ListingModel> listings) {
            if (listings.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'lib/core/images/SleepingCatFromGlitch.svg',
                      height: 100, // Adjust height as desired
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No listings yet!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Create a listing at the',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      'bottom right corner!',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Sorting Logic
            listings.sort((a, b) {
              // Calculate the number of bookings for each listing
              final aBookings =
                  ref.watch(getAllBookingsProvider(a.uid!)).asData?.value ?? [];
              final bBookings =
                  ref.watch(getAllBookingsProvider(b.uid!)).asData?.value ?? [];

              // Compare the number of bookings (descending order)
              return bBookings.length.compareTo(aBookings.length);
            });

            return ListView.builder(
              itemCount: listings.length,
              itemBuilder: (context, index) {
                final listing = listings[index];

                return ref
                    .watch(getAllBookingsProvider(listing.uid!))
                    .maybeWhen(
                      data: (List<ListingBookings> bookings) {
                        // Order the listings based on the number of bookings per listings
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: CommunityHubListingCard(
                            listing: listing,
                            bookings: bookings,
                          ),
                        );
                      },
                      orElse: () => const SizedBox.shrink(),
                    );
              },
            );
          },
          orElse: () => const SizedBox.shrink(),
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

    final user = ref.watch(userProvider);

    if (user!.isManager) {
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
