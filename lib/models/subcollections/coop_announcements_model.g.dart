// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coop_announcements_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoopAnnouncementsImpl _$$CoopAnnouncementsImplFromJson(
        Map<String, dynamic> json) =>
    _$CoopAnnouncementsImpl(
      title: json['title'] as String,
      description: json['description'] as String,
      timestamp:
          const TimestampSerializer().fromJson(json['timestamp'] as Timestamp?),
      uid: json['uid'] as String?,
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String?,
    );

Map<String, dynamic> _$$CoopAnnouncementsImplToJson(
        _$CoopAnnouncementsImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'timestamp': const TimestampSerializer().toJson(instance.timestamp),
      'uid': instance.uid,
      'imageUrl': instance.imageUrl,
      'category': instance.category,
    };
