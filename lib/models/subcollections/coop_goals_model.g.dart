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
      targetDate: const TimestampSerializer()
          .fromJson(json['targetDate'] as Timestamp?),
      category: json['category'] as String?,
      metrics:
          (json['metrics'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$CoopGoalsImplToJson(_$CoopGoalsImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'title': instance.title,
      'description': instance.description,
      'targetDate': const TimestampSerializer().toJson(instance.targetDate),
      'category': instance.category,
      'metrics': instance.metrics,
    };
