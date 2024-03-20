// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coop_vote_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoopVoteImpl _$$CoopVoteImplFromJson(Map<String, dynamic> json) =>
    _$CoopVoteImpl(
      uid: json['uid'] as String?,
      coopId: json['coopId'] as String?,
      position: json['position'] as String?,
      candidates: (json['candidates'] as List<dynamic>?)
          ?.map((e) => CoopVoteCandidate.fromJson(e as Map<String, dynamic>))
          .toList(),
      dueDate:
          const TimestampSerializer().fromJson(json['dueDate'] as Timestamp?),
    );

Map<String, dynamic> _$$CoopVoteImplToJson(_$CoopVoteImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'coopId': instance.coopId,
      'position': instance.position,
      'candidates': instance.candidates?.map((e) => e.toJson()).toList(),
      'dueDate': const TimestampSerializer().toJson(instance.dueDate),
    };

_$CoopVoteCandidateImpl _$$CoopVoteCandidateImplFromJson(
        Map<String, dynamic> json) =>
    _$CoopVoteCandidateImpl(
      uid: json['uid'] as String?,
      voters:
          (json['voters'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$CoopVoteCandidateImplToJson(
        _$CoopVoteCandidateImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'voters': instance.voters,
    };
