import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lakbay/core/util/utils.dart';

part 'join_coop_params.freezed.dart';
part 'join_coop_params.g.dart';

@freezed
class JoinCoopParams with _$JoinCoopParams {
  factory JoinCoopParams({
    String? uid,
    String? coopId,
    String? name,
    String? userUid,
    @TimestampSerializer() DateTime? timestamp,
    num? age,
    String? gender,
    String? religion,
    String? nationality,
    String? civilStatus,
    String? committee,
    String? role,
    String? status, //pending, rejected, completed
    HandledByModel? updatedBy,
    List<ReqFile>? reqFiles,
  }) = _JoinCoopParams;

  factory JoinCoopParams.fromJson(Map<String, dynamic> json) =>
      _$JoinCoopParamsFromJson(json);
}

@freezed
class HandledByModel with _$HandledByModel {
  factory HandledByModel({
    String? uid,
    String? name,
  }) = _HandledByModel;

  factory HandledByModel.fromJson(Map<String, dynamic> json) =>
      _$HandledByModelFromJson(json);
}

@freezed
class ReqFile with _$ReqFile {
  factory ReqFile({
    String? fileName,
    String? fileTitle,
    String? path,
    String? url,
  }) = _ReqFile;

  factory ReqFile.fromJson(Map<String, dynamic> json) =>
      _$ReqFileFromJson(json);
}
