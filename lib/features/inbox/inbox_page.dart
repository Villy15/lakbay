import 'package:flutter/material.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Inbox'),
      body: Center(
        child: Text('InboxPage Page'),
      ),
    );
  }
}