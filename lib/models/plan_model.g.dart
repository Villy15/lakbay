// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlanModelImpl _$$PlanModelImplFromJson(Map<String, dynamic> json) =>
    _$PlanModelImpl(
      uid: json['uid'] as String?,
      location: json['location'] as String,
      startDate:
          const TimestampSerializer().fromJson(json['startDate'] as Timestamp?),
      endDate:
          const TimestampSerializer().fromJson(json['endDate'] as Timestamp?),
      activities: (json['activities'] as List<dynamic>?)
          ?.map((e) => PlanActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$$PlanModelImplToJson(_$PlanModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'location': instance.location,
      'startDate': const TimestampSerializer().toJson(instance.startDate),
      'endDate': const TimestampSerializer().toJson(instance.endDate),
      'activities': instance.activities?.map((e) => e.toJson()).toList(),
      'userId': instance.userId,
    };

_$PlanActivityImpl _$$PlanActivityImplFromJson(Map<String, dynamic> json) =>
    _$PlanActivityImpl(
      dateTime:
          const TimestampSerializer().fromJson(json['dateTime'] as Timestamp?),
      title: json['title'] as String?,
      description: json['description'] as String?,
      startTime:
          const TimestampSerializer().fromJson(json['startTime'] as Timestamp?),
      endTime:
          const TimestampSerializer().fromJson(json['endTime'] as Timestamp?),
    );

Map<String, dynamic> _$$PlanActivityImplToJson(_$PlanActivityImpl instance) =>
    <String, dynamic>{
      'dateTime': const TimestampSerializer().toJson(instance.dateTime),
      'title': instance.title,
      'description': instance.description,
      'startTime': const TimestampSerializer().toJson(instance.startTime),
      'endTime': const TimestampSerializer().toJson(instance.endTime),
    };
