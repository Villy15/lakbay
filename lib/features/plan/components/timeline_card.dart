import 'package:flutter/material.dart';
import 'package:lakbay/core/util/utils.dart';

class TimelineCard extends StatefulWidget {
  final String title;
  final String subtitle;
  const TimelineCard({super.key, required this.title, required this.subtitle});

  @override
  State<TimelineCard> createState() => _TimelineCardState();
}

class _TimelineCardState extends State<TimelineCard> {
  void onTap() {
    // Action for Check In Details
    showSnackBar(context, 'Check In Details');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: InkWell(
        splashColor: Colors.orange.withAlpha(30),
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(widget.subtitle),
              const SizedBox(height: 8),
              // TextButton(
              //   onPressed: () => onTap(),
              //   child: const Text('Check In Details'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
