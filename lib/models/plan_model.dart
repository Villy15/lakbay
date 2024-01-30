import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lakbay/core/util/utils.dart';

part 'plan_model.freezed.dart';
part 'plan_model.g.dart';

@freezed
class PlanModel with _$PlanModel {
  factory PlanModel({
    String? uid,
    required String location,
    @TimestampSerializer() DateTime? startDate,
    @TimestampSerializer() DateTime? endDate,
    List<PlanActivity>? activities,
    required String userId,
  }) = _PlanModel;

  factory PlanModel.fromJson(Map<String, dynamic> json) =>
      _$PlanModelFromJson(json);
}

@freezed
class PlanActivity with _$PlanActivity {
  factory PlanActivity({
    @TimestampSerializer() DateTime? dateTime,
    String? title,
    String? description,
    @TimestampSerializer() DateTime? startTime,
    @TimestampSerializer() DateTime? endTime,
  }) = _PlanActivity;

  factory PlanActivity.fromJson(Map<String, dynamic> json) =>
      _$PlanActivityFromJson(json);
}
