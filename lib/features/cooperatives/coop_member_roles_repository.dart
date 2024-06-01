import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lakbay/core/constants/firebase_constants.dart';
import 'package:lakbay/core/failure.dart';
import 'package:lakbay/core/providers/firebase_providers.dart';
import 'package:lakbay/core/typdef.dart';
import 'package:lakbay/models/coop_member_roles_model.dart';

final coopMemberRolesRepositoryProvider = Provider((ref) {
  return CoopMemberRolesRepository(firestore: ref.watch(firestoreProvider));
});

class CoopMemberRolesRepository {
  final FirebaseFirestore _firestore;
  CoopMemberRolesRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  // add new member and its role 
  FutureEither<String> addMemberRole(CoopMemberRoles coopMemberRoles) async {
    try {
      // generate new document ID
      var doc = _coopMemberRoles.doc();

      // update the uid of the coop members collection
      coopMemberRoles = coopMemberRoles.copyWith(uid: doc.id);

      await doc.set(coopMemberRoles.toJson());

      // return the uid of the newly added coop member role
      return right(doc.id);
    } on FirebaseException catch (e) {
      return left(Failure(e.message.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // read all members and their roles
  Stream<List<CoopMemberRoles>> readAllMembersRoles() {
    return _coopMemberRoles.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => CoopMemberRoles.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }

  // read event by uid 
  Stream<CoopMemberRoles> readMemberRole(String uid) {
    return _coopMemberRoles.doc(uid).snapshots().map((snapshot) =>
        CoopMemberRoles.fromJson(snapshot.data() as Map<String, dynamic>));
  }

  CollectionReference get _coopMemberRoles =>
      _firestore.collection(FirebaseConstants.coopMemberRolesCollection);
}
