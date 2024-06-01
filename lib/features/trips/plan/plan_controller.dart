import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/trips/plan/plan_repository.dart';
import 'package:lakbay/models/plan_model.dart';

// getPlanByUidProvider
final getPlanByUidProvider =
    StreamProvider.autoDispose.family<PlanModel, String>((ref, uid) {
  final planController = ref.watch(plansControllerProvider.notifier);
  return planController.getPlanByUid(uid);
});

// readPlansByUserIdProvider
final readPlansByUserIdProvider =
    StreamProvider.autoDispose.family<List<PlanModel>, String>((ref, userId) {
  final planController = ref.watch(plansControllerProvider.notifier);
  return planController.readPlansByUserId(userId);
});
final getPlansByPropertiesProvider =
    StreamProvider.autoDispose.family<List<PlanModel>, Query>((ref, query) {
  final planController = ref.watch(plansControllerProvider.notifier);
  return planController.getPlansByProperties(query);
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

  void addPlan(PlanModel plan, BuildContext context, WidgetRef ref) async {
    state = true;
    final result = await _planRepository.addPlan(plan);

    result.fold(
      (failure) {
        state = false;
      },
      (uid) {
        state = false;
        ref.read(navBarVisibilityProvider.notifier).show();
        context.pop();
      },
    );
  }

  void deletePlan(PlanModel plan, BuildContext context) async {
    state = true;
    final result = await _planRepository.deletePlanByUid(plan.uid!);

    result.fold(
      (failure) {
        state = false;
      },
      (uid) {
        state = false;
        context.pop();
      },
    );
  }

  // Update plan by uid
  void updatePlan(PlanModel plan, BuildContext context,
      [bool? shouldPop]) async {
    state = true;

    final result = await _planRepository.updatePlanByUid(plan.uid!, plan);
    shouldPop ??= true;

    result.fold(
      (failure) {
        state = false;
      },
      (uid) {
        state = false;
        if (shouldPop == true) {
          context.pop();
        }
      },
    );
  }

  // Update plan by adding an activity
  void addActivityToPlan(
      String planId, PlanActivity activity, BuildContext context) async {
    state = true;
    // Read the plan by uid
    var plan = await _planRepository.readPlanByUid(planId).first;

    // Add the activity to the plan using copyWith

    plan = plan.copyWith(
      activities: [...plan.activities!, activity],
    );

    // Update the plan
    final result = await _planRepository.updatePlanByUid(planId, plan);

    result.fold(
      (failure) {
        state = false;
      },
      (uid) {
        state = false;
        // context.pop();
        // context.pop();
        // context.pop();
      },
    );
  }

  // Delete Plan Activity by uid
  void deleteActivityFromPlan(PlanModel plan, BuildContext context) async {
    // Read the plan by uid
    state = true;
    // Update the plan
    final result = await _planRepository.updatePlanByUid(plan.uid!, plan);

    result.fold(
      (failure) {
        state = false;
      },
      (uid) {
        state = false;
      },
    );
  }

  // Read plan by uid
  Stream<PlanModel> getPlanByUid(String uid) {
    return _planRepository.readPlanByUid(uid);
  }

  // Real all plans by user id
  Stream<List<PlanModel>> readPlansByUserId(String userId) {
    return _planRepository.readPlansByUserId(userId);
  }

  Stream<List<PlanModel>> getPlansByProperties(Query query) {
    return _planRepository.readPlanByProperties(query);
  }
}
