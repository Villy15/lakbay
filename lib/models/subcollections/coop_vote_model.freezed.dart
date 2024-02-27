// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coop_vote_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CoopVote _$CoopVoteFromJson(Map<String, dynamic> json) {
  return _CoopVote.fromJson(json);
}

/// @nodoc
mixin _$CoopVote {
  String? get uid => throw _privateConstructorUsedError;
  String? get position => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get dueDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CoopVoteCopyWith<CoopVote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoopVoteCopyWith<$Res> {
  factory $CoopVoteCopyWith(CoopVote value, $Res Function(CoopVote) then) =
      _$CoopVoteCopyWithImpl<$Res, CoopVote>;
  @useResult
  $Res call(
      {String? uid,
      String? position,
      @TimestampSerializer() DateTime? dueDate});
}

/// @nodoc
class _$CoopVoteCopyWithImpl<$Res, $Val extends CoopVote>
    implements $CoopVoteCopyWith<$Res> {
  _$CoopVoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? position = freezed,
    Object? dueDate = freezed,
  }) {
    return _then(_value.copyWith(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CoopVoteImplCopyWith<$Res>
    implements $CoopVoteCopyWith<$Res> {
  factory _$$CoopVoteImplCopyWith(
          _$CoopVoteImpl value, $Res Function(_$CoopVoteImpl) then) =
      __$$CoopVoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? uid,
      String? position,
      @TimestampSerializer() DateTime? dueDate});
}

/// @nodoc
class __$$CoopVoteImplCopyWithImpl<$Res>
    extends _$CoopVoteCopyWithImpl<$Res, _$CoopVoteImpl>
    implements _$$CoopVoteImplCopyWith<$Res> {
  __$$CoopVoteImplCopyWithImpl(
      _$CoopVoteImpl _value, $Res Function(_$CoopVoteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? position = freezed,
    Object? dueDate = freezed,
  }) {
    return _then(_$CoopVoteImpl(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CoopVoteImpl implements _CoopVote {
  _$CoopVoteImpl(
      {this.uid, this.position, @TimestampSerializer() this.dueDate});

  factory _$CoopVoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoopVoteImplFromJson(json);

  @override
  final String? uid;
  @override
  final String? position;
  @override
  @TimestampSerializer()
  final DateTime? dueDate;

  @override
  String toString() {
    return 'CoopVote(uid: $uid, position: $position, dueDate: $dueDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoopVoteImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uid, position, dueDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CoopVoteImplCopyWith<_$CoopVoteImpl> get copyWith =>
      __$$CoopVoteImplCopyWithImpl<_$CoopVoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoopVoteImplToJson(
      this,
    );
  }
}

abstract class _CoopVote implements CoopVote {
  factory _CoopVote(
      {final String? uid,
      final String? position,
      @TimestampSerializer() final DateTime? dueDate}) = _$CoopVoteImpl;

  factory _CoopVote.fromJson(Map<String, dynamic> json) =
      _$CoopVoteImpl.fromJson;

  @override
  String? get uid;
  @override
  String? get position;
  @override
  @TimestampSerializer()
  DateTime? get dueDate;
  @override
  @JsonKey(ignore: true)
  _$$CoopVoteImplCopyWith<_$CoopVoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
