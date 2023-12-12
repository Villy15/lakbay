// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lakbay/core/constants/firebase_constants.dart';
import 'package:lakbay/core/failure.dart';
import 'package:lakbay/core/providers/firebase_providers.dart';
import 'package:lakbay/core/typdef.dart';
import 'package:lakbay/models/user_model.dart';

final userRepositoryProvider = Provider((ref) {
  return UserRepository(firestore: ref.watch(firestoreProvider));
});

class UserRepository {
  final FirebaseFirestore _firestore;
  UserRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  // Real all users
  Stream<List<UserModel>> readUsers() {
    return _users.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Read user by uid
  Stream<UserModel> readUser(String uid) {
    return _users.doc(uid).snapshots().map((snapshot) {
      return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    });
  }

  // Edit user isCoopView by uid
  FutureVoid editUserIsCoopView(String uid, bool isCoopView) async {
    try {
      return right(_users.doc(uid).update({'isCoopView': isCoopView}));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Edit user
  FutureVoid editUser(String uid, UserModel user) async {
    try {
      return right(_users.doc(uid).update(user.toJson()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
}
