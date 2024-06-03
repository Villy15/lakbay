import 'package:freezed_annotation/freezed_annotation.dart';

part 'coop_member_roles_model.freezed.dart';
part 'coop_member_roles_model.g.dart';

@freezed
class CoopMemberRoles with _$CoopMemberRoles {
  factory CoopMemberRoles(
      {String? uid,
      required String coopId,
      String? memberId,
      List<String>? rolesSelected,
      List<String>? fileUploads}) = _CoopMemberRoles;

  factory CoopMemberRoles.fromJson(Map<String, dynamic> json) =>
      _$CoopMemberRolesFromJson(json);
}
