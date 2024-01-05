import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/events/events_controller.dart';

class EventsPage extends ConsumerWidget {
  const EventsPage({super.key});

  void readEvent(BuildContext context, String eventId) {
    context.push("/read_event/$eventId");
  }

  void navigateToAddEvent(BuildContext context) {
    context.push("/add_event");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: CustomAppBar(title: 'Events', user: user),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                ref.watch(getAllEventsProvider).when(
                      data: (events) {
                        // return a grid view of events
                        return GridView.builder(
                          itemCount: events.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            mainAxisExtent: 240,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Card(
                              clipBehavior: Clip.hardEdge,
                              elevation: 1,
                              surfaceTintColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: InkWell(
                                onTap: () {
                                  readEvent(context, events[index].uid!);
                                },
                                splashColor: Colors.orange.withAlpha(30),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(20)),
                                        child: Image.network(
                                          events[index].imageUrl ?? '',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              events[index].name,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'From ${DateFormat('MMM dd').format(events[index].startDate)} to ${DateFormat('MMM dd').format(events[index].endDate)}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      error: (error, stackTrace) => ErrorText(
                        error: error.toString(),
                        stackTrace: '',
                      ),
                      loading: () => const Loader(),
                    ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToAddEvent(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
