import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lakbay/core/util/utils.dart';

part 'plan_model.freezed.dart';
part 'plan_model.g.dart';

@freezed
class PlanModel with _$PlanModel {
  const PlanModel._();

  factory PlanModel({
    String? uid,
    required String location,
    @TimestampSerializer() DateTime? startDate,
    @TimestampSerializer() DateTime? endDate,
    List<PlanActivity>? activities,
    required String name,
    required num budget,
    required num guests,
    String? imageUrl,
    required String userId,
  }) = _PlanModel;

  factory PlanModel.fromJson(Map<String, dynamic> json) =>
      _$PlanModelFromJson(json);

  // Check the date of the activity if it is the same as the date of the plan
  bool isSameDate(DateTime date) {
    return activities?.any((activity) {
          return activity.dateTime?.year == date.year &&
              activity.dateTime?.month == date.month &&
              activity.dateTime?.day == date.day;
        }) ??
        false;
  }
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
