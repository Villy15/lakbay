// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_reviews.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListingReviewsImpl _$$ListingReviewsImplFromJson(Map<String, dynamic> json) =>
    _$ListingReviewsImpl(
      uid: json['uid'] as String?,
      userId: json['userId'] as String,
      author: json['author'] as String,
      rating: json['rating'] as num,
      review: json['review'] as String,
      positiveFeedback: json['positiveFeedback'] as String?,
      negativeFeedback: json['negativeFeedback'] as String?,
      createdAt: const TimestampSerializer().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$$ListingReviewsImplToJson(
        _$ListingReviewsImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'userId': instance.userId,
      'author': instance.author,
      'rating': instance.rating,
      'review': instance.review,
      'positiveFeedback': instance.positiveFeedback,
      'negativeFeedback': instance.negativeFeedback,
      'createdAt': const TimestampSerializer().toJson(instance.createdAt),
    };
