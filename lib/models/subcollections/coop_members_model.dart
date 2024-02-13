import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lakbay/core/util/utils.dart';

part 'coop_members_model.freezed.dart';
part 'coop_members_model.g.dart';

@freezed
class CooperativeMembers with _$CooperativeMembers {
  const CooperativeMembers._();

  factory CooperativeMembers({
    required String name,
    String? uid,
    List<String>? privileges,
    CooperativeMembersRole? role,
    List<CooperativeMembersRole>? committees,
    @Default(false) bool? isManager,
    BoardRole? boardRole,
    @TimestampSerializer() DateTime? timestamp,
  }) = _CooperativeMembers;

  factory CooperativeMembers.fromJson(Map<String, dynamic> json) =>
      _$CooperativeMembersFromJson(json);


  // Is Committee Member given a string
  bool isCommitteeMember(String committeeName) {
    return committees
            ?.any((committee) => committee.committeeName == committeeName) ??
        false;
  }

  // What role does he have in the committee
  String? committeeRole(String committeeName) {
    return committees
        ?.firstWhere(
          (committee) => committee.committeeName == committeeName,
        )
        .role;
  }

  // Is Committee Manager
  bool get isCommitteeManager {
    return committees?.any((committee) => committee.role == 'Manager') ?? false;
  }

  // isRegularMember, check if he is not a manager and not a committee member or manager
  bool get isRegularMember {
    return !isManager! && committees!.isEmpty;
  }
}

@freezed
class CooperativeMembersRole with _$CooperativeMembersRole {
  factory CooperativeMembersRole({
    String? committeeName,
    String? role,
    @TimestampSerializer() DateTime? timestamp,
  }) = _CooperativeMembersRole;

  factory CooperativeMembersRole.fromJson(Map<String, dynamic> json) =>
      _$CooperativeMembersRoleFromJson(json);
}

@freezed
class BoardRole with _$BoardRole {
  factory BoardRole({
    String? role,
    @TimestampSerializer() DateTime? timestamp,
  }) = _BoardRole;

  factory BoardRole.fromJson(Map<String, dynamic> json) =>
      _$BoardRoleFromJson(json);
}
