// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coop_privileges_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CooperativePrivileges _$CooperativePrivilegesFromJson(
    Map<String, dynamic> json) {
  return _CooperativePrivileges.fromJson(json);
}

/// @nodoc
mixin _$CooperativePrivileges {
  String get committeeName => throw _privateConstructorUsedError;
  List<ManagerPrivileges> get managerPrivileges =>
      throw _privateConstructorUsedError;
  List<MemberPrivileges> get memberPrivileges =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CooperativePrivilegesCopyWith<CooperativePrivileges> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CooperativePrivilegesCopyWith<$Res> {
  factory $CooperativePrivilegesCopyWith(CooperativePrivileges value,
          $Res Function(CooperativePrivileges) then) =
      _$CooperativePrivilegesCopyWithImpl<$Res, CooperativePrivileges>;
  @useResult
  $Res call(
      {String committeeName,
      List<ManagerPrivileges> managerPrivileges,
      List<MemberPrivileges> memberPrivileges});
}

/// @nodoc
class _$CooperativePrivilegesCopyWithImpl<$Res,
        $Val extends CooperativePrivileges>
    implements $CooperativePrivilegesCopyWith<$Res> {
  _$CooperativePrivilegesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? committeeName = null,
    Object? managerPrivileges = null,
    Object? memberPrivileges = null,
  }) {
    return _then(_value.copyWith(
      committeeName: null == committeeName
          ? _value.committeeName
          : committeeName // ignore: cast_nullable_to_non_nullable
              as String,
      managerPrivileges: null == managerPrivileges
          ? _value.managerPrivileges
          : managerPrivileges // ignore: cast_nullable_to_non_nullable
              as List<ManagerPrivileges>,
      memberPrivileges: null == memberPrivileges
          ? _value.memberPrivileges
          : memberPrivileges // ignore: cast_nullable_to_non_nullable
              as List<MemberPrivileges>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CooperativePrivilegesImplCopyWith<$Res>
    implements $CooperativePrivilegesCopyWith<$Res> {
  factory _$$CooperativePrivilegesImplCopyWith(
          _$CooperativePrivilegesImpl value,
          $Res Function(_$CooperativePrivilegesImpl) then) =
      __$$CooperativePrivilegesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String committeeName,
      List<ManagerPrivileges> managerPrivileges,
      List<MemberPrivileges> memberPrivileges});
}

/// @nodoc
class __$$CooperativePrivilegesImplCopyWithImpl<$Res>
    extends _$CooperativePrivilegesCopyWithImpl<$Res,
        _$CooperativePrivilegesImpl>
    implements _$$CooperativePrivilegesImplCopyWith<$Res> {
  __$$CooperativePrivilegesImplCopyWithImpl(_$CooperativePrivilegesImpl _value,
      $Res Function(_$CooperativePrivilegesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? committeeName = null,
    Object? managerPrivileges = null,
    Object? memberPrivileges = null,
  }) {
    return _then(_$CooperativePrivilegesImpl(
      committeeName: null == committeeName
          ? _value.committeeName
          : committeeName // ignore: cast_nullable_to_non_nullable
              as String,
      managerPrivileges: null == managerPrivileges
          ? _value._managerPrivileges
          : managerPrivileges // ignore: cast_nullable_to_non_nullable
              as List<ManagerPrivileges>,
      memberPrivileges: null == memberPrivileges
          ? _value._memberPrivileges
          : memberPrivileges // ignore: cast_nullable_to_non_nullable
              as List<MemberPrivileges>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CooperativePrivilegesImpl extends _CooperativePrivileges {
  _$CooperativePrivilegesImpl(
      {required this.committeeName,
      required final List<ManagerPrivileges> managerPrivileges,
      required final List<MemberPrivileges> memberPrivileges})
      : _managerPrivileges = managerPrivileges,
        _memberPrivileges = memberPrivileges,
        super._();

  factory _$CooperativePrivilegesImpl.fromJson(Map<String, dynamic> json) =>
      _$$CooperativePrivilegesImplFromJson(json);

  @override
  final String committeeName;
  final List<ManagerPrivileges> _managerPrivileges;
  @override
  List<ManagerPrivileges> get managerPrivileges {
    if (_managerPrivileges is EqualUnmodifiableListView)
      return _managerPrivileges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_managerPrivileges);
  }

  final List<MemberPrivileges> _memberPrivileges;
  @override
  List<MemberPrivileges> get memberPrivileges {
    if (_memberPrivileges is EqualUnmodifiableListView)
      return _memberPrivileges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_memberPrivileges);
  }

  @override
  String toString() {
    return 'CooperativePrivileges(committeeName: $committeeName, managerPrivileges: $managerPrivileges, memberPrivileges: $memberPrivileges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CooperativePrivilegesImpl &&
            (identical(other.committeeName, committeeName) ||
                other.committeeName == committeeName) &&
            const DeepCollectionEquality()
                .equals(other._managerPrivileges, _managerPrivileges) &&
            const DeepCollectionEquality()
                .equals(other._memberPrivileges, _memberPrivileges));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      committeeName,
      const DeepCollectionEquality().hash(_managerPrivileges),
      const DeepCollectionEquality().hash(_memberPrivileges));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CooperativePrivilegesImplCopyWith<_$CooperativePrivilegesImpl>
      get copyWith => __$$CooperativePrivilegesImplCopyWithImpl<
          _$CooperativePrivilegesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CooperativePrivilegesImplToJson(
      this,
    );
  }
}

abstract class _CooperativePrivileges extends CooperativePrivileges {
  factory _CooperativePrivileges(
          {required final String committeeName,
          required final List<ManagerPrivileges> managerPrivileges,
          required final List<MemberPrivileges> memberPrivileges}) =
      _$CooperativePrivilegesImpl;
  _CooperativePrivileges._() : super._();

  factory _CooperativePrivileges.fromJson(Map<String, dynamic> json) =
      _$CooperativePrivilegesImpl.fromJson;

  @override
  String get committeeName;
  @override
  List<ManagerPrivileges> get managerPrivileges;
  @override
  List<MemberPrivileges> get memberPrivileges;
  @override
  @JsonKey(ignore: true)
  _$$CooperativePrivilegesImplCopyWith<_$CooperativePrivilegesImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ManagerPrivileges _$ManagerPrivilegesFromJson(Map<String, dynamic> json) {
  return _ManagerPrivileges.fromJson(json);
}

/// @nodoc
mixin _$ManagerPrivileges {
  String get privilegeName => throw _privateConstructorUsedError;
  bool get isAllowed => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ManagerPrivilegesCopyWith<ManagerPrivileges> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagerPrivilegesCopyWith<$Res> {
  factory $ManagerPrivilegesCopyWith(
          ManagerPrivileges value, $Res Function(ManagerPrivileges) then) =
      _$ManagerPrivilegesCopyWithImpl<$Res, ManagerPrivileges>;
  @useResult
  $Res call({String privilegeName, bool isAllowed});
}

/// @nodoc
class _$ManagerPrivilegesCopyWithImpl<$Res, $Val extends ManagerPrivileges>
    implements $ManagerPrivilegesCopyWith<$Res> {
  _$ManagerPrivilegesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? privilegeName = null,
    Object? isAllowed = null,
  }) {
    return _then(_value.copyWith(
      privilegeName: null == privilegeName
          ? _value.privilegeName
          : privilegeName // ignore: cast_nullable_to_non_nullable
              as String,
      isAllowed: null == isAllowed
          ? _value.isAllowed
          : isAllowed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManagerPrivilegesImplCopyWith<$Res>
    implements $ManagerPrivilegesCopyWith<$Res> {
  factory _$$ManagerPrivilegesImplCopyWith(_$ManagerPrivilegesImpl value,
          $Res Function(_$ManagerPrivilegesImpl) then) =
      __$$ManagerPrivilegesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String privilegeName, bool isAllowed});
}

/// @nodoc
class __$$ManagerPrivilegesImplCopyWithImpl<$Res>
    extends _$ManagerPrivilegesCopyWithImpl<$Res, _$ManagerPrivilegesImpl>
    implements _$$ManagerPrivilegesImplCopyWith<$Res> {
  __$$ManagerPrivilegesImplCopyWithImpl(_$ManagerPrivilegesImpl _value,
      $Res Function(_$ManagerPrivilegesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? privilegeName = null,
    Object? isAllowed = null,
  }) {
    return _then(_$ManagerPrivilegesImpl(
      privilegeName: null == privilegeName
          ? _value.privilegeName
          : privilegeName // ignore: cast_nullable_to_non_nullable
              as String,
      isAllowed: null == isAllowed
          ? _value.isAllowed
          : isAllowed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ManagerPrivilegesImpl implements _ManagerPrivileges {
  _$ManagerPrivilegesImpl(
      {required this.privilegeName, this.isAllowed = false});

  factory _$ManagerPrivilegesImpl.fromJson(Map<String, dynamic> json) =>
      _$$ManagerPrivilegesImplFromJson(json);

  @override
  final String privilegeName;
  @override
  @JsonKey()
  final bool isAllowed;

  @override
  String toString() {
    return 'ManagerPrivileges(privilegeName: $privilegeName, isAllowed: $isAllowed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagerPrivilegesImpl &&
            (identical(other.privilegeName, privilegeName) ||
                other.privilegeName == privilegeName) &&
            (identical(other.isAllowed, isAllowed) ||
                other.isAllowed == isAllowed));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, privilegeName, isAllowed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagerPrivilegesImplCopyWith<_$ManagerPrivilegesImpl> get copyWith =>
      __$$ManagerPrivilegesImplCopyWithImpl<_$ManagerPrivilegesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ManagerPrivilegesImplToJson(
      this,
    );
  }
}

abstract class _ManagerPrivileges implements ManagerPrivileges {
  factory _ManagerPrivileges(
      {required final String privilegeName,
      final bool isAllowed}) = _$ManagerPrivilegesImpl;

  factory _ManagerPrivileges.fromJson(Map<String, dynamic> json) =
      _$ManagerPrivilegesImpl.fromJson;

  @override
  String get privilegeName;
  @override
  bool get isAllowed;
  @override
  @JsonKey(ignore: true)
  _$$ManagerPrivilegesImplCopyWith<_$ManagerPrivilegesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MemberPrivileges _$MemberPrivilegesFromJson(Map<String, dynamic> json) {
  return _MemberPrivileges.fromJson(json);
}

/// @nodoc
mixin _$MemberPrivileges {
  String get privilegeName => throw _privateConstructorUsedError;
  bool get isAllowed => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MemberPrivilegesCopyWith<MemberPrivileges> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberPrivilegesCopyWith<$Res> {
  factory $MemberPrivilegesCopyWith(
          MemberPrivileges value, $Res Function(MemberPrivileges) then) =
      _$MemberPrivilegesCopyWithImpl<$Res, MemberPrivileges>;
  @useResult
  $Res call({String privilegeName, bool isAllowed});
}

/// @nodoc
class _$MemberPrivilegesCopyWithImpl<$Res, $Val extends MemberPrivileges>
    implements $MemberPrivilegesCopyWith<$Res> {
  _$MemberPrivilegesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? privilegeName = null,
    Object? isAllowed = null,
  }) {
    return _then(_value.copyWith(
      privilegeName: null == privilegeName
          ? _value.privilegeName
          : privilegeName // ignore: cast_nullable_to_non_nullable
              as String,
      isAllowed: null == isAllowed
          ? _value.isAllowed
          : isAllowed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MemberPrivilegesImplCopyWith<$Res>
    implements $MemberPrivilegesCopyWith<$Res> {
  factory _$$MemberPrivilegesImplCopyWith(_$MemberPrivilegesImpl value,
          $Res Function(_$MemberPrivilegesImpl) then) =
      __$$MemberPrivilegesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String privilegeName, bool isAllowed});
}

/// @nodoc
class __$$MemberPrivilegesImplCopyWithImpl<$Res>
    extends _$MemberPrivilegesCopyWithImpl<$Res, _$MemberPrivilegesImpl>
    implements _$$MemberPrivilegesImplCopyWith<$Res> {
  __$$MemberPrivilegesImplCopyWithImpl(_$MemberPrivilegesImpl _value,
      $Res Function(_$MemberPrivilegesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? privilegeName = null,
    Object? isAllowed = null,
  }) {
    return _then(_$MemberPrivilegesImpl(
      privilegeName: null == privilegeName
          ? _value.privilegeName
          : privilegeName // ignore: cast_nullable_to_non_nullable
              as String,
      isAllowed: null == isAllowed
          ? _value.isAllowed
          : isAllowed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberPrivilegesImpl implements _MemberPrivileges {
  _$MemberPrivilegesImpl({required this.privilegeName, this.isAllowed = false});

  factory _$MemberPrivilegesImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberPrivilegesImplFromJson(json);

  @override
  final String privilegeName;
  @override
  @JsonKey()
  final bool isAllowed;

  @override
  String toString() {
    return 'MemberPrivileges(privilegeName: $privilegeName, isAllowed: $isAllowed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberPrivilegesImpl &&
            (identical(other.privilegeName, privilegeName) ||
                other.privilegeName == privilegeName) &&
            (identical(other.isAllowed, isAllowed) ||
                other.isAllowed == isAllowed));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, privilegeName, isAllowed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberPrivilegesImplCopyWith<_$MemberPrivilegesImpl> get copyWith =>
      __$$MemberPrivilegesImplCopyWithImpl<_$MemberPrivilegesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberPrivilegesImplToJson(
      this,
    );
  }
}

abstract class _MemberPrivileges implements MemberPrivileges {
  factory _MemberPrivileges(
      {required final String privilegeName,
      final bool isAllowed}) = _$MemberPrivilegesImpl;

  factory _MemberPrivileges.fromJson(Map<String, dynamic> json) =
      _$MemberPrivilegesImpl.fromJson;

  @override
  String get privilegeName;
  @override
  bool get isAllowed;
  @override
  @JsonKey(ignore: true)
  _$$MemberPrivilegesImplCopyWith<_$MemberPrivilegesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
