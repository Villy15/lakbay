import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/calendar/components/booking_card.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class ShowAllBookings extends ConsumerStatefulWidget {
  final BuildContext parentContext;
  const ShowAllBookings({
    super.key,
    required this.parentContext,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShowAllBookingsState();
}

class _ShowAllBookingsState extends ConsumerState<ShowAllBookings> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(coopsControllerProvider);
    final user = ref.watch(userProvider);
    return SizedBox(
      height: MediaQuery.of(context).size.height * .95,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upcoming Bookings'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              ref.read(navBarVisibilityProvider.notifier).show();
              context.pop(widget.parentContext);
            },
          ),
        ),
        body: isLoading
            ? const Loader()
            : ref
                .watch(getAllBookingsByCoopIdProvider(user!.currentCoop!))
                .when(
                  data: (bookings) {
                    return _body(bookings);
                  },
                  loading: () => const Loader(),
                  error: (error, stack) {
                    return Center(
                      child: Text(
                        'Error: $error',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  },
                ),
      ),
    );
  }

  SingleChildScrollView _body(List<ListingBookings> bookings) {
    // make bookings appear only if they are within the next 7 days and make it ascending
    final updatedBookings = bookings
        .where((booking) =>
            DateTime.now().isBefore(booking.startDate!) &&
            DateTime.now()
                .add(const Duration(days: 7))
                .isAfter(booking.startDate!))
        .toList()
      ..sort((a, b) => a.startDate!.compareTo(b.startDate!));

    // Show the rest of the bookings after the next 7 days
    final futureBookings = bookings
        .where((booking) => DateTime.now()
            .add(const Duration(days: 7))
            .isBefore(booking.startDate!))
        .toList()
      ..sort((a, b) => a.startDate!.compareTo(b.startDate!));

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This week : ${updatedBookings.length} bookings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ListView.separated(
              itemCount: updatedBookings.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.all(8.0),
              ),
              itemBuilder: (context, index) {
                final booking = updatedBookings[index];
                return ref.watch(getListingProvider(booking.listingId)).when(
                      data: (listing) {
                        return BookingCard(
                          booking: booking,
                          listing: listing,
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) => ErrorText(
                        error: error.toString(),
                        stackTrace: stack.toString(),
                      ),
                    );
              },
            ),
            const SizedBox(height: 10.0),

            // Show the rest of the bookings after the next 7 days
            Text(
              'Future Bookings : ${futureBookings.length} bookings',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            ListView.separated(
              itemCount: futureBookings.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.all(8.0),
              ),
              itemBuilder: (context, index) {
                final booking = futureBookings[index];
                return ref.watch(getListingProvider(booking.listingId)).when(
                      data: (listing) {
                        return BookingCard(
                          booking: booking,
                          listing: listing,
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) => ErrorText(
                        error: error.toString(),
                        stackTrace: stack.toString(),
                      ),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
