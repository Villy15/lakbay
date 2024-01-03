import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/models/coop_model.dart';

class LeaveCoopPage extends ConsumerStatefulWidget {
  final CooperativeModel coop;

  const LeaveCoopPage({super.key, required this.coop});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LeaveCoopPageState();
}

class _LeaveCoopPageState extends ConsumerState<LeaveCoopPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });

    // Set initial values
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed.

    super.dispose();
  }

  void leaveCooperative(CooperativeModel coop) {
    ref.read(coopsControllerProvider.notifier).leaveCooperative(coop, context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(coopsControllerProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Leave Cooperative')),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cancel Button
              TextButton(
                onPressed: () {
                  context.pop();
                  ref.read(navBarVisibilityProvider.notifier).show();
                },
                child: const Text('Cancel'),
              ),

              // Save Button
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }

                  final userUid = ref.read(userProvider)?.uid ?? '';
                  // Remove user to members in Coop
                  final updatedCoop = widget.coop.copyWith(
                    members: widget.coop.members
                        .where((member) => member != userUid)
                        .toList(),
                  );

                  // Update coop
                  leaveCooperative(updatedCoop);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
        body: isLoading
            ? const Loader()
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      children: [],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
