// ignore_for_file: unused_field

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/notifications/notifications_repository.dart';
import 'package:lakbay/models/notifications_model.dart';

final getNotificationsByOwnerIdProvider =
    StreamProvider.family<List<NotificationsModel>, String>((ref, ownerId) {
  final notificationController =
      ref.watch(notificationControllerProvider.notifier);
  return notificationController.getNotificationsByOwnerId(ownerId);
});

final getAllNotificationsProvider =
    StreamProvider<List<NotificationsModel>>((ref) {
  final notificationController =
      ref.watch(notificationControllerProvider.notifier);
  return notificationController.getAllNotifications();
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

  // Stream all notifications

  Stream<List<NotificationsModel>> getAllNotifications() {
    return _notificationsRepository.readAllNotifications();
  }

  void addNotification(NotificationsModel notif, BuildContext context) async {
    final result = await _notificationsRepository.addNotification(notif);

    result.fold(
      (failure) {
        state = false;
        showSnackBar(context, failure.message);
      },
      (notifUid) {
        state = false;

        if (notif.isToAllMembers! == false) {
          cloudNotification(notif.title!, notif.message!, notif.ownerId!);
        }
      },
    );
  }

  Future<void> cloudNotification(
      String title, String message, String ownerId) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://us-central1-lakbay-cd97e.cloudfunctions.net/notifyUserPaymentListing'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'notification': {
              'notificationTitle': title,
              'notificationMessage': message,
              'userId': ownerId,
            },
          }));

      if (response.statusCode == 200) {
        debugPrint(
            'Notification sent successfully. This is the response: ${response.body}');
      } else {
        debugPrint(
            'Failed to send notification. This is the response: ${response.body}');
      }
    } catch (e) {
      debugPrint('This is the error: $e');
    }
  }
}
