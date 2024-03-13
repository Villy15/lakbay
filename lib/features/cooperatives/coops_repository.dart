// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lakbay/core/constants/firebase_constants.dart';
import 'package:lakbay/core/failure.dart';
import 'package:lakbay/core/providers/firebase_providers.dart';
import 'package:lakbay/core/typdef.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/subcollections/coop_announcements_model.dart';
import 'package:lakbay/models/subcollections/coop_goals_model.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';
import 'package:lakbay/models/subcollections/coop_privileges_model.dart';
import 'package:lakbay/models/subcollections/coop_vote_model.dart';

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

  // Privileges Subcollection
  CollectionReference privileges(String coopId) {
    return _communities
        .doc(coopId)
        .collection(FirebaseConstants.privilegesSubCollection);
  }

  // Announcements Subcollection
  CollectionReference announcements(String coopId) {
    return _communities
        .doc(coopId)
        .collection(FirebaseConstants.announcementsSubCollection);
  }

  // Goals Subcollection
  CollectionReference goals(String coopId) {
    return _communities
        .doc(coopId)
        .collection(FirebaseConstants.goalsSubCollection);
  }

  // Votes Subcollection
  CollectionReference votes(String coopId) {
    return _communities
        .doc(coopId)
        .collection(FirebaseConstants.votesSubCollection);
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

  // Update a member in members subcollection
  FutureVoid updateMember(
      String coopId, String uid, CooperativeMembers coopMember) async {
    try {
      return right(await members(coopId).doc(uid).update(coopMember.toJson()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Update a list of members in members subcollection
  FutureVoid updateMembers(
      String coopId, List<CooperativeMembers> coopMembers) async {
    try {
      var batch = _firestore.batch();

      for (var coopMember in coopMembers) {
        var doc = members(coopId).doc(coopMember.uid);
        batch.update(doc, coopMember.toJson());
      }

      return right(await batch.commit());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Read a member in members subcollection
  Stream<CooperativeMembers> readMember(String coopId, String uid) {
    return members(coopId).doc(uid).snapshots().map((snapshot) {
      return CooperativeMembers.fromJson(
          snapshot.data() as Map<String, dynamic>);
    });
  }

  // Read members
  Stream<List<CooperativeMembers>> readMembers(String coopId) {
    return members(coopId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CooperativeMembers.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Read members by committeeName
  Stream<List<CooperativeMembers>> readMembersByCommitteeName(
      String coopId, String committeeName) {
    return members(coopId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CooperativeMembers.fromJson(doc.data() as Map<String, dynamic>);
      }).where((member) {
        return member.isCommitteeMember(committeeName);
      }).toList();
    });
  }

  // Read members that does not belong to committees.committeeName
  Stream<List<CooperativeMembers>> readMembersNotInCommittee(
      String coopId, String committeeName) {
    return members(coopId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CooperativeMembers.fromJson(doc.data() as Map<String, dynamic>);
      }).where((member) {
        return !member.isCommitteeMember(committeeName);
      }).toList();
    });
  }

  // Add privileges subcollection
  FutureEither addPrivileges(
      String coopId, CooperativePrivileges coopPrivileges) async {
    try {
      // Generate a new document ID based on the user's ID
      var doc = privileges(coopId).doc(coopPrivileges.committeeName);

      // Update the uid of the cooperative
      coopPrivileges = coopPrivileges.copyWith(committeeName: doc.id);

      // Add the cooperative to the database
      await doc.set(coopPrivileges.toJson());

      // Return the uid of the newly added cooperative
      return right(doc.id);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Read privileges
  Stream<List<CooperativePrivileges>> readPrivileges(String coopId) {
    return privileges(coopId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CooperativePrivileges.fromJson(
            doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Read privileges by committeeName
  Stream<CooperativePrivileges> readPrivilegesByCommitteeName(
      String coopId, String committeeName) {
    return privileges(coopId).doc(committeeName).snapshots().map((snapshot) {
      return CooperativePrivileges.fromJson(
          snapshot.data() as Map<String, dynamic>);
    });
  }

  // Update privileges
  FutureVoid updatePrivileges(
      String coopId, CooperativePrivileges coopPrivileges) async {
    try {
      return right(await privileges(coopId)
          .doc(coopPrivileges.committeeName)
          .update(coopPrivileges.toJson()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Initialize privileges subcollection
  FutureEither initializePrivilege(
      String coopId, CooperativePrivileges coopPrivileges) async {
    try {
      // Generate a new document ID based on the user's ID
      var doc = privileges(coopId).doc(coopPrivileges.committeeName);

      // Update the uid of the cooperative
      coopPrivileges = coopPrivileges.copyWith(committeeName: doc.id);

      // Add the cooperative to the database
      await doc.set(coopPrivileges.toJson());

      // Return the uid of the newly added cooperative
      return right(doc.id);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // ANNOUNCEMENTS

  // Add an announcement in announcements subcollection
  FutureEither<String> addAnnouncement(
      String coopId, CoopAnnouncements coopAnnouncement) async {
    try {
      // Generate a new document ID
      var doc = announcements(coopId).doc();

      // Update the uid of the cooperative
      coopAnnouncement = coopAnnouncement.copyWith(uid: doc.id);

      // Add the cooperative to the database
      await doc.set(coopAnnouncement.toJson());

      // Return the uid of the newly added cooperative
      return right(doc.id);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Read all announcements of a cooperative
  Stream<List<CoopAnnouncements>> readAnnouncements(String coopId) {
    return announcements(coopId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CoopAnnouncements.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // GOALS
  // Add a goal in goals subcollection
  FutureEither<String> addGoal(String coopId, CoopGoals coopGoal) async {
    try {
      // Generate a new document ID
      var doc = _communities
          .doc(coopId)
          .collection(FirebaseConstants.goalsSubCollection)
          .doc();

      // Update the uid of the cooperative
      coopGoal = coopGoal.copyWith(uid: doc.id);

      // Add the cooperative to the database
      await doc.set(coopGoal.toJson());

      // Return the uid of the newly added cooperative
      return right(doc.id);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Read all goals of a cooperative
  Stream<List<CoopGoals>> readGoals(String coopId) {
    return goals(coopId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CoopGoals.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Add a vote in votes subcollection
  FutureEither<String> addVote(String coopId, CoopVote coopVote) async {
    try {
      // Generate a new document ID
      var doc = _communities
          .doc(coopId)
          .collection(FirebaseConstants.votesSubCollection)
          .doc();

      // Update the uid of the cooperative
      coopVote = coopVote.copyWith(uid: doc.id);

      // Add the cooperative to the database
      await doc.set(coopVote.toJson());

      // Return the uid of the newly added cooperative
      return right(doc.id);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Read all votes of a cooperative
  Stream<List<CoopVote>> readVotes(String coopId) {
    return votes(coopId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CoopVote.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
