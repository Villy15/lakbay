import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  Widget build(BuildContext context) {
    debugPrint('Announcement: HI');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
      ),
      body: const Center(
        child: Text('Read Announcement'),
      ),
    );
  }
}
