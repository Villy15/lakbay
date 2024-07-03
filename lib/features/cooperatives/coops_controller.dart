import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/cooperatives/coops_repository.dart';
import 'package:lakbay/features/notifications/notifications_controller.dart';
import 'package:lakbay/features/user/user_controller.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/notifications_model.dart';
import 'package:lakbay/models/subcollections/coop_announcements_model.dart';
import 'package:lakbay/models/subcollections/coop_goals_model.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';
import 'package:lakbay/models/subcollections/coop_privileges_model.dart';
import 'package:lakbay/models/subcollections/coop_vote_model.dart';
import 'package:lakbay/models/user_model.dart';
import 'package:lakbay/models/wrappers/committee_params.dart';
import 'package:lakbay/models/wrappers/join_coop_params.dart';

// Get all cooperatives provider
final getAllCooperativesProvider = StreamProvider((ref) {
  final coopsController = ref.watch(coopsControllerProvider.notifier);
  return coopsController.getAllCooperatives();
});

// Get a cooperative provider
final getCooperativeProvider =
    StreamProvider.autoDispose.family<CooperativeModel, String>((ref, uid) {
  final coopsController = ref.watch(coopsControllerProvider.notifier);
  return coopsController.getCooperative(uid);
});

// Get cooperatives by member provider
final getCooperativesByMemberProvider = StreamProvider.autoDispose
    .family<List<CooperativeModel>, String>((ref, uid) {
  final coopsController = ref.watch(coopsControllerProvider.notifier);
  return coopsController.getCooperativesByMember(uid);
});

// Cooperative controller provider
final coopsControllerProvider =
    StateNotifierProvider<CoopsController, bool>((ref) {
  final coopsRepository = ref.watch(coopsRepositoryProvider);
  return CoopsController(coopsRepository: coopsRepository, ref: ref);
});

// getMemberProvider
final getMemberProvider = StreamProvider.autoDispose
    .family<CooperativeMembers, String>((ref, memberUid) {
  final coopsController = ref.watch(coopsControllerProvider.notifier);
  return coopsController.getMember(
      ref.read(userProvider)!.currentCoop!, memberUid);
});

// Get all members provider
final getAllMembersProvider = StreamProvider.autoDispose
    .family<List<CooperativeMembers>, String>((ref, coopUid) {
  final coopsController = ref.watch(coopsControllerProvider.notifier);
  return coopsController.getAllMembers(coopUid);
});

// Get all members belongs to a committee name provider
final getAllMembersInCommitteeProvider = StreamProvider.autoDispose
    .family<List<CooperativeMembers>, CommitteeParams>((ref, committeeParams) {
  final coopsController = ref.watch(coopsControllerProvider.notifier);
  return coopsController.getAllMembersInCommittee(
      committeeParams.coopUid, committeeParams.committeeName);
});

// Get all members that does not belong to a committee name provider
final getAllMembersNotInCommitteeProvider = StreamProvider.autoDispose
    .family<List<CooperativeMembers>, CommitteeParams>((ref, committeeParams) {
  final coopsController = ref.watch(coopsControllerProvider.notifier);
  return coopsController.getAllMembersNotInCommittee(
      committeeParams.coopUid, committeeParams.committeeName);
});

// Get a privilege provider
final getPrivilegeProvider = StreamProvider.autoDispose
    .family<CooperativePrivileges, String>((ref, committeeName) {
  final coopsController = ref.watch(coopsControllerProvider.notifier);
  return coopsController.getPrivilege(
      ref.read(userProvider)!.currentCoop!, committeeName);
});

// Get all privileges provider
final getAllPrivilegesProvider = StreamProvider.autoDispose
    .family<List<CooperativePrivileges>, String>((ref, coopUid) {
  final coopsController = ref.watch(coopsControllerProvider.notifier);
  return coopsController.getAllPrivileges(coopUid);
});

// Get all announcements provider
final getAllAnnouncementsProvider = StreamProvider.autoDispose
    .family<List<CoopAnnouncements>, String>((ref, coopUid) {
  final coopsController = ref.watch(coopsControllerProvider.notifier);
  return coopsController.getAllAnnouncements(coopUid);
});

// Get all goals provider
final getAllGoalsProvider =
    StreamProvider.autoDispose.family<List<CoopGoals>, String>((ref, coopUid) {
  final coopsController = ref.watch(coopsControllerProvider.notifier);
  return coopsController.getAllGoals(coopUid);
});

// Get a goal provider
final getGoalProvider =
    StreamProvider.autoDispose.family<CoopGoals, String>((ref, goalUid) {
  final coopsController = ref.watch(coopsControllerProvider.notifier);
  return coopsController.getGoal(ref.read(userProvider)!.currentCoop!, goalUid);
});

// Get all votes provider
final getAllVotesProvider =
    StreamProvider.autoDispose.family<List<CoopVote>, String>((ref, coopUid) {
  final coopsController = ref.watch(coopsControllerProvider.notifier);
  return coopsController.getAllVotes(coopUid);
});

// Get a vote provider
final getVoteProvider =
    StreamProvider.autoDispose.family<CoopVote, String>((ref, voteUid) {
  final coopsController = ref.watch(coopsControllerProvider.notifier);
  return coopsController.getVote(ref.read(userProvider)!.currentCoop!, voteUid);
});

final getApplicationByProperties = StreamProvider.autoDispose
    .family<List<JoinCoopParams>, Query>((ref, query) {
  final applicationController = ref.watch(coopsControllerProvider.notifier);

  return applicationController.getApplicationByProperties(query);
});

class CoopsController extends StateNotifier<bool> {
  final CoopsRepository _coopsRepository;
  final Ref _ref;

  CoopsController({required CoopsRepository coopsRepository, required Ref ref})
      : _coopsRepository = coopsRepository,
        _ref = ref,
        super(false);

  void registerCooperative(CooperativeModel coop, BuildContext context) async {
    state = true;
    final result = await _coopsRepository.addCoop(coop);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        showSnackBar(context, l.message);
      },
      (coopUid) async {
        // coopUid is the uid of the newly added cooperative
        // You can use it here

        final user = _ref.read(userProvider);

        // Using copyWith to update the user
        final updatedUser = user?.copyWith(
          currentCoop: coopUid,
          isCoopView: true,
          cooperativesJoined: [
            ...?user.cooperativesJoined,
            CooperativesJoined(
              cooperativeId: coopUid,
              cooperativeName: coop.name,
              role: "Manager", // Set the role here
            ),
          ],
        );

        // Update user
        _ref
            .read(usersControllerProvider.notifier)
            .editUserAfterRegisterCoop(user!.uid, updatedUser!);

        var coopMember = CooperativeMembers(
          name: user.name,
          uid: user.uid,
          privileges: [],
          role: CooperativeMembersRole(
            committeeName: '',
            role: 'Manager',
          ),
          committees: [],
          timestamp: DateTime.now(),
        );

        // Add user to members in Coop
        _ref.read(coopsControllerProvider.notifier).addMember(
              coopUid,
              coopMember,
              context,
            );

        // Initialized the privileges
        _ref
            .read(coopsControllerProvider.notifier)
            .initializePrivileges(coopUid);

        state = false;
        showSnackBar(context, 'Cooperative registered successfully');
        context.pop();
        _ref.read(navBarVisibilityProvider.notifier).show();
      },
    );
  }

  // Edit a cooperative
  void editCooperative(CooperativeModel coop, BuildContext context) async {
    state = true;
    final result = await _coopsRepository.updateCoop(coop);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        showSnackBar(context, l.message);
      },
      (r) {
        // Handle the success here
        state = false;
        // showSnackBar(context, 'Cooperative updated successfully');
        // context.pop();
      },
    );
  }

  void addMemberUidOnMembersList(String coopUid, String memberUid) async {
    state = true;
    final result = await _coopsRepository.addMemberToCoop(coopUid, memberUid);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        // showSnackBar(context, l.message);
      },
      (r) {
        // Handle the success here
        state = false;
        // showSnackBar(context, 'Member added successfully');
        // context.pop();
        // _ref.read(navBarVisibilityProvider.notifier).show();
      },
    );
  }

  void joinCooperative(CooperativeModel coop, BuildContext context,
      [bool? isManager]) async {
    state = true;
    final result = await _coopsRepository.updateCoop(coop);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        showSnackBar(context, l.message);
      },
      (r) async {
        // Handle the success here
        final user = _ref.read(userProvider);

        // If there is a passed optional parameter isManager
        // then set the role to Manager else set it to Member
        final role = isManager != null && isManager ? 'Manager' : 'Member';

        // Using copyWith to update the user
        final updatedUser = user?.copyWith(
          currentCoop: coop.uid,
          isCoopView: true,
          cooperativesJoined: [
            ...?user.cooperativesJoined,
            CooperativesJoined(
              cooperativeId: coop.uid!,
              cooperativeName: coop.name,
              role: role, // Set the role here
            ),
          ],
        );

        // Update user
        _ref
            .read(usersControllerProvider.notifier)
            .editUserAfterJoinCoop(user!.uid, updatedUser!);

        var coopMember = CooperativeMembers(
          name: user.name,
          uid: user.uid,
          privileges: [],
          role: CooperativeMembersRole(
            committeeName: '',
            role: role,
          ),
          committees: [],
          timestamp: DateTime.now(),
        );

        // Add user to members in Coop
        _ref.read(coopsControllerProvider.notifier).addMember(
              coop.uid!,
              coopMember,
              context,
            );

        state = false;
        showSnackBar(context, 'Cooperative joined successfully');
        context.go('/today');
        _ref.read(navBarVisibilityProvider.notifier).show();
        _ref.read(bottomNavBarProvider.notifier).setPosition(0);
      },
    );
  }

  void registerMembers(
      CooperativeModel coop, BuildContext context, UserModel userModel) async {
    state = true;
    final result = await _coopsRepository.updateCoop(coop);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        showSnackBar(context, l.message);
      },
      (r) async {
        var coopMember = CooperativeMembers(
          name: userModel.name,
          uid: userModel.uid,
          privileges: [],
          role: CooperativeMembersRole(
            committeeName: '',
            role: 'Member',
          ),
          committees: [],
          timestamp: DateTime.now(),
        );

        // Add user to members in Coop
        _ref.read(coopsControllerProvider.notifier).addMember(
              coop.uid!,
              coopMember,
              context,
            );

        state = false;
      },
    );
  }

  // Leave a cooperative
  void leaveCooperative(CooperativeModel coop, BuildContext context) async {
    state = true;
    final result = await _coopsRepository.updateCoop(coop);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        showSnackBar(context, l.message);
      },
      (r) async {
        // Handle the success here
        final user = _ref.read(userProvider);

        // Using copyWith to update the user
        final updatedUser = user?.copyWith(
          cooperativesJoined: user.cooperativesJoined
              ?.where((coopJoined) => coopJoined.cooperativeId != coop.uid)
              .toList(),
          currentCoop: '',
          isCoopView: false,
        );

        // Update user
        _ref
            .read(usersControllerProvider.notifier)
            .editUserAfterJoinCoop(user!.uid, updatedUser!);

        // Remove user from members in Coop
        _ref.read(coopsControllerProvider.notifier).removeMember(
              coop.uid!,
              user.uid,
              context,
            );

        state = false;
        showSnackBar(context, 'Cooperative left successfully');
        context.go('/coops');
        _ref.read(navBarVisibilityProvider.notifier).show();
        _ref.read(bottomNavBarProvider.notifier).setPosition(3);
      },
    );
  }

  // Read all cooperatives
  Stream<List<CooperativeModel>> getAllCooperatives() {
    return _coopsRepository.readCoops();
  }

  // Read a cooperative
  Stream<CooperativeModel> getCooperative(String uid) {
    return _coopsRepository.readCoop(uid);
  }

  // Read all cooperatives that the user is a member of
  Stream<List<CooperativeModel>> getCooperativesByMember(String uid) {
    return _coopsRepository.readCoopsJoined(uid);
  }

  // Real all members
  Stream<List<CooperativeMembers>> getAllMembers(String coopUid) {
    return _coopsRepository.readMembers(coopUid);
  }

  // Real all members belongs to a committee name
  Stream<List<CooperativeMembers>> getAllMembersInCommittee(
      String coopUid, String committeeName) {
    return _coopsRepository.readMembersByCommitteeName(coopUid, committeeName);
  }

  // Real all members that does not belong to a committee name
  Stream<List<CooperativeMembers>> getAllMembersNotInCommittee(
      String coopUid, String committeeName) {
    return _coopsRepository.readMembersNotInCommittee(coopUid, committeeName);
  }

  // Real all privileges
  Stream<List<CooperativePrivileges>> getAllPrivileges(String coopUid) {
    return _coopsRepository.readPrivileges(coopUid);
  }

  // Read a privilege
  Stream<CooperativePrivileges> getPrivilege(String coopUid, String committee) {
    return _coopsRepository.readPrivilegesByCommitteeName(coopUid, committee);
  }

  // Read a member
  Stream<CooperativeMembers> getMember(String coopUid, String memberUid) {
    return _coopsRepository.readMember(coopUid, memberUid);
  }

  // Subcollection
  // Add Member
  void addMember(String coopUid, CooperativeMembers coopMember,
      BuildContext context) async {
    state = true;
    final result = await _coopsRepository.addMember(coopUid, coopMember);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        showSnackBar(context, l.message);
      },
      (r) {
        // Handle the success here
        state = false;
        // showSnackBar(context, 'Member added successfully');
        // context.pop();
        // _ref.read(navBarVisibilityProvider.notifier).show();
      },
    );
  }

  // Delete Member
  void removeMember(
      String coopUid, String memberUid, BuildContext context) async {
    state = true;
    final result = await _coopsRepository.deleteMember(coopUid, memberUid);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        showSnackBar(context, l.message);
      },
      (r) {
        // Handle the success here
        state = false;
        // showSnackBar(context, 'Member removed successfully');
        // context.pop();
        // _ref.read(navBarVisibilityProvider.notifier).show();
      },
    );
  }

  void updateCoop(String coopUid, CooperativeModel updatedCoop,
      BuildContext context) async {
    state = true;
    final result = await _coopsRepository.updateCoop(updatedCoop);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        showSnackBar(context, l.message);
      },
      (r) {
        // Handle the success here
        state = false;
        showSnackBar(context, 'Jobs updated successfully');
        context.pop();
        // _ref.read(navBarVisibilityProvider.notifier).show();
      },
    );
  }

  // Update Member
  void updateMember(String coopUid, String memberUid,
      CooperativeMembers coopMember, BuildContext context) async {
    state = true;
    final result =
        await _coopsRepository.updateMember(coopUid, memberUid, coopMember);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        showSnackBar(context, l.message);
      },
      (r) {
        // Handle the success here
        state = false;
        // showSnackBar(context, 'Member updated successfully');
        // context.pop();
        // _ref.read(navBarVisibilityProvider.notifier).show();
      },
    );
  }

  // Update a list of members
  void updateMembers(String coopUid, List<CooperativeMembers> coopMembers,
      BuildContext context) async {
    state = true;
    final result = await _coopsRepository.updateMembers(coopUid, coopMembers);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        showSnackBar(context, l.message);
      },
      (r) {
        // Handle the success here
        state = false;
        showSnackBar(context, 'Members updated successfully');
        context.pop();
        _ref.read(navBarVisibilityProvider.notifier).show();
      },
    );
  }

  // Privilege subcollection
  // Update a privilege
  void updatePrivilege(String coopUid, CooperativePrivileges coopPrivilege,
      BuildContext context) async {
    state = true;
    final result =
        await _coopsRepository.updatePrivileges(coopUid, coopPrivilege);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        showSnackBar(context, l.message);
      },
      (r) {
        // Handle the success here
        state = false;
        // showSnackBar(context, 'Privilege updated successfully');
        // context.pop();
        // _ref.read(navBarVisibilityProvider.notifier).show();
      },
    );
  }

  void initializePrivileges(String coopUid) async {
    state = true;

    // Initialize the list of privileges for Tourism Committee
    CooperativePrivileges coopPrivileges = CooperativePrivileges(
      committeeName: 'Tourism',
      managerPrivileges: [
        ManagerPrivileges(privilegeName: 'Add listing', isAllowed: true),
        ManagerPrivileges(privilegeName: 'Edit listing', isAllowed: true),
        ManagerPrivileges(privilegeName: 'Delete listing', isAllowed: true),
      ],
      memberPrivileges: [
        MemberPrivileges(privilegeName: 'Add listing', isAllowed: false),
        MemberPrivileges(privilegeName: 'Edit listing', isAllowed: false),
        MemberPrivileges(privilegeName: 'Delete listing', isAllowed: false),
      ],
    );

    await _coopsRepository.initializePrivilege(coopUid, coopPrivileges);

    // Initialize the list of privileges for Event Committee
    coopPrivileges = CooperativePrivileges(
      committeeName: 'Events',
      managerPrivileges: [
        ManagerPrivileges(privilegeName: 'Add event', isAllowed: true),
        ManagerPrivileges(privilegeName: 'Edit event', isAllowed: true),
        ManagerPrivileges(privilegeName: 'Delete event', isAllowed: true),
      ],
      memberPrivileges: [
        MemberPrivileges(privilegeName: 'Add event', isAllowed: false),
        MemberPrivileges(privilegeName: 'Edit event', isAllowed: false),
        MemberPrivileges(privilegeName: 'Delete event', isAllowed: false),
      ],
    );

    final result =
        await _coopsRepository.initializePrivilege(coopUid, coopPrivileges);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        // showSnackBar(context, l.message);
      },
      (r) {
        // Handle the success here
        state = false;
        // showSnackBar(context, 'Privileges initialized successfully');
        // context.pop();
        // _ref.read(navBarVisibilityProvider.notifier).show();
      },
    );
  }

  // Add announcement
  void addAnnouncement(String coopUid, CoopAnnouncements coopAnnouncement,
      BuildContext context, WidgetRef ref) {
    state = true;
    _coopsRepository.addAnnouncement(coopUid, coopAnnouncement).then((result) {
      result.fold(
        (l) {
          // Handle the error here
          state = false;
          showSnackBar(context, l.message);
        },
        (r) {
          // Handle the success here
          state = false;
          showSnackBar(context, 'Announcement added successfully');
          context.pop();
          _ref.read(navBarVisibilityProvider.notifier).show();

          // add notification
          final notif = NotificationsModel(
              title:
                  ref.watch(getCooperativeProvider(coopUid)).asData?.value.name,
              message: "A new announcement is made: ${coopAnnouncement.title}",
              coopId: coopUid,
              isToAllMembers: true,
              type: 'coop_announcement',
              createdAt: DateTime.now(),
              isRead: false);

          ref
              .read(notificationControllerProvider.notifier)
              .addNotification(notif, context);
        },
      );
    });
  }

  // Read all aannounecements of a cooperative
  Stream<List<CoopAnnouncements>> getAllAnnouncements(String coopUid) {
    return _coopsRepository.readAnnouncements(coopUid);
  }

  // Add Goal
  void addGoal(String coopUid, CoopGoals coopGoal, BuildContext context) {
    state = true;
    _coopsRepository.addGoal(coopUid, coopGoal).then((result) {
      result.fold(
        (l) {
          // Handle the error here
          state = false;
          showSnackBar(context, l.message);
        },
        (r) {
          // Handle the success here
          state = false;
          showSnackBar(context, 'Goal added successfully');
          context.pop();
          _ref.read(navBarVisibilityProvider.notifier).show();
        },
      );
    });
  }

  // Read all goals of a cooperative
  Stream<List<CoopGoals>> getAllGoals(String coopUid) {
    return _coopsRepository.readGoals(coopUid);
  }

  // Real a goal of a cooperative
  Stream<CoopGoals> getGoal(String coopUid, String goalUid) {
    return _coopsRepository.readGoal(coopUid, goalUid);
  }

  // Add Vote
  void addVote(String coopUid, CoopVote coopVote, BuildContext context) {
    state = true;
    _coopsRepository.addVote(coopUid, coopVote).then((result) {
      result.fold(
        (l) {
          // Handle the error here
          state = false;
          showSnackBar(context, l.message);
        },
        (r) {
          // Handle the success here
          state = false;
          showSnackBar(context, 'Vote added successfully');
          context.pop();
          _ref.read(navBarVisibilityProvider.notifier).show();
        },
      );
    });
  }

  // Read all votes of a cooperative
  Stream<List<CoopVote>> getAllVotes(String coopUid) {
    return _coopsRepository.readVotes(coopUid);
  }

  // Read a vote
  Stream<CoopVote> getVote(String coopUid, String voteUid) {
    return _coopsRepository.readVote(coopUid, voteUid);
  }

  // Edit Vote
  void editVote(String coopUid, CoopVote coopVote, BuildContext context) {
    state = true;
    debugPrint('CoopVote: ${coopVote.toString()}');
    _coopsRepository.updateVote(coopUid, coopVote).then((result) {
      result.fold(
        (l) {
          // Handle the error here
          state = false;
          showSnackBar(context, l.message);
        },
        (r) {
          // Handle the success here
          state = false;
          showSnackBar(context, 'Voted successfully');
          context.pop();
        },
      );
    });
  }

  ///////////////////////////////////////////////////////////////////APPLICATIONS\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

  Stream<List<JoinCoopParams>> getApplicationByProperties(query) {
    return _coopsRepository.readApplicationsByProperties(query);
  }

  void addApplication(
      String coopUid, JoinCoopParams application, BuildContext context) {
    state = true;
    _coopsRepository.addApplication(coopUid, application).then((result) {
      result.fold(
        (l) {
          // Handle the error here
          state = false;
          showSnackBar(context, l.message);
        },
        (r) {
          // Handle the success here
          state = false;
          showSnackBar(context, 'Application Submitted');
          context.pop(true);
          _ref.read(navBarVisibilityProvider.notifier).show();
        },
      );
    });
  }

  void editApplication(
      JoinCoopParams updatedApplication, BuildContext context) {
    state = true;
    _coopsRepository.updateApplication(updatedApplication).then((result) {
      result.fold(
        (l) {
          // Handle the error here
          state = false;
          showSnackBar(context, l.message);
        },
        (r) {
          // Handle the success here
          state = false;
          showSnackBar(context, 'Applicaiotn updated successfully');
        },
      );
    });
  }

  void deleteApplication(
      String coopUid, String applicationUid, BuildContext context) async {
    state = true;
    final result =
        await _coopsRepository.deleteApplication(coopUid, applicationUid);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        showSnackBar(context, l.message);
      },
      (r) {
        // Handle the success here
        state = false;
        showSnackBar(context, 'Application removed successfully');
        // context.pop();
        // _ref.read(navBarVisibilityProvider.notifier).show();
      },
    );
  }
}
