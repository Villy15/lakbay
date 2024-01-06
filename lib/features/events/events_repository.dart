import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lakbay/core/constants/firebase_constants.dart';
import 'package:lakbay/core/failure.dart';
import 'package:lakbay/core/providers/firebase_providers.dart';
import 'package:lakbay/core/typdef.dart';
import 'package:lakbay/models/event_model.dart';

final eventsRepositoryProvider = Provider((ref) {
  return EventsRepository(firestore: ref.watch(firestoreProvider));
});

class EventsRepository {
  final FirebaseFirestore _firestore;
  EventsRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  // Add an event
  FutureEither<String> addEvent(EventModel event) async {
    try {
      // Generate a new document ID
      var doc = _events.doc();

      // Update the uid of the event
      event = event.copyWith(uid: doc.id);

      await doc.set(event.toJson());

      // Return the uid of the newly added event
      return right(event.uid!);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Read all events
  Stream<List<EventModel>> readEvents() {
    return _events.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return EventModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Read all events by CoopID
  Stream<List<EventModel>> readEventsByCoopId(String coopId) {
    return _events
        .where('cooperative.cooperativeId', isEqualTo: coopId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return EventModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Read event by uid
  Stream<EventModel> readEvent(String uid) {
    return _events.doc(uid).snapshots().map((snapshot) {
      return EventModel.fromJson(snapshot.data() as Map<String, dynamic>);
    });
  }

  // Update event
  FutureVoid updateEvent(EventModel event) async {
    try {
      return right(await _events.doc(event.uid).update(event.toJson()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Join Event
  FutureEither<String> joinEvent(String eventUid, String memberUid) async {
    try {
      // Get the event document reference
      final eventRef = _events.doc(eventUid);

      // Get the current members
      final eventSnapshot = await eventRef.get();
      final eventData = eventSnapshot.data() as Map<String, dynamic>?;

      if (eventData == null) {
        return left(Failure('Event not found.'));
      }

      final List<String> members =
          List<String>.from(eventData['members'] ?? []);

      // Check if the member is already in the event
      if (members.contains(memberUid)) {
        return left(Failure('Member is already part of the event.'));
      }

      // Add the member to the event
      members.add(memberUid);

      // Update the members in the event document
      await eventRef.update({'members': members});

      return right(eventUid);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Leave Event
  FutureEither<String> leaveEvent(String eventUid, String memberUid) async {
    try {
      // Get the event document reference
      final eventRef = _events.doc(eventUid);

      // Get the current members
      final eventSnapshot = await eventRef.get();
      final eventData = eventSnapshot.data() as Map<String, dynamic>?;

      if (eventData == null) {
        return left(Failure('Event not found.'));
      }

      final List<String> members =
          List<String>.from(eventData['members'] ?? []);

      // Check if the member is in the event
      if (!members.contains(memberUid)) {
        return left(Failure('Member is not part of the event.'));
      }

      // Remove the member from the event
      members.remove(memberUid);

      // Update the members in the event document
      await eventRef.update({'members': members});

      return right(eventUid);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _events =>
      _firestore.collection(FirebaseConstants.eventsCollection);
}
