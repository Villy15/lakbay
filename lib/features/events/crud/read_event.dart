import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/events/crud/contribute_event.dart';
import 'package:lakbay/features/events/events_controller.dart';
import 'package:lakbay/models/event_model.dart';

class ReadEventPage extends ConsumerStatefulWidget {
  final String eventId;
  const ReadEventPage({super.key, required this.eventId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReadEventPageState();
}

class _ReadEventPageState extends ConsumerState<ReadEventPage> {
  void eventManagerTools(BuildContext context, EventModel event) {
    context.pushNamed(
      'event_manager_tools',
      extra: event,
    );
  }

  void joinEvent(BuildContext context, EventModel event) {
    context.pushNamed(
      'join_event',
      extra: event,
    );
  }

  void checkDetails(BuildContext context, EventModel event) {
    context.pushNamed(
      'confirm_event',
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

    return ref.watch(getEventsProvider(widget.eventId)).when(
          data: (EventModel event) {
            // Check if the user is a member of the event
            final bool isMember = event.members.contains(user.uid);

            return PopScope(
              canPop: false,
              onPopInvoked: (bool didPop) {
                context.pop();
                ref.read(navBarVisibilityProvider.notifier).show();
              },
              child: Scaffold(
                // Add appbar with back button
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    iconSize: 20,
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      context.pop();
                      ref.read(navBarVisibilityProvider.notifier).show();
                    },
                  ),
                ),
                bottomNavigationBar: BottomAppBar(
                  surfaceTintColor: Colors.white,
                  height: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                useSafeArea: true,
                                isScrollControlled: true,
                                isDismissible: true,
                                builder: (BuildContext context) {
                                  return ContributeEventPage(
                                      eventId: event.uid!,
                                      coopId: event.cooperative.cooperativeId);
                                },
                              );
                            },
                            child: const Text('Contribute Event'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FilledButton(
                            // Make it wider
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(180, 45)),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                              ),
                            ),
                            onPressed: () {
                              isMember
                                  ? checkDetails(context, event)
                                  : joinEvent(context, event);
                            },
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                isMember ? 'Check Event Details' : 'Join Event',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DisplayImage(
                        imageUrl: event.imageUrl,
                        height: 200,
                        width: double.infinity,
                        radius: BorderRadius.zero,
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today),
                                const SizedBox(width: 8),
                                Text(
                                  "${DateFormat('d MMM').format(event.startDate!)} - ${DateFormat('d MMM').format(event.endDate!)}",
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
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          event.name,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Number of Participants
                      Padding(
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
                      ),

                      const SizedBox(height: 10),

                      // Description
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(event.description ?? ''),
                      ),
                      const SizedBox(height: 10),

                      // Address
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
                  ),
                ),
              ),
            );
          },
          error: (error, stackTrace) => Scaffold(
            body: ErrorText(
              error: error.toString(),
              stackTrace: '',
            ),
          ),
          loading: () => const Scaffold(
            body: Loader(),
          ),
        );
  }
}
