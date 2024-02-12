import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class CustomerAccomodationReceipt extends StatelessWidget {
  final ListingModel listing;
  final ListingBookings booking;

  const CustomerAccomodationReceipt(
      {super.key, required this.listing, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            const Text("Booking Successfull!"),
            const Text("Booking Information"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Booking Ref No:"),
                Text("${booking.id}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Payment Option:"),
                Text(" ${booking.paymentOption}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Status:"),
                Text(" ${booking.bookingStatus}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Listing Title:"),
                Text(" ${listing.title}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Room ID:"),
                Text(" ${booking.roomId}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Check In:"),
                Text(" ${booking.startDate}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Check Out:"),
                Text(" ${booking.endDate}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Guests:"),
                Text(" ${booking.guests}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Customer Name:"),
                Text(" ${booking.customerName}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Customer No.:"),
                Text(" ${booking.customerPhoneNo}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Emergency Contact Name:"),
                Text(" ${booking.emergencyContactName}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Emergency Contact No.:"),
                Text(" ${booking.emergencyContactNo}"),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text("Close")),
            )
          ]),
        ),
      ),
    );
  }
}
