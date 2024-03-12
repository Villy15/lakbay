import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/models/subcollections/coop_announcements_model.dart';

class ReadAnnouncement extends ConsumerStatefulWidget {
  final CoopAnnouncements announcement;
  const ReadAnnouncement({super.key, required this.announcement});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReadAnnouncementState();
}

class _ReadAnnouncementState extends ConsumerState<ReadAnnouncement> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Read Announcement'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _header(),
              const SizedBox(height: 8),
              _category(),
              const SizedBox(height: 8),
              _title(),
              const SizedBox(height: 24),
              _desc(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _category() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Text(
          widget.announcement.category!.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  Padding _desc() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(
        widget.announcement.description,
        style: const TextStyle(
          fontSize: 18.0,
        ),
      ),
    );
  }

  Padding _title() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(
        widget.announcement.title,
        style: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Padding _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today),
              const SizedBox(width: 8),
              Text(
                DateFormat('d MMM yyyy').format(widget.announcement.timestamp!),
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          OutlinedButton(
            onPressed: () {
              // eventManagerTools(context, event);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
            ),
            child: const Text('Manager Tools'),
          )
        ],
      ),
    );
  }
}
