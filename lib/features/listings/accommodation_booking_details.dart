// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class AccommodationBookingsDetails extends StatefulWidget {
  final ListingBookings booking;
  const AccommodationBookingsDetails({
    super.key,
    required this.booking,
  });

  @override
  State<AccommodationBookingsDetails> createState() =>
      _AccommodationBookingsDetailsState();
}

class _AccommodationBookingsDetailsState
    extends State<AccommodationBookingsDetails> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
