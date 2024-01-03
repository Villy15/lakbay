import 'package:freezed_annotation/freezed_annotation.dart';

part 'coop_privileges_model.freezed.dart';
part 'coop_privileges_model.g.dart';

@freezed
class CooperativePrivileges with _$CooperativePrivileges {
  const CooperativePrivileges._();

  factory CooperativePrivileges({
    required String committeeName,
    required List<ManagerPrivileges> managerPrivileges,
    required List<MemberPrivileges> memberPrivileges,
  }) = _CooperativePrivileges;

  factory CooperativePrivileges.fromJson(Map<String, dynamic> json) =>
      _$CooperativePrivilegesFromJson(json);

  bool isManagerPrivilegeAllowed(String privilegeName) {
    return managerPrivileges.any((privilege) =>
        privilege.privilegeName == privilegeName && privilege.isAllowed);
  }

  bool isMemberPrivilegeAllowed(String privilegeName) {
    return memberPrivileges.any((privilege) =>
        privilege.privilegeName == privilegeName && privilege.isAllowed);
  }
}

@freezed
class ManagerPrivileges with _$ManagerPrivileges {
  factory ManagerPrivileges({
    required String privilegeName,
    @Default(false) bool isAllowed,
  }) = _ManagerPrivileges;

  factory ManagerPrivileges.fromJson(Map<String, dynamic> json) =>
      _$ManagerPrivilegesFromJson(json);
}

@freezed
class MemberPrivileges with _$MemberPrivileges {
  factory MemberPrivileges({
    required String privilegeName,
    @Default(false) bool isAllowed,
  }) = _MemberPrivileges;

  factory MemberPrivileges.fromJson(Map<String, dynamic> json) =>
      _$MemberPrivilegesFromJson(json);
}
