// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifications_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationsModel _$NotificationsModelFromJson(Map<String, dynamic> json) {
  return _NotificationsModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationsModel {
  String? get uid => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String? get coopId => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String? get listingId => throw _privateConstructorUsedError;
  String? get eventId => throw _privateConstructorUsedError;
  String? get bookingId => throw _privateConstructorUsedError;
  bool? get isTapped => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  String? get routePath => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationsModelCopyWith<NotificationsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationsModelCopyWith<$Res> {
  factory $NotificationsModelCopyWith(
          NotificationsModel value, $Res Function(NotificationsModel) then) =
      _$NotificationsModelCopyWithImpl<$Res, NotificationsModel>;
  @useResult
  $Res call(
      {String? uid,
      String ownerId,
      String? userId,
      String? coopId,
      String? message,
      String? listingId,
      String? eventId,
      String? bookingId,
      bool? isTapped,
      String? type,
      @TimestampSerializer() DateTime? createdAt,
      String? routePath});
}

/// @nodoc
class _$NotificationsModelCopyWithImpl<$Res, $Val extends NotificationsModel>
    implements $NotificationsModelCopyWith<$Res> {
  _$NotificationsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? ownerId = null,
    Object? userId = freezed,
    Object? coopId = freezed,
    Object? message = freezed,
    Object? listingId = freezed,
    Object? eventId = freezed,
    Object? bookingId = freezed,
    Object? isTapped = freezed,
    Object? type = freezed,
    Object? createdAt = freezed,
    Object? routePath = freezed,
  }) {
    return _then(_value.copyWith(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      coopId: freezed == coopId
          ? _value.coopId
          : coopId // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      listingId: freezed == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
      isTapped: freezed == isTapped
          ? _value.isTapped
          : isTapped // ignore: cast_nullable_to_non_nullable
              as bool?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      routePath: freezed == routePath
          ? _value.routePath
          : routePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationsModelImplCopyWith<$Res>
    implements $NotificationsModelCopyWith<$Res> {
  factory _$$NotificationsModelImplCopyWith(_$NotificationsModelImpl value,
          $Res Function(_$NotificationsModelImpl) then) =
      __$$NotificationsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? uid,
      String ownerId,
      String? userId,
      String? coopId,
      String? message,
      String? listingId,
      String? eventId,
      String? bookingId,
      bool? isTapped,
      String? type,
      @TimestampSerializer() DateTime? createdAt,
      String? routePath});
}

/// @nodoc
class __$$NotificationsModelImplCopyWithImpl<$Res>
    extends _$NotificationsModelCopyWithImpl<$Res, _$NotificationsModelImpl>
    implements _$$NotificationsModelImplCopyWith<$Res> {
  __$$NotificationsModelImplCopyWithImpl(_$NotificationsModelImpl _value,
      $Res Function(_$NotificationsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? ownerId = null,
    Object? userId = freezed,
    Object? coopId = freezed,
    Object? message = freezed,
    Object? listingId = freezed,
    Object? eventId = freezed,
    Object? bookingId = freezed,
    Object? isTapped = freezed,
    Object? type = freezed,
    Object? createdAt = freezed,
    Object? routePath = freezed,
  }) {
    return _then(_$NotificationsModelImpl(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      coopId: freezed == coopId
          ? _value.coopId
          : coopId // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      listingId: freezed == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
      isTapped: freezed == isTapped
          ? _value.isTapped
          : isTapped // ignore: cast_nullable_to_non_nullable
              as bool?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      routePath: freezed == routePath
          ? _value.routePath
          : routePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationsModelImpl implements _NotificationsModel {
  _$NotificationsModelImpl(
      {this.uid,
      required this.ownerId,
      this.userId,
      this.coopId,
      this.message,
      this.listingId,
      this.eventId,
      this.bookingId,
      this.isTapped = false,
      this.type,
      @TimestampSerializer() this.createdAt,
      this.routePath});

  factory _$NotificationsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationsModelImplFromJson(json);

  @override
  final String? uid;
  @override
  final String ownerId;
  @override
  final String? userId;
  @override
  final String? coopId;
  @override
  final String? message;
  @override
  final String? listingId;
  @override
  final String? eventId;
  @override
  final String? bookingId;
  @override
  @JsonKey()
  final bool? isTapped;
  @override
  final String? type;
  @override
  @TimestampSerializer()
  final DateTime? createdAt;
  @override
  final String? routePath;

  @override
  String toString() {
    return 'NotificationsModel(uid: $uid, ownerId: $ownerId, userId: $userId, coopId: $coopId, message: $message, listingId: $listingId, eventId: $eventId, bookingId: $bookingId, isTapped: $isTapped, type: $type, createdAt: $createdAt, routePath: $routePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationsModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.coopId, coopId) || other.coopId == coopId) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.listingId, listingId) ||
                other.listingId == listingId) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.isTapped, isTapped) ||
                other.isTapped == isTapped) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.routePath, routePath) ||
                other.routePath == routePath));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      ownerId,
      userId,
      coopId,
      message,
      listingId,
      eventId,
      bookingId,
      isTapped,
      type,
      createdAt,
      routePath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationsModelImplCopyWith<_$NotificationsModelImpl> get copyWith =>
      __$$NotificationsModelImplCopyWithImpl<_$NotificationsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationsModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationsModel implements NotificationsModel {
  factory _NotificationsModel(
      {final String? uid,
      required final String ownerId,
      final String? userId,
      final String? coopId,
      final String? message,
      final String? listingId,
      final String? eventId,
      final String? bookingId,
      final bool? isTapped,
      final String? type,
      @TimestampSerializer() final DateTime? createdAt,
      final String? routePath}) = _$NotificationsModelImpl;

  factory _NotificationsModel.fromJson(Map<String, dynamic> json) =
      _$NotificationsModelImpl.fromJson;

  @override
  String? get uid;
  @override
  String get ownerId;
  @override
  String? get userId;
  @override
  String? get coopId;
  @override
  String? get message;
  @override
  String? get listingId;
  @override
  String? get eventId;
  @override
  String? get bookingId;
  @override
  bool? get isTapped;
  @override
  String? get type;
  @override
  @TimestampSerializer()
  DateTime? get createdAt;
  @override
  String? get routePath;
  @override
  @JsonKey(ignore: true)
  _$$NotificationsModelImplCopyWith<_$NotificationsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
