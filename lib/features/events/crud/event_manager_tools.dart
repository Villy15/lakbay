import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/models/event_model.dart';

class EventManagerToolsPage extends ConsumerWidget {
  final EventModel event;
  const EventManagerToolsPage({super.key, required this.event});

  void editEvent(BuildContext context, EventModel event) {
    context.pushNamed(
      'edit_event',
      extra: event,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, Function> listTileMapEventDetails = {
      'Edit Event': () => ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Event'),
            onTap: () => editEvent(context, event),
          ),
      // Delete cooperativ
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Manager Tools')),
      body: Scrollbar(
        // Always show scrollbar
        thumbVisibility: true,
        child: SingleChildScrollView(
          // Show scroll bar only when needed
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cooperative Details
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Event Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listTileMapEventDetails.length,
                  itemBuilder: (context, index) {
                    final key = listTileMapEventDetails.keys.elementAt(index);
                    final listTile = listTileMapEventDetails[key]!();
                    return listTile;
                  },
                  separatorBuilder: (context, index) => const Divider(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
