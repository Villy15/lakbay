import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class CustomerTransportReceipt extends ConsumerWidget {
  final ListingModel listing;
  final ListingBookings booking;
  const CustomerTransportReceipt(
      {super.key, required this.listing, required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height / 10),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[300]!, width: 2.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: const Offset(0, 3))
                    ],
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Booking Successful!'),
                      const Text('Booking Information'),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Booking Ref No: '),
                            Text('${booking.id}')
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Payment Option: '),
                            Text('${booking.paymentOption}')
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Status: '),
                            Text(booking.bookingStatus)
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Listing Title: '),
                            Text(listing.title)
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Trip: '),
                            Text('${booking.typeOfTrip}')
                          ]),
                      if (booking.typeOfTrip == 'Public') ...[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Booked Date: '),
                              Text(_formatDatetime(booking.startDate!))
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Departure Time: '),
                              Text(_formatTimeOfDay(booking.startTime!))
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Pickup Point: '),
                              Text('${listing.availableTransport?.pickupPoint}')
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Destination: '),
                              Text('${listing.availableTransport?.destination}')
                            ]),
                      ] else ...[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Booked First Date: '),
                              Text(_formatDatetime(booking.startDate!))
                            ]),
                      ],
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Guests: '),
                            Text('${booking.guests}')
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Customer Name: '),
                            Text(booking.customerName)
                          ]),
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
                          const Text("Price:"),
                          Text(" ${booking.price}"),
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
                              ref
                                  .read(parentStateProvider.notifier)
                                  .setState(true);
                              context.pop();
                            },
                            child: const Text("Close")),
                      )
                    ]))));
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  String _formatDatetime(DateTime dateTime) {
    final format = DateFormat('yyyy-MM-dd'); // Format the date as "yyyy-MM-dd"
    return format.format(dateTime);
  }
}
