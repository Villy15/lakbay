import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/models/subcollections/coop_goals_model.dart';

class ReadGoal extends ConsumerStatefulWidget {
  final String goalId;
  const ReadGoal({super.key, required this.goalId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReadGoalState();
}

class _ReadGoalState extends ConsumerState<ReadGoal> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getGoalProvider(widget.goalId)).when(
          data: (goal) {
            return PopScope(
              canPop: false,
              onPopInvoked: (bool didPop) {
                context.pop();
                ref.read(navBarVisibilityProvider.notifier).show();
              },
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Read Goal'),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      _header(goal),
                      const SizedBox(height: 8),
                      _category(goal),
                      const SizedBox(height: 8),
                      _title(goal),
                      const SizedBox(height: 24),
                      _desc(goal),
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        );
    // return PopScope(
    //   canPop: false,
    //   onPopInvoked: (bool didPop) {
    //     context.pop();
    //     ref.read(navBarVisibilityProvider.notifier).show();
    //   },
    //   child: Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Read Announcement'),
    //     ),
    //     body: SingleChildScrollView(
    //       child: Column(
    //         children: [
    //           _header(),
    //           const SizedBox(height: 8),
    //           _category(),
    //           const SizedBox(height: 8),
    //           _title(),
    //           const SizedBox(height: 24),
    //           _desc(),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget _category(CoopGoals goal) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Text(
          goal.category!.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  Padding _desc(CoopGoals goal) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(
        goal.description!,
        style: const TextStyle(
          fontSize: 18.0,
        ),
      ),
    );
  }

  Padding _title(CoopGoals goal) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(
        goal.title!,
        style: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Padding _header(CoopGoals goal) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today),
              const SizedBox(width: 8),
              Text(
                DateFormat('d MMM yyyy').format(goal.targetDate!),
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          OutlinedButton(
            onPressed: () {
              // eventManagerTools(context, event);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
            ),
            child: const Text('Manager Tools'),
          )
        ],
      ),
    );
  }
}
