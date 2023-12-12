import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/cooperatives/coops_repository.dart';
import 'package:lakbay/features/user/user_controller.dart';
import 'package:lakbay/models/coop_model.dart';

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

        // Update user's coopsJoined, coopsManaged, currentCoop, isCoopView = true, isManager = true
        final user = _ref.read(userProvider);

        // Using copyWith to update the user
        final updatedUser = user?.copyWith(
          coopsJoined: [...?user.coopsJoined, coopUid],
          coopsManaged: [...?user.coopsManaged, coopUid],
          currentCoop: coopUid,
          isCoopView: true,
          isManager: true,
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

  // Read all cooperatives
  Stream<List<CooperativeModel>> getAllCooperatives() {
    return _coopsRepository.readCoops();
  }

  // Read a cooperative
  Stream<CooperativeModel> getCooperative(String uid) {
    return _coopsRepository.readCoop(uid);
  }
}
