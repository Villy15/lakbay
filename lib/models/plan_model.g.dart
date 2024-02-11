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
      memories: (json['memories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      name: json['name'] as String,
      budget: json['budget'] as num,
      guests: json['guests'] as num,
      imageUrl: json['imageUrl'] as String?,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$$PlanModelImplToJson(_$PlanModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'location': instance.location,
      'startDate': const TimestampSerializer().toJson(instance.startDate),
      'endDate': const TimestampSerializer().toJson(instance.endDate),
      'activities': instance.activities?.map((e) => e.toJson()).toList(),
      'memories': instance.memories,
      'name': instance.name,
      'budget': instance.budget,
      'guests': instance.guests,
      'imageUrl': instance.imageUrl,
      'userId': instance.userId,
    };

_$PlanActivityImpl _$$PlanActivityImplFromJson(Map<String, dynamic> json) =>
    _$PlanActivityImpl(
      dateTime:
          const TimestampSerializer().fromJson(json['dateTime'] as Timestamp?),
      listingId: json['listingId'] as String?,
      category: json['category'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      startTime:
          const TimestampSerializer().fromJson(json['startTime'] as Timestamp?),
      endTime:
          const TimestampSerializer().fromJson(json['endTime'] as Timestamp?),
    );

Map<String, dynamic> _$$PlanActivityImplToJson(_$PlanActivityImpl instance) =>
    <String, dynamic>{
      'dateTime': const TimestampSerializer().toJson(instance.dateTime),
      'listingId': instance.listingId,
      'category': instance.category,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'startTime': const TimestampSerializer().toJson(instance.startTime),
      'endTime': const TimestampSerializer().toJson(instance.endTime),
    };
