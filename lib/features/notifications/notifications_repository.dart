import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/core/constants/firebase_constants.dart';
import 'package:lakbay/core/providers/firebase_providers.dart';
import 'package:lakbay/models/notifications_model.dart';

final notificationsRepositoryProvider = Provider((ref) {
  return NotificationsRepository(firestore: ref.watch(firestoreProvider));
});

class NotificationsRepository {
  final FirebaseFirestore _firestore;

  NotificationsRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  // Read all notifs by a coopid
  Stream<List<NotificationsModel>> readNotificationsByOwnerId(String ownerId) {
    return _notifications
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return NotificationsModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  CollectionReference get _notifications =>
      _firestore.collection(FirebaseConstants.notificationsCollection);
}
