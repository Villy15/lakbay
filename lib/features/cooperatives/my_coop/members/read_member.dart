import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/user/user_controller.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/user_model.dart';

class ReadMemberPage extends ConsumerStatefulWidget {
  final String userId;
  const ReadMemberPage({super.key, required this.userId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReadMemberPageState();
}

class _ReadMemberPageState extends ConsumerState<ReadMemberPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  void pop() {
    context.pop();
    ref.read(navBarVisibilityProvider.notifier).show();
  }

  void editProfile(UserModel user) {
    context.pushNamed(
      'edit_profile',
      extra: user,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getUserProvider(widget.userId)).when(
          data: (UserModel userModel) {
            return ref
                .watch(getCooperativeProvider(userModel.currentCoop!))
                .when(
                  data: (CooperativeModel coop) {
                    return PopScope(
                      canPop: false,
                      onPopInvoked: (bool didPop) {
                        pop();
                      },
                      child: Scaffold(
                        appBar: _appBar(userModel),
                        body: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Card Similar to AirBnb
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: profileCard(context, userModel, coop),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  error: (error, stackTrace) => Scaffold(
                    body: ErrorText(
                      error: error.toString(),
                      stackTrace: stackTrace.toString(),
                    ),
                  ),
                  loading: () => const Scaffold(
                    body: Loader(),
                  ),
                );
          },
          error: (error, stackTrace) => Scaffold(
            body: ErrorText(
              error: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          ),
          loading: () => const Scaffold(
            body: Loader(),
          ),
        );
  }

  AppBar _appBar(UserModel user) {
    return AppBar(
      title: const Text('Coop Profile Page'),
      actions: [
        TextButton(
          onPressed: () {
            editProfile(user);
          },
          child: const Text(
            'Edit',
            style: TextStyle(
              fontSize: 16,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Card profileCard(
      BuildContext context, UserModel userModel, CooperativeModel coop) {
    return Card(
      surfaceTintColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: userModel.profilePic != ''
                      ? NetworkImage(userModel.profilePic)
                      : null,
                  backgroundColor: Theme.of(context).colorScheme.onBackground,
                  child: userModel.profilePic == ''
                      ? Text(
                          userModel.name[0].toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                            fontSize: 40,
                          ),
                        )
                      : null,
                ),

                // Name
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    userModel.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Role
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Text(
                    userModel.role,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                children: [
                  // Review count
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '1',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Review',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),

                      // Divider
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          height: 1,
                          width: 100,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ],
                  ),

                  // Review count
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '1',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Month in Lakbay',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),

                      // Divider
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          height: 1,
                          width: 100,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
