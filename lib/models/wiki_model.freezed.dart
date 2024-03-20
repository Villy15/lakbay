// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wiki_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WikiModel _$WikiModelFromJson(Map<String, dynamic> json) {
  return _WikiModel.fromJson(json);
}

/// @nodoc
mixin _$WikiModel {
  String? get uid => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get coopId => throw _privateConstructorUsedError;
  String get tag => throw _privateConstructorUsedError;
  List<WikiComments>? get comments => throw _privateConstructorUsedError;
  num? get votes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WikiModelCopyWith<WikiModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WikiModelCopyWith<$Res> {
  factory $WikiModelCopyWith(WikiModel value, $Res Function(WikiModel) then) =
      _$WikiModelCopyWithImpl<$Res, WikiModel>;
  @useResult
  $Res call(
      {String? uid,
      String title,
      String description,
      String? imageUrl,
      String createdBy,
      DateTime createdAt,
      String coopId,
      String tag,
      List<WikiComments>? comments,
      num? votes});
}

/// @nodoc
class _$WikiModelCopyWithImpl<$Res, $Val extends WikiModel>
    implements $WikiModelCopyWith<$Res> {
  _$WikiModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? coopId = null,
    Object? tag = null,
    Object? comments = freezed,
    Object? votes = freezed,
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      coopId: null == coopId
          ? _value.coopId
          : coopId // ignore: cast_nullable_to_non_nullable
              as String,
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
      comments: freezed == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<WikiComments>?,
      votes: freezed == votes
          ? _value.votes
          : votes // ignore: cast_nullable_to_non_nullable
              as num?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WikiModelImplCopyWith<$Res>
    implements $WikiModelCopyWith<$Res> {
  factory _$$WikiModelImplCopyWith(
          _$WikiModelImpl value, $Res Function(_$WikiModelImpl) then) =
      __$$WikiModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? uid,
      String title,
      String description,
      String? imageUrl,
      String createdBy,
      DateTime createdAt,
      String coopId,
      String tag,
      List<WikiComments>? comments,
      num? votes});
}

/// @nodoc
class __$$WikiModelImplCopyWithImpl<$Res>
    extends _$WikiModelCopyWithImpl<$Res, _$WikiModelImpl>
    implements _$$WikiModelImplCopyWith<$Res> {
  __$$WikiModelImplCopyWithImpl(
      _$WikiModelImpl _value, $Res Function(_$WikiModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? coopId = null,
    Object? tag = null,
    Object? comments = freezed,
    Object? votes = freezed,
  }) {
    return _then(_$WikiModelImpl(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      coopId: null == coopId
          ? _value.coopId
          : coopId // ignore: cast_nullable_to_non_nullable
              as String,
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
      comments: freezed == comments
          ? _value._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<WikiComments>?,
      votes: freezed == votes
          ? _value.votes
          : votes // ignore: cast_nullable_to_non_nullable
              as num?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WikiModelImpl implements _WikiModel {
  _$WikiModelImpl(
      {this.uid,
      required this.title,
      required this.description,
      this.imageUrl,
      required this.createdBy,
      required this.createdAt,
      required this.coopId,
      required this.tag,
      final List<WikiComments>? comments,
      this.votes})
      : _comments = comments;

  factory _$WikiModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WikiModelImplFromJson(json);

  @override
  final String? uid;
  @override
  final String title;
  @override
  final String description;
  @override
  final String? imageUrl;
  @override
  final String createdBy;
  @override
  final DateTime createdAt;
  @override
  final String coopId;
  @override
  final String tag;
  final List<WikiComments>? _comments;
  @override
  List<WikiComments>? get comments {
    final value = _comments;
    if (value == null) return null;
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final num? votes;

  @override
  String toString() {
    return 'WikiModel(uid: $uid, title: $title, description: $description, imageUrl: $imageUrl, createdBy: $createdBy, createdAt: $createdAt, coopId: $coopId, tag: $tag, comments: $comments, votes: $votes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WikiModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.coopId, coopId) || other.coopId == coopId) &&
            (identical(other.tag, tag) || other.tag == tag) &&
            const DeepCollectionEquality().equals(other._comments, _comments) &&
            (identical(other.votes, votes) || other.votes == votes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      title,
      description,
      imageUrl,
      createdBy,
      createdAt,
      coopId,
      tag,
      const DeepCollectionEquality().hash(_comments),
      votes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WikiModelImplCopyWith<_$WikiModelImpl> get copyWith =>
      __$$WikiModelImplCopyWithImpl<_$WikiModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WikiModelImplToJson(
      this,
    );
  }
}

abstract class _WikiModel implements WikiModel {
  factory _WikiModel(
      {final String? uid,
      required final String title,
      required final String description,
      final String? imageUrl,
      required final String createdBy,
      required final DateTime createdAt,
      required final String coopId,
      required final String tag,
      final List<WikiComments>? comments,
      final num? votes}) = _$WikiModelImpl;

  factory _WikiModel.fromJson(Map<String, dynamic> json) =
      _$WikiModelImpl.fromJson;

  @override
  String? get uid;
  @override
  String get title;
  @override
  String get description;
  @override
  String? get imageUrl;
  @override
  String get createdBy;
  @override
  DateTime get createdAt;
  @override
  String get coopId;
  @override
  String get tag;
  @override
  List<WikiComments>? get comments;
  @override
  num? get votes;
  @override
  @JsonKey(ignore: true)
  _$$WikiModelImplCopyWith<_$WikiModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WikiComments _$WikiCommentsFromJson(Map<String, dynamic> json) {
  return _WikiComments.fromJson(json);
}

/// @nodoc
mixin _$WikiComments {
  String get comment => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  num? get votes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WikiCommentsCopyWith<WikiComments> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WikiCommentsCopyWith<$Res> {
  factory $WikiCommentsCopyWith(
          WikiComments value, $Res Function(WikiComments) then) =
      _$WikiCommentsCopyWithImpl<$Res, WikiComments>;
  @useResult
  $Res call(
      {String comment,
      String createdBy,
      DateTime createdAt,
      String? imageUrl,
      num? votes});
}

/// @nodoc
class _$WikiCommentsCopyWithImpl<$Res, $Val extends WikiComments>
    implements $WikiCommentsCopyWith<$Res> {
  _$WikiCommentsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comment = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? imageUrl = freezed,
    Object? votes = freezed,
  }) {
    return _then(_value.copyWith(
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      votes: freezed == votes
          ? _value.votes
          : votes // ignore: cast_nullable_to_non_nullable
              as num?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WikiCommentsImplCopyWith<$Res>
    implements $WikiCommentsCopyWith<$Res> {
  factory _$$WikiCommentsImplCopyWith(
          _$WikiCommentsImpl value, $Res Function(_$WikiCommentsImpl) then) =
      __$$WikiCommentsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String comment,
      String createdBy,
      DateTime createdAt,
      String? imageUrl,
      num? votes});
}

/// @nodoc
class __$$WikiCommentsImplCopyWithImpl<$Res>
    extends _$WikiCommentsCopyWithImpl<$Res, _$WikiCommentsImpl>
    implements _$$WikiCommentsImplCopyWith<$Res> {
  __$$WikiCommentsImplCopyWithImpl(
      _$WikiCommentsImpl _value, $Res Function(_$WikiCommentsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comment = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? imageUrl = freezed,
    Object? votes = freezed,
  }) {
    return _then(_$WikiCommentsImpl(
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      votes: freezed == votes
          ? _value.votes
          : votes // ignore: cast_nullable_to_non_nullable
              as num?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WikiCommentsImpl implements _WikiComments {
  _$WikiCommentsImpl(
      {required this.comment,
      required this.createdBy,
      required this.createdAt,
      this.imageUrl,
      this.votes});

  factory _$WikiCommentsImpl.fromJson(Map<String, dynamic> json) =>
      _$$WikiCommentsImplFromJson(json);

  @override
  final String comment;
  @override
  final String createdBy;
  @override
  final DateTime createdAt;
  @override
  final String? imageUrl;
  @override
  final num? votes;

  @override
  String toString() {
    return 'WikiComments(comment: $comment, createdBy: $createdBy, createdAt: $createdAt, imageUrl: $imageUrl, votes: $votes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WikiCommentsImpl &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.votes, votes) || other.votes == votes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, comment, createdBy, createdAt, imageUrl, votes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WikiCommentsImplCopyWith<_$WikiCommentsImpl> get copyWith =>
      __$$WikiCommentsImplCopyWithImpl<_$WikiCommentsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WikiCommentsImplToJson(
      this,
    );
  }
}

abstract class _WikiComments implements WikiComments {
  factory _WikiComments(
      {required final String comment,
      required final String createdBy,
      required final DateTime createdAt,
      final String? imageUrl,
      final num? votes}) = _$WikiCommentsImpl;

  factory _WikiComments.fromJson(Map<String, dynamic> json) =
      _$WikiCommentsImpl.fromJson;

  @override
  String get comment;
  @override
  String get createdBy;
  @override
  DateTime get createdAt;
  @override
  String? get imageUrl;
  @override
  num? get votes;
  @override
  @JsonKey(ignore: true)
  _$$WikiCommentsImplCopyWith<_$WikiCommentsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
