// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coop_member_roles_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CoopMemberRoles _$CoopMemberRolesFromJson(Map<String, dynamic> json) {
  return _CoopMemberRoles.fromJson(json);
}

/// @nodoc
mixin _$CoopMemberRoles {
  String? get uid => throw _privateConstructorUsedError;
  String get coopId => throw _privateConstructorUsedError;
  String? get memberId => throw _privateConstructorUsedError;
  List<String>? get rolesSelected => throw _privateConstructorUsedError;
  List<String>? get fileUploads => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CoopMemberRolesCopyWith<CoopMemberRoles> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoopMemberRolesCopyWith<$Res> {
  factory $CoopMemberRolesCopyWith(
          CoopMemberRoles value, $Res Function(CoopMemberRoles) then) =
      _$CoopMemberRolesCopyWithImpl<$Res, CoopMemberRoles>;
  @useResult
  $Res call(
      {String? uid,
      String coopId,
      String? memberId,
      List<String>? rolesSelected,
      List<String>? fileUploads});
}

/// @nodoc
class _$CoopMemberRolesCopyWithImpl<$Res, $Val extends CoopMemberRoles>
    implements $CoopMemberRolesCopyWith<$Res> {
  _$CoopMemberRolesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? coopId = null,
    Object? memberId = freezed,
    Object? rolesSelected = freezed,
    Object? fileUploads = freezed,
  }) {
    return _then(_value.copyWith(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      coopId: null == coopId
          ? _value.coopId
          : coopId // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: freezed == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String?,
      rolesSelected: freezed == rolesSelected
          ? _value.rolesSelected
          : rolesSelected // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      fileUploads: freezed == fileUploads
          ? _value.fileUploads
          : fileUploads // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CoopMemberRolesImplCopyWith<$Res>
    implements $CoopMemberRolesCopyWith<$Res> {
  factory _$$CoopMemberRolesImplCopyWith(_$CoopMemberRolesImpl value,
          $Res Function(_$CoopMemberRolesImpl) then) =
      __$$CoopMemberRolesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? uid,
      String coopId,
      String? memberId,
      List<String>? rolesSelected,
      List<String>? fileUploads});
}

/// @nodoc
class __$$CoopMemberRolesImplCopyWithImpl<$Res>
    extends _$CoopMemberRolesCopyWithImpl<$Res, _$CoopMemberRolesImpl>
    implements _$$CoopMemberRolesImplCopyWith<$Res> {
  __$$CoopMemberRolesImplCopyWithImpl(
      _$CoopMemberRolesImpl _value, $Res Function(_$CoopMemberRolesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? coopId = null,
    Object? memberId = freezed,
    Object? rolesSelected = freezed,
    Object? fileUploads = freezed,
  }) {
    return _then(_$CoopMemberRolesImpl(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      coopId: null == coopId
          ? _value.coopId
          : coopId // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: freezed == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String?,
      rolesSelected: freezed == rolesSelected
          ? _value._rolesSelected
          : rolesSelected // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      fileUploads: freezed == fileUploads
          ? _value._fileUploads
          : fileUploads // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CoopMemberRolesImpl implements _CoopMemberRoles {
  _$CoopMemberRolesImpl(
      {this.uid,
      required this.coopId,
      this.memberId,
      final List<String>? rolesSelected,
      final List<String>? fileUploads})
      : _rolesSelected = rolesSelected,
        _fileUploads = fileUploads;

  factory _$CoopMemberRolesImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoopMemberRolesImplFromJson(json);

  @override
  final String? uid;
  @override
  final String coopId;
  @override
  final String? memberId;
  final List<String>? _rolesSelected;
  @override
  List<String>? get rolesSelected {
    final value = _rolesSelected;
    if (value == null) return null;
    if (_rolesSelected is EqualUnmodifiableListView) return _rolesSelected;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _fileUploads;
  @override
  List<String>? get fileUploads {
    final value = _fileUploads;
    if (value == null) return null;
    if (_fileUploads is EqualUnmodifiableListView) return _fileUploads;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CoopMemberRoles(uid: $uid, coopId: $coopId, memberId: $memberId, rolesSelected: $rolesSelected, fileUploads: $fileUploads)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoopMemberRolesImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.coopId, coopId) || other.coopId == coopId) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            const DeepCollectionEquality()
                .equals(other._rolesSelected, _rolesSelected) &&
            const DeepCollectionEquality()
                .equals(other._fileUploads, _fileUploads));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      coopId,
      memberId,
      const DeepCollectionEquality().hash(_rolesSelected),
      const DeepCollectionEquality().hash(_fileUploads));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CoopMemberRolesImplCopyWith<_$CoopMemberRolesImpl> get copyWith =>
      __$$CoopMemberRolesImplCopyWithImpl<_$CoopMemberRolesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoopMemberRolesImplToJson(
      this,
    );
  }
}

abstract class _CoopMemberRoles implements CoopMemberRoles {
  factory _CoopMemberRoles(
      {final String? uid,
      required final String coopId,
      final String? memberId,
      final List<String>? rolesSelected,
      final List<String>? fileUploads}) = _$CoopMemberRolesImpl;

  factory _CoopMemberRoles.fromJson(Map<String, dynamic> json) =
      _$CoopMemberRolesImpl.fromJson;

  @override
  String? get uid;
  @override
  String get coopId;
  @override
  String? get memberId;
  @override
  List<String>? get rolesSelected;
  @override
  List<String>? get fileUploads;
  @override
  @JsonKey(ignore: true)
  _$$CoopMemberRolesImplCopyWith<_$CoopMemberRolesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
