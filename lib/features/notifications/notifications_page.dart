import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/events/events_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/notifications/notifications_controller.dart';
import 'package:lakbay/models/notifications_model.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ref.watch(getNotificationsByOwnerIdProvider(user!.uid)).when(
            data: (notifications) {
              // Create temp data
              notifications = [
                NotificationsModel(
                  uid: '1',
                  ownerId: 'mW8eJarptUUlP6gYxFB1JM1i21q2',
                  coopId: "lenkp0ga5MTluKUM25AH",
                  message: 'You have a pending balance of Php 1000.',
                  isTapped: false,
                  type: "coop",
                  createdAt: DateTime(2024, 5, 1),
                ),
                NotificationsModel(
                  uid: '1',
                  ownerId: 'mW8eJarptUUlP6gYxFB1JM1i21q2',
                  coopId: "lenkp0ga5MTluKUM25AH",
                  message: 'A booking is made on on June 1 - June 3, 2021.',
                  isTapped: true,
                  listingId: '942oLXTg0K7T8qGJ97KM',
                  type: "listing",
                  createdAt: DateTime(2024, 5, 1),
                ),
                NotificationsModel(
                  uid: '1',
                  ownerId: 'mW8eJarptUUlP6gYxFB1JM1i21q2',
                  coopId: "lenkp0ga5MTluKUM25AH",
                  message: 'You have a pending task to complete.',
                  isTapped: true,
                  eventId: 'xzAcUJEbtYUXuIi1xdny',
                  type: "event",
                  createdAt: DateTime(2024, 5, 1),
                ),
              ];

              if (notifications.isEmpty) {
                return emptyNotifs();
              }

              final today = DateTime.now();
              final yesterday =
                  today.subtract(const Duration(days: 1, milliseconds: 1));
              final last7Days =
                  today.subtract(const Duration(days: 7, milliseconds: 1));
              final last30Days =
                  today.subtract(const Duration(days: 30, milliseconds: 1));

              final todayNotifs = notifications
                  .where((notif) => notif.createdAt!.isAfter(yesterday))
                  .toList();
              final yesterdayNotifs = notifications
                  .where((notif) =>
                      notif.createdAt!.isAfter(last7Days) &&
                      notif.createdAt!.isBefore(today))
                  .toList();
              final last7DaysNotifs = notifications
                  .where((notif) =>
                      notif.createdAt!.isAfter(last30Days) &&
                      notif.createdAt!.isBefore(yesterday))
                  .toList();
              final last30DaysNotifs = notifications
                  .where((notif) => notif.createdAt!.isBefore(last30Days))
                  .toList();

              final groupedNotifs = [
                if (todayNotifs.isNotEmpty) ['Today', todayNotifs],
                if (yesterdayNotifs.isNotEmpty) ['Yesterday', yesterdayNotifs],
                if (last7DaysNotifs.isNotEmpty)
                  ['Last 7 days', last7DaysNotifs],
                if (last30DaysNotifs.isNotEmpty)
                  ['Last 30 days', last30DaysNotifs],
              ];

              return ListView.separated(
                itemCount: groupedNotifs.length,
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(),
                ),
                itemBuilder: (context, index) {
                  final group = groupedNotifs[index];
                  final title = group[0] as String;
                  final groupNotifs = group[1] as List<NotificationsModel>;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      ...groupNotifs.map((notif) => _listTileNotifs(notif)),
                    ],
                  );
                },
              );
            },
            error: (error, stackTrace) =>
                ErrorText(error: error.toString(), stackTrace: ''),
            loading: () => const Loader(),
          ),
    );
  }

  Widget _listTileNotifs(NotificationsModel notif) {
    Widget leadingWidget;
    String title;
    String message = notif.message!;
    bool isTapped = notif.isTapped!;

    switch (notif.type) {
      case 'listing':
        final listing =
            ref.watch(getListingProvider(notif.listingId!)).asData?.value;
        leadingWidget = notifAvatar(listing?.images?[0].url ?? '');
        title = listing?.title ?? '';
        break;
      case 'coop':
        final coop =
            ref.watch(getCooperativeProvider(notif.coopId!)).asData?.value;
        leadingWidget = notifAvatar(coop?.imageUrl ?? '');
        title = coop?.name ?? '';
        break;
      case 'event':
        final event =
            ref.watch(getEventsProvider(notif.eventId!)).asData?.value;
        leadingWidget = notifAvatar(event?.imageUrl ?? '');
        title = event?.name ?? '';
        break;
      default:
        leadingWidget = const CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.transparent,
        );
        title = '';
    }

    return _createListTile(
      title: title,
      message: message,
      leading: leadingWidget,
      isTapped: isTapped,
    );
  }

  ListTile _createListTile(
      {required String title,
      required String message,
      required Widget leading,
      required bool isTapped}) {
    return ListTile(
      onTap: () => {},
      leading: leading,
      tileColor: isTapped
          ? Theme.of(context).colorScheme.background
          : Theme.of(context).colorScheme.primary.withOpacity(0.1),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(message),
    );
  }

  CircleAvatar notifAvatar(String imageUrl) {
    return CircleAvatar(
      radius: 30.0,
      backgroundImage: NetworkImage(imageUrl),
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  Widget emptyNotifs() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'lib/core/images/SleepingCatFromGlitch.svg',
                  height: 100, // Adjust height as desired
                ),
                const SizedBox(height: 20),
                const Text(
                  'No notifications so far!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Stay tuned for updates!',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const Text(
                  'Check out other features!',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
