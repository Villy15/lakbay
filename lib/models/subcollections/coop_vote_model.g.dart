// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coop_vote_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoopVoteImpl _$$CoopVoteImplFromJson(Map<String, dynamic> json) =>
    _$CoopVoteImpl(
      uid: json['uid'] as String?,
      position: json['position'] as String?,
      dueDate:
          const TimestampSerializer().fromJson(json['dueDate'] as Timestamp?),
    );

Map<String, dynamic> _$$CoopVoteImplToJson(_$CoopVoteImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'position': instance.position,
      'dueDate': const TimestampSerializer().toJson(instance.dueDate),
    };
