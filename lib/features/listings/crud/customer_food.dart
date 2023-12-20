import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/models/listing_model.dart';

class CustomerFood extends ConsumerStatefulWidget {
  final ListingModel listing;
  const CustomerFood({super.key, required this.listing});

  @override
  ConsumerState<CustomerFood> createState() => _CustomerFoodState();
}

class _CustomerFoodState extends ConsumerState<CustomerFood> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
