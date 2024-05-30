// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SurveyModelImpl _$$SurveyModelImplFromJson(Map<String, dynamic> json) =>
    _$SurveyModelImpl(
      uid: json['uid'] as String?,
      userId: json['userId'] as String,
      surveyType: json['surveyType'] as String?,
      dateCreated: const TimestampSerializer()
          .fromJson(json['dateCreated'] as Timestamp?),
    );

Map<String, dynamic> _$$SurveyModelImplToJson(_$SurveyModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'userId': instance.userId,
      'surveyType': instance.surveyType,
      'dateCreated': const TimestampSerializer().toJson(instance.dateCreated),
    };
