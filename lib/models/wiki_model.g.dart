// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wiki_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WikiModelImpl _$$WikiModelImplFromJson(Map<String, dynamic> json) =>
    _$WikiModelImpl(
      uid: json['uid'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      coopId: json['coopId'] as String,
      tag: json['tag'] as String,
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => WikiComments.fromJson(e as Map<String, dynamic>))
          .toList(),
      votes: json['votes'] as num?,
    );

Map<String, dynamic> _$$WikiModelImplToJson(_$WikiModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'coopId': instance.coopId,
      'tag': instance.tag,
      'comments': instance.comments?.map((e) => e.toJson()).toList(),
      'votes': instance.votes,
    };

_$WikiCommentsImpl _$$WikiCommentsImplFromJson(Map<String, dynamic> json) =>
    _$WikiCommentsImpl(
      comment: json['comment'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      imageUrl: json['imageUrl'] as String?,
      votes: json['votes'] as num?,
    );

Map<String, dynamic> _$$WikiCommentsImplToJson(_$WikiCommentsImpl instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'imageUrl': instance.imageUrl,
      'votes': instance.votes,
    };
