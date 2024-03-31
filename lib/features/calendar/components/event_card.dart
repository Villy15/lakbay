import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/models/event_model.dart';
import 'package:lakbay/models/user_model.dart';

class EventCard extends ConsumerWidget {
  const EventCard({
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
    return Card(
      elevation: 1,
      borderOnForeground: true,
      // Add a border to the card
      surfaceTintColor: Theme.of(context).colorScheme.background,
      // margin: const EdgeInsets.symmetric(
      //   horizontal: 12.0,
      //   vertical: 4.0,
      // ),
      child: ListTile(
        onTap: () {
          readEvent(context, event.uid!, ref.read(userProvider)!);
        },
        title: Text(event.name),
        // subtitle Start Date - End Date, format it to Feb 26, 2024
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${DateFormat('MMM dd, yyyy').format(event.startDate!)} - ${DateFormat('MMM dd, yyyy').format(event.endDate!)}",
            ),
          ],
        ),
        trailing: const Text('Event'),

        // display Image in leading
        leading: (event.imageUrl != null && event.imageUrl!.isNotEmpty)
            ? Image.network(
                event.imageUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
            : null,
      ),
    );
  }
}
