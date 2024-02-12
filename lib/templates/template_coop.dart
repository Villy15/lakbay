import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/models/coop_model.dart';

class JoinCoopCodePage extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  const JoinCoopCodePage({super.key, required this.coop});

  @override
  ConsumerState<JoinCoopCodePage> createState() => _JoinCoopCodePageState();
}

class _JoinCoopCodePageState extends ConsumerState<JoinCoopCodePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Join Cooperative Code')),
        body: const Center(
          child: Text('Join Cooperative Code'),
        ),
      ),
    );
  }
}
