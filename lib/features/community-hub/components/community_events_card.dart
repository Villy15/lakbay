import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/tasks/tasks_controller.dart';
import 'package:lakbay/models/event_model.dart';
import 'package:lakbay/models/user_model.dart';

class CommunityHubEventsCard extends ConsumerWidget {
  const CommunityHubEventsCard({
    super.key,
    required this.event,
  });

  final EventModel event;

  void readEvent(BuildContext context, String eventId, UserModel user) {
    if (user.isCoopView!) {
      context.push("/my_coop/event/$eventId");
    } else {
      context.push("/read_event/$eventId");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    final taskList = ref
        .watch(getTasksByCoopIdAndEventIdProvider(
            (user!.currentCoop!, event.uid!)))
        .asData
        ?.value;

    return Card(
      borderOnForeground: true,
      child: ListTile(
        onTap: () {
          readEvent(context, event.uid!, user);
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.eventType != null)
              Text(
                event.eventType!.toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            Text(
              event.name,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
        // subtitle Start Date - End Date, format it to Feb 26, 2024
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.date_range_outlined,
                  size: 14,
                ),
                const SizedBox(width: 4),
                // Event Date
                Text(
                  //DateFormat('MMM dd, yyyy').format(event.startDate) + ' - ' + DateFormat('MMM dd, yyyy').format(event.endDate),
                  '${DateFormat('MMM dd, yyyy').format(event.startDate!)} - ${DateFormat('MMM dd, yyyy').format(event.endDate!)}',

                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            // Number of bookings
            Wrap(
              children: [
                ActionChip(
                  onPressed: () {},
                  label: Text(
                    '${event.members.length} Participants',
                  ),
                  // Icon to show the number of bookings
                  avatar: const Icon(
                    Icons.people_outline,
                  ),
                ),

                // Number of tasks that need contributions
                ActionChip(
                  onPressed: () {},
                  label: Text(
                    '${taskList?.length ?? 0} Tasks Need Contributions',
                  ),
                  // Icon to show the number of tasks
                  avatar: const Icon(
                    Icons.task_alt,
                  ),
                ),
              ],
            ),
          ],
        ),

        // display Image in leading
        // Make the image have border radius
        trailing: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(
            event.imageUrl!,
            width: 50,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),

        // leading: Image.network(
        //   listing.images!.first.url!,
        //   width: 50,
        //   height: 50,
        //   fit: BoxFit.cover,
        // ),
      ),
    );
  }
}
