import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';

class ManagerDashboardPage extends ConsumerStatefulWidget {
  const ManagerDashboardPage({super.key});

  @override
  ConsumerState<ManagerDashboardPage> createState() =>
      _ManagerDashboardPageState();
}

class _ManagerDashboardPageState extends ConsumerState<ManagerDashboardPage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
        appBar: CustomAppBar(title: 'Dashboard', user: user),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              Center(child: Text('Manager Dashboard Page')),
            ],
          ),
        ));
  }
}
