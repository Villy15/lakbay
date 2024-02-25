import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.booking,
    required this.listing,
  });

  final ListingBookings booking;
  final ListingModel listing;

  void _onTap(BuildContext context) {
    context.push('/market/${booking.category}/booking_details',
        extra: {'booking': booking, 'listing': listing});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      borderOnForeground: true,
      // Add a border to the card
      surfaceTintColor: Theme.of(context).colorScheme.background,
      margin: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 4.0,
      ),
      child: ListTile(
        onTap: () {
          _onTap(context);
        },
        title: Text(booking.listingTitle),
        // subtitle Start Date - End Date, format it to Feb 26, 2024
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${DateFormat('MMM dd, yyyy').format(booking.startDate!)} - ${DateFormat('MMM dd, yyyy').format(booking.endDate!)}",
            ),

            // Customer Name
            Text(
              "Customer: ${booking.customerName}",
            ),

            // Guests
            Text(
              "Guests: ${booking.guests}",
            ),
          ],
        ),
        trailing: Text(
          booking.bookingStatus,
        ),

        // display Image in leading
        leading: Image.network(
          listing.images!.first.url!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
