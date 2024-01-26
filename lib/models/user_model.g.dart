// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      uid: json['uid'] as String,
      name: json['name'] as String,
      profilePic: json['profilePic'] as String,
      phoneNo: json['phoneNo'] as String?,
      isAuthenticated: json['isAuthenticated'] as bool,
      imageUrl: json['imageUrl'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      isCoopView: json['isCoopView'] as bool?,
      cooperativesJoined: (json['cooperativesJoined'] as List<dynamic>?)
          ?.map((e) => CooperativesJoined.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentCoop: json['currentCoop'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'profilePic': instance.profilePic,
      'phoneNo': instance.phoneNo,
      'isAuthenticated': instance.isAuthenticated,
      'imageUrl': instance.imageUrl,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'isCoopView': instance.isCoopView,
      'cooperativesJoined':
          instance.cooperativesJoined?.map((e) => e.toJson()).toList(),
      'currentCoop': instance.currentCoop,
    };

_$CooperativesJoinedImpl _$$CooperativesJoinedImplFromJson(
        Map<String, dynamic> json) =>
    _$CooperativesJoinedImpl(
      cooperativeId: json['cooperativeId'] as String,
      cooperativeName: json['cooperativeName'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$$CooperativesJoinedImplToJson(
        _$CooperativesJoinedImpl instance) =>
    <String, dynamic>{
      'cooperativeId': instance.cooperativeId,
      'cooperativeName': instance.cooperativeName,
      'role': instance.role,
    };
