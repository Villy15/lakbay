import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lakbay/core/util/utils.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
class TaskModel with _$TaskModel {
  factory TaskModel({
    String? uid,
    required String title,
    String? description,
    @TimestampSerializer() DateTime? dueDate,
    required String priority,
    required String coopId,
    @TimestampSerializer() DateTime? createdAt,
    required String type,
    String? eventId,
    String? publisherId,
    List<TaskCheckList>? checkList,
    List<String>? assignedTo,
    @Default(false) bool? askContribution,
    List<String>? contributors,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
}

@freezed
class TaskCheckList with _$TaskCheckList {
  factory TaskCheckList({
    required String title,
    required bool isDone,
    String? proofUrl,
  }) = _TaskCheckList;

  factory TaskCheckList.fromJson(Map<String, dynamic> json) =>
      _$TaskCheckListFromJson(json);
}
