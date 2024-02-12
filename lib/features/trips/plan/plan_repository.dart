import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lakbay/core/constants/firebase_constants.dart';
import 'package:lakbay/core/failure.dart';
import 'package:lakbay/core/providers/firebase_providers.dart';
import 'package:lakbay/core/typdef.dart';
import 'package:lakbay/models/plan_model.dart';

final planRepositoryProvider = Provider((ref) {
  return PlanRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class PlanRepository {
  final FirebaseFirestore _firestore;

  PlanRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _plans =>
      _firestore.collection(FirebaseConstants.plansCollection);

  // Add an plan
  FutureEither<String> addPlan(PlanModel plan) async {
    try {
      // Generate a new document ID
      var doc = _plans.doc();

      // Update the uid of the plan
      plan = plan.copyWith(uid: doc.id);

      await doc.set(plan.toJson());

      // Return the uid of the newly added plan
      return right(plan.uid!);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Read plan by uid
  Stream<PlanModel> readPlanByUid(String uid) {
    return _plans.doc(uid).snapshots().map((snapshot) {
      return PlanModel.fromJson(snapshot.data() as Map<String, dynamic>);
    });
  }

  // Real all plans by user id
  Stream<List<PlanModel>> readPlansByUserId(String userId) {
    return _plans
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return PlanModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Read all plans
  Stream<List<PlanModel>> readPlans() {
    return _plans.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PlanModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Update plan by uid
  FutureEither<String> updatePlanByUid(String uid, PlanModel plan) async {
    try {
      await _plans.doc(uid).update(plan.toJson());
      return right(uid);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Delete plan by uid
  FutureEither<String> deletePlanByUid(String uid) async {
    try {
      await _plans.doc(uid).delete();
      return right(uid);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
