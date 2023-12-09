import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';

class InboxPage extends ConsumerWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: CustomAppBar(title: 'Inbox', user: user),
      body: const Center(
        child: Text('InboxPage Page'),
      ),
    );
  }
}
