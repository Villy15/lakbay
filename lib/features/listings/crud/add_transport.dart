import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/models/coop_model.dart';

class AddTransport extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  const AddTransport({required this.coop, super.key});

  @override
  ConsumerState<AddTransport> createState() => _AddTransportState();
}

class _AddTransportState extends ConsumerState<AddTransport> {
  // global key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // stepper
  int activeStep = 0;
  int upperBound = 6;

  // initial values
  String type = 'Nature-Based';
  
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}