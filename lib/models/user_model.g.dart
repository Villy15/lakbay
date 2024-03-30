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
      email: json['email'] as String?,
      address: json['address'] as String?,
      emergencyContact: json['emergencyContact'] as String?,
      emergencyContactName: json['emergencyContactName'] as String?,
      isAuthenticated: json['isAuthenticated'] as bool,
      imageUrl: json['imageUrl'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      isCoopView: json['isCoopView'] as bool?,
      cooperativesJoined: (json['cooperativesJoined'] as List<dynamic>?)
          ?.map((e) => CooperativesJoined.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentCoop: json['currentCoop'] as String?,
      validIdUrl: json['validIdUrl'] as String?,
      birthCertificateUrl: json['birthCertificateUrl'] as String?,
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => UserReviews.fromJson(e as Map<String, dynamic>))
          .toList(),
      middleName: json['middleName'] as String?,
      birthDate:
          const TimestampSerializer().fromJson(json['birthDate'] as Timestamp?),
      age: json['age'] as num?,
      gender: json['gender'] as String?,
      religion: json['religion'] as String?,
      nationality: json['nationality'] as String?,
      civilStatus: json['civilStatus'] as String?,
      createdAt:
          const TimestampSerializer().fromJson(json['createdAt'] as Timestamp?),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'profilePic': instance.profilePic,
      'phoneNo': instance.phoneNo,
      'email': instance.email,
      'address': instance.address,
      'emergencyContact': instance.emergencyContact,
      'emergencyContactName': instance.emergencyContactName,
      'isAuthenticated': instance.isAuthenticated,
      'imageUrl': instance.imageUrl,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'isCoopView': instance.isCoopView,
      'cooperativesJoined':
          instance.cooperativesJoined?.map((e) => e.toJson()).toList(),
      'currentCoop': instance.currentCoop,
      'validIdUrl': instance.validIdUrl,
      'birthCertificateUrl': instance.birthCertificateUrl,
      'reviews': instance.reviews?.map((e) => e.toJson()).toList(),
      'middleName': instance.middleName,
      'birthDate': const TimestampSerializer().toJson(instance.birthDate),
      'age': instance.age,
      'gender': instance.gender,
      'religion': instance.religion,
      'nationality': instance.nationality,
      'civilStatus': instance.civilStatus,
      'createdAt': const TimestampSerializer().toJson(instance.createdAt),
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

_$UserReviewsImpl _$$UserReviewsImplFromJson(Map<String, dynamic> json) =>
    _$UserReviewsImpl(
      userId: json['userId'] as String,
      reviewerId: json['reviewerId'] as String,
      listingId: json['listingId'] as String,
      createdAt:
          const TimestampSerializer().fromJson(json['createdAt'] as Timestamp?),
      review: json['review'] as String,
    );

Map<String, dynamic> _$$UserReviewsImplToJson(_$UserReviewsImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'reviewerId': instance.reviewerId,
      'listingId': instance.listingId,
      'createdAt': const TimestampSerializer().toJson(instance.createdAt),
      'review': instance.review,
    };
