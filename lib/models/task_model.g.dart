// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskModelImpl _$$TaskModelImplFromJson(Map<String, dynamic> json) =>
    _$TaskModelImpl(
      uid: json['uid'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate:
          const TimestampSerializer().fromJson(json['dueDate'] as Timestamp?),
      priority: json['priority'] as String,
      coopId: json['coopId'] as String,
      createdAt:
          const TimestampSerializer().fromJson(json['createdAt'] as Timestamp?),
      type: json['type'] as String,
      eventId: json['eventId'] as String?,
      publisherId: json['publisherId'] as String?,
    );

Map<String, dynamic> _$$TaskModelImplToJson(_$TaskModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'title': instance.title,
      'description': instance.description,
      'dueDate': const TimestampSerializer().toJson(instance.dueDate),
      'priority': instance.priority,
      'coopId': instance.coopId,
      'createdAt': const TimestampSerializer().toJson(instance.createdAt),
      'type': instance.type,
      'eventId': instance.eventId,
      'publisherId': instance.publisherId,
    };
