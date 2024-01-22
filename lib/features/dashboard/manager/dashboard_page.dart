import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/tasks/tasks_controller.dart';
import 'package:lakbay/features/tasks/widgets/today_task_card.dart';

class TodayPage extends ConsumerStatefulWidget {
  const TodayPage({super.key});

  @override
  ConsumerState<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends ConsumerState<TodayPage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: CustomAppBar(title: 'Today', user: user),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tasks",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ref.watch(getTasksByUserIdProvider(user!.uid)).when(
                  data: (tasks) {
                    debugPrintJson("File Name: dashboard_page.dart");
                    return Expanded(
                      child: ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return TodayTaskCard(task: task);
                        },
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (error, stack) => ErrorText(
                    error: error.toString(),
                    stackTrace: stack.toString(),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
