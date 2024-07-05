import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lakbay/core/util/utils.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@freezed
class EventModel with _$EventModel {
  factory EventModel({
    String? uid,
    required String name,
    String? description,
    required String address,
    required String city,
    required String province,
    required String imagePath,
    String? imageUrl,
    required List<String> members,
    required List<String> managers,
    List<EventGoalsAndObjectives>? goalsAndObjectives,
    @TimestampSerializer() DateTime? startDate,
    @TimestampSerializer() DateTime? endDate,
    required EventCooperative cooperative,
    String? eventType,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}

@freezed
class EventCooperative with _$EventCooperative {
  factory EventCooperative({
    required String cooperativeId,
    required String cooperativeName,
  }) = _EventCooperative;

  factory EventCooperative.fromJson(Map<String, dynamic> json) =>
      _$EventCooperativeFromJson(json);
}

@freezed
class EventGoalsAndObjectives with _$EventGoalsAndObjectives {
  factory EventGoalsAndObjectives({
    required String goal,
    required num objective,
    bool? isAchieved,
  }) = _EventGoalsAndObjectives;

  factory EventGoalsAndObjectives.fromJson(Map<String, dynamic> json) =>
      _$EventGoalsAndObjectivesFromJson(json);
}
