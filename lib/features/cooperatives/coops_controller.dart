import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/cooperatives/coops_repository.dart';
import 'package:lakbay/features/user/user_controller.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';
import 'package:lakbay/models/subcollections/coop_privileges_model.dart';
import 'package:lakbay/models/user_model.dart';
import 'package:lakbay/models/wrappers/committee_params.dart';

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
              cooperativeId: coop.uid!,
              cooperativeName: coop.name,
              role: "Manager", // Set the role here
            ),
          ],
        );

        // Update user
        _ref
            .read(usersControllerProvider.notifier)
            .editUserAfterRegisterCoop(user!.uid, updatedUser!);

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
        showSnackBar(context, 'Cooperative updated successfully');
        context.pop();
      },
    );
  }

  void joinCooperative(CooperativeModel coop, BuildContext context) async {
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
          currentCoop: coop.uid,
          isCoopView: true,
          cooperativesJoined: [
            ...?user.cooperativesJoined,
            CooperativesJoined(
              cooperativeId: coop.uid!,
              cooperativeName: coop.name,
              role: "Member", // Set the role here
            ),
          ],
        );

        // Update user
        _ref
            .read(usersControllerProvider.notifier)
            .editUserAfterJoinCoop(user!.uid, updatedUser!);

        var coopMember = CooperativeMembers(
          uid: user.uid,
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
        showSnackBar(context, 'Cooperative joined successfully');
        context.go('/manager_dashboard');
        _ref.read(navBarVisibilityProvider.notifier).show();
        _ref.read(bottomNavBarProvider.notifier).setPosition(0);
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

  // Real all members
  Stream<List<CooperativeMembers>> getAllMembers(String coopUid) {
    return _coopsRepository.readMembers(coopUid);
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
}
