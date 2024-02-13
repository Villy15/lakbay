import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
          margin: EdgeInsets.only(top: MediaQuery.sizeOf(context).height / 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white, // Receipts are usually white
            border: Border.all(
              color: Colors.grey[300]!, // Light grey border around the receipt
              width: 2.0, // Border thickness
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Shadow color
                spreadRadius: 2, // Spread radius
                blurRadius: 7, // Blur radius
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(8), // Optional: round corners
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                Text(
                    " ${DateFormat('MMMM dd, yyyy HH:mm').format(booking.startDate!)}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Check Out:"),
                Text(
                    " ${DateFormat('MMMM dd, yyyy HH:mm').format(booking.endDate!)}"),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Room Price:"),
                Text(" ${booking.price}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Night/s:"),
                Text(
                    " ${booking.endDate!.difference(booking.startDate!).inDays}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Amount Paid:"),
                Text(" ${booking.amountPaid!.toStringAsFixed(2)}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Amount Due:"),
                Text(
                    " ${(booking.totalPrice! - booking.amountPaid!).toStringAsFixed(2)}"),
              ],
            ),
            const SizedBox(
              height: 20,
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
