import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/cooperatives/coop_member_roles_repository.dart';
import 'package:lakbay/models/coop_member_roles_model.dart';

final getCoopMemberRolesProvider = 
    StreamProvider.autoDispose.family<CoopMemberRoles, String>((ref, uid) {
      final coopMemberRolesController = ref.watch(coopMemberRolesControllerProvider.notifier);
      return coopMemberRolesController.getMemberRole(uid);
    });

final getAllCoopMemberRolesProvider =  
    StreamProvider.autoDispose<List<CoopMemberRoles>>((ref) {
      final coopMemberRolesController = ref.watch(coopMemberRolesControllerProvider.notifier);
      return coopMemberRolesController.getAllMemberRoles();
    });

final coopMemberRolesControllerProvider =
    StateNotifierProvider<CoopMemberRolesController, bool>((ref) {
      final coopMemberRolesRepository = ref.watch(coopMemberRolesRepositoryProvider);
      return CoopMemberRolesController(
        coopMemberRolesRepository: coopMemberRolesRepository,
        ref: ref,
      );
    });

class CoopMemberRolesController extends StateNotifier<bool> {
  final CoopMemberRolesRepository _coopMemberRolesRepository;
  final Ref _ref;

  CoopMemberRolesController({
    required CoopMemberRolesRepository coopMemberRolesRepository,
    required Ref ref,
  })  : _coopMemberRolesRepository = coopMemberRolesRepository,
        _ref = ref,
        super(false);
  
  Stream<List<CoopMemberRoles>> getAllMemberRoles() {
    return _coopMemberRolesRepository.readAllMembersRoles();
  }

  void addMemberRole(CoopMemberRoles coopMemberRoles, BuildContext context) async {
    final result = await _coopMemberRolesRepository.addMemberRole(coopMemberRoles);

    result.fold(
      (failure) {
        state = false;
        showSnackBar(context, failure.message);
      },
      (coopMemberRolesUid) {
        state = false;
        _ref.read(navBarVisibilityProvider.notifier).show();
        context.pop();
        showSnackBar(context, 'Coop Member Role added successfully');
      }
    );
  }

  Stream<CoopMemberRoles> getMemberRole(String uid) {
    return _coopMemberRolesRepository.readMemberRole(uid);
  }
}
