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
  String? get coopId => throw _privateConstructorUsedError;
  String? get position => throw _privateConstructorUsedError;
  List<CoopVoteCandidate>? get candidates => throw _privateConstructorUsedError;
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
      String? coopId,
      String? position,
      List<CoopVoteCandidate>? candidates,
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
    Object? coopId = freezed,
    Object? position = freezed,
    Object? candidates = freezed,
    Object? dueDate = freezed,
  }) {
    return _then(_value.copyWith(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      coopId: freezed == coopId
          ? _value.coopId
          : coopId // ignore: cast_nullable_to_non_nullable
              as String?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String?,
      candidates: freezed == candidates
          ? _value.candidates
          : candidates // ignore: cast_nullable_to_non_nullable
              as List<CoopVoteCandidate>?,
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
      String? coopId,
      String? position,
      List<CoopVoteCandidate>? candidates,
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
    Object? coopId = freezed,
    Object? position = freezed,
    Object? candidates = freezed,
    Object? dueDate = freezed,
  }) {
    return _then(_$CoopVoteImpl(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      coopId: freezed == coopId
          ? _value.coopId
          : coopId // ignore: cast_nullable_to_non_nullable
              as String?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String?,
      candidates: freezed == candidates
          ? _value._candidates
          : candidates // ignore: cast_nullable_to_non_nullable
              as List<CoopVoteCandidate>?,
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
      {this.uid,
      this.coopId,
      this.position,
      final List<CoopVoteCandidate>? candidates,
      @TimestampSerializer() this.dueDate})
      : _candidates = candidates;

  factory _$CoopVoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoopVoteImplFromJson(json);

  @override
  final String? uid;
  @override
  final String? coopId;
  @override
  final String? position;
  final List<CoopVoteCandidate>? _candidates;
  @override
  List<CoopVoteCandidate>? get candidates {
    final value = _candidates;
    if (value == null) return null;
    if (_candidates is EqualUnmodifiableListView) return _candidates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @TimestampSerializer()
  final DateTime? dueDate;

  @override
  String toString() {
    return 'CoopVote(uid: $uid, coopId: $coopId, position: $position, candidates: $candidates, dueDate: $dueDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoopVoteImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.coopId, coopId) || other.coopId == coopId) &&
            (identical(other.position, position) ||
                other.position == position) &&
            const DeepCollectionEquality()
                .equals(other._candidates, _candidates) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uid, coopId, position,
      const DeepCollectionEquality().hash(_candidates), dueDate);

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
      final String? coopId,
      final String? position,
      final List<CoopVoteCandidate>? candidates,
      @TimestampSerializer() final DateTime? dueDate}) = _$CoopVoteImpl;

  factory _CoopVote.fromJson(Map<String, dynamic> json) =
      _$CoopVoteImpl.fromJson;

  @override
  String? get uid;
  @override
  String? get coopId;
  @override
  String? get position;
  @override
  List<CoopVoteCandidate>? get candidates;
  @override
  @TimestampSerializer()
  DateTime? get dueDate;
  @override
  @JsonKey(ignore: true)
  _$$CoopVoteImplCopyWith<_$CoopVoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CoopVoteCandidate _$CoopVoteCandidateFromJson(Map<String, dynamic> json) {
  return _CoopVoteCandidate.fromJson(json);
}

/// @nodoc
mixin _$CoopVoteCandidate {
  String? get uid => throw _privateConstructorUsedError;
  List<String>? get voters => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CoopVoteCandidateCopyWith<CoopVoteCandidate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoopVoteCandidateCopyWith<$Res> {
  factory $CoopVoteCandidateCopyWith(
          CoopVoteCandidate value, $Res Function(CoopVoteCandidate) then) =
      _$CoopVoteCandidateCopyWithImpl<$Res, CoopVoteCandidate>;
  @useResult
  $Res call({String? uid, List<String>? voters});
}

/// @nodoc
class _$CoopVoteCandidateCopyWithImpl<$Res, $Val extends CoopVoteCandidate>
    implements $CoopVoteCandidateCopyWith<$Res> {
  _$CoopVoteCandidateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? voters = freezed,
  }) {
    return _then(_value.copyWith(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      voters: freezed == voters
          ? _value.voters
          : voters // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CoopVoteCandidateImplCopyWith<$Res>
    implements $CoopVoteCandidateCopyWith<$Res> {
  factory _$$CoopVoteCandidateImplCopyWith(_$CoopVoteCandidateImpl value,
          $Res Function(_$CoopVoteCandidateImpl) then) =
      __$$CoopVoteCandidateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? uid, List<String>? voters});
}

/// @nodoc
class __$$CoopVoteCandidateImplCopyWithImpl<$Res>
    extends _$CoopVoteCandidateCopyWithImpl<$Res, _$CoopVoteCandidateImpl>
    implements _$$CoopVoteCandidateImplCopyWith<$Res> {
  __$$CoopVoteCandidateImplCopyWithImpl(_$CoopVoteCandidateImpl _value,
      $Res Function(_$CoopVoteCandidateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? voters = freezed,
  }) {
    return _then(_$CoopVoteCandidateImpl(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      voters: freezed == voters
          ? _value._voters
          : voters // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CoopVoteCandidateImpl implements _CoopVoteCandidate {
  _$CoopVoteCandidateImpl({this.uid, final List<String>? voters})
      : _voters = voters;

  factory _$CoopVoteCandidateImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoopVoteCandidateImplFromJson(json);

  @override
  final String? uid;
  final List<String>? _voters;
  @override
  List<String>? get voters {
    final value = _voters;
    if (value == null) return null;
    if (_voters is EqualUnmodifiableListView) return _voters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CoopVoteCandidate(uid: $uid, voters: $voters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoopVoteCandidateImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            const DeepCollectionEquality().equals(other._voters, _voters));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, uid, const DeepCollectionEquality().hash(_voters));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CoopVoteCandidateImplCopyWith<_$CoopVoteCandidateImpl> get copyWith =>
      __$$CoopVoteCandidateImplCopyWithImpl<_$CoopVoteCandidateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoopVoteCandidateImplToJson(
      this,
    );
  }
}

abstract class _CoopVoteCandidate implements CoopVoteCandidate {
  factory _CoopVoteCandidate({final String? uid, final List<String>? voters}) =
      _$CoopVoteCandidateImpl;

  factory _CoopVoteCandidate.fromJson(Map<String, dynamic> json) =
      _$CoopVoteCandidateImpl.fromJson;

  @override
  String? get uid;
  @override
  List<String>? get voters;
  @override
  @JsonKey(ignore: true)
  _$$CoopVoteCandidateImplCopyWith<_$CoopVoteCandidateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
