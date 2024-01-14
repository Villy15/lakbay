import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/events/events_controller.dart';
import 'package:lakbay/features/tasks/tasks_controller.dart';
import 'package:lakbay/features/tasks/widgets/coop_task_card.dart';
import 'package:lakbay/models/event_model.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';

class CoopReadEventPage extends ConsumerStatefulWidget {
  final String eventId;
  const CoopReadEventPage({super.key, required this.eventId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CoopReadEventPageState();
}

class _CoopReadEventPageState extends ConsumerState<CoopReadEventPage> {
  void eventManagerTools(BuildContext context, EventModel event) {
    context.pushNamed(
      'event_manager_tools',
      extra: event,
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final member = ref.watch(getMemberProvider(user!.uid)).asData?.value;

    void addEventTask(BuildContext context, EventModel event) {
      context.pushNamed(
        'add_event_task',
        extra: event,
      );
    }

    return ref.watch(getEventsProvider(widget.eventId)).when(
          data: (EventModel event) {
            debugPrintJson("File Name: coop_read_event.dart");

            return DefaultTabController(
              initialIndex: 0,
              length: 2,
              child: PopScope(
                canPop: false,
                onPopInvoked: (bool didPop) {
                  context.pop();
                  ref.read(navBarVisibilityProvider.notifier).show();
                },
                child: Scaffold(
                  appBar: _appBar(event),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      addEventTask(context, event);
                    },
                    child: const Icon(Icons.add),
                  ),
                  body: TabBarView(
                    children: [
                      // Event Tasks
                      ref
                          .watch(getTasksByCoopIdAndEventIdProvider(
                              (user.currentCoop!, widget.eventId)))
                          .when(
                            data: (tasks) {
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
                          ),
                      // Event Details
                      ListView(
                        children: [
                          eventImage(event),
                          const SizedBox(height: 20),
                          eventDate(event, member),
                          eventName(event),
                          const SizedBox(height: 10),
                          eventParticipants(event),
                          const SizedBox(height: 10),
                          eventDescription(event),
                          const SizedBox(height: 10),
                          // Address
                          eventLocation(event),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => const Loader(),
          error: (error, stack) => ErrorText(
            error: error.toString(),
            stackTrace: stack.toString(),
          ),
        );
  }

  Column eventLocation(EventModel event) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              const Icon(Icons.location_on),
              const SizedBox(width: 8),
              Text(
                'Address: ${event.address}, ${event.city}, ${event.province}',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Map Placeholder
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  Padding eventDescription(EventModel event) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(event.description ?? ''),
    );
  }

  Padding eventParticipants(EventModel event) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          const Icon(Icons.people),
          const SizedBox(width: 8),
          Text(
            '${event.members.length} Participants',
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Padding eventName(EventModel event) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(
        event.name,
        style: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Padding eventDate(EventModel event, CooperativeMembers? member) {
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
                "${DateFormat('d MMM').format(event.startDate)} - ${DateFormat('d MMM').format(event.endDate)}",
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          member?.committeeRole("Events") == "Manager"
              ? OutlinedButton(
                  onPressed: () {
                    eventManagerTools(context, event);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                    ),
                  ),
                  child: const Text('Event Manager Tools'),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  DisplayImage eventImage(EventModel event) {
    return DisplayImage(
      imageUrl: event.imageUrl,
      height: 200,
      width: double.infinity,
      radius: BorderRadius.zero,
    );
  }

  AppBar _appBar(EventModel event) {
    List<Widget> tabs = [
      const SizedBox(
        width: 100.0,
        child: Tab(
          // icon: Icon(Icons.person),
          child: Text('Tasks'),
        ),
      ),
      const SizedBox(
        width: 100.0,
        child: Tab(
          // icon: Icon(Icons.people),
          child: Text('Details'),
        ),
      ),
    ];

    return AppBar(
      title: Text(
        event.name,
        overflow: TextOverflow.ellipsis,
      ),
      // Add icon on the right side of the app bar of a person

      bottom: TabBar(
        tabAlignment: TabAlignment.center,
        labelPadding: EdgeInsets.zero,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: tabs,
      ),
    );
  }
}
