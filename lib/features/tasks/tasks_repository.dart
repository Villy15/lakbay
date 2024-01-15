import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lakbay/core/constants/firebase_constants.dart';
import 'package:lakbay/core/failure.dart';
import 'package:lakbay/core/providers/firebase_providers.dart';
import 'package:lakbay/core/typdef.dart';
import 'package:lakbay/models/task_model.dart';

final tasksRepositoryProvider = Provider((ref) {
  return TasksRepository(firestore: ref.watch(firestoreProvider));
});

class TasksRepository {
  final FirebaseFirestore _firestore;

  TasksRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _tasks =>
      _firestore.collection(FirebaseConstants.tasksCollection);

  // Add a task
  FutureEither<String> addTask(TaskModel task) async {
    try {
      // Generate a new document ID
      var doc = _tasks.doc();

      // Update the uid of the task
      task = task.copyWith(uid: doc.id);

      await doc.set(task.toJson());

      // Return the uid of the newly added task
      return right(task.uid!);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Read a task
  Stream<TaskModel> readTask(String uid) {
    return _tasks.doc(uid).snapshots().map((snapshot) {
      return TaskModel.fromJson(snapshot.data() as Map<String, dynamic>);
    });
  }

  // Read all tasks
  Stream<List<TaskModel>> readTasks() {
    return _tasks.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TaskModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Read all tasks by coopId and eventId
  Stream<List<TaskModel>> readTasksByCoopIdAndEventId(
      {required String coopId, required String eventId}) {
    return _tasks
        .where('coopId', isEqualTo: coopId)
        .where('eventId', isEqualTo: eventId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TaskModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Read all tasks where the user is assigned to
  Stream<List<TaskModel>> readTasksByAssignedTo(String uid) {
    return _tasks
        .where('assignedTo', arrayContains: uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TaskModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Update a task
  FutureVoid updateTask(TaskModel task) async {
    try {
      return right(await _tasks.doc(task.uid).update(task.toJson()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
