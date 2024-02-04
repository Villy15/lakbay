// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PlanModel _$PlanModelFromJson(Map<String, dynamic> json) {
  return _PlanModel.fromJson(json);
}

/// @nodoc
mixin _$PlanModel {
  String? get uid => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get startDate => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get endDate => throw _privateConstructorUsedError;
  List<PlanActivity>? get activities => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlanModelCopyWith<PlanModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanModelCopyWith<$Res> {
  factory $PlanModelCopyWith(PlanModel value, $Res Function(PlanModel) then) =
      _$PlanModelCopyWithImpl<$Res, PlanModel>;
  @useResult
  $Res call(
      {String? uid,
      String location,
      @TimestampSerializer() DateTime? startDate,
      @TimestampSerializer() DateTime? endDate,
      List<PlanActivity>? activities,
      String userId});
}

/// @nodoc
class _$PlanModelCopyWithImpl<$Res, $Val extends PlanModel>
    implements $PlanModelCopyWith<$Res> {
  _$PlanModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? location = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? activities = freezed,
    Object? userId = null,
  }) {
    return _then(_value.copyWith(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      activities: freezed == activities
          ? _value.activities
          : activities // ignore: cast_nullable_to_non_nullable
              as List<PlanActivity>?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlanModelImplCopyWith<$Res>
    implements $PlanModelCopyWith<$Res> {
  factory _$$PlanModelImplCopyWith(
          _$PlanModelImpl value, $Res Function(_$PlanModelImpl) then) =
      __$$PlanModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? uid,
      String location,
      @TimestampSerializer() DateTime? startDate,
      @TimestampSerializer() DateTime? endDate,
      List<PlanActivity>? activities,
      String userId});
}

/// @nodoc
class __$$PlanModelImplCopyWithImpl<$Res>
    extends _$PlanModelCopyWithImpl<$Res, _$PlanModelImpl>
    implements _$$PlanModelImplCopyWith<$Res> {
  __$$PlanModelImplCopyWithImpl(
      _$PlanModelImpl _value, $Res Function(_$PlanModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? location = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? activities = freezed,
    Object? userId = null,
  }) {
    return _then(_$PlanModelImpl(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      activities: freezed == activities
          ? _value._activities
          : activities // ignore: cast_nullable_to_non_nullable
              as List<PlanActivity>?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlanModelImpl extends _PlanModel {
  _$PlanModelImpl(
      {this.uid,
      required this.location,
      @TimestampSerializer() this.startDate,
      @TimestampSerializer() this.endDate,
      final List<PlanActivity>? activities,
      required this.userId})
      : _activities = activities,
        super._();

  factory _$PlanModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlanModelImplFromJson(json);

  @override
  final String? uid;
  @override
  final String location;
  @override
  @TimestampSerializer()
  final DateTime? startDate;
  @override
  @TimestampSerializer()
  final DateTime? endDate;
  final List<PlanActivity>? _activities;
  @override
  List<PlanActivity>? get activities {
    final value = _activities;
    if (value == null) return null;
    if (_activities is EqualUnmodifiableListView) return _activities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String userId;

  @override
  String toString() {
    return 'PlanModel(uid: $uid, location: $location, startDate: $startDate, endDate: $endDate, activities: $activities, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality()
                .equals(other._activities, _activities) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uid, location, startDate,
      endDate, const DeepCollectionEquality().hash(_activities), userId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanModelImplCopyWith<_$PlanModelImpl> get copyWith =>
      __$$PlanModelImplCopyWithImpl<_$PlanModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlanModelImplToJson(
      this,
    );
  }
}

abstract class _PlanModel extends PlanModel {
  factory _PlanModel(
      {final String? uid,
      required final String location,
      @TimestampSerializer() final DateTime? startDate,
      @TimestampSerializer() final DateTime? endDate,
      final List<PlanActivity>? activities,
      required final String userId}) = _$PlanModelImpl;
  _PlanModel._() : super._();

  factory _PlanModel.fromJson(Map<String, dynamic> json) =
      _$PlanModelImpl.fromJson;

  @override
  String? get uid;
  @override
  String get location;
  @override
  @TimestampSerializer()
  DateTime? get startDate;
  @override
  @TimestampSerializer()
  DateTime? get endDate;
  @override
  List<PlanActivity>? get activities;
  @override
  String get userId;
  @override
  @JsonKey(ignore: true)
  _$$PlanModelImplCopyWith<_$PlanModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlanActivity _$PlanActivityFromJson(Map<String, dynamic> json) {
  return _PlanActivity.fromJson(json);
}

/// @nodoc
mixin _$PlanActivity {
  @TimestampSerializer()
  DateTime? get dateTime => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get startTime => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get endTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlanActivityCopyWith<PlanActivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanActivityCopyWith<$Res> {
  factory $PlanActivityCopyWith(
          PlanActivity value, $Res Function(PlanActivity) then) =
      _$PlanActivityCopyWithImpl<$Res, PlanActivity>;
  @useResult
  $Res call(
      {@TimestampSerializer() DateTime? dateTime,
      String? title,
      String? description,
      @TimestampSerializer() DateTime? startTime,
      @TimestampSerializer() DateTime? endTime});
}

/// @nodoc
class _$PlanActivityCopyWithImpl<$Res, $Val extends PlanActivity>
    implements $PlanActivityCopyWith<$Res> {
  _$PlanActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateTime = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
  }) {
    return _then(_value.copyWith(
      dateTime: freezed == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlanActivityImplCopyWith<$Res>
    implements $PlanActivityCopyWith<$Res> {
  factory _$$PlanActivityImplCopyWith(
          _$PlanActivityImpl value, $Res Function(_$PlanActivityImpl) then) =
      __$$PlanActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@TimestampSerializer() DateTime? dateTime,
      String? title,
      String? description,
      @TimestampSerializer() DateTime? startTime,
      @TimestampSerializer() DateTime? endTime});
}

/// @nodoc
class __$$PlanActivityImplCopyWithImpl<$Res>
    extends _$PlanActivityCopyWithImpl<$Res, _$PlanActivityImpl>
    implements _$$PlanActivityImplCopyWith<$Res> {
  __$$PlanActivityImplCopyWithImpl(
      _$PlanActivityImpl _value, $Res Function(_$PlanActivityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateTime = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
  }) {
    return _then(_$PlanActivityImpl(
      dateTime: freezed == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlanActivityImpl implements _PlanActivity {
  _$PlanActivityImpl(
      {@TimestampSerializer() this.dateTime,
      this.title,
      this.description,
      @TimestampSerializer() this.startTime,
      @TimestampSerializer() this.endTime});

  factory _$PlanActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlanActivityImplFromJson(json);

  @override
  @TimestampSerializer()
  final DateTime? dateTime;
  @override
  final String? title;
  @override
  final String? description;
  @override
  @TimestampSerializer()
  final DateTime? startTime;
  @override
  @TimestampSerializer()
  final DateTime? endTime;

  @override
  String toString() {
    return 'PlanActivity(dateTime: $dateTime, title: $title, description: $description, startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanActivityImpl &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, dateTime, title, description, startTime, endTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanActivityImplCopyWith<_$PlanActivityImpl> get copyWith =>
      __$$PlanActivityImplCopyWithImpl<_$PlanActivityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlanActivityImplToJson(
      this,
    );
  }
}

abstract class _PlanActivity implements PlanActivity {
  factory _PlanActivity(
      {@TimestampSerializer() final DateTime? dateTime,
      final String? title,
      final String? description,
      @TimestampSerializer() final DateTime? startTime,
      @TimestampSerializer() final DateTime? endTime}) = _$PlanActivityImpl;

  factory _PlanActivity.fromJson(Map<String, dynamic> json) =
      _$PlanActivityImpl.fromJson;

  @override
  @TimestampSerializer()
  DateTime? get dateTime;
  @override
  String? get title;
  @override
  String? get description;
  @override
  @TimestampSerializer()
  DateTime? get startTime;
  @override
  @TimestampSerializer()
  DateTime? get endTime;
  @override
  @JsonKey(ignore: true)
  _$$PlanActivityImplCopyWith<_$PlanActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
