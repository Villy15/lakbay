import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/trips/plan/plan_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class ManageFood extends ConsumerStatefulWidget {
  final ListingModel listing;
  const ManageFood({super.key, required this.listing});

  @override
  ConsumerState<ManageFood> createState() => _ManageFoodState();
}

class _ManageFoodState extends ConsumerState<ManageFood> {
  List<SizedBox> tabs = [
    const SizedBox(width: 100, child: Tab(child: Text('Bookings'))),
    const SizedBox(width: 100, child: Tab(child: Text('Details')))
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  AppBar _appBar(String title, BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          // fontFamily: 'Satisfy',
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottom: TabBar(
        tabAlignment: TabAlignment.center,
        labelPadding: EdgeInsets.zero,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: tabs,
      ),
    );
  }

  Widget build(BuildContext context) {
    final planUid = ref.read(currentPlanIdProvider);
    final isLoading = ref.watch(plansControllerProvider);
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: DefaultTabController(
        initialIndex: 0,
        length: tabs.length,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
        )
      )
    );
  }

  Widget bookings() {
    return ref.watch(getAllBookingsProvider(widget.listing.uid!)).when(
        data: (List<ListingBookings> bookings) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: bookings.length,
              itemBuilder: ((context, index) {
                final booking = bookings[index];
                num needsContribution = 0;
                String formattedStartDate =
                    DateFormat('MMMM dd').format(bookings[index].startDate!);

                ref
                    .watch(getBookingTasksByBookingId(
                        (booking.listingId, booking.id!)))
                    .when(
                        data: (List<BookingTask> bookingTasks) {
                          for (var bookingTask in bookingTasks) {
                            needsContribution = needsContribution + 1;
                          }
                        },
                        error: (error, stackTrace) => ErrorText(
                              error: error.toString(),
                              stackTrace: stackTrace.toString(),
                            ),
                        loading: () => const Loader());
              }));
        },
        error: (error, stackTrace) => Scaffold(
              body: ErrorText(
                error: error.toString(),
                stackTrace: stackTrace.toString(),
              ),
            ),
        loading: () => const Scaffold(body: Loader()));
  }
}
