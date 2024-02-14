import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class BookingsAccomodationCustomer extends ConsumerStatefulWidget {
  final ListingModel listing;
  final ListingBookings booking;
  const BookingsAccomodationCustomer(
      {super.key, required this.listing, required this.booking});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookingsAccomodationCustomerState();
}

class _BookingsAccomodationCustomerState
    extends ConsumerState<BookingsAccomodationCustomer> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            iconSize: 20,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
              ref.read(navBarVisibilityProvider.notifier).show();
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DisplayImage(
              imageUrl: widget.listing.images!.first.url!,
              height: 250,
              width: double.infinity,
              radius: BorderRadius.zero,
            ),

            // Check in Checkout
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Check In'),
                      Text(
                        DateFormat.yMMMd().format(widget.booking.startDate!),
                      ),
                      // Checkin time
                      Text(
                        DateFormat.jm().format(widget.listing.checkIn!),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Check Out'),
                      Text(
                        DateFormat.yMMMd().format(widget.booking.endDate!),
                      ),
                      // Checkout time
                      Text(
                        DateFormat.jm().format(widget.listing.checkOut!),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // List Tile Message Host
            ListTile(
              leading: const Icon(Icons.message_outlined),
              title: const Text('Message Host'),
              onTap: () {
                context.go('/chat');
              },
            ),

            // List Tile Show Listing
            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: const Text('Show Listing'),
              onTap: () {},
            ),

            // Plan Trip Header
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Plan Trip',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Filled Button Add to a trip
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Go to your trip'),
              ),
            ),

            // Reservation Details Header
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Reservation Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Reservation Details Num of Guests
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.people_alt_outlined),
                  const SizedBox(width: 8),
                  Text(
                    'Number of Guests: ${widget.booking.guests}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            // Cancellation Policy Text
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Cancellation Policy: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),

            // List Tile Refund Reuests
            ListTile(
              leading: const Icon(Icons.request_quote_outlined),
              title: const Text('Request Refund'),
              onTap: () {},
            ),

            // Getting There Header
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Getting There',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Getting There Address
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.listing.city}, ${widget.listing.province}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            // Hosted By Header
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Hosted By',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Hosted by Cooperative Name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.people_alt_outlined),
                  const SizedBox(width: 8),
                  Text(
                    widget.listing.cooperative.cooperativeName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            // Payment Information Header
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Payment Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
