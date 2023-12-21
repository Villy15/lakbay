// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lakbay/core/constants/firebase_constants.dart';
import 'package:lakbay/core/failure.dart';
import 'package:lakbay/core/providers/firebase_providers.dart';
import 'package:lakbay/core/typdef.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';

final coopsRepositoryProvider = Provider((ref) {
  return CoopsRepository(firestore: ref.watch(firestoreProvider));
});

class CoopsRepository {
  final FirebaseFirestore _firestore;
  CoopsRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  // Add a cooperative
  FutureEither<String> addCoop(CooperativeModel coop) async {
    try {
      // Generate a new document ID
      var doc = _communities.doc();

      // Update the uid of the cooperative
      coop = coop.copyWith(uid: doc.id);

      // Add the cooperative to the database
      await doc.set(coop.toJson());

      // Return the uid of the newly added cooperative
      return right(coop.uid!);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Real all cooperatives
  Stream<List<CooperativeModel>> readCoops() {
    return _communities.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CooperativeModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Read community by uid
  Stream<CooperativeModel> readCoop(String uid) {
    return _communities.doc(uid).snapshots().map((snapshot) {
      return CooperativeModel.fromJson(snapshot.data() as Map<String, dynamic>);
    });
  }

  // Update cooperative
  FutureVoid updateCoop(CooperativeModel coop) async {
    try {
      return right(await _communities.doc(coop.uid).update(coop.toJson()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.coopsCollection);

  // Members Subcollection
  CollectionReference members(String coopId) {
    return _communities
        .doc(coopId)
        .collection(FirebaseConstants.membersSubCollection);
  }

  // Add a member in members subcollection
  FutureEither<String> addMember(
      String coopId, CooperativeMembers coopMember) async {
    try {
      // Generate a new document ID based on the user's ID
      var doc = members(coopId).doc(coopMember.uid);

      // Update the uid of the cooperative
      coopMember = coopMember.copyWith(uid: doc.id);

      // Add the cooperative to the database
      await doc.set(coopMember.toJson());

      // Return the uid of the newly added cooperative
      return right(doc.id);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Delete a member in members subcollection
  FutureVoid deleteMember(String coopId, String uid) async {
    try {
      return right(await members(coopId).doc(uid).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Read members
  Stream<List<CooperativeMembers>> readMembers(String coopId) {
    return members(coopId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CooperativeMembers.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
