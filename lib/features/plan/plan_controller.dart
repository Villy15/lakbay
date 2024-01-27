import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/plan/plan_repository.dart';
import 'package:lakbay/models/plan_model.dart';

// getPlanByUidProvider
final getPlanByUidProvider =
    StreamProvider.autoDispose.family<PlanModel, String>((ref, uid) {
  final planController = ref.watch(plansControllerProvider.notifier);
  return planController.getPlanByUid(uid);
});

final plansControllerProvider =
    StateNotifierProvider<PlanController, bool>((ref) {
  final planRepository = ref.watch(planRepositoryProvider);
  return PlanController(
    planRepository: planRepository,
    ref: ref,
  );
});

class PlanController extends StateNotifier<bool> {
  final PlanRepository _planRepository;
  // ignore: unused_field
  final Ref _ref;

  PlanController({
    required PlanRepository planRepository,
    required Ref ref,
  })  : _planRepository = planRepository,
        _ref = ref,
        super(false);

  void addPlan(PlanModel plan, BuildContext context) async {
    final result = await _planRepository.addPlan(plan);

    result.fold(
      (failure) {
        state = false;
      },
      (uid) {
        state = true;
        context.pop();
      },
    );
  }

  // Read plan by uid
  Stream<PlanModel> getPlanByUid(String uid) {
    return _planRepository.readPlanByUid(uid);
  }
}
