// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
// import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';
import 'package:lakbay/models/user_model.dart';

class ManageCommitteesPage extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  final String committeeName;
  const ManageCommitteesPage(
      {super.key, required this.coop, required this.committeeName});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManageCommitteesPageState();
}

class _ManageCommitteesPageState extends ConsumerState<ManageCommitteesPage> {
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

  void removeCommitteeMember(BuildContext context, CooperativeMembers member) {
    if (!mounted) return;

    // Update member to remove committee
    member = member.copyWith(
      committees: member.committees!
          .where((committee) => committee.committeeName != widget.committeeName)
          .toList(),
    );

    // Update member
    ref.read(coopsControllerProvider.notifier).updateMember(
          widget.coop.uid!,
          member.uid!,
          member,
          context,
        );
  }

  void makeMemberManager(BuildContext context, CooperativeMembers member) {
    if (!mounted) return;

    // Update member to remove committee
    member = member.copyWith(
      committees: member.committees!
          .map((committee) => committee.committeeName == widget.committeeName
              ? committee.copyWith(
                  role: committee.role == 'Manager' ? 'Member' : 'Manager')
              : committee)
          .toList(),
    );

    // Update member
    ref.read(coopsControllerProvider.notifier).updateMember(
          widget.coop.uid!,
          member.uid!,
          member,
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    // final user = ref.watch(userProvider);
    // final scaffoldKey = ref.watch(scaffoldKeyProvider);
    debugPrintJson("File Name: manage_committees_page.dart");

    return ref.watch(getAllMembersProvider(widget.coop.uid!)).when(
          data: (members) {
            // Filter members by committee Name and filter out managers
            members = members
                .where(
                    (member) => member.isCommitteeMember(widget.committeeName))
                .toList();

            // Seperate managers and members
            final managers = members
                .where((member) =>
                    member.committees!
                        .any((committee) => committee.role == 'Manager') &&
                    member.committees!.any((committee) =>
                        committee.committeeName == widget.committeeName))
                .toList();

            // Remove managers from members list
            members.removeWhere((member) => managers.contains(member));
            return Scaffold(
              appBar: AppBar(title: Text('${widget.committeeName} Committee')),
              floatingActionButton: FloatingActionButton(
                onPressed: () => {
                  addCommitteeMembers(
                      context, widget.coop, widget.committeeName),
                },
                child: const Icon(Icons.add),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // All Managers
                      _managersHeading('Managers'),

                      managers.isEmpty
                          ? const Center(child: Text('No managers'))
                          : ListView.separated(
                              itemCount: managers.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final member = managers[index];

                                return ref
                                    .watch(getUserDataProvider(member.uid!))
                                    .when(
                                      data: (user) {
                                        return listMember(
                                            user, member, context);
                                      },
                                      error: (error, stackTrace) =>
                                          const SizedBox(),
                                      loading: () => const SizedBox(),
                                    );
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                            ),

                      // All Members
                      _managersHeading('Members'),

                      members.isEmpty
                          ? const Center(child: Text('No members'))
                          : ListView.separated(
                              itemCount: members.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final member = members[index];

                                // debugPrint(member.toString());

                                return ref
                                    .watch(getUserDataProvider(member.uid!))
                                    .when(
                                      data: (user) {
                                        return listMember(
                                            user, member, context);
                                      },
                                      error: (error, stackTrace) =>
                                          const SizedBox(),
                                      loading: () => const SizedBox(),
                                    );
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(),
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
    return Slidable(
      key: Key(user.uid),
      endActionPane: ActionPane(
        extentRatio: 0.75,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            borderRadius: BorderRadius.circular(8.0),
            onPressed: (context) {
              if (mounted) {
                makeMemberManager(context, member);
              }
            },
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            foregroundColor: Theme.of(context).colorScheme.background,
            icon: Icons.edit,
            label: member.isCommitteeManager ? 'Member' : 'Manager',
          ),
          const SizedBox(width: 8.0),
          // Manager slide action
          SlidableAction(
            // An action can be bigger than the others.
            borderRadius: BorderRadius.circular(8.0),
            onPressed: (context) {
              if (mounted) {
                removeCommitteeMember(context, member);
              }
            },
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.background,
            icon: Icons.archive,
            label: 'Remove',
          ),
        ],
      ),
      child: ListTile(
        onTap: () => {
          readMember(user),
        },
        title: Text(user.name),
        subtitle: Text(member.role?.role ?? 'Test'),
        trailing: const Icon(Icons.arrow_forward_rounded),
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
      ),
    );
  }
}
