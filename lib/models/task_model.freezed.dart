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
  List<TaskCheckList>? get checkList => throw _privateConstructorUsedError;
  List<String>? get assignedTo => throw _privateConstructorUsedError;
  bool? get askContribution => throw _privateConstructorUsedError;
  List<String>? get contributors => throw _privateConstructorUsedError;

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
      String? publisherId,
      List<TaskCheckList>? checkList,
      List<String>? assignedTo,
      bool? askContribution,
      List<String>? contributors});
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
    Object? checkList = freezed,
    Object? assignedTo = freezed,
    Object? askContribution = freezed,
    Object? contributors = freezed,
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
      checkList: freezed == checkList
          ? _value.checkList
          : checkList // ignore: cast_nullable_to_non_nullable
              as List<TaskCheckList>?,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      askContribution: freezed == askContribution
          ? _value.askContribution
          : askContribution // ignore: cast_nullable_to_non_nullable
              as bool?,
      contributors: freezed == contributors
          ? _value.contributors
          : contributors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
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
      String? publisherId,
      List<TaskCheckList>? checkList,
      List<String>? assignedTo,
      bool? askContribution,
      List<String>? contributors});
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
    Object? checkList = freezed,
    Object? assignedTo = freezed,
    Object? askContribution = freezed,
    Object? contributors = freezed,
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
      checkList: freezed == checkList
          ? _value._checkList
          : checkList // ignore: cast_nullable_to_non_nullable
              as List<TaskCheckList>?,
      assignedTo: freezed == assignedTo
          ? _value._assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      askContribution: freezed == askContribution
          ? _value.askContribution
          : askContribution // ignore: cast_nullable_to_non_nullable
              as bool?,
      contributors: freezed == contributors
          ? _value._contributors
          : contributors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
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
      this.publisherId,
      final List<TaskCheckList>? checkList,
      final List<String>? assignedTo,
      this.askContribution = false,
      final List<String>? contributors})
      : _checkList = checkList,
        _assignedTo = assignedTo,
        _contributors = contributors;

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
  final List<TaskCheckList>? _checkList;
  @override
  List<TaskCheckList>? get checkList {
    final value = _checkList;
    if (value == null) return null;
    if (_checkList is EqualUnmodifiableListView) return _checkList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _assignedTo;
  @override
  List<String>? get assignedTo {
    final value = _assignedTo;
    if (value == null) return null;
    if (_assignedTo is EqualUnmodifiableListView) return _assignedTo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final bool? askContribution;
  final List<String>? _contributors;
  @override
  List<String>? get contributors {
    final value = _contributors;
    if (value == null) return null;
    if (_contributors is EqualUnmodifiableListView) return _contributors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'TaskModel(uid: $uid, title: $title, description: $description, dueDate: $dueDate, priority: $priority, coopId: $coopId, createdAt: $createdAt, type: $type, eventId: $eventId, publisherId: $publisherId, checkList: $checkList, assignedTo: $assignedTo, askContribution: $askContribution, contributors: $contributors)';
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
                other.publisherId == publisherId) &&
            const DeepCollectionEquality()
                .equals(other._checkList, _checkList) &&
            const DeepCollectionEquality()
                .equals(other._assignedTo, _assignedTo) &&
            (identical(other.askContribution, askContribution) ||
                other.askContribution == askContribution) &&
            const DeepCollectionEquality()
                .equals(other._contributors, _contributors));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      title,
      description,
      dueDate,
      priority,
      coopId,
      createdAt,
      type,
      eventId,
      publisherId,
      const DeepCollectionEquality().hash(_checkList),
      const DeepCollectionEquality().hash(_assignedTo),
      askContribution,
      const DeepCollectionEquality().hash(_contributors));

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
      final String? publisherId,
      final List<TaskCheckList>? checkList,
      final List<String>? assignedTo,
      final bool? askContribution,
      final List<String>? contributors}) = _$TaskModelImpl;

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
  List<TaskCheckList>? get checkList;
  @override
  List<String>? get assignedTo;
  @override
  bool? get askContribution;
  @override
  List<String>? get contributors;
  @override
  @JsonKey(ignore: true)
  _$$TaskModelImplCopyWith<_$TaskModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskCheckList _$TaskCheckListFromJson(Map<String, dynamic> json) {
  return _TaskCheckList.fromJson(json);
}

/// @nodoc
mixin _$TaskCheckList {
  String get title => throw _privateConstructorUsedError;
  bool get isDone => throw _privateConstructorUsedError;
  String? get proofUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TaskCheckListCopyWith<TaskCheckList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCheckListCopyWith<$Res> {
  factory $TaskCheckListCopyWith(
          TaskCheckList value, $Res Function(TaskCheckList) then) =
      _$TaskCheckListCopyWithImpl<$Res, TaskCheckList>;
  @useResult
  $Res call({String title, bool isDone, String? proofUrl});
}

/// @nodoc
class _$TaskCheckListCopyWithImpl<$Res, $Val extends TaskCheckList>
    implements $TaskCheckListCopyWith<$Res> {
  _$TaskCheckListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? isDone = null,
    Object? proofUrl = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isDone: null == isDone
          ? _value.isDone
          : isDone // ignore: cast_nullable_to_non_nullable
              as bool,
      proofUrl: freezed == proofUrl
          ? _value.proofUrl
          : proofUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskCheckListImplCopyWith<$Res>
    implements $TaskCheckListCopyWith<$Res> {
  factory _$$TaskCheckListImplCopyWith(
          _$TaskCheckListImpl value, $Res Function(_$TaskCheckListImpl) then) =
      __$$TaskCheckListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, bool isDone, String? proofUrl});
}

/// @nodoc
class __$$TaskCheckListImplCopyWithImpl<$Res>
    extends _$TaskCheckListCopyWithImpl<$Res, _$TaskCheckListImpl>
    implements _$$TaskCheckListImplCopyWith<$Res> {
  __$$TaskCheckListImplCopyWithImpl(
      _$TaskCheckListImpl _value, $Res Function(_$TaskCheckListImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? isDone = null,
    Object? proofUrl = freezed,
  }) {
    return _then(_$TaskCheckListImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isDone: null == isDone
          ? _value.isDone
          : isDone // ignore: cast_nullable_to_non_nullable
              as bool,
      proofUrl: freezed == proofUrl
          ? _value.proofUrl
          : proofUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskCheckListImpl implements _TaskCheckList {
  _$TaskCheckListImpl(
      {required this.title, required this.isDone, this.proofUrl});

  factory _$TaskCheckListImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskCheckListImplFromJson(json);

  @override
  final String title;
  @override
  final bool isDone;
  @override
  final String? proofUrl;

  @override
  String toString() {
    return 'TaskCheckList(title: $title, isDone: $isDone, proofUrl: $proofUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskCheckListImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.isDone, isDone) || other.isDone == isDone) &&
            (identical(other.proofUrl, proofUrl) ||
                other.proofUrl == proofUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, title, isDone, proofUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskCheckListImplCopyWith<_$TaskCheckListImpl> get copyWith =>
      __$$TaskCheckListImplCopyWithImpl<_$TaskCheckListImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskCheckListImplToJson(
      this,
    );
  }
}

abstract class _TaskCheckList implements TaskCheckList {
  factory _TaskCheckList(
      {required final String title,
      required final bool isDone,
      final String? proofUrl}) = _$TaskCheckListImpl;

  factory _TaskCheckList.fromJson(Map<String, dynamic> json) =
      _$TaskCheckListImpl.fromJson;

  @override
  String get title;
  @override
  bool get isDone;
  @override
  String? get proofUrl;
  @override
  @JsonKey(ignore: true)
  _$$TaskCheckListImplCopyWith<_$TaskCheckListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
