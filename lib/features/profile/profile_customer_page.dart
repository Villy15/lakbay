import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/user/user_controller.dart';
import 'package:lakbay/models/user_model.dart';

class ProfilePage extends ConsumerStatefulWidget {
  final String userId;
  const ProfilePage({super.key, required this.userId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
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
            Map<String, Function> settings = {
              'Display Name': () => ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Display Name'),
                    subtitle: Text(userModel.name),
                  ),
              // First Name
              'First Name': () => ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('First Name'),
                    subtitle:
                        Text(userModel.firstName ?? 'No first name provided'),
                  ),

              // Last Name
              'Last Name': () => ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Last Name'),
                    subtitle:
                        Text(userModel.lastName ?? 'No last name provided'),
                  ),
              'Email': () => ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: Text(userModel.email ?? 'No email'),
                  ),
              'Phone Number': () => ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Phone Number'),
                    subtitle:
                        Text(userModel.phoneNo ?? 'No phone number provided'),
                  ),

              // Address
              'Address': () => ListTile(
                    leading: const Icon(Icons.location_on),
                    title: const Text('Address'),
                    subtitle: Text(userModel.address ?? 'No address provided'),
                  ),

              // Emergency Contact
              'Emergency Contact': () => ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Emergency Contact'),
                    subtitle: Text(userModel.emergencyContact ??
                        'No emergency contact provided'),
                  ),
              'Government ID': () => ListTile(
                    leading: const Icon(Icons.credit_card),
                    title: const Text('Government ID'),
                    subtitle: Text(
                      userModel.governmentId ??
                        'No government ID provided'),
                  ),
            };

            Map<String, Function> documents = {
              // Valid ID
              'Valid ID': () => ListTile(
                    leading: const Icon(Icons.file_copy),
                    title: const Text('Valid ID'),
                    // Trailing arrow
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                    subtitle: Text(
                      userModel.validIdUrl != null && userModel.validIdUrl != ''
                          ? 'Valid ID provided'
                          : 'No valid ID uploaded',
                    ),
                  ),
              'Birth Certificate': () => ListTile(
                    leading: const Icon(Icons.file_copy),
                    title: const Text('Birth Certificate'),
                    // Trailing arrow
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                    subtitle: Text(
                      userModel.birthCertificateUrl != null &&
                              userModel.birthCertificateUrl != ''
                          ? 'Birth Certificate provided'
                          : 'No birth certificate uploaded',
                    ),
                  ),
            };

            return PopScope(
              canPop: false,
              onPopInvoked: (bool didPop) {
                pop();
              },
              child: Scaffold(
                appBar: _appBar(userModel),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card Similar to AirBnb
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: profileCard(context, userModel),
                      ),

                      // SizedBox
                      const SizedBox(height: 16.0),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // SizedBox
                      const SizedBox(height: 8.0),

                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: settings.length,
                        itemBuilder: (context, index) {
                          final key = settings.keys.elementAt(index);
                          final listTile = settings[key]!();
                          return listTile;
                        },
                        separatorBuilder: (context, index) => const Divider(),
                      ),

                      // SizedBox
                      const SizedBox(height: 16.0),

                      // Documents Uploaded for Coop
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Documents Uploaded for Coop',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // SizedBox
                      const SizedBox(height: 8.0),

                      // Documents
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          final key = documents.keys.elementAt(index);
                          final listTile = documents[key]!();
                          return listTile;
                        },
                        separatorBuilder: (context, index) => const Divider(),
                      ),
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
  }

  AppBar _appBar(UserModel user) {
    return AppBar(
      title: const Text('Profile Page'),
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

  Card profileCard(BuildContext context, UserModel userModel) {
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
                      Text(
                        userModel.reviews?.length.toString() ?? '0',
                        style: const TextStyle(
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
                      Text(
                        calculateMonths(userModel.createdAt),
                        style: const TextStyle(
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

String calculateMonths(DateTime? createdAt) {
  if (createdAt == null) {
    return '1';
  }

  int months = max(1, DateTime.now().difference(createdAt).inDays ~/ 30);
  return '$months';
}
