import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/bookings/widgets/booking_card.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/listings/listing_controller.dart';

class BookingsPage extends ConsumerStatefulWidget {
  const BookingsPage({super.key});

  @override
  ConsumerState<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends ConsumerState<BookingsPage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);

    return Scaffold(
      appBar: CustomAppBar(title: 'Bookings', user: user),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                ref.watch(getAllBookingsByCustomerIdProvider(user!.uid)).when(
                      data: (bookings) {
                        // return a grid view of events
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: bookings.length,
                          itemBuilder: (context, index) {
                            final booking = bookings[index];

                            return ref
                                .watch(getListingProvider(booking.listingId))
                                .when(
                                  data: (listing) {
                                    return BookingCard(
                                      booking: booking,
                                      listing: listing,
                                    );
                                  },
                                  error: (error, stackTrace) => ErrorText(
                                    error: error.toString(),
                                    stackTrace: '',
                                  ),
                                  loading: () => const Loader(),
                                );
                          },
                        );
                      },
                      error: (error, stackTrace) => ErrorText(
                        error: error.toString(),
                        stackTrace: '',
                      ),
                      loading: () => const Loader(),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
