// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskModelImpl _$$TaskModelImplFromJson(Map<String, dynamic> json) =>
    _$TaskModelImpl(
      uid: json['uid'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate:
          const TimestampSerializer().fromJson(json['dueDate'] as Timestamp?),
      priority: json['priority'] as String,
      coopId: json['coopId'] as String,
      createdAt:
          const TimestampSerializer().fromJson(json['createdAt'] as Timestamp?),
      type: json['type'] as String,
      eventId: json['eventId'] as String?,
      publisherId: json['publisherId'] as String?,
      checkList: (json['checkList'] as List<dynamic>?)
          ?.map((e) => TaskCheckList.fromJson(e as Map<String, dynamic>))
          .toList(),
      assignedTo: (json['assignedTo'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      askContribution: json['askContribution'] as bool? ?? false,
      contributors: (json['contributors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$TaskModelImplToJson(_$TaskModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'title': instance.title,
      'description': instance.description,
      'dueDate': const TimestampSerializer().toJson(instance.dueDate),
      'priority': instance.priority,
      'coopId': instance.coopId,
      'createdAt': const TimestampSerializer().toJson(instance.createdAt),
      'type': instance.type,
      'eventId': instance.eventId,
      'publisherId': instance.publisherId,
      'checkList': instance.checkList?.map((e) => e.toJson()).toList(),
      'assignedTo': instance.assignedTo,
      'askContribution': instance.askContribution,
      'contributors': instance.contributors,
    };

_$TaskCheckListImpl _$$TaskCheckListImplFromJson(Map<String, dynamic> json) =>
    _$TaskCheckListImpl(
      title: json['title'] as String,
      isDone: json['isDone'] as bool,
      proofUrl: json['proofUrl'] as String?,
    );

Map<String, dynamic> _$$TaskCheckListImplToJson(_$TaskCheckListImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'isDone': instance.isDone,
      'proofUrl': instance.proofUrl,
    };
