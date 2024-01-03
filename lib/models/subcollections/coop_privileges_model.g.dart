// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coop_privileges_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CooperativePrivilegesImpl _$$CooperativePrivilegesImplFromJson(
        Map<String, dynamic> json) =>
    _$CooperativePrivilegesImpl(
      committeeName: json['committeeName'] as String,
      managerPrivileges: (json['managerPrivileges'] as List<dynamic>)
          .map((e) => ManagerPrivileges.fromJson(e as Map<String, dynamic>))
          .toList(),
      memberPrivileges: (json['memberPrivileges'] as List<dynamic>)
          .map((e) => MemberPrivileges.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CooperativePrivilegesImplToJson(
        _$CooperativePrivilegesImpl instance) =>
    <String, dynamic>{
      'committeeName': instance.committeeName,
      'managerPrivileges':
          instance.managerPrivileges.map((e) => e.toJson()).toList(),
      'memberPrivileges':
          instance.memberPrivileges.map((e) => e.toJson()).toList(),
    };

_$ManagerPrivilegesImpl _$$ManagerPrivilegesImplFromJson(
        Map<String, dynamic> json) =>
    _$ManagerPrivilegesImpl(
      privilegeName: json['privilegeName'] as String,
      isAllowed: json['isAllowed'] as bool? ?? false,
    );

Map<String, dynamic> _$$ManagerPrivilegesImplToJson(
        _$ManagerPrivilegesImpl instance) =>
    <String, dynamic>{
      'privilegeName': instance.privilegeName,
      'isAllowed': instance.isAllowed,
    };

_$MemberPrivilegesImpl _$$MemberPrivilegesImplFromJson(
        Map<String, dynamic> json) =>
    _$MemberPrivilegesImpl(
      privilegeName: json['privilegeName'] as String,
      isAllowed: json['isAllowed'] as bool? ?? false,
    );

Map<String, dynamic> _$$MemberPrivilegesImplToJson(
        _$MemberPrivilegesImpl instance) =>
    <String, dynamic>{
      'privilegeName': instance.privilegeName,
      'isAllowed': instance.isAllowed,
    };
