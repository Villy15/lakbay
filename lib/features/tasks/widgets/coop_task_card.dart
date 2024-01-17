import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/models/task_model.dart';

class CoopTaskCard extends ConsumerStatefulWidget {
  final TaskModel task;
  const CoopTaskCard({super.key, required this.task});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CoopTaskCardState();
}

class _CoopTaskCardState extends ConsumerState<CoopTaskCard> {
  void readTask(BuildContext context, TaskModel task) {
    context.pushNamed(
      'read_event_task',
      // extra: task,
      pathParameters: {'taskId': task.uid!},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: InkWell(
        splashColor: Colors.orange.withAlpha(30),
        onTap: () => readTask(context, widget.task),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              eventPriority(context),
              const SizedBox(height: 10),
              eventTitle(context),
              eventDueDate(context),

              // Progress Bar
              const SizedBox(height: 30),

              eventTaskMembers(context),

              const SizedBox(height: 20),

              eventProgress(context),
            ],
          ),
        ),
      ),
    );
  }

  Row eventTaskMembers(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        widget.task.assignedTo!.isNotEmpty
            ? Expanded(
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.task.assignedTo!.length > 4
                        ? 4
                        : widget.task.assignedTo!.length,
                    itemBuilder: (context, index) {
                      final userId = widget.task.assignedTo?[index];
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
                          if (index == 3 && widget.task.assignedTo!.length > 4)
                            Positioned(
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.background,
                                radius: 20,
                                child: Text(
                                    '+${widget.task.assignedTo!.length - 4}'),
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
              daysLeft(widget.task.dueDate!),
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

  Column eventProgress(BuildContext context) {
    final totalTasks = widget.task.checkList?.length ?? 0;
    final completedTasks =
        widget.task.checkList?.where((task) => task.isDone).length ?? 0;
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

  Text eventDueDate(BuildContext context) {
    return Text(
      DateFormat('EEEE - MMM dd, y').format(widget.task.dueDate!),
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget eventTitle(BuildContext context) {
    return Text(
      widget.task.title,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget eventPriority(BuildContext context) {
    return Row(
      children: [
        Text(
          (widget.task.priority[0].toUpperCase() +
              widget.task.priority.substring(1).toLowerCase()),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (widget.task.priority == "high")
          const Icon(
            Icons.priority_high,
            color: Colors.red,
          )
        else if (widget.task.priority == "medium")
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
    );
  }
}
