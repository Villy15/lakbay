// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/notifications/notifications_repository.dart';
import 'package:lakbay/models/notifications_model.dart';

final getNotificationsByOwnerIdProvider =
    StreamProvider.family<List<NotificationsModel>, String>((ref, ownerId) {
  final notificationController =
      ref.watch(notificationControllerProvider.notifier);
  return notificationController.getNotificationsByOwnerId(ownerId);
});

final notificationControllerProvider =
    StateNotifierProvider<NotificationsController, bool>((ref) {
  final notifRepository = ref.watch(notificationsRepositoryProvider);
  return NotificationsController(
    notificationsRepository: notifRepository,
    ref: ref,
  );
});

class NotificationsController extends StateNotifier<bool> {
  final NotificationsRepository _notificationsRepository;
  final Ref _ref;

  NotificationsController({
    required NotificationsRepository notificationsRepository,
    required Ref ref,
  })  : _notificationsRepository = notificationsRepository,
        _ref = ref,
        super(false);

  // Stream all notifications by ownerId
  Stream<List<NotificationsModel>> getNotificationsByOwnerId(String ownerId) {
    return _notificationsRepository.readNotificationsByOwnerId(ownerId);
  }

  void addNotification(NotificationsModel notif, BuildContext context) async {
    final result = await _notificationsRepository.addNotification(notif);

    result.fold(
      (failure) {
        state = false;
        showSnackBar(context, failure.message);
      },
      (wikiUid) {
        state = false;
      },
    );
  }
}
