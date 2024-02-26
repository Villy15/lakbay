import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/models/event_model.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
  });

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      borderOnForeground: true,
      // Add a border to the card
      surfaceTintColor: Theme.of(context).colorScheme.background,
      margin: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 4.0,
      ),
      child: ListTile(
        onTap: () {},
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
