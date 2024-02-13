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
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get imagePath => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

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
      String name,
      String? description,
      String imagePath,
      String? imageUrl});
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
    Object? name = null,
    Object? description = freezed,
    Object? imagePath = null,
    Object? imageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
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
      String name,
      String? description,
      String imagePath,
      String? imageUrl});
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
    Object? name = null,
    Object? description = freezed,
    Object? imagePath = null,
    Object? imageUrl = freezed,
  }) {
    return _then(_$WikiModelImpl(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WikiModelImpl implements _WikiModel {
  _$WikiModelImpl(
      {this.uid,
      required this.name,
      this.description,
      required this.imagePath,
      this.imageUrl});

  factory _$WikiModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WikiModelImplFromJson(json);

  @override
  final String? uid;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String imagePath;
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'WikiModel(uid: $uid, name: $name, description: $description, imagePath: $imagePath, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WikiModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, uid, name, description, imagePath, imageUrl);

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
      required final String name,
      final String? description,
      required final String imagePath,
      final String? imageUrl}) = _$WikiModelImpl;

  factory _WikiModel.fromJson(Map<String, dynamic> json) =
      _$WikiModelImpl.fromJson;

  @override
  String? get uid;
  @override
  String get name;
  @override
  String? get description;
  @override
  String get imagePath;
  @override
  String? get imageUrl;
  @override
  @JsonKey(ignore: true)
  _$$WikiModelImplCopyWith<_$WikiModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
