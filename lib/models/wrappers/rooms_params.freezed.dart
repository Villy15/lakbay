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

GetRoomsParams _$GetRoomsParamsFromJson(Map<String, dynamic> json) {
  return _GetRoomsParams.fromJson(json);
}

/// @nodoc
mixin _$GetRoomsParams {
  List<String>? get unavailableRoomUids => throw _privateConstructorUsedError;
  num? get guests => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetRoomsParamsCopyWith<GetRoomsParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetRoomsParamsCopyWith<$Res> {
  factory $GetRoomsParamsCopyWith(
          GetRoomsParams value, $Res Function(GetRoomsParams) then) =
      _$GetRoomsParamsCopyWithImpl<$Res, GetRoomsParams>;
  @useResult
  $Res call({List<String>? unavailableRoomUids, num? guests});
}

/// @nodoc
class _$GetRoomsParamsCopyWithImpl<$Res, $Val extends GetRoomsParams>
    implements $GetRoomsParamsCopyWith<$Res> {
  _$GetRoomsParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? unavailableRoomUids = freezed,
    Object? guests = freezed,
  }) {
    return _then(_value.copyWith(
      unavailableRoomUids: freezed == unavailableRoomUids
          ? _value.unavailableRoomUids
          : unavailableRoomUids // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      guests: freezed == guests
          ? _value.guests
          : guests // ignore: cast_nullable_to_non_nullable
              as num?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetRoomsParamsImplCopyWith<$Res>
    implements $GetRoomsParamsCopyWith<$Res> {
  factory _$$GetRoomsParamsImplCopyWith(_$GetRoomsParamsImpl value,
          $Res Function(_$GetRoomsParamsImpl) then) =
      __$$GetRoomsParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String>? unavailableRoomUids, num? guests});
}

/// @nodoc
class __$$GetRoomsParamsImplCopyWithImpl<$Res>
    extends _$GetRoomsParamsCopyWithImpl<$Res, _$GetRoomsParamsImpl>
    implements _$$GetRoomsParamsImplCopyWith<$Res> {
  __$$GetRoomsParamsImplCopyWithImpl(
      _$GetRoomsParamsImpl _value, $Res Function(_$GetRoomsParamsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? unavailableRoomUids = freezed,
    Object? guests = freezed,
  }) {
    return _then(_$GetRoomsParamsImpl(
      unavailableRoomUids: freezed == unavailableRoomUids
          ? _value._unavailableRoomUids
          : unavailableRoomUids // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      guests: freezed == guests
          ? _value.guests
          : guests // ignore: cast_nullable_to_non_nullable
              as num?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetRoomsParamsImpl implements _GetRoomsParams {
  _$GetRoomsParamsImpl({final List<String>? unavailableRoomUids, this.guests})
      : _unavailableRoomUids = unavailableRoomUids;

  factory _$GetRoomsParamsImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetRoomsParamsImplFromJson(json);

  final List<String>? _unavailableRoomUids;
  @override
  List<String>? get unavailableRoomUids {
    final value = _unavailableRoomUids;
    if (value == null) return null;
    if (_unavailableRoomUids is EqualUnmodifiableListView)
      return _unavailableRoomUids;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final num? guests;

  @override
  String toString() {
    return 'GetRoomsParams(unavailableRoomUids: $unavailableRoomUids, guests: $guests)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetRoomsParamsImpl &&
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
  _$$GetRoomsParamsImplCopyWith<_$GetRoomsParamsImpl> get copyWith =>
      __$$GetRoomsParamsImplCopyWithImpl<_$GetRoomsParamsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetRoomsParamsImplToJson(
      this,
    );
  }
}

abstract class _GetRoomsParams implements GetRoomsParams {
  factory _GetRoomsParams(
      {final List<String>? unavailableRoomUids,
      final num? guests}) = _$GetRoomsParamsImpl;

  factory _GetRoomsParams.fromJson(Map<String, dynamic> json) =
      _$GetRoomsParamsImpl.fromJson;

  @override
  List<String>? get unavailableRoomUids;
  @override
  num? get guests;
  @override
  @JsonKey(ignore: true)
  _$$GetRoomsParamsImplCopyWith<_$GetRoomsParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
