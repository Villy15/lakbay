import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/notifications/notifications_controller.dart';
import 'package:lakbay/models/user_model.dart';

class NotificationWithBadgeIcon extends ConsumerStatefulWidget {
  final UserModel? user;
  const NotificationWithBadgeIcon({
    super.key,
    required this.user,
  });

  @override 
  ConsumerState<NotificationWithBadgeIcon> createState() => _NotificationWithBadgeIconState();
}

class _NotificationWithBadgeIconState extends ConsumerState<NotificationWithBadgeIcon> {
  @override 
  Widget build(BuildContext context) {
    final notifications = ref.watch(getNotificationsByOwnerIdProvider(widget.user!.uid));
    return notifications.when(
      loading: () => badges.Badge(
        badgeContent: const CircularProgressIndicator(),
        child: const Icon(Icons.notifications),
      ),
      error:(error, stackTrace) => badges.Badge(
        badgeContent: const Icon(Icons.error),
        child: const Icon(Icons.notifications),
      ),
      data: (notificationList) {
        final notificationCount = notificationList.where((notification) => !(notification.isRead)).length;
        return badges.Badge(
          position: badges.BadgePosition.topEnd(top: -9,),
          badgeContent: Text(
            notificationCount.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 7
            ),
            selectionColor: Colors.red,
          ),
          child: const Icon(
            Icons.notifications_none_outlined
          ),
        );
      },
    );
  }
}

// class CustomNotificationIcon extends StatelessWidget {
//   final UserModel? user; 
//   const CustomNotificationIcon({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     final notifications = ref.watch(getNotificationsByOwnerIdProvider(user!.uid));
//     return badges.Badge(
//       badgeContent: Text(
//         notificationCount.toString(),
//         style: const TextStyle(color: Colors.white),
//       ),
//       child: const Icon(Icons.notifications),
//     );
//   }
// }