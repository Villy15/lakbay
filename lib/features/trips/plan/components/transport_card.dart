import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class TransportCard extends ConsumerStatefulWidget {
  final String category;
  final List<ListingBookings> bookings;
  const TransportCard(
      {super.key, required this.category, required this.bookings});

  @override
  ConsumerState<TransportCard> createState() => _TransportCardState();
}

class _TransportCardState extends ConsumerState<TransportCard> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
