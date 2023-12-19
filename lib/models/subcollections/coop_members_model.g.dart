// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coop_members_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CooperativeMembersImpl _$$CooperativeMembersImplFromJson(
        Map<String, dynamic> json) =>
    _$CooperativeMembersImpl(
      uid: json['uid'] as String?,
      privileges: (json['privileges'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      role: json['role'] == null
          ? null
          : CooperativeMembersRole.fromJson(
              json['role'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CooperativeMembersImplToJson(
        _$CooperativeMembersImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'privileges': instance.privileges,
      'role': instance.role?.toJson(),
    };

_$CooperativeMembersRoleImpl _$$CooperativeMembersRoleImplFromJson(
        Map<String, dynamic> json) =>
    _$CooperativeMembersRoleImpl(
      committeeName: json['committeeName'] as String?,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$$CooperativeMembersRoleImplToJson(
        _$CooperativeMembersRoleImpl instance) =>
    <String, dynamic>{
      'committeeName': instance.committeeName,
      'role': instance.role,
    };
