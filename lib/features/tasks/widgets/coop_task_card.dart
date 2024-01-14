import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/models/event_model.dart';
import 'package:lakbay/models/task_model.dart';

class CoopTaskCard extends ConsumerStatefulWidget {
  final TaskModel task;
  const CoopTaskCard({super.key, required this.task});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CoopTaskCardState();
}

class _CoopTaskCardState extends ConsumerState<CoopTaskCard> {
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
        onTap: () {},
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            "https://i.pravatar.cc/150?img=1"), // NetworkImage
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            "https://i.pravatar.cc/150?img=2"), // NetworkImage
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            "https://i.pravatar.cc/150?img=3"), // NetworkImage
                      ),
                    ],
                  ),
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
              ),

              const SizedBox(height: 20),

              eventProgress(context),
            ],
          ),
        ),
      ),
    );
  }

  String daysLeft(DateTime dueDate) {
    final currentDate = DateTime.now();
    final difference = dueDate.difference(currentDate);

    debugPrint('Due Date: $dueDate');
    debugPrint('Current Date: $currentDate');
    debugPrint('Difference: $difference');

    if (difference.isNegative) {
      return 'Due date passed';
    } else {
      return '${difference.inDays} days left';
    }
  }

  Column eventProgress(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          minHeight: 5,
          value: 0.5,
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
              "2/4",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }

  Text eventDueDate(BuildContext context) {
    return Text(
      DateFormat('EEEE - MMM dd, y').format(widget.task.createdAt!),
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
