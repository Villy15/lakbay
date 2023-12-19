import 'package:freezed_annotation/freezed_annotation.dart';

part 'coop_members_model.freezed.dart';
part 'coop_members_model.g.dart';

@freezed
class CooperativeMembers with _$CooperativeMembers {
  factory CooperativeMembers({
    String? uid,
    List<String>? privileges,
    CooperativeMembersRole? role,
  }) = _CooperativeMembers;

  factory CooperativeMembers.fromJson(Map<String, dynamic> json) =>
      _$CooperativeMembersFromJson(json);
}

@freezed
class CooperativeMembersRole with _$CooperativeMembersRole {
  factory CooperativeMembersRole({
    String? committeeName,
    String? role,
  }) = _CooperativeMembersRole;

  factory CooperativeMembersRole.fromJson(Map<String, dynamic> json) =>
      _$CooperativeMembersRoleFromJson(json);
}
