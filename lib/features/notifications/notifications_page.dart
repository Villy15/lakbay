import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
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
      body: ref.watch(getAllNotificationsProvider).when(
            data: (notifications) {
              // Create temp data
              notifications = [
                NotificationsModel(
                  uid: '1',
                  title: 'Payment Successful',
                  ownerId: 'mW8eJarptUUlP6gYxFB1JM1i21q2',
                  coopId: "lenkp0ga5MTluKUM25AH",
                  message:
                      'You have a pending balance: Php 1000. Please pay. Iwahori Multiasdasd',
                  isTapped: false,
                  type: "coop",
                  createdAt: DateTime(2024, 6, 3, 12, 30, 0),
                  isToAllMembers: false,
                ),
                NotificationsModel(
                  uid: '1',
                  title: 'Iwahori Multipurpose Cooperative',
                  ownerId: 'mW8eJarptUUlP6gYxFB1JM1i21q2',
                  coopId: "lenkp0ga5MTluKUM25AH",
                  message:
                      'A new announcement is made: Notifce of Upcoming Election for Coop board Members',
                  isTapped: false,
                  type: "coop_announcement",
                  createdAt: DateTime(2024, 6, 3, 12, 30, 0),
                  isToAllMembers: true,
                ),
                // Assigned Task
                NotificationsModel(
                  uid: '1',
                  title: 'Hotel lakbay',
                  ownerId: 'mW8eJarptUUlP6gYxFB1JM1i21q2',
                  coopId: "lenkp0ga5MTluKUM25AH",
                  message: 'A booking is made: June 1 - June 3, 2021.',
                  isTapped: true,
                  listingId: '942oLXTg0K7T8qGJ97KM',
                  type: "listing",
                  bookingId: '1OLHTBacUZJPeH3hpvrb',
                  createdAt: DateTime(2024, 6, 2, 12, 30, 0),
                  isToAllMembers: true,
                ),
                NotificationsModel(
                  uid: '1',
                  ownerId: 'mW8eJarptUUlP6gYxFB1JM1i21q2',
                  title: 'Hotel lakbay',
                  coopId: "lenkp0ga5MTluKUM25AH",
                  message: 'You have a new task: Clean the room',
                  isTapped: true,
                  listingId: '942oLXTg0K7T8qGJ97KM',
                  type: "listing",
                  bookingId: '1OLHTBacUZJPeH3hpvrb',
                  createdAt: DateTime(2024, 6, 2, 12, 30, 0),
                  isToAllMembers: false,
                ),
                NotificationsModel(
                  uid: '1',
                  title: 'Pre Membership Seminar',
                  ownerId: 'mW8eJarptUUlP6gYxFB1JM1i21q2',
                  coopId: "lenkp0ga5MTluKUM25AH",
                  message:
                      'You have a pending task to complete: Create PPT Presentation',
                  isTapped: true,
                  eventId: 'xzAcUJEbtYUXuIi1xdny',
                  type: "event",
                  createdAt: DateTime(2024, 5, 1, 12, 30, 0),
                  isToAllMembers: false,
                ),
              ];

              if (notifications.isEmpty) {
                return emptyNotifs();
              }

              // Filter notifications by if isToAllMembers is true and ownerId is the user's id
              notifications = notifications
                  .where(
                    (notif) =>
                        notif.isToAllMembers! || notif.ownerId == user?.uid,
                  )
                  .toList();

              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              final endOfYesterday = DateTime(now.year, now.month, now.day)
                  .subtract(const Duration(milliseconds: 1));
              final startOfYesterday =
                  endOfYesterday.subtract(const Duration(days: 1));
              final last30Days = today.subtract(const Duration(days: 30));

              final todayNotifs = notifications
                  .where((notif) => notif.createdAt!.isAfter(endOfYesterday))
                  .toList();
              final yesterdayNotifs = notifications
                  .where((notif) =>
                      notif.createdAt!.isAfter(startOfYesterday) &&
                      notif.createdAt!.isBefore(today))
                  .toList();
              final last7DaysNotifs = notifications
                  .where((notif) =>
                      notif.createdAt!.isAfter(last30Days) &&
                      notif.createdAt!.isBefore(startOfYesterday))
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
    String message = notif.message!;
    bool isTapped = notif.isTapped!;
    VoidCallback onTap;

    switch (notif.type) {
      case 'listing':
        final listing =
            ref.watch(getListingProvider(notif.listingId!)).asData?.value;
        leadingWidget = notifAvatar(listing?.images?[0].url ?? '');

        final booking = ref
            .watch(getBookingByIdProvider((notif.listingId!, notif.bookingId!)))
            .asData
            ?.value;

        // onTap
        onTap = () {
          context.push(
            '/market/${booking?.category}/booking_details',
            extra: {'booking': booking, 'listing': listing},
          ).whenComplete(
            () => ref.read(navBarVisibilityProvider.notifier).show(),
          );
        };

        break;
      case 'coop':
        final coop =
            ref.watch(getCooperativeProvider(notif.coopId!)).asData?.value;
        leadingWidget = notifAvatar(coop?.imageUrl ?? '');

        // Define onTap for 'coop' case
        onTap = () {
          // Add your navigation code here
        };
        break;
      case 'coop_announcement':
        final coop =
            ref.watch(getCooperativeProvider(notif.coopId!)).asData?.value;
        leadingWidget = notifAvatar(coop?.imageUrl ?? '');

        // Define onTap for 'coop' case
        onTap = () {
          // Add your navigation code here
        };
        break;
      case 'event':
        final event =
            ref.watch(getEventsProvider(notif.eventId!)).asData?.value;
        leadingWidget = notifAvatar(event?.imageUrl ?? '');

        // Define onTap for 'coop' case
        onTap = () {
          // Add your navigation code here
        };
        break;
      default:
        leadingWidget = const CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.transparent,
        );
        onTap = () {}; // Default onTap
    }

    return _createListTile(
      title: notif.title!,
      message: message,
      leading: leadingWidget,
      isTapped: isTapped,
      onTap: onTap,
    );
  }

  ListTile _createListTile(
      {required String title,
      required String message,
      required Widget leading,
      required bool isTapped,
      required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
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
      subtitle: RichText(
        text: TextSpan(
          text: '${message.split(': ')[0]}: ',
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(
              text:
                  message.split(': ').length > 1 ? message.split(': ')[1] : '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  CircleAvatar notifAvatar(String? imageUrl) {
    return CircleAvatar(
      radius: 30.0,
      backgroundImage:
          imageUrl != '' && imageUrl != null ? NetworkImage(imageUrl) : null,
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
