// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_coop_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JoinCoopParamsImpl _$$JoinCoopParamsImplFromJson(Map<String, dynamic> json) =>
    _$JoinCoopParamsImpl(
      uid: json['uid'] as String?,
      coopId: json['coopId'] as String?,
      name: json['name'] as String?,
      userUid: json['userUid'] as String?,
      timestamp:
          const TimestampSerializer().fromJson(json['timestamp'] as Timestamp?),
      age: json['age'] as num?,
      gender: json['gender'] as String?,
      religion: json['religion'] as String?,
      nationality: json['nationality'] as String?,
      civilStatus: json['civilStatus'] as String?,
      committee: json['committee'] as String?,
      role: json['role'] as String?,
      status: json['status'] as String?,
      updatedBy: json['updatedBy'] == null
          ? null
          : HandledByModel.fromJson(json['updatedBy'] as Map<String, dynamic>),
      reqFiles: (json['reqFiles'] as List<dynamic>?)
          ?.map((e) => ReqFile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$JoinCoopParamsImplToJson(
        _$JoinCoopParamsImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'coopId': instance.coopId,
      'name': instance.name,
      'userUid': instance.userUid,
      'timestamp': const TimestampSerializer().toJson(instance.timestamp),
      'age': instance.age,
      'gender': instance.gender,
      'religion': instance.religion,
      'nationality': instance.nationality,
      'civilStatus': instance.civilStatus,
      'committee': instance.committee,
      'role': instance.role,
      'status': instance.status,
      'updatedBy': instance.updatedBy?.toJson(),
      'reqFiles': instance.reqFiles?.map((e) => e.toJson()).toList(),
    };

_$HandledByModelImpl _$$HandledByModelImplFromJson(Map<String, dynamic> json) =>
    _$HandledByModelImpl(
      uid: json['uid'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$HandledByModelImplToJson(
        _$HandledByModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
    };

_$ReqFileImpl _$$ReqFileImplFromJson(Map<String, dynamic> json) =>
    _$ReqFileImpl(
      fileName: json['fileName'] as String?,
      fileTitle: json['fileTitle'] as String?,
      path: json['path'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$$ReqFileImplToJson(_$ReqFileImpl instance) =>
    <String, dynamic>{
      'fileName': instance.fileName,
      'fileTitle': instance.fileTitle,
      'path': instance.path,
      'url': instance.url,
    };
