// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coop_member_roles_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoopMemberRolesImpl _$$CoopMemberRolesImplFromJson(
        Map<String, dynamic> json) =>
    _$CoopMemberRolesImpl(
      uid: json['uid'] as String?,
      coopId: json['coopId'] as String,
      memberId: json['memberId'] as String?,
      rolesSelected: (json['rolesSelected'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      fileUploads: (json['fileUploads'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$CoopMemberRolesImplToJson(
        _$CoopMemberRolesImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'coopId': instance.coopId,
      'memberId': instance.memberId,
      'rolesSelected': instance.rolesSelected,
      'fileUploads': instance.fileUploads,
    };
