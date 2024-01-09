import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/events/events_controller.dart';
import 'package:lakbay/models/event_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ConfirmEventPage extends ConsumerStatefulWidget {
  final EventModel event;
  const ConfirmEventPage({super.key, required this.event});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfirmEventPageState();
}

class _ConfirmEventPageState extends ConsumerState<ConfirmEventPage> {
  void leaveEvent() {
    final user = ref.read(userProvider);
    ref
        .read(eventsControllerProvider.notifier)
        .leaveEvent(widget.event.uid!, user!.uid, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ListView(
          children: [
            registeredCard(),
            const SizedBox(height: 20),
            eventDetailsCard(),
            const SizedBox(height: 20),
            eventContactsCard(),
            const SizedBox(height: 20),
            eventOnDayCard(),
            const SizedBox(height: 20),
            eventQR(context),
            const SizedBox(height: 20),
            showQR(),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'If you wish to leave this event, please click the button below.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20), // Add some spacing
                    ElevatedButton(
                      // Make it larger
                      style: ElevatedButton.styleFrom(
                        // Color
                        backgroundColor: Theme.of(context).colorScheme.error,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      // Color
                      onPressed: () {
                        leaveEvent();
                      },
                      child: Text(
                        'Leave Event',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onError,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding showQR() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        '🔔 Show this on the day of the event at the registration',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

  Center eventQR(BuildContext context) {
    return Center(
      child: QrImageView(
        data: 'This is a simple QR code',
        version: QrVersions.auto,
        size: 320,
        gapless: false,
        padding: const EdgeInsets.all(20.0),
        dataModuleStyle: QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        eyeStyle: QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
  }

  Card eventOnDayCard() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('On the Day:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('✔️ Check-in:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(
                '• Present your confirmation email or QR code at the registration desk',
                style: TextStyle(
                  fontSize: 16,
                )),
            // Message icon
            SizedBox(height: 20),
            // Event GC
            Text('👜 Tools and Equipment',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(
                '• All necessary tools will be provided. If you wish to bring your own gloves or equipment, please do so.',
                style: TextStyle(
                  fontSize: 16,
                )),
            SizedBox(height: 20),
            // Food and beverages
            Text('🍽️ Food and Beverages',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(
                '• Lunch and refreshments will be provided. Please bring your own water bottle.',
                style: TextStyle(
                  fontSize: 16,
                )),
          ],
        ),
      ),
    );
  }

  Card eventContactsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Keep this Information Handy',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('🗣️ Contact Person',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('• Adrian Villanueva [TODO]',
                    style: TextStyle(
                      fontSize: 16,
                    )),
                // Message icon
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.message,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Event GC
            const Text('👥 • Event Group Chat',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.event.name,
                    style: const TextStyle(
                      fontSize: 16,
                    )),
                // Message icon
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.message),
                ),
              ],
            ),
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
            const Text('Event Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('🎉 Event Name',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(
              widget.event.name,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text('📅 Dates',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(
                '${DateFormat('dd MMM').format(widget.event.startDate)} - ${DateFormat('dd MMM').format(widget.event.endDate)}',
                style: const TextStyle(
                  fontSize: 16,
                )),
            const SizedBox(height: 20),
            const Text('📍 Location',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),

            Text(
              widget.event.address,
              style: const TextStyle(fontSize: 16),
            ),
            // Add more event details if necessary
          ],
        ),
      ),
    );
  }

  Card registeredCard() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    '✅ You\'re Registered!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Text(
                        'Thank you for joining us at the event',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Your participation is confirmed.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
