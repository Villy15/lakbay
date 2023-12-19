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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CooperativeMembers _$CooperativeMembersFromJson(Map<String, dynamic> json) {
  return _CooperativeMembers.fromJson(json);
}

/// @nodoc
mixin _$CooperativeMembers {
  String? get uid => throw _privateConstructorUsedError;
  List<String>? get privileges => throw _privateConstructorUsedError;
  CooperativeMembersRole? get role => throw _privateConstructorUsedError;

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
      {String? uid, List<String>? privileges, CooperativeMembersRole? role});

  $CooperativeMembersRoleCopyWith<$Res>? get role;
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
    Object? uid = freezed,
    Object? privileges = freezed,
    Object? role = freezed,
  }) {
    return _then(_value.copyWith(
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
      {String? uid, List<String>? privileges, CooperativeMembersRole? role});

  @override
  $CooperativeMembersRoleCopyWith<$Res>? get role;
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
    Object? uid = freezed,
    Object? privileges = freezed,
    Object? role = freezed,
  }) {
    return _then(_$CooperativeMembersImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CooperativeMembersImpl implements _CooperativeMembers {
  _$CooperativeMembersImpl(
      {this.uid, final List<String>? privileges, this.role})
      : _privileges = privileges;

  factory _$CooperativeMembersImpl.fromJson(Map<String, dynamic> json) =>
      _$$CooperativeMembersImplFromJson(json);

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

  @override
  String toString() {
    return 'CooperativeMembers(uid: $uid, privileges: $privileges, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CooperativeMembersImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            const DeepCollectionEquality()
                .equals(other._privileges, _privileges) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, uid, const DeepCollectionEquality().hash(_privileges), role);

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

abstract class _CooperativeMembers implements CooperativeMembers {
  factory _CooperativeMembers(
      {final String? uid,
      final List<String>? privileges,
      final CooperativeMembersRole? role}) = _$CooperativeMembersImpl;

  factory _CooperativeMembers.fromJson(Map<String, dynamic> json) =
      _$CooperativeMembersImpl.fromJson;

  @override
  String? get uid;
  @override
  List<String>? get privileges;
  @override
  CooperativeMembersRole? get role;
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
  $Res call({String? committeeName, String? role});
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
  $Res call({String? committeeName, String? role});
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CooperativeMembersRoleImpl implements _CooperativeMembersRole {
  _$CooperativeMembersRoleImpl({this.committeeName, this.role});

  factory _$CooperativeMembersRoleImpl.fromJson(Map<String, dynamic> json) =>
      _$$CooperativeMembersRoleImplFromJson(json);

  @override
  final String? committeeName;
  @override
  final String? role;

  @override
  String toString() {
    return 'CooperativeMembersRole(committeeName: $committeeName, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CooperativeMembersRoleImpl &&
            (identical(other.committeeName, committeeName) ||
                other.committeeName == committeeName) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, committeeName, role);

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
      final String? role}) = _$CooperativeMembersRoleImpl;

  factory _CooperativeMembersRole.fromJson(Map<String, dynamic> json) =
      _$CooperativeMembersRoleImpl.fromJson;

  @override
  String? get committeeName;
  @override
  String? get role;
  @override
  @JsonKey(ignore: true)
  _$$CooperativeMembersRoleImplCopyWith<_$CooperativeMembersRoleImpl>
      get copyWith => throw _privateConstructorUsedError;
}
