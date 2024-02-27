// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coop_announcements_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CoopAnnouncements _$CoopAnnouncementsFromJson(Map<String, dynamic> json) {
  return _CoopAnnouncements.fromJson(json);
}

/// @nodoc
mixin _$CoopAnnouncements {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get timestamp => throw _privateConstructorUsedError;
  String? get uid => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CoopAnnouncementsCopyWith<CoopAnnouncements> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoopAnnouncementsCopyWith<$Res> {
  factory $CoopAnnouncementsCopyWith(
          CoopAnnouncements value, $Res Function(CoopAnnouncements) then) =
      _$CoopAnnouncementsCopyWithImpl<$Res, CoopAnnouncements>;
  @useResult
  $Res call(
      {String title,
      String description,
      @TimestampSerializer() DateTime? timestamp,
      String? uid,
      String? imageUrl,
      String? category});
}

/// @nodoc
class _$CoopAnnouncementsCopyWithImpl<$Res, $Val extends CoopAnnouncements>
    implements $CoopAnnouncementsCopyWith<$Res> {
  _$CoopAnnouncementsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? timestamp = freezed,
    Object? uid = freezed,
    Object? imageUrl = freezed,
    Object? category = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CoopAnnouncementsImplCopyWith<$Res>
    implements $CoopAnnouncementsCopyWith<$Res> {
  factory _$$CoopAnnouncementsImplCopyWith(_$CoopAnnouncementsImpl value,
          $Res Function(_$CoopAnnouncementsImpl) then) =
      __$$CoopAnnouncementsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String description,
      @TimestampSerializer() DateTime? timestamp,
      String? uid,
      String? imageUrl,
      String? category});
}

/// @nodoc
class __$$CoopAnnouncementsImplCopyWithImpl<$Res>
    extends _$CoopAnnouncementsCopyWithImpl<$Res, _$CoopAnnouncementsImpl>
    implements _$$CoopAnnouncementsImplCopyWith<$Res> {
  __$$CoopAnnouncementsImplCopyWithImpl(_$CoopAnnouncementsImpl _value,
      $Res Function(_$CoopAnnouncementsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? timestamp = freezed,
    Object? uid = freezed,
    Object? imageUrl = freezed,
    Object? category = freezed,
  }) {
    return _then(_$CoopAnnouncementsImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CoopAnnouncementsImpl implements _CoopAnnouncements {
  _$CoopAnnouncementsImpl(
      {required this.title,
      required this.description,
      @TimestampSerializer() this.timestamp,
      this.uid,
      this.imageUrl,
      this.category});

  factory _$CoopAnnouncementsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoopAnnouncementsImplFromJson(json);

  @override
  final String title;
  @override
  final String description;
  @override
  @TimestampSerializer()
  final DateTime? timestamp;
  @override
  final String? uid;
  @override
  final String? imageUrl;
  @override
  final String? category;

  @override
  String toString() {
    return 'CoopAnnouncements(title: $title, description: $description, timestamp: $timestamp, uid: $uid, imageUrl: $imageUrl, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoopAnnouncementsImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, title, description, timestamp, uid, imageUrl, category);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CoopAnnouncementsImplCopyWith<_$CoopAnnouncementsImpl> get copyWith =>
      __$$CoopAnnouncementsImplCopyWithImpl<_$CoopAnnouncementsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoopAnnouncementsImplToJson(
      this,
    );
  }
}

abstract class _CoopAnnouncements implements CoopAnnouncements {
  factory _CoopAnnouncements(
      {required final String title,
      required final String description,
      @TimestampSerializer() final DateTime? timestamp,
      final String? uid,
      final String? imageUrl,
      final String? category}) = _$CoopAnnouncementsImpl;

  factory _CoopAnnouncements.fromJson(Map<String, dynamic> json) =
      _$CoopAnnouncementsImpl.fromJson;

  @override
  String get title;
  @override
  String get description;
  @override
  @TimestampSerializer()
  DateTime? get timestamp;
  @override
  String? get uid;
  @override
  String? get imageUrl;
  @override
  String? get category;
  @override
  @JsonKey(ignore: true)
  _$$CoopAnnouncementsImplCopyWith<_$CoopAnnouncementsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
