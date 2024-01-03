// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
// import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/subcollections/coop_privileges_model.dart';

class ManagePrivileges extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  const ManagePrivileges({super.key, required this.coop});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManagePrivilegesState();
}

class _ManagePrivilegesState extends ConsumerState<ManagePrivileges> {
  // Tourism Committee Privileges

  @override
  void initState() {
    super.initState();
  }

  void initializePrivileges() {
    ref
        .read(coopsControllerProvider.notifier)
        .initializePrivileges(widget.coop.uid!);
  }

  void updatePrivileges(CooperativePrivileges privilege) {
    ref
        .read(coopsControllerProvider.notifier)
        .updatePrivilege(widget.coop.uid!, privilege, context);
  }

  @override
  Widget build(BuildContext context) {
    // final user = ref.watch(userProvider);

    return ref.watch(getAllPrivilegesProvider(widget.coop.uid!)).when(
        data: (privileges) {
          // Find the privilege for the 'Tourism' committee
          final tourismPrivilege = privileges.firstWhere(
            (privilege) => privilege.committeeName == 'Tourism',
            orElse: () {
              return CooperativePrivileges(
                committeeName: 'Tourism',
                managerPrivileges: [],
                memberPrivileges: [],
              );
            },
          );

          // Find the privilege for the 'Events' committee
          final eventsPrivilege = privileges.firstWhere(
            (privilege) => privilege.committeeName == 'Events',
            orElse: () {
              return CooperativePrivileges(
                committeeName: 'Events',
                managerPrivileges: [],
                memberPrivileges: [],
              );
            },
          );

          return Scaffold(
            appBar: AppBar(title: const Text('Manage Privileges')),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // All Managers
                    // Button to initialize privileges
                    ElevatedButton(
                      onPressed: () => initializePrivileges(),
                      child: const Text('Initialize Privileges'),
                    ),
                    committeePrivileges(tourismPrivilege),
                    committeePrivileges(eventsPrivilege),
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
            ));
  }

  Column committeePrivileges(CooperativePrivileges privilege) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _managersHeading('Tourism Committee'),
        _subHeading('Managers'),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: privilege.managerPrivileges.length,
          itemBuilder: (context, index) {
            final managerPrivilege = privilege.managerPrivileges[index];

            return SwitchListTile(
              title: Text(managerPrivilege.privilegeName),
              value: managerPrivilege.isAllowed,
              onChanged: (value) {
                final updatedManagerPrivileges =
                    privilege.managerPrivileges.map((p) {
                  if (p == managerPrivilege) {
                    return p.copyWith(isAllowed: value);
                  }
                  return p;
                }).toList();

                final updatedPrivilege = privilege.copyWith(
                    managerPrivileges: updatedManagerPrivileges);

                updatePrivileges(updatedPrivilege);
              },
            );
          },
          separatorBuilder: (context, index) => const Divider(),
        ),
        _subHeading('Members'),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: privilege.memberPrivileges.length,
          itemBuilder: (context, index) {
            final memberPrivilege = privilege.memberPrivileges[index];

            return SwitchListTile(
              title: Text(memberPrivilege.privilegeName),
              value: memberPrivilege.isAllowed,
              onChanged: (value) {
                final updatedMemberPrivileges =
                    privilege.memberPrivileges.map((p) {
                  if (p == memberPrivilege) {
                    return p.copyWith(isAllowed: value);
                  }
                  return p;
                }).toList();

                final updatedPrivilege = privilege.copyWith(
                    memberPrivileges: updatedMemberPrivileges);

                updatePrivileges(updatedPrivilege);
              },
            );
          },
          separatorBuilder: (context, index) => const Divider(),
        ),
      ],
    );
  }

  Padding _managersHeading(String heading) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        heading,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Padding _subHeading(String heading) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        heading,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
