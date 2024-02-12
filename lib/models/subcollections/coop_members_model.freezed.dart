// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coop_members_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CooperativeMembers _$CooperativeMembersFromJson(Map<String, dynamic> json) {
  return _CooperativeMembers.fromJson(json);
}

/// @nodoc
mixin _$CooperativeMembers {
  String get name => throw _privateConstructorUsedError;
  String? get uid => throw _privateConstructorUsedError;
  List<String>? get privileges => throw _privateConstructorUsedError;
  CooperativeMembersRole? get role => throw _privateConstructorUsedError;
  List<CooperativeMembersRole>? get committees =>
      throw _privateConstructorUsedError;
  bool? get isManager => throw _privateConstructorUsedError;
  BoardRole? get boardRole => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CooperativeMembersCopyWith<CooperativeMembers> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CooperativeMembersCopyWith<$Res> {
  factory $CooperativeMembersCopyWith(
          CooperativeMembers value, $Res Function(CooperativeMembers) then) =
      _$CooperativeMembersCopyWithImpl<$Res, CooperativeMembers>;
  @useResult
  $Res call(
      {String name,
      String? uid,
      List<String>? privileges,
      CooperativeMembersRole? role,
      List<CooperativeMembersRole>? committees,
      bool? isManager,
      BoardRole? boardRole,
      @TimestampSerializer() DateTime? timestamp});

  $CooperativeMembersRoleCopyWith<$Res>? get role;
  $BoardRoleCopyWith<$Res>? get boardRole;
}

/// @nodoc
class _$CooperativeMembersCopyWithImpl<$Res, $Val extends CooperativeMembers>
    implements $CooperativeMembersCopyWith<$Res> {
  _$CooperativeMembersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? uid = freezed,
    Object? privileges = freezed,
    Object? role = freezed,
    Object? committees = freezed,
    Object? isManager = freezed,
    Object? boardRole = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      privileges: freezed == privileges
          ? _value.privileges
          : privileges // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as CooperativeMembersRole?,
      committees: freezed == committees
          ? _value.committees
          : committees // ignore: cast_nullable_to_non_nullable
              as List<CooperativeMembersRole>?,
      isManager: freezed == isManager
          ? _value.isManager
          : isManager // ignore: cast_nullable_to_non_nullable
              as bool?,
      boardRole: freezed == boardRole
          ? _value.boardRole
          : boardRole // ignore: cast_nullable_to_non_nullable
              as BoardRole?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CooperativeMembersRoleCopyWith<$Res>? get role {
    if (_value.role == null) {
      return null;
    }

    return $CooperativeMembersRoleCopyWith<$Res>(_value.role!, (value) {
      return _then(_value.copyWith(role: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BoardRoleCopyWith<$Res>? get boardRole {
    if (_value.boardRole == null) {
      return null;
    }

    return $BoardRoleCopyWith<$Res>(_value.boardRole!, (value) {
      return _then(_value.copyWith(boardRole: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CooperativeMembersImplCopyWith<$Res>
    implements $CooperativeMembersCopyWith<$Res> {
  factory _$$CooperativeMembersImplCopyWith(_$CooperativeMembersImpl value,
          $Res Function(_$CooperativeMembersImpl) then) =
      __$$CooperativeMembersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String? uid,
      List<String>? privileges,
      CooperativeMembersRole? role,
      List<CooperativeMembersRole>? committees,
      bool? isManager,
      BoardRole? boardRole,
      @TimestampSerializer() DateTime? timestamp});

  @override
  $CooperativeMembersRoleCopyWith<$Res>? get role;
  @override
  $BoardRoleCopyWith<$Res>? get boardRole;
}

/// @nodoc
class __$$CooperativeMembersImplCopyWithImpl<$Res>
    extends _$CooperativeMembersCopyWithImpl<$Res, _$CooperativeMembersImpl>
    implements _$$CooperativeMembersImplCopyWith<$Res> {
  __$$CooperativeMembersImplCopyWithImpl(_$CooperativeMembersImpl _value,
      $Res Function(_$CooperativeMembersImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? uid = freezed,
    Object? privileges = freezed,
    Object? role = freezed,
    Object? committees = freezed,
    Object? isManager = freezed,
    Object? boardRole = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_$CooperativeMembersImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      privileges: freezed == privileges
          ? _value._privileges
          : privileges // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as CooperativeMembersRole?,
      committees: freezed == committees
          ? _value._committees
          : committees // ignore: cast_nullable_to_non_nullable
              as List<CooperativeMembersRole>?,
      isManager: freezed == isManager
          ? _value.isManager
          : isManager // ignore: cast_nullable_to_non_nullable
              as bool?,
      boardRole: freezed == boardRole
          ? _value.boardRole
          : boardRole // ignore: cast_nullable_to_non_nullable
              as BoardRole?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CooperativeMembersImpl extends _CooperativeMembers {
  _$CooperativeMembersImpl(
      {required this.name,
      this.uid,
      final List<String>? privileges,
      this.role,
      final List<CooperativeMembersRole>? committees,
      this.isManager = false,
      this.boardRole,
      @TimestampSerializer() this.timestamp})
      : _privileges = privileges,
        _committees = committees,
        super._();

  factory _$CooperativeMembersImpl.fromJson(Map<String, dynamic> json) =>
      _$$CooperativeMembersImplFromJson(json);

  @override
  final String name;
  @override
  final String? uid;
  final List<String>? _privileges;
  @override
  List<String>? get privileges {
    final value = _privileges;
    if (value == null) return null;
    if (_privileges is EqualUnmodifiableListView) return _privileges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final CooperativeMembersRole? role;
  final List<CooperativeMembersRole>? _committees;
  @override
  List<CooperativeMembersRole>? get committees {
    final value = _committees;
    if (value == null) return null;
    if (_committees is EqualUnmodifiableListView) return _committees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final bool? isManager;
  @override
  final BoardRole? boardRole;
  @override
  @TimestampSerializer()
  final DateTime? timestamp;

  @override
  String toString() {
    return 'CooperativeMembers(name: $name, uid: $uid, privileges: $privileges, role: $role, committees: $committees, isManager: $isManager, boardRole: $boardRole, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CooperativeMembersImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            const DeepCollectionEquality()
                .equals(other._privileges, _privileges) &&
            (identical(other.role, role) || other.role == role) &&
            const DeepCollectionEquality()
                .equals(other._committees, _committees) &&
            (identical(other.isManager, isManager) ||
                other.isManager == isManager) &&
            (identical(other.boardRole, boardRole) ||
                other.boardRole == boardRole) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      uid,
      const DeepCollectionEquality().hash(_privileges),
      role,
      const DeepCollectionEquality().hash(_committees),
      isManager,
      boardRole,
      timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CooperativeMembersImplCopyWith<_$CooperativeMembersImpl> get copyWith =>
      __$$CooperativeMembersImplCopyWithImpl<_$CooperativeMembersImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CooperativeMembersImplToJson(
      this,
    );
  }
}

abstract class _CooperativeMembers extends CooperativeMembers {
  factory _CooperativeMembers(
          {required final String name,
          final String? uid,
          final List<String>? privileges,
          final CooperativeMembersRole? role,
          final List<CooperativeMembersRole>? committees,
          final bool? isManager,
          final BoardRole? boardRole,
          @TimestampSerializer() final DateTime? timestamp}) =
      _$CooperativeMembersImpl;
  _CooperativeMembers._() : super._();

  factory _CooperativeMembers.fromJson(Map<String, dynamic> json) =
      _$CooperativeMembersImpl.fromJson;

  @override
  String get name;
  @override
  String? get uid;
  @override
  List<String>? get privileges;
  @override
  CooperativeMembersRole? get role;
  @override
  List<CooperativeMembersRole>? get committees;
  @override
  bool? get isManager;
  @override
  BoardRole? get boardRole;
  @override
  @TimestampSerializer()
  DateTime? get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$CooperativeMembersImplCopyWith<_$CooperativeMembersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CooperativeMembersRole _$CooperativeMembersRoleFromJson(
    Map<String, dynamic> json) {
  return _CooperativeMembersRole.fromJson(json);
}

/// @nodoc
mixin _$CooperativeMembersRole {
  String? get committeeName => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CooperativeMembersRoleCopyWith<CooperativeMembersRole> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CooperativeMembersRoleCopyWith<$Res> {
  factory $CooperativeMembersRoleCopyWith(CooperativeMembersRole value,
          $Res Function(CooperativeMembersRole) then) =
      _$CooperativeMembersRoleCopyWithImpl<$Res, CooperativeMembersRole>;
  @useResult
  $Res call(
      {String? committeeName,
      String? role,
      @TimestampSerializer() DateTime? timestamp});
}

/// @nodoc
class _$CooperativeMembersRoleCopyWithImpl<$Res,
        $Val extends CooperativeMembersRole>
    implements $CooperativeMembersRoleCopyWith<$Res> {
  _$CooperativeMembersRoleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? committeeName = freezed,
    Object? role = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_value.copyWith(
      committeeName: freezed == committeeName
          ? _value.committeeName
          : committeeName // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CooperativeMembersRoleImplCopyWith<$Res>
    implements $CooperativeMembersRoleCopyWith<$Res> {
  factory _$$CooperativeMembersRoleImplCopyWith(
          _$CooperativeMembersRoleImpl value,
          $Res Function(_$CooperativeMembersRoleImpl) then) =
      __$$CooperativeMembersRoleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? committeeName,
      String? role,
      @TimestampSerializer() DateTime? timestamp});
}

/// @nodoc
class __$$CooperativeMembersRoleImplCopyWithImpl<$Res>
    extends _$CooperativeMembersRoleCopyWithImpl<$Res,
        _$CooperativeMembersRoleImpl>
    implements _$$CooperativeMembersRoleImplCopyWith<$Res> {
  __$$CooperativeMembersRoleImplCopyWithImpl(
      _$CooperativeMembersRoleImpl _value,
      $Res Function(_$CooperativeMembersRoleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? committeeName = freezed,
    Object? role = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_$CooperativeMembersRoleImpl(
      committeeName: freezed == committeeName
          ? _value.committeeName
          : committeeName // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CooperativeMembersRoleImpl implements _CooperativeMembersRole {
  _$CooperativeMembersRoleImpl(
      {this.committeeName, this.role, @TimestampSerializer() this.timestamp});

  factory _$CooperativeMembersRoleImpl.fromJson(Map<String, dynamic> json) =>
      _$$CooperativeMembersRoleImplFromJson(json);

  @override
  final String? committeeName;
  @override
  final String? role;
  @override
  @TimestampSerializer()
  final DateTime? timestamp;

  @override
  String toString() {
    return 'CooperativeMembersRole(committeeName: $committeeName, role: $role, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CooperativeMembersRoleImpl &&
            (identical(other.committeeName, committeeName) ||
                other.committeeName == committeeName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, committeeName, role, timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CooperativeMembersRoleImplCopyWith<_$CooperativeMembersRoleImpl>
      get copyWith => __$$CooperativeMembersRoleImplCopyWithImpl<
          _$CooperativeMembersRoleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CooperativeMembersRoleImplToJson(
      this,
    );
  }
}

abstract class _CooperativeMembersRole implements CooperativeMembersRole {
  factory _CooperativeMembersRole(
          {final String? committeeName,
          final String? role,
          @TimestampSerializer() final DateTime? timestamp}) =
      _$CooperativeMembersRoleImpl;

  factory _CooperativeMembersRole.fromJson(Map<String, dynamic> json) =
      _$CooperativeMembersRoleImpl.fromJson;

  @override
  String? get committeeName;
  @override
  String? get role;
  @override
  @TimestampSerializer()
  DateTime? get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$CooperativeMembersRoleImplCopyWith<_$CooperativeMembersRoleImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BoardRole _$BoardRoleFromJson(Map<String, dynamic> json) {
  return _BoardRole.fromJson(json);
}

/// @nodoc
mixin _$BoardRole {
  String? get role => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BoardRoleCopyWith<BoardRole> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardRoleCopyWith<$Res> {
  factory $BoardRoleCopyWith(BoardRole value, $Res Function(BoardRole) then) =
      _$BoardRoleCopyWithImpl<$Res, BoardRole>;
  @useResult
  $Res call({String? role, @TimestampSerializer() DateTime? timestamp});
}

/// @nodoc
class _$BoardRoleCopyWithImpl<$Res, $Val extends BoardRole>
    implements $BoardRoleCopyWith<$Res> {
  _$BoardRoleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? role = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_value.copyWith(
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BoardRoleImplCopyWith<$Res>
    implements $BoardRoleCopyWith<$Res> {
  factory _$$BoardRoleImplCopyWith(
          _$BoardRoleImpl value, $Res Function(_$BoardRoleImpl) then) =
      __$$BoardRoleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? role, @TimestampSerializer() DateTime? timestamp});
}

/// @nodoc
class __$$BoardRoleImplCopyWithImpl<$Res>
    extends _$BoardRoleCopyWithImpl<$Res, _$BoardRoleImpl>
    implements _$$BoardRoleImplCopyWith<$Res> {
  __$$BoardRoleImplCopyWithImpl(
      _$BoardRoleImpl _value, $Res Function(_$BoardRoleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? role = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_$BoardRoleImpl(
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BoardRoleImpl implements _BoardRole {
  _$BoardRoleImpl({this.role, @TimestampSerializer() this.timestamp});

  factory _$BoardRoleImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoardRoleImplFromJson(json);

  @override
  final String? role;
  @override
  @TimestampSerializer()
  final DateTime? timestamp;

  @override
  String toString() {
    return 'BoardRole(role: $role, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoardRoleImpl &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, role, timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BoardRoleImplCopyWith<_$BoardRoleImpl> get copyWith =>
      __$$BoardRoleImplCopyWithImpl<_$BoardRoleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoardRoleImplToJson(
      this,
    );
  }
}

abstract class _BoardRole implements BoardRole {
  factory _BoardRole(
      {final String? role,
      @TimestampSerializer() final DateTime? timestamp}) = _$BoardRoleImpl;

  factory _BoardRole.fromJson(Map<String, dynamic> json) =
      _$BoardRoleImpl.fromJson;

  @override
  String? get role;
  @override
  @TimestampSerializer()
  DateTime? get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$BoardRoleImplCopyWith<_$BoardRoleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
