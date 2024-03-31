import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lakbay/core/util/utils.dart';

part 'coop_model.freezed.dart';
part 'coop_model.g.dart';

@freezed
class CooperativeModel with _$CooperativeModel {
  factory CooperativeModel({
    String? uid,
    required String name,
    String? description,
    String? address,
    required String city,
    required String province,
    required String imagePath,
    String? imageUrl,
    String? code,
    required List<String> members,
    required List<String> managers,
    num? membershipFee,
    num? membershipDividends,
    num? shareCapital,
    num? minimumMemberShareCount,
    @TimestampSerializer() DateTime? dateCreated,
    ValidityStatus? validityStatus,
    ValidationFiles? validationFiles,
  }) = _CooperativeModel;

  factory CooperativeModel.fromJson(Map<String, dynamic> json) =>
      _$CooperativeModelFromJson(json);
}

@freezed
class ValidationFiles with _$ValidationFiles {
  factory ValidationFiles({
    String? certificateOfRegistration,
    String? articlesOfCooperation,
    String? byLaws,
    String? audit,
    String? letterAuth,
  }) = _ValidationFiles;

  factory ValidationFiles.fromJson(Map<String, dynamic> json) =>
      _$ValidationFilesFromJson(json);
}

@freezed
class ValidityStatus with _$ValidityStatus {
  factory ValidityStatus({
    String? status,
    @TimestampSerializer() DateTime? dateValidated,
  }) = _ValidityStatus;

  factory ValidityStatus.fromJson(Map<String, dynamic> json) =>
      _$ValidityStatusFromJson(json);
}
