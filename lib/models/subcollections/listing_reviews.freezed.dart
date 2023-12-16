// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listing_reviews.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ListingReviews _$ListingReviewsFromJson(Map<String, dynamic> json) {
  return _ListingReviews.fromJson(json);
}

/// @nodoc
mixin _$ListingReviews {
  String? get uid => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  num get rating => throw _privateConstructorUsedError;
  String get review => throw _privateConstructorUsedError;
  String? get positiveFeedback => throw _privateConstructorUsedError;
  String? get negativeFeedback => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ListingReviewsCopyWith<ListingReviews> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListingReviewsCopyWith<$Res> {
  factory $ListingReviewsCopyWith(
          ListingReviews value, $Res Function(ListingReviews) then) =
      _$ListingReviewsCopyWithImpl<$Res, ListingReviews>;
  @useResult
  $Res call(
      {String? uid,
      String userId,
      String author,
      num rating,
      String review,
      String? positiveFeedback,
      String? negativeFeedback,
      @TimestampSerializer() DateTime createdAt});
}

/// @nodoc
class _$ListingReviewsCopyWithImpl<$Res, $Val extends ListingReviews>
    implements $ListingReviewsCopyWith<$Res> {
  _$ListingReviewsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? userId = null,
    Object? author = null,
    Object? rating = null,
    Object? review = null,
    Object? positiveFeedback = freezed,
    Object? negativeFeedback = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as num,
      review: null == review
          ? _value.review
          : review // ignore: cast_nullable_to_non_nullable
              as String,
      positiveFeedback: freezed == positiveFeedback
          ? _value.positiveFeedback
          : positiveFeedback // ignore: cast_nullable_to_non_nullable
              as String?,
      negativeFeedback: freezed == negativeFeedback
          ? _value.negativeFeedback
          : negativeFeedback // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ListingReviewsImplCopyWith<$Res>
    implements $ListingReviewsCopyWith<$Res> {
  factory _$$ListingReviewsImplCopyWith(_$ListingReviewsImpl value,
          $Res Function(_$ListingReviewsImpl) then) =
      __$$ListingReviewsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? uid,
      String userId,
      String author,
      num rating,
      String review,
      String? positiveFeedback,
      String? negativeFeedback,
      @TimestampSerializer() DateTime createdAt});
}

/// @nodoc
class __$$ListingReviewsImplCopyWithImpl<$Res>
    extends _$ListingReviewsCopyWithImpl<$Res, _$ListingReviewsImpl>
    implements _$$ListingReviewsImplCopyWith<$Res> {
  __$$ListingReviewsImplCopyWithImpl(
      _$ListingReviewsImpl _value, $Res Function(_$ListingReviewsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? userId = null,
    Object? author = null,
    Object? rating = null,
    Object? review = null,
    Object? positiveFeedback = freezed,
    Object? negativeFeedback = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$ListingReviewsImpl(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as num,
      review: null == review
          ? _value.review
          : review // ignore: cast_nullable_to_non_nullable
              as String,
      positiveFeedback: freezed == positiveFeedback
          ? _value.positiveFeedback
          : positiveFeedback // ignore: cast_nullable_to_non_nullable
              as String?,
      negativeFeedback: freezed == negativeFeedback
          ? _value.negativeFeedback
          : negativeFeedback // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListingReviewsImpl implements _ListingReviews {
  _$ListingReviewsImpl(
      {this.uid,
      required this.userId,
      required this.author,
      required this.rating,
      required this.review,
      this.positiveFeedback,
      this.negativeFeedback,
      @TimestampSerializer() required this.createdAt});

  factory _$ListingReviewsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListingReviewsImplFromJson(json);

  @override
  final String? uid;
  @override
  final String userId;
  @override
  final String author;
  @override
  final num rating;
  @override
  final String review;
  @override
  final String? positiveFeedback;
  @override
  final String? negativeFeedback;
  @override
  @TimestampSerializer()
  final DateTime createdAt;

  @override
  String toString() {
    return 'ListingReviews(uid: $uid, userId: $userId, author: $author, rating: $rating, review: $review, positiveFeedback: $positiveFeedback, negativeFeedback: $negativeFeedback, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListingReviewsImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.review, review) || other.review == review) &&
            (identical(other.positiveFeedback, positiveFeedback) ||
                other.positiveFeedback == positiveFeedback) &&
            (identical(other.negativeFeedback, negativeFeedback) ||
                other.negativeFeedback == negativeFeedback) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uid, userId, author, rating,
      review, positiveFeedback, negativeFeedback, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ListingReviewsImplCopyWith<_$ListingReviewsImpl> get copyWith =>
      __$$ListingReviewsImplCopyWithImpl<_$ListingReviewsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListingReviewsImplToJson(
      this,
    );
  }
}

abstract class _ListingReviews implements ListingReviews {
  factory _ListingReviews(
          {final String? uid,
          required final String userId,
          required final String author,
          required final num rating,
          required final String review,
          final String? positiveFeedback,
          final String? negativeFeedback,
          @TimestampSerializer() required final DateTime createdAt}) =
      _$ListingReviewsImpl;

  factory _ListingReviews.fromJson(Map<String, dynamic> json) =
      _$ListingReviewsImpl.fromJson;

  @override
  String? get uid;
  @override
  String get userId;
  @override
  String get author;
  @override
  num get rating;
  @override
  String get review;
  @override
  String? get positiveFeedback;
  @override
  String? get negativeFeedback;
  @override
  @TimestampSerializer()
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ListingReviewsImplCopyWith<_$ListingReviewsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
