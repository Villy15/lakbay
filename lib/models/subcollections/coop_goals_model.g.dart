// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coop_goals_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoopGoalsImpl _$$CoopGoalsImplFromJson(Map<String, dynamic> json) =>
    _$CoopGoalsImpl(
      uid: json['uid'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      coopId: json['coopId'] as String?,
      targetDate: const TimestampSerializer()
          .fromJson(json['targetDate'] as Timestamp?),
      category: json['category'] as String?,
      metrics:
          (json['metrics'] as List<dynamic>?)?.map((e) => e as String).toList(),
      progress: json['progress'] as num?,
    );

Map<String, dynamic> _$$CoopGoalsImplToJson(_$CoopGoalsImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'title': instance.title,
      'description': instance.description,
      'coopId': instance.coopId,
      'targetDate': const TimestampSerializer().toJson(instance.targetDate),
      'category': instance.category,
      'metrics': instance.metrics,
      'progress': instance.progress,
    };
