import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/models/listing_model.dart';

class CustomerFoodService extends ConsumerStatefulWidget {
  final ListingModel listing;
  const CustomerFoodService({super.key, required this.listing});

  @override
  ConsumerState<CustomerFoodService> createState() =>
      _CustomerFoodServiceState();
}

class _CustomerFoodServiceState extends ConsumerState<CustomerFoodService> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
