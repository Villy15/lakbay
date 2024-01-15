import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/tasks/tasks_repository.dart';
import 'package:lakbay/models/task_model.dart';

// Stream Provider for get tasks by coopId and eventId
final getTasksByCoopIdAndEventIdProvider =
    StreamProvider.family<List<TaskModel>, (String coopId, String eventId)>(
        (ref, params) {
  final tasksController = ref.watch(tasksControllerProvider.notifier);
  return tasksController.getTasksByCoopIdAndEventId(
    coopId: params.$1,
    eventId: params.$2,
  );
});

// Stream Provider for getTask
final getTaskProvider = StreamProvider.family<TaskModel, String>((ref, uid) {
  final tasksController = ref.watch(tasksControllerProvider.notifier);
  return tasksController.getTask(uid);
});

// Stream Provider for getTasks
final getTasksProvider = StreamProvider<List<TaskModel>>((ref) {
  final tasksController = ref.watch(tasksControllerProvider.notifier);
  return tasksController.getTasks();
});

final tasksControllerProvider =
    StateNotifierProvider<TasksController, bool>((ref) {
  final tasksRepository = ref.watch(tasksRepositoryProvider);
  return TasksController(
    tasksRepository: tasksRepository,
    ref: ref,
  );
});

class TasksController extends StateNotifier<bool> {
  final TasksRepository _tasksRepository;
  // ignore: unused_field
  final Ref _ref;

  TasksController({
    required TasksRepository tasksRepository,
    required Ref ref,
  })  : _tasksRepository = tasksRepository,
        _ref = ref,
        super(false);

  // Read a task
  Stream<TaskModel> getTask(String uid) {
    return _tasksRepository.readTask(uid);
  }

  // Read all tasks
  Stream<List<TaskModel>> getTasks() {
    return _tasksRepository.readTasks();
  }

  // Read all tasks by coopId and eventId
  Stream<List<TaskModel>> getTasksByCoopIdAndEventId(
      {required String coopId, required String eventId}) {
    return _tasksRepository.readTasksByCoopIdAndEventId(
      coopId: coopId,
      eventId: eventId,
    );
  }

  // Add task
  void addTask(BuildContext context, TaskModel task) async {
    state = true;
    final result = await _tasksRepository.addTask(task);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        showSnackBar(context, l.message);
      },
      (taskUid) {
        state = false;
        showSnackBar(context, 'Task added successfully');
        context.pop();
      },
    );
  }

  // Update task
  void updateTask(BuildContext context, TaskModel task) async {
    state = true;
    final result = await _tasksRepository.updateTask(task);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        showSnackBar(context, l.message);
      },
      (_) {
        state = false;
      },
    );
  }
}
