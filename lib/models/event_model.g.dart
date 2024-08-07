// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventModelImpl _$$EventModelImplFromJson(Map<String, dynamic> json) =>
    _$EventModelImpl(
      uid: json['uid'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String,
      city: json['city'] as String,
      province: json['province'] as String,
      imagePath: json['imagePath'] as String,
      imageUrl: json['imageUrl'] as String?,
      members:
          (json['members'] as List<dynamic>).map((e) => e as String).toList(),
      managers:
          (json['managers'] as List<dynamic>).map((e) => e as String).toList(),
      goalsAndObjectives: (json['goalsAndObjectives'] as List<dynamic>?)
          ?.map((e) =>
              EventGoalsAndObjectives.fromJson(e as Map<String, dynamic>))
          .toList(),
      startDate:
          const TimestampSerializer().fromJson(json['startDate'] as Timestamp?),
      endDate:
          const TimestampSerializer().fromJson(json['endDate'] as Timestamp?),
      cooperative: EventCooperative.fromJson(
          json['cooperative'] as Map<String, dynamic>),
      eventType: json['eventType'] as String?,
    );

Map<String, dynamic> _$$EventModelImplToJson(_$EventModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'city': instance.city,
      'province': instance.province,
      'imagePath': instance.imagePath,
      'imageUrl': instance.imageUrl,
      'members': instance.members,
      'managers': instance.managers,
      'goalsAndObjectives':
          instance.goalsAndObjectives?.map((e) => e.toJson()).toList(),
      'startDate': const TimestampSerializer().toJson(instance.startDate),
      'endDate': const TimestampSerializer().toJson(instance.endDate),
      'cooperative': instance.cooperative.toJson(),
      'eventType': instance.eventType,
    };

_$EventCooperativeImpl _$$EventCooperativeImplFromJson(
        Map<String, dynamic> json) =>
    _$EventCooperativeImpl(
      cooperativeId: json['cooperativeId'] as String,
      cooperativeName: json['cooperativeName'] as String,
    );

Map<String, dynamic> _$$EventCooperativeImplToJson(
        _$EventCooperativeImpl instance) =>
    <String, dynamic>{
      'cooperativeId': instance.cooperativeId,
      'cooperativeName': instance.cooperativeName,
    };

_$EventGoalsAndObjectivesImpl _$$EventGoalsAndObjectivesImplFromJson(
        Map<String, dynamic> json) =>
    _$EventGoalsAndObjectivesImpl(
      goal: json['goal'] as String,
      objective: json['objective'] as num,
      isAchieved: json['isAchieved'] as bool?,
    );

Map<String, dynamic> _$$EventGoalsAndObjectivesImplToJson(
        _$EventGoalsAndObjectivesImpl instance) =>
    <String, dynamic>{
      'goal': instance.goal,
      'objective': instance.objective,
      'isAchieved': instance.isAchieved,
    };
