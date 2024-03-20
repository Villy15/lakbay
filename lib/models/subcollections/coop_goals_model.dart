import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lakbay/core/util/utils.dart';

part 'coop_goals_model.freezed.dart';
part 'coop_goals_model.g.dart';

@freezed
class CoopGoals with _$CoopGoals {
  factory CoopGoals({
    String? uid,
    String? title,
    String? description,
    String? coopId,
    @TimestampSerializer() DateTime? targetDate,
    String? category,
    List<String>? metrics,
    num? progress,
  }) = _CoopGoals;

  factory CoopGoals.fromJson(Map<String, dynamic> json) =>
      _$CoopGoalsFromJson(json);
}
