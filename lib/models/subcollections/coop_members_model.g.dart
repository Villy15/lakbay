// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coop_members_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CooperativeMembersImpl _$$CooperativeMembersImplFromJson(
        Map<String, dynamic> json) =>
    _$CooperativeMembersImpl(
      name: json['name'] as String,
      uid: json['uid'] as String?,
      privileges: (json['privileges'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      role: json['role'] == null
          ? null
          : CooperativeMembersRole.fromJson(
              json['role'] as Map<String, dynamic>),
      committees: (json['committees'] as List<dynamic>?)
          ?.map(
              (e) => CooperativeMembersRole.fromJson(e as Map<String, dynamic>))
          .toList(),
      isManager: json['isManager'] as bool? ?? false,
      boardRole: json['boardRole'] == null
          ? null
          : BoardRole.fromJson(json['boardRole'] as Map<String, dynamic>),
      timestamp:
          const TimestampSerializer().fromJson(json['timestamp'] as Timestamp?),
      paidMembershipFee: json['paidMembershipFee'] as bool?,
    );

Map<String, dynamic> _$$CooperativeMembersImplToJson(
        _$CooperativeMembersImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'uid': instance.uid,
      'privileges': instance.privileges,
      'role': instance.role?.toJson(),
      'committees': instance.committees?.map((e) => e.toJson()).toList(),
      'isManager': instance.isManager,
      'boardRole': instance.boardRole?.toJson(),
      'timestamp': const TimestampSerializer().toJson(instance.timestamp),
      'paidMembershipFee': instance.paidMembershipFee,
    };

_$CooperativeMembersRoleImpl _$$CooperativeMembersRoleImplFromJson(
        Map<String, dynamic> json) =>
    _$CooperativeMembersRoleImpl(
      committeeName: json['committeeName'] as String?,
      role: json['role'] as String?,
      timestamp:
          const TimestampSerializer().fromJson(json['timestamp'] as Timestamp?),
    );

Map<String, dynamic> _$$CooperativeMembersRoleImplToJson(
        _$CooperativeMembersRoleImpl instance) =>
    <String, dynamic>{
      'committeeName': instance.committeeName,
      'role': instance.role,
      'timestamp': const TimestampSerializer().toJson(instance.timestamp),
    };

_$BoardRoleImpl _$$BoardRoleImplFromJson(Map<String, dynamic> json) =>
    _$BoardRoleImpl(
      role: json['role'] as String?,
      timestamp:
          const TimestampSerializer().fromJson(json['timestamp'] as Timestamp?),
    );

Map<String, dynamic> _$$BoardRoleImplToJson(_$BoardRoleImpl instance) =>
    <String, dynamic>{
      'role': instance.role,
      'timestamp': const TimestampSerializer().toJson(instance.timestamp),
    };
