import 'package:freezed_annotation/freezed_annotation.dart';

part 'committee_params.freezed.dart';
part 'committee_params.g.dart';

@freezed
class CommitteeParams with _$CommitteeParams {
  factory CommitteeParams({
    required String coopUid,
    required String committeeName,
  }) = _CommitteeParams;

  factory CommitteeParams.fromJson(Map<String, dynamic> json) =>
      _$CommitteeParamsFromJson(json);
}
