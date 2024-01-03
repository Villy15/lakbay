import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/events/events_controller.dart';
import 'package:lakbay/models/user_model.dart';
import 'package:lakbay/models/event_model.dart';
import 'package:lakbay/features/common/providers/app_bar_provider.dart';
import 'package:intl/intl.dart';

class ReadEventPage extends ConsumerWidget {
  final String eventId;

  const ReadEventPage({Key? key, required this.eventId}) : super(key: key);

  void editEvent(BuildContext context, EventModel event) {
    context.pushNamed(
      'edit_event',
      extra: event,
    );
  }

  void joinEvent(BuildContext context, EventModel event, EventController controller, UserModel? user) {
    controller.joinEvent(event.uid!, user?.uid ?? '', context);
  }

  void leaveEvent(BuildContext context, EventModel event, EventController controller, UserModel? user) {
    controller.leaveEvent(event.uid!, user?.uid ?? '', context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final scaffoldKey = ref.watch(scaffoldKeyProvider);

    return ref.watch(getEventsProvider(eventId)).when(
      data: (EventModel event) {
        final controller = ref.read(eventsControllerProvider.notifier);

        // Check if the user is a member of the event
        final bool isMember = event.members.contains(user?.uid);

        return Scaffold(
          appBar: _appBar(scaffoldKey, user),
          body: SingleChildScrollView(
            child: Column(
              children: [
                DisplayImage(
                  imageUrl: event.imageUrl,
                  height: 150,
                  width: double.infinity,
                  radius: BorderRadius.zero,
                ),
                const SizedBox(height: 20),
                Text(
                  event.name,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Description
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(event.description ?? ''),
                ),
                const SizedBox(height: 20),

                // Address
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Address: ${event.address}, ${event.city}, ${event.province}',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Start Date
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Start Date: ${DateFormat('MMMM d, y').format(event.startDate)}',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // End Date
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'End Date: ${DateFormat('MMMM d, y').format(event.endDate)}',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Edit Event Button
                ElevatedButton(
                  onPressed: () {
                    editEvent(context, event);
                  },
                  child: const Text('Edit Event'),
                ),

                // Join Event Button (visible if not a member)
                if (!isMember)
                  ElevatedButton(
                    onPressed: () {
                      joinEvent(context, event, controller, user);
                    },
                    child: const Text('Join Event'),
                  ),

                // Leave Event Button (visible if a member)
                if (isMember)
                  ElevatedButton(
                    onPressed: () {
                      leaveEvent(context, event, controller, user);
                    },
                    child: const Text('Leave Event'),
                  ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) => Scaffold(
        body: ErrorText(error: error.toString()),
      ),
      loading: () => const Scaffold(
        body: Loader(),
      ),
    );
  }

  AppBar _appBar(GlobalKey<ScaffoldState> scaffoldKey, UserModel? user) {
    return AppBar(
      title: const Text("View Event"),
      actions: [
        IconButton(
          onPressed: () {
            scaffoldKey.currentState?.openEndDrawer();
          },
          icon: CircleAvatar(
            radius: 20.0,
            backgroundImage: user?.profilePic != null && user?.profilePic != ''
                ? NetworkImage(user!.profilePic)
                : const AssetImage('lib/core/images/default_profile_pic.jpg') as ImageProvider,
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
