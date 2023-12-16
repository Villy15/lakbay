import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lakbay/core/util/utils.dart';

part 'listing_reviews.freezed.dart';
part 'listing_reviews.g.dart';

@freezed
class ListingReviews with _$ListingReviews {
  factory ListingReviews({
    String? uid,
    required String userId,
    required String author,
    required num rating,
    required String review,
    String? positiveFeedback,
    String? negativeFeedback,
    @TimestampSerializer() required DateTime createdAt,
  }) = _ListingReviews;

  factory ListingReviews.fromJson(Map<String, dynamic> json) =>
      _$ListingReviewsFromJson(json);
}
