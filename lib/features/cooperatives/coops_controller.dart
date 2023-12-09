import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/cooperatives/coops_repository.dart';
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
    state = false;
    result.fold(
        (l) => showSnackBar(context, l.message),
        (r) => {
              showSnackBar(context, 'Cooperative registered successfully'),
              context.pop(),
              _ref.read(navBarVisibilityProvider.notifier).show()
            });
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
