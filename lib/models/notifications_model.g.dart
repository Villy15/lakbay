// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationsModelImpl _$$NotificationsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationsModelImpl(
      uid: json['uid'] as String?,
      ownerId: json['ownerId'] as String,
      userId: json['userId'] as String?,
      coopId: json['coopId'] as String?,
      message: json['message'] as String?,
      listingId: json['listingId'] as String?,
      eventId: json['eventId'] as String?,
      isTapped: json['isTapped'] as bool? ?? false,
      type: json['type'] as String?,
      createdAt:
          const TimestampSerializer().fromJson(json['createdAt'] as Timestamp?),
    );

Map<String, dynamic> _$$NotificationsModelImplToJson(
        _$NotificationsModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'ownerId': instance.ownerId,
      'userId': instance.userId,
      'coopId': instance.coopId,
      'message': instance.message,
      'listingId': instance.listingId,
      'eventId': instance.eventId,
      'isTapped': instance.isTapped,
      'type': instance.type,
      'createdAt': const TimestampSerializer().toJson(instance.createdAt),
    };
