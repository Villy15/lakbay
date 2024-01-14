import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/tasks/tasks_controller.dart';
import 'package:lakbay/models/task_model.dart';

class ReadEventTask extends ConsumerStatefulWidget {
  final String taskId;
  const ReadEventTask({super.key, required this.taskId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReadEventTaskState();
}

class _ReadEventTaskState extends ConsumerState<ReadEventTask> {
  void editTask(BuildContext context, TaskModel task) {
    context.pushNamed(
      'edit_event_task',
      extra: task,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Task Details"),
        ),
        body: ref.watch(getTaskProvider(widget.taskId)).when(
              data: (TaskModel task) {
                debugPrintJson("File Name: event_tasks_read.dart");
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: ListView(
                    children: [
                      headerCard(context, task),
                      const SizedBox(height: 20),
                      taskDesc(context, task),
                      const SizedBox(height: 20),
                      Text(
                        "Checklist",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: task.checkList?.length ?? 0,
                        itemBuilder: (context, index) {
                          final item = task.checkList![index];
                          return Slidable(
                            key: Key(item.title),
                            endActionPane: ActionPane(
                              extentRatio: 0.40,
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  // An action can be bigger than the others.
                                  borderRadius: BorderRadius.circular(8.0),
                                  onPressed: (context) {
                                    if (mounted) {
                                      ref
                                          .read(
                                              tasksControllerProvider.notifier)
                                          .updateTask(
                                            context,
                                            task.copyWith(
                                              checkList: task.checkList!
                                                  .where((e) => e != item)
                                                  .toList(),
                                            ),
                                          );
                                    }
                                  },
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                  foregroundColor:
                                      Theme.of(context).colorScheme.background,
                                  icon: Icons.archive,
                                  label: 'Remove',
                                ),
                              ],
                            ),
                            child: CheckboxListTile(
                              title: Text(item.title),
                              value: item.isDone,
                              onChanged: (value) {
                                ref
                                    .read(tasksControllerProvider.notifier)
                                    .updateTask(
                                      context,
                                      task.copyWith(
                                        checkList: task.checkList!
                                            .map((e) => e == item
                                                ? item.copyWith(
                                                    isDone: value ?? false)
                                                : e)
                                            .toList(),
                                      ),
                                    );
                              },
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Add Item'),
                        leading: const Icon(Icons.add),
                        onTap: () => _addItem(context, task),
                      ),
                    ],
                  ),
                );
              },
              error: (error, stackTrace) => ErrorText(
                error: error.toString(),
                stackTrace: stackTrace.toString(),
              ),
              loading: () => const Loader(),
            ));
  }

  void _addItem(BuildContext context, TaskModel task) {
    TextEditingController itemController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Checklist Item'),
          content: TextField(
            controller: itemController,
            decoration: const InputDecoration(hintText: "Enter item name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                final item = TaskCheckList(
                  title: itemController.text,
                  isDone: false,
                );

                ref.read(tasksControllerProvider.notifier).updateTask(
                      context,
                      task.copyWith(
                        checkList: [...task.checkList ?? [], item],
                      ),
                    );
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }

  Column taskDesc(BuildContext context, TaskModel task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        Text(
          task.description ?? "No description provided",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget headerCard(BuildContext context, TaskModel task) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            eventPriority(context, task),
            const SizedBox(height: 10),
            eventTitle(context, task),
            eventDueDate(context, task),

            // Progress Bar
            const SizedBox(height: 30),

            eventTaskMembers(context, task),

            const SizedBox(height: 20),

            eventProgress(context, task),
          ],
        ),
      ),
    );
  }

  Row eventTaskMembers(BuildContext context, TaskModel task) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        task.assignedTo!.isNotEmpty
            ? Expanded(
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: task.assignedTo!.length > 4
                        ? 4
                        : task.assignedTo!.length,
                    itemBuilder: (context, index) {
                      final userId = task.assignedTo?[index];
                      return Stack(
                        children: [
                          ref.watch(getUserDataProvider(userId!)).maybeWhen(
                                data: (user) {
                                  return CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                      user.profilePic,
                                    ),
                                  );
                                },
                                orElse: () => const SizedBox.shrink(),
                              ),
                          if (index == 3 && task.assignedTo!.length > 4)
                            Positioned(
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.background,
                                radius: 20,
                                child: Text('+${task.assignedTo!.length - 4}'),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              )
            : const SizedBox.shrink(),
        // Time Left
        Row(
          children: [
            const Icon(Icons.timer_outlined),
            const SizedBox(width: 8),
            Text(
              daysLeft(task.dueDate!),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }

  String daysLeft(DateTime dueDate) {
    final currentDate = DateTime.now();
    final difference = dueDate.difference(currentDate);

    // debugPrint('Due Date: $dueDate');
    // debugPrint('Current Date: $currentDate');
    // debugPrint('Difference: $difference');

    if (difference.isNegative) {
      return 'Due date passed';
    } else {
      return '${difference.inDays} days left';
    }
  }

  Column eventProgress(BuildContext context, TaskModel task) {
    final totalTasks = task.checkList?.length ?? 0;
    final completedTasks =
        task.checkList?.where((task) => task.isDone).length ?? 0;
    final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Column(
      children: [
        LinearProgressIndicator(
          borderRadius: BorderRadius.circular(10),
          minHeight: 5,
          value: progress,
          backgroundColor: Theme.of(context).colorScheme.background,
          valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary),
        ),

        // Progress Bar Label
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Progress",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              "$completedTasks/$totalTasks",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }

  Text eventDueDate(BuildContext context, TaskModel task) {
    return Text(
      DateFormat('EEEE - MMM dd, y').format(task.dueDate!),
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget eventTitle(BuildContext context, TaskModel task) {
    return Text(
      task.title,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget eventPriority(BuildContext context, TaskModel task) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              (task.priority[0].toUpperCase() +
                  task.priority.substring(1).toLowerCase()),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (task.priority == "high")
              const Icon(
                Icons.priority_high,
                color: Colors.red,
              )
            else if (task.priority == "medium")
              const Icon(
                Icons.priority_high,
                color: Colors.yellow,
              )
            else
              const Icon(
                Icons.priority_high,
                color: Colors.green,
              ),
          ],
        ),
        // Elevated Button to Edit Task
        ElevatedButton(
          onPressed: () => editTask(context, task),
          child: const Text('Edit'),
        )
      ],
    );
  }
}
