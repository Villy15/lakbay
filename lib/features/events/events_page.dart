import 'package:flutter/material.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar  (title: 'Events'),
      body: Center(
        child: Text('EventsPage Page'),
      ),
    );
  }
}