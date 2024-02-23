// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rooms_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RoomsParams _$RoomsParamsFromJson(Map<String, dynamic> json) {
  return _RoomsParams.fromJson(json);
}

/// @nodoc
mixin _$RoomsParams {
  List<String> get unavailableRoomUids => throw _privateConstructorUsedError;
  num get guests => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RoomsParamsCopyWith<RoomsParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomsParamsCopyWith<$Res> {
  factory $RoomsParamsCopyWith(
          RoomsParams value, $Res Function(RoomsParams) then) =
      _$RoomsParamsCopyWithImpl<$Res, RoomsParams>;
  @useResult
  $Res call({List<String> unavailableRoomUids, num guests});
}

/// @nodoc
class _$RoomsParamsCopyWithImpl<$Res, $Val extends RoomsParams>
    implements $RoomsParamsCopyWith<$Res> {
  _$RoomsParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? unavailableRoomUids = null,
    Object? guests = null,
  }) {
    return _then(_value.copyWith(
      unavailableRoomUids: null == unavailableRoomUids
          ? _value.unavailableRoomUids
          : unavailableRoomUids // ignore: cast_nullable_to_non_nullable
              as List<String>,
      guests: null == guests
          ? _value.guests
          : guests // ignore: cast_nullable_to_non_nullable
              as num,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoomsParamsImplCopyWith<$Res>
    implements $RoomsParamsCopyWith<$Res> {
  factory _$$RoomsParamsImplCopyWith(
          _$RoomsParamsImpl value, $Res Function(_$RoomsParamsImpl) then) =
      __$$RoomsParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> unavailableRoomUids, num guests});
}

/// @nodoc
class __$$RoomsParamsImplCopyWithImpl<$Res>
    extends _$RoomsParamsCopyWithImpl<$Res, _$RoomsParamsImpl>
    implements _$$RoomsParamsImplCopyWith<$Res> {
  __$$RoomsParamsImplCopyWithImpl(
      _$RoomsParamsImpl _value, $Res Function(_$RoomsParamsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? unavailableRoomUids = null,
    Object? guests = null,
  }) {
    return _then(_$RoomsParamsImpl(
      unavailableRoomUids: null == unavailableRoomUids
          ? _value._unavailableRoomUids
          : unavailableRoomUids // ignore: cast_nullable_to_non_nullable
              as List<String>,
      guests: null == guests
          ? _value.guests
          : guests // ignore: cast_nullable_to_non_nullable
              as num,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoomsParamsImpl implements _RoomsParams {
  _$RoomsParamsImpl(
      {required final List<String> unavailableRoomUids, required this.guests})
      : _unavailableRoomUids = unavailableRoomUids;

  factory _$RoomsParamsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoomsParamsImplFromJson(json);

  final List<String> _unavailableRoomUids;
  @override
  List<String> get unavailableRoomUids {
    if (_unavailableRoomUids is EqualUnmodifiableListView)
      return _unavailableRoomUids;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unavailableRoomUids);
  }

  @override
  final num guests;

  @override
  String toString() {
    return 'RoomsParams(unavailableRoomUids: $unavailableRoomUids, guests: $guests)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoomsParamsImpl &&
            const DeepCollectionEquality()
                .equals(other._unavailableRoomUids, _unavailableRoomUids) &&
            (identical(other.guests, guests) || other.guests == guests));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_unavailableRoomUids), guests);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoomsParamsImplCopyWith<_$RoomsParamsImpl> get copyWith =>
      __$$RoomsParamsImplCopyWithImpl<_$RoomsParamsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoomsParamsImplToJson(
      this,
    );
  }
}

abstract class _RoomsParams implements RoomsParams {
  factory _RoomsParams(
      {required final List<String> unavailableRoomUids,
      required final num guests}) = _$RoomsParamsImpl;

  factory _RoomsParams.fromJson(Map<String, dynamic> json) =
      _$RoomsParamsImpl.fromJson;

  @override
  List<String> get unavailableRoomUids;
  @override
  num get guests;
  @override
  @JsonKey(ignore: true)
  _$$RoomsParamsImplCopyWith<_$RoomsParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
