// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'committee_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CommitteeParams _$CommitteeParamsFromJson(Map<String, dynamic> json) {
  return _CommitteeParams.fromJson(json);
}

/// @nodoc
mixin _$CommitteeParams {
  String get coopUid => throw _privateConstructorUsedError;
  String get committeeName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommitteeParamsCopyWith<CommitteeParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommitteeParamsCopyWith<$Res> {
  factory $CommitteeParamsCopyWith(
          CommitteeParams value, $Res Function(CommitteeParams) then) =
      _$CommitteeParamsCopyWithImpl<$Res, CommitteeParams>;
  @useResult
  $Res call({String coopUid, String committeeName});
}

/// @nodoc
class _$CommitteeParamsCopyWithImpl<$Res, $Val extends CommitteeParams>
    implements $CommitteeParamsCopyWith<$Res> {
  _$CommitteeParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coopUid = null,
    Object? committeeName = null,
  }) {
    return _then(_value.copyWith(
      coopUid: null == coopUid
          ? _value.coopUid
          : coopUid // ignore: cast_nullable_to_non_nullable
              as String,
      committeeName: null == committeeName
          ? _value.committeeName
          : committeeName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommitteeParamsImplCopyWith<$Res>
    implements $CommitteeParamsCopyWith<$Res> {
  factory _$$CommitteeParamsImplCopyWith(_$CommitteeParamsImpl value,
          $Res Function(_$CommitteeParamsImpl) then) =
      __$$CommitteeParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String coopUid, String committeeName});
}

/// @nodoc
class __$$CommitteeParamsImplCopyWithImpl<$Res>
    extends _$CommitteeParamsCopyWithImpl<$Res, _$CommitteeParamsImpl>
    implements _$$CommitteeParamsImplCopyWith<$Res> {
  __$$CommitteeParamsImplCopyWithImpl(
      _$CommitteeParamsImpl _value, $Res Function(_$CommitteeParamsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coopUid = null,
    Object? committeeName = null,
  }) {
    return _then(_$CommitteeParamsImpl(
      coopUid: null == coopUid
          ? _value.coopUid
          : coopUid // ignore: cast_nullable_to_non_nullable
              as String,
      committeeName: null == committeeName
          ? _value.committeeName
          : committeeName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommitteeParamsImpl implements _CommitteeParams {
  _$CommitteeParamsImpl({required this.coopUid, required this.committeeName});

  factory _$CommitteeParamsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommitteeParamsImplFromJson(json);

  @override
  final String coopUid;
  @override
  final String committeeName;

  @override
  String toString() {
    return 'CommitteeParams(coopUid: $coopUid, committeeName: $committeeName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommitteeParamsImpl &&
            (identical(other.coopUid, coopUid) || other.coopUid == coopUid) &&
            (identical(other.committeeName, committeeName) ||
                other.committeeName == committeeName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, coopUid, committeeName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommitteeParamsImplCopyWith<_$CommitteeParamsImpl> get copyWith =>
      __$$CommitteeParamsImplCopyWithImpl<_$CommitteeParamsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommitteeParamsImplToJson(
      this,
    );
  }
}

abstract class _CommitteeParams implements CommitteeParams {
  factory _CommitteeParams(
      {required final String coopUid,
      required final String committeeName}) = _$CommitteeParamsImpl;

  factory _CommitteeParams.fromJson(Map<String, dynamic> json) =
      _$CommitteeParamsImpl.fromJson;

  @override
  String get coopUid;
  @override
  String get committeeName;
  @override
  @JsonKey(ignore: true)
  _$$CommitteeParamsImplCopyWith<_$CommitteeParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
