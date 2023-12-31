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
  final bool? isMember;

  const JoinCoopPage({super.key, required this.coop, this.isMember});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JoinCoopPageState();
}

class _JoinCoopPageState extends ConsumerState<JoinCoopPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _codeController = TextEditingController();

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

  void joinCooperative() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    final userUid = ref.read(userProvider)?.uid ?? '';
    // Add user to members in Coop
    var updatedCoop = widget.coop.copyWith(
      members: [...widget.coop.members, userUid],
    );

    // Update coop
    ref
        .read(coopsControllerProvider.notifier)
        .joinCooperative(updatedCoop, context);
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
        appBar: AppBar(title: const Text('Join Cooperative')),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // If isMember is true, add an input where he can input the code

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

                    // Check if code is correct
                    if (_codeController.text == widget.coop.code) {
                      // Join Cooperative
                      joinCooperative();
                    } else {
                      // Show error
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invalid Code'),
                        ),
                      );
                    }
                  }
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      children: [
                        widget.isMember == true
                            ? TextFormField(
                                controller: _codeController,
                                decoration: const InputDecoration(
                                  icon: Icon(
                                    Icons.forward_rounded,
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter Code*',
                                  helperText: '*required',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter code';
                                  }
                                  return null;
                                },
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
