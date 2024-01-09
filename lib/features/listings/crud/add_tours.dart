import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/models/coop_model.dart';

class AddTour extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  const AddTour({required this.coop, super.key});

  @override
  ConsumerState<AddTour> createState() => _AddTourState();
}

class _AddTourState extends ConsumerState<AddTour> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}