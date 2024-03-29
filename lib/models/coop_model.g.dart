// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CooperativeModelImpl _$$CooperativeModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CooperativeModelImpl(
      uid: json['uid'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String,
      province: json['province'] as String,
      imagePath: json['imagePath'] as String,
      imageUrl: json['imageUrl'] as String?,
      code: json['code'] as String?,
      members:
          (json['members'] as List<dynamic>).map((e) => e as String).toList(),
      managers:
          (json['managers'] as List<dynamic>).map((e) => e as String).toList(),
      membershipFee: json['membershipFee'] as num?,
      membershipDividends: json['membershipDividends'] as num?,
      dateCreated: const TimestampSerializer()
          .fromJson(json['dateCreated'] as Timestamp?),
      validityStatus: json['validityStatus'] == null
          ? null
          : ValidityStatus.fromJson(
              json['validityStatus'] as Map<String, dynamic>),
      validationFiles: json['validationFiles'] == null
          ? null
          : ValidationFiles.fromJson(
              json['validationFiles'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CooperativeModelImplToJson(
        _$CooperativeModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'city': instance.city,
      'province': instance.province,
      'imagePath': instance.imagePath,
      'imageUrl': instance.imageUrl,
      'code': instance.code,
      'members': instance.members,
      'managers': instance.managers,
      'membershipFee': instance.membershipFee,
      'membershipDividends': instance.membershipDividends,
      'dateCreated': const TimestampSerializer().toJson(instance.dateCreated),
      'validityStatus': instance.validityStatus?.toJson(),
      'validationFiles': instance.validationFiles?.toJson(),
    };

_$ValidationFilesImpl _$$ValidationFilesImplFromJson(
        Map<String, dynamic> json) =>
    _$ValidationFilesImpl(
      certificateOfRegistration: json['certificateOfRegistration'] as String?,
      articlesOfCooperation: json['articlesOfCooperation'] as String?,
      byLaws: json['byLaws'] as String?,
      audit: json['audit'] as String?,
      letterAuth: json['letterAuth'] as String?,
    );

Map<String, dynamic> _$$ValidationFilesImplToJson(
        _$ValidationFilesImpl instance) =>
    <String, dynamic>{
      'certificateOfRegistration': instance.certificateOfRegistration,
      'articlesOfCooperation': instance.articlesOfCooperation,
      'byLaws': instance.byLaws,
      'audit': instance.audit,
      'letterAuth': instance.letterAuth,
    };

_$ValidityStatusImpl _$$ValidityStatusImplFromJson(Map<String, dynamic> json) =>
    _$ValidityStatusImpl(
      status: json['status'] as String?,
      dateValidated: const TimestampSerializer()
          .fromJson(json['dateValidated'] as Timestamp?),
    );

Map<String, dynamic> _$$ValidityStatusImplToJson(
        _$ValidityStatusImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'dateValidated':
          const TimestampSerializer().toJson(instance.dateValidated),
    };
