import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/models/listing_model.dart';

class ManageFood extends ConsumerStatefulWidget {
  final ListingModel listing;
  const ManageFood({super.key, required this.listing});

  @override
  ConsumerState<ManageFood> createState() => _ManageFoodState();
}

class _ManageFoodState extends ConsumerState<ManageFood> {
  // List<SizedBox> tabs = []
  Widget build(BuildContext context) {
    return Container();
  }
}
