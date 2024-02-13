import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/app_bar_provider.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/user_model.dart';

class BookingsPage extends ConsumerStatefulWidget {
  const BookingsPage({super.key});

  @override
  ConsumerState<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends ConsumerState<BookingsPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final scaffoldKey = ref.watch(scaffoldKeyProvider);

    return ref.watch(getAllBookingsByCustomerIdProvider(user!.uid)).when(
          data: (List<ListingBookings> bookings) {
            // Get all listings by the cooperative
            debugPrintJson("File Name: bookings_page.dart");
            return DefaultTabController(
              initialIndex: 0,
              length: 4,
              child: Scaffold(
                appBar: _appBar(
                  scaffoldKey,
                  user,
                  context,
                ),
                body: TabBarView(
                  children: [
                    reserved(bookings),
                    const Placeholder(),
                    const Placeholder(),
                    const Placeholder(),
                  ],
                ),
                floatingActionButton: null,
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
      SizedBox(
        width: MediaQuery.sizeOf(context).width / 5,
        child: const Tab(
          child: Text(
            "Reserved",
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
      SizedBox(
        width: MediaQuery.sizeOf(context).width / 5,
        child: const Tab(
          child: Text(
            'Completed',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
      SizedBox(
        width: MediaQuery.sizeOf(context).width / 5,
        child: const Tab(
          child: Text(
            'Cancelled',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
      SizedBox(
        width: MediaQuery.sizeOf(context).width / 5,
        child: const Tab(
          child: Text(
            'Refunded',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    ];

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 75),
      child: AppBar(
        title: const Text(
          'Bookings',
        ),
        // Add icon on the right side of the app bar of a person
        actions: [
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
          tabAlignment: TabAlignment.center,
          isScrollable: true,
          tabs: tabs,
        ),
      ),
    );
  }

  reserved(List<ListingBookings> bookings) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return Text(bookings[index].id!);
        });
  }

  Widget accommodationBookingCard() {
    return const Card();
  }
}
