// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coop_goals_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CoopGoals _$CoopGoalsFromJson(Map<String, dynamic> json) {
  return _CoopGoals.fromJson(json);
}

/// @nodoc
mixin _$CoopGoals {
  String? get uid => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get targetDate => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  List<String>? get metrics => throw _privateConstructorUsedError;
  num? get progress => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CoopGoalsCopyWith<CoopGoals> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoopGoalsCopyWith<$Res> {
  factory $CoopGoalsCopyWith(CoopGoals value, $Res Function(CoopGoals) then) =
      _$CoopGoalsCopyWithImpl<$Res, CoopGoals>;
  @useResult
  $Res call(
      {String? uid,
      String? title,
      String? description,
      @TimestampSerializer() DateTime? targetDate,
      String? category,
      List<String>? metrics,
      num? progress});
}

/// @nodoc
class _$CoopGoalsCopyWithImpl<$Res, $Val extends CoopGoals>
    implements $CoopGoalsCopyWith<$Res> {
  _$CoopGoalsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? targetDate = freezed,
    Object? category = freezed,
    Object? metrics = freezed,
    Object? progress = freezed,
  }) {
    return _then(_value.copyWith(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      targetDate: freezed == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      metrics: freezed == metrics
          ? _value.metrics
          : metrics // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as num?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CoopGoalsImplCopyWith<$Res>
    implements $CoopGoalsCopyWith<$Res> {
  factory _$$CoopGoalsImplCopyWith(
          _$CoopGoalsImpl value, $Res Function(_$CoopGoalsImpl) then) =
      __$$CoopGoalsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? uid,
      String? title,
      String? description,
      @TimestampSerializer() DateTime? targetDate,
      String? category,
      List<String>? metrics,
      num? progress});
}

/// @nodoc
class __$$CoopGoalsImplCopyWithImpl<$Res>
    extends _$CoopGoalsCopyWithImpl<$Res, _$CoopGoalsImpl>
    implements _$$CoopGoalsImplCopyWith<$Res> {
  __$$CoopGoalsImplCopyWithImpl(
      _$CoopGoalsImpl _value, $Res Function(_$CoopGoalsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? targetDate = freezed,
    Object? category = freezed,
    Object? metrics = freezed,
    Object? progress = freezed,
  }) {
    return _then(_$CoopGoalsImpl(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      targetDate: freezed == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      metrics: freezed == metrics
          ? _value._metrics
          : metrics // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as num?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CoopGoalsImpl implements _CoopGoals {
  _$CoopGoalsImpl(
      {this.uid,
      this.title,
      this.description,
      @TimestampSerializer() this.targetDate,
      this.category,
      final List<String>? metrics,
      this.progress})
      : _metrics = metrics;

  factory _$CoopGoalsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoopGoalsImplFromJson(json);

  @override
  final String? uid;
  @override
  final String? title;
  @override
  final String? description;
  @override
  @TimestampSerializer()
  final DateTime? targetDate;
  @override
  final String? category;
  final List<String>? _metrics;
  @override
  List<String>? get metrics {
    final value = _metrics;
    if (value == null) return null;
    if (_metrics is EqualUnmodifiableListView) return _metrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final num? progress;

  @override
  String toString() {
    return 'CoopGoals(uid: $uid, title: $title, description: $description, targetDate: $targetDate, category: $category, metrics: $metrics, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoopGoalsImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._metrics, _metrics) &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      title,
      description,
      targetDate,
      category,
      const DeepCollectionEquality().hash(_metrics),
      progress);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CoopGoalsImplCopyWith<_$CoopGoalsImpl> get copyWith =>
      __$$CoopGoalsImplCopyWithImpl<_$CoopGoalsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoopGoalsImplToJson(
      this,
    );
  }
}

abstract class _CoopGoals implements CoopGoals {
  factory _CoopGoals(
      {final String? uid,
      final String? title,
      final String? description,
      @TimestampSerializer() final DateTime? targetDate,
      final String? category,
      final List<String>? metrics,
      final num? progress}) = _$CoopGoalsImpl;

  factory _CoopGoals.fromJson(Map<String, dynamic> json) =
      _$CoopGoalsImpl.fromJson;

  @override
  String? get uid;
  @override
  String? get title;
  @override
  String? get description;
  @override
  @TimestampSerializer()
  DateTime? get targetDate;
  @override
  String? get category;
  @override
  List<String>? get metrics;
  @override
  num? get progress;
  @override
  @JsonKey(ignore: true)
  _$$CoopGoalsImplCopyWith<_$CoopGoalsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
