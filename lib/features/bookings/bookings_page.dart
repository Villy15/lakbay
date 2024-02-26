import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  FilledButton createNewTrip() {
    return FilledButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(
          double.infinity,
          50,
        )), // Set width to double.infinity
      ),
      onPressed: () {
        onNewTripPressed();
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add),
          SizedBox(width: 10),
          Text('CREATE A NEW TRIP'),
        ],
      ),
    );
  }

  void onNewTripPressed() {
    context.push(
      '/trips/add',
    );
  }

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ref.watch(getAllBookingsByCustomerIdProvider(user!.uid)).when(
                      data: (bookings) {
                        // If bookings is empty, show a message
                        if (bookings.isEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'No Bookings Yet',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Let's create a new trip header
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Create a new trip to start planning your next adventure!',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              createNewTrip(),
                            ],
                          );
                        }
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
