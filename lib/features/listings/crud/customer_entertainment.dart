import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/models/listing_model.dart';

class CustomerEntertainment extends ConsumerStatefulWidget {
  final ListingModel listing;
  const CustomerEntertainment({super.key, required this.listing});

  @override
  ConsumerState<CustomerEntertainment> createState() =>
      _CustomerEntertainmentState();
}

class _CustomerEntertainmentState extends ConsumerState<CustomerEntertainment> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
