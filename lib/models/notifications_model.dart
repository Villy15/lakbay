import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lakbay/core/util/utils.dart';

part 'notifications_model.freezed.dart';
part 'notifications_model.g.dart';

@freezed
class NotificationsModel with _$NotificationsModel {
  factory NotificationsModel({
    String? uid,
    String? ownerId,
    String? userId,
    String? coopId,
    String? message,
    String? title,
    String? listingId,
    String? eventId,
    String? bookingId,
    @Default(false) bool? isTapped,
    String? type,
    @TimestampSerializer() DateTime? createdAt,
    String? routePath,
    @Default(false) bool? isToAllMembers,
  }) = _NotificationsModel;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationsModelFromJson(json);
}
