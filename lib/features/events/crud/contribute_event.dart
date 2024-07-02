import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/tasks/tasks_controller.dart';
import 'package:lakbay/features/tasks/widgets/coop_task_card.dart';

class ContributeEventPage extends ConsumerStatefulWidget {
  final String eventId;
  final String coopId;
  const ContributeEventPage(
      {super.key, required this.eventId, required this.coopId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ContributeEventPageState();
}

class _ContributeEventPageState extends ConsumerState<ContributeEventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tasks'),
        ),
        body: ref
            .watch(getTasksByCoopIdAndEventIdProvider(
                (widget.coopId, widget.eventId)))
            .when(
              data: (tasks) {
                if (tasks.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 100),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'lib/core/images/SleepingCatFromGlitch.svg',
                              height: 100, // Adjust height as desired
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'No tasks yet!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Create a task and share it',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const Text(
                              'with your team members',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      // createNewTrip(),
                    ],
                  );
                }
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CoopTaskCard(task: task),
                    );
                  },
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (error, stack) => ErrorText(
                error: error.toString(),
                stackTrace: stack.toString(),
              ),
            ));
  }
}
