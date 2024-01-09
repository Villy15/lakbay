import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/events/events_controller.dart';
import 'package:lakbay/models/event_model.dart';

class JoinEventPage extends ConsumerStatefulWidget {
  final EventModel event;
  const JoinEventPage({super.key, required this.event});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JoinEventPageState();
}

class _JoinEventPageState extends ConsumerState<JoinEventPage> {
  void joinEvent() {
    final user = ref.read(userProvider);
    ref
        .read(eventsControllerProvider.notifier)
        .joinEvent(widget.event.uid!, user!.uid, context, widget.event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Join Event'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ListView(
            children: [
              eventSummary(),
              eventDetailsCard(),
              const SizedBox(height: 20),
              eventRulesCard(),
              const SizedBox(height: 20),
              eventConfirmCard()
            ],
          ),
        ));
  }

  Card eventConfirmCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'By confirming below, you agree to our terms and conditions, and privacy policy.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(
              // Make it wider
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(300, 45)),
              ),
              onPressed: () {
                joinEvent();
              },
              child: const Text('Confirm and Join Event'),
            ),
          ],
        ),
      ),
    );
  }

  Card eventRulesCard() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ground Rules',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
                '• To ensure a safe and enjoyable event for everyone, we kindly ask you to follow these guidelines:',
                style: TextStyle(
                  fontSize: 16,
                )),
            // Add a bulleted point list of text
            SizedBox(height: 10),
            Text(
                '• Use tools and resources responsibly and return them after use',
                style: TextStyle(
                  fontSize: 16,
                )),
            SizedBox(height: 10),
            Text(
                '• Follow all safety instructions and stay within designated areas',
                style: TextStyle(
                  fontSize: 16,
                )),
            SizedBox(height: 10),
            Text('• Dispose of waste properly in the provided bins',
                style: TextStyle(
                  fontSize: 16,
                )),
          ],
        ),
      ),
    );
  }

  Card eventDetailsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your trip',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Dates',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(
                        '${DateFormat('dd MMM').format(widget.event.startDate)} - ${DateFormat('dd MMM').format(widget.event.endDate)} (${widget.event.endDate.difference(widget.event.startDate).inDays} days)',
                        style: const TextStyle(
                          fontSize: 16,
                        )),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ListTile eventSummary() {
    return ListTile(
      leading: DisplayImage(
        imageUrl: widget.event.imageUrl,
        height: 100,
        width: 100,
        radius: BorderRadius.zero,
      ),
      title: Text(
        widget.event.name,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
