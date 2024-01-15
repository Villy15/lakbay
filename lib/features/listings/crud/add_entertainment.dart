import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/models/coop_model.dart';

class AddEntertainment extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  const AddEntertainment({required this.coop, super.key});

  @override
  ConsumerState<AddEntertainment> createState() => _AddEntertainmentState();
}

class _AddEntertainmentState extends ConsumerState<AddEntertainment> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}