import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lakbay/core/util/utils.dart';

part 'survey_model.freezed.dart';
part 'survey_model.g.dart';

@freezed
class SurveyModel with _$SurveyModel {
  factory SurveyModel({
    String? uid,
    required String userId,
    String? surveyType,
    @TimestampSerializer() DateTime? dateCreated,
  }) = _SurveyModel;

  factory SurveyModel.fromJson(Map<String, dynamic> json) =>
      _$SurveyModelFromJson(json);
}
