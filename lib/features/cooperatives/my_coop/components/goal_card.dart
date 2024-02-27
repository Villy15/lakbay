import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/models/subcollections/coop_goals_model.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({
    super.key,
    required this.goal,
  });

  final CoopGoals goal;

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.white,
      // color: Theme.of(context).colorScheme.background,
      child: InkWell(
        // Make the entire card tappable
        onTap: () => {},
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Chip
              if (goal.category != null)
                Text(
                  goal.category!.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                goal.title!,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(goal.description!,
                  maxLines: 3, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 24),
              Column(
                children: [
                  LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(10),
                    minHeight: 5,
                    value: goal.progress!.toDouble(),
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
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
                        "${(goal.progress! * 100).toStringAsFixed(0)}%",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilledButton(
                    onPressed: () => {},
                    child: const Text('Read more'),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      // Posted on

                      Text(
                        'Target Date${DateFormat.yMMMd().format(
                          goal.targetDate ?? DateTime.now(),
                        )}.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
