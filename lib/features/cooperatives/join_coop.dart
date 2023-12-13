import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/models/coop_model.dart';

class JoinCoopPage extends ConsumerStatefulWidget {
  final CooperativeModel coop;

  const JoinCoopPage({Key? key, required this.coop}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JoinCoopPageState();
}

class _JoinCoopPageState extends ConsumerState<JoinCoopPage> {
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

  void joinCooperative(CooperativeModel coop) {
    ref.read(coopsControllerProvider.notifier).joinCooperative(coop, context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(coopsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Join Cooperative')),
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
                // Add user to members in Coop
                var updatedCoop = widget.coop.copyWith(
                  members: [...widget.coop.members, userUid],
                );

                // Update coop
                joinCooperative(updatedCoop);
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
    );
  }
}
