import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/models/subcollections/coop_announcements_model.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({
    super.key,
    required this.announcement,
  });

  final CoopAnnouncements announcement;

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.white,
      // color: Theme.of(context).colorScheme.background,
      child: InkWell(
        // Make the entire card tappable
        onTap: () => {},
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Chip
              if (announcement.category != null)
                Text(
                  announcement.category!.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                announcement.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(announcement.description,
                  maxLines: 3, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilledButton(
                    onPressed: () => {},
                    child: const Text('Read more'),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      // Posted on

                      Text(
                        'Posted on ${DateFormat.yMMMd().format(
                          announcement.timestamp ?? DateTime.now(),
                        )}.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
