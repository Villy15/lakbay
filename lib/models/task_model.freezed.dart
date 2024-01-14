// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) {
  return _TaskModel.fromJson(json);
}

/// @nodoc
mixin _$TaskModel {
  String? get uid => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get dueDate => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  String get coopId => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get eventId => throw _privateConstructorUsedError;
  String? get publisherId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TaskModelCopyWith<TaskModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskModelCopyWith<$Res> {
  factory $TaskModelCopyWith(TaskModel value, $Res Function(TaskModel) then) =
      _$TaskModelCopyWithImpl<$Res, TaskModel>;
  @useResult
  $Res call(
      {String? uid,
      String title,
      String? description,
      @TimestampSerializer() DateTime? dueDate,
      String priority,
      String coopId,
      @TimestampSerializer() DateTime? createdAt,
      String type,
      String? eventId,
      String? publisherId});
}

/// @nodoc
class _$TaskModelCopyWithImpl<$Res, $Val extends TaskModel>
    implements $TaskModelCopyWith<$Res> {
  _$TaskModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? dueDate = freezed,
    Object? priority = null,
    Object? coopId = null,
    Object? createdAt = freezed,
    Object? type = null,
    Object? eventId = freezed,
    Object? publisherId = freezed,
  }) {
    return _then(_value.copyWith(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      coopId: null == coopId
          ? _value.coopId
          : coopId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
      publisherId: freezed == publisherId
          ? _value.publisherId
          : publisherId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskModelImplCopyWith<$Res>
    implements $TaskModelCopyWith<$Res> {
  factory _$$TaskModelImplCopyWith(
          _$TaskModelImpl value, $Res Function(_$TaskModelImpl) then) =
      __$$TaskModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? uid,
      String title,
      String? description,
      @TimestampSerializer() DateTime? dueDate,
      String priority,
      String coopId,
      @TimestampSerializer() DateTime? createdAt,
      String type,
      String? eventId,
      String? publisherId});
}

/// @nodoc
class __$$TaskModelImplCopyWithImpl<$Res>
    extends _$TaskModelCopyWithImpl<$Res, _$TaskModelImpl>
    implements _$$TaskModelImplCopyWith<$Res> {
  __$$TaskModelImplCopyWithImpl(
      _$TaskModelImpl _value, $Res Function(_$TaskModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? dueDate = freezed,
    Object? priority = null,
    Object? coopId = null,
    Object? createdAt = freezed,
    Object? type = null,
    Object? eventId = freezed,
    Object? publisherId = freezed,
  }) {
    return _then(_$TaskModelImpl(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      coopId: null == coopId
          ? _value.coopId
          : coopId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
      publisherId: freezed == publisherId
          ? _value.publisherId
          : publisherId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskModelImpl implements _TaskModel {
  _$TaskModelImpl(
      {this.uid,
      required this.title,
      this.description,
      @TimestampSerializer() this.dueDate,
      required this.priority,
      required this.coopId,
      @TimestampSerializer() this.createdAt,
      required this.type,
      this.eventId,
      this.publisherId});

  factory _$TaskModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskModelImplFromJson(json);

  @override
  final String? uid;
  @override
  final String title;
  @override
  final String? description;
  @override
  @TimestampSerializer()
  final DateTime? dueDate;
  @override
  final String priority;
  @override
  final String coopId;
  @override
  @TimestampSerializer()
  final DateTime? createdAt;
  @override
  final String type;
  @override
  final String? eventId;
  @override
  final String? publisherId;

  @override
  String toString() {
    return 'TaskModel(uid: $uid, title: $title, description: $description, dueDate: $dueDate, priority: $priority, coopId: $coopId, createdAt: $createdAt, type: $type, eventId: $eventId, publisherId: $publisherId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.coopId, coopId) || other.coopId == coopId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.publisherId, publisherId) ||
                other.publisherId == publisherId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uid, title, description, dueDate,
      priority, coopId, createdAt, type, eventId, publisherId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskModelImplCopyWith<_$TaskModelImpl> get copyWith =>
      __$$TaskModelImplCopyWithImpl<_$TaskModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskModelImplToJson(
      this,
    );
  }
}

abstract class _TaskModel implements TaskModel {
  factory _TaskModel(
      {final String? uid,
      required final String title,
      final String? description,
      @TimestampSerializer() final DateTime? dueDate,
      required final String priority,
      required final String coopId,
      @TimestampSerializer() final DateTime? createdAt,
      required final String type,
      final String? eventId,
      final String? publisherId}) = _$TaskModelImpl;

  factory _TaskModel.fromJson(Map<String, dynamic> json) =
      _$TaskModelImpl.fromJson;

  @override
  String? get uid;
  @override
  String get title;
  @override
  String? get description;
  @override
  @TimestampSerializer()
  DateTime? get dueDate;
  @override
  String get priority;
  @override
  String get coopId;
  @override
  @TimestampSerializer()
  DateTime? get createdAt;
  @override
  String get type;
  @override
  String? get eventId;
  @override
  String? get publisherId;
  @override
  @JsonKey(ignore: true)
  _$$TaskModelImplCopyWith<_$TaskModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
