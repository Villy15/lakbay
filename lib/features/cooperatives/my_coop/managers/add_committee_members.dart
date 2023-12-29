// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';
import 'package:lakbay/models/user_model.dart';

class AddCommitteeMembersPage extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  final String committeeName;
  const AddCommitteeMembersPage(
      {super.key, required this.coop, required this.committeeName});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddCommitteeMembersPageState();
}

class _AddCommitteeMembersPageState
    extends ConsumerState<AddCommitteeMembersPage> {
  void readMember(UserModel user) {
    context.push('/my_coop/functions/members/${user.uid}');
  }

  void addCommitteeMembers(
      BuildContext context, CooperativeModel coop, String committeeName) {
    context.pushNamed(
      'add_committee_members',
      extra: coop,
      pathParameters: {'committeeName': committeeName},
    );
  }

  List<CooperativeMembers> members = [];

  void addMember(CooperativeMembers member) {
    setState(() {
      members.add(member);
    });
  }

  void removeMember(CooperativeMembers member) {
    setState(() {
      members.remove(member);
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  void onSave() {
    // Change the role of members using copyWith
    members = members.map((member) {
      // Create a new committee
      CooperativeMembersRole newCommittee = CooperativeMembersRole(
        committeeName: widget.committeeName,
        role: 'Member', // Replace 'Role' with the actual role
        timestamp: DateTime.now(),
      );

      // Add the new committee to the existing committees
      List<CooperativeMembersRole> updatedCommittees =
          List.from(member.committees ?? []);
      updatedCommittees.add(newCommittee);

      // Return the member with the updated committees
      return member.copyWith(
        committees: updatedCommittees,
      );
    }).toList();

    ref.read(coopsControllerProvider.notifier).updateMembers(
          widget.coop.uid!,
          members,
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    // final user = ref.watch(userProvider);

    return ref.watch(getAllMembersProvider(widget.coop.uid!)).when(
          data: (members) {
            return PopScope(
              canPop: false,
              onPopInvoked: (bool didPop) {
                context.pop();
                ref.read(navBarVisibilityProvider.notifier).show();
              },
              child: Scaffold(
                appBar:
                    AppBar(title: Text('${widget.committeeName} Committees')),
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
                          onSave();
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // All Managers
                        _managersHeading('Add Tourism Committee Members'),

                        ListView.separated(
                          itemCount: members.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final member = members[index];

                            // Check if member is already in the committee
                            if (member.isCommitteeMember('Tourism')) {
                              // Add to uids
                              members.add(member);
                            }

                            return ref
                                .watch(getUserDataProvider(member.uid!))
                                .when(
                                  data: (user) {
                                    return listMember(user, member, context);
                                  },
                                  error: (error, stackTrace) =>
                                      const SizedBox(),
                                  loading: () => const SizedBox(),
                                );
                          },
                          separatorBuilder: (context, index) => const Divider(),
                        ),
                      ],
                    ),
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

  Widget listMember(
      UserModel user, CooperativeMembers member, BuildContext context) {
    return ListTile(
      onTap: () {
        if (members.contains(member)) {
          removeMember(member);
        } else {
          addMember(member);
        }
      },
      title: Text(user.name),
      subtitle: Text(member.role?.role ?? 'Test'),
      trailing: Checkbox(
        value: members.contains(member),
        onChanged: (value) {
          if (value!) {
            addMember(member);
          } else {
            removeMember(member);
          }
        },
      ),
      leading: CircleAvatar(
        radius: 20.0,
        backgroundImage:
            user.profilePic != '' ? NetworkImage(user.profilePic) : null,
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        child: user.profilePic == ''
            ? Text(
                user.name[0].toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                ),
              )
            : null,
      ),
    );
  }
}
