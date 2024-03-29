// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coop_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CooperativeModel _$CooperativeModelFromJson(Map<String, dynamic> json) {
  return _CooperativeModel.fromJson(json);
}

/// @nodoc
mixin _$CooperativeModel {
  String? get uid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get province => throw _privateConstructorUsedError;
  String get imagePath => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;
  List<String> get members => throw _privateConstructorUsedError;
  List<String> get managers => throw _privateConstructorUsedError;
  num? get membershipFee => throw _privateConstructorUsedError;
  num? get membershipDividends => throw _privateConstructorUsedError;
  ValidationFiles? get validationFiles => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CooperativeModelCopyWith<CooperativeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CooperativeModelCopyWith<$Res> {
  factory $CooperativeModelCopyWith(
          CooperativeModel value, $Res Function(CooperativeModel) then) =
      _$CooperativeModelCopyWithImpl<$Res, CooperativeModel>;
  @useResult
  $Res call(
      {String? uid,
      String name,
      String? description,
      String? address,
      String city,
      String province,
      String imagePath,
      String? imageUrl,
      String? code,
      List<String> members,
      List<String> managers,
      num? membershipFee,
      num? membershipDividends,
      ValidationFiles? validationFiles});

  $ValidationFilesCopyWith<$Res>? get validationFiles;
}

/// @nodoc
class _$CooperativeModelCopyWithImpl<$Res, $Val extends CooperativeModel>
    implements $CooperativeModelCopyWith<$Res> {
  _$CooperativeModelCopyWithImpl(this._value, this._then);

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
    Object? address = freezed,
    Object? city = null,
    Object? province = null,
    Object? imagePath = null,
    Object? imageUrl = freezed,
    Object? code = freezed,
    Object? members = null,
    Object? managers = null,
    Object? membershipFee = freezed,
    Object? membershipDividends = freezed,
    Object? validationFiles = freezed,
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
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      province: null == province
          ? _value.province
          : province // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<String>,
      managers: null == managers
          ? _value.managers
          : managers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      membershipFee: freezed == membershipFee
          ? _value.membershipFee
          : membershipFee // ignore: cast_nullable_to_non_nullable
              as num?,
      membershipDividends: freezed == membershipDividends
          ? _value.membershipDividends
          : membershipDividends // ignore: cast_nullable_to_non_nullable
              as num?,
      validationFiles: freezed == validationFiles
          ? _value.validationFiles
          : validationFiles // ignore: cast_nullable_to_non_nullable
              as ValidationFiles?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ValidationFilesCopyWith<$Res>? get validationFiles {
    if (_value.validationFiles == null) {
      return null;
    }

    return $ValidationFilesCopyWith<$Res>(_value.validationFiles!, (value) {
      return _then(_value.copyWith(validationFiles: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CooperativeModelImplCopyWith<$Res>
    implements $CooperativeModelCopyWith<$Res> {
  factory _$$CooperativeModelImplCopyWith(_$CooperativeModelImpl value,
          $Res Function(_$CooperativeModelImpl) then) =
      __$$CooperativeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? uid,
      String name,
      String? description,
      String? address,
      String city,
      String province,
      String imagePath,
      String? imageUrl,
      String? code,
      List<String> members,
      List<String> managers,
      num? membershipFee,
      num? membershipDividends,
      ValidationFiles? validationFiles});

  @override
  $ValidationFilesCopyWith<$Res>? get validationFiles;
}

/// @nodoc
class __$$CooperativeModelImplCopyWithImpl<$Res>
    extends _$CooperativeModelCopyWithImpl<$Res, _$CooperativeModelImpl>
    implements _$$CooperativeModelImplCopyWith<$Res> {
  __$$CooperativeModelImplCopyWithImpl(_$CooperativeModelImpl _value,
      $Res Function(_$CooperativeModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? address = freezed,
    Object? city = null,
    Object? province = null,
    Object? imagePath = null,
    Object? imageUrl = freezed,
    Object? code = freezed,
    Object? members = null,
    Object? managers = null,
    Object? membershipFee = freezed,
    Object? membershipDividends = freezed,
    Object? validationFiles = freezed,
  }) {
    return _then(_$CooperativeModelImpl(
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
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      province: null == province
          ? _value.province
          : province // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<String>,
      managers: null == managers
          ? _value._managers
          : managers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      membershipFee: freezed == membershipFee
          ? _value.membershipFee
          : membershipFee // ignore: cast_nullable_to_non_nullable
              as num?,
      membershipDividends: freezed == membershipDividends
          ? _value.membershipDividends
          : membershipDividends // ignore: cast_nullable_to_non_nullable
              as num?,
      validationFiles: freezed == validationFiles
          ? _value.validationFiles
          : validationFiles // ignore: cast_nullable_to_non_nullable
              as ValidationFiles?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CooperativeModelImpl implements _CooperativeModel {
  _$CooperativeModelImpl(
      {this.uid,
      required this.name,
      this.description,
      this.address,
      required this.city,
      required this.province,
      required this.imagePath,
      this.imageUrl,
      this.code,
      required final List<String> members,
      required final List<String> managers,
      this.membershipFee,
      this.membershipDividends,
      this.validationFiles})
      : _members = members,
        _managers = managers;

  factory _$CooperativeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CooperativeModelImplFromJson(json);

  @override
  final String? uid;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? address;
  @override
  final String city;
  @override
  final String province;
  @override
  final String imagePath;
  @override
  final String? imageUrl;
  @override
  final String? code;
  final List<String> _members;
  @override
  List<String> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  final List<String> _managers;
  @override
  List<String> get managers {
    if (_managers is EqualUnmodifiableListView) return _managers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_managers);
  }

  @override
  final num? membershipFee;
  @override
  final num? membershipDividends;
  @override
  final ValidationFiles? validationFiles;

  @override
  String toString() {
    return 'CooperativeModel(uid: $uid, name: $name, description: $description, address: $address, city: $city, province: $province, imagePath: $imagePath, imageUrl: $imageUrl, code: $code, members: $members, managers: $managers, membershipFee: $membershipFee, membershipDividends: $membershipDividends, validationFiles: $validationFiles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CooperativeModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.province, province) ||
                other.province == province) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.code, code) || other.code == code) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            const DeepCollectionEquality().equals(other._managers, _managers) &&
            (identical(other.membershipFee, membershipFee) ||
                other.membershipFee == membershipFee) &&
            (identical(other.membershipDividends, membershipDividends) ||
                other.membershipDividends == membershipDividends) &&
            (identical(other.validationFiles, validationFiles) ||
                other.validationFiles == validationFiles));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      name,
      description,
      address,
      city,
      province,
      imagePath,
      imageUrl,
      code,
      const DeepCollectionEquality().hash(_members),
      const DeepCollectionEquality().hash(_managers),
      membershipFee,
      membershipDividends,
      validationFiles);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CooperativeModelImplCopyWith<_$CooperativeModelImpl> get copyWith =>
      __$$CooperativeModelImplCopyWithImpl<_$CooperativeModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CooperativeModelImplToJson(
      this,
    );
  }
}

abstract class _CooperativeModel implements CooperativeModel {
  factory _CooperativeModel(
      {final String? uid,
      required final String name,
      final String? description,
      final String? address,
      required final String city,
      required final String province,
      required final String imagePath,
      final String? imageUrl,
      final String? code,
      required final List<String> members,
      required final List<String> managers,
      final num? membershipFee,
      final num? membershipDividends,
      final ValidationFiles? validationFiles}) = _$CooperativeModelImpl;

  factory _CooperativeModel.fromJson(Map<String, dynamic> json) =
      _$CooperativeModelImpl.fromJson;

  @override
  String? get uid;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get address;
  @override
  String get city;
  @override
  String get province;
  @override
  String get imagePath;
  @override
  String? get imageUrl;
  @override
  String? get code;
  @override
  List<String> get members;
  @override
  List<String> get managers;
  @override
  num? get membershipFee;
  @override
  num? get membershipDividends;
  @override
  ValidationFiles? get validationFiles;
  @override
  @JsonKey(ignore: true)
  _$$CooperativeModelImplCopyWith<_$CooperativeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ValidationFiles _$ValidationFilesFromJson(Map<String, dynamic> json) {
  return _ValidationFiles.fromJson(json);
}

/// @nodoc
mixin _$ValidationFiles {
  String? get certificateOfRegistration => throw _privateConstructorUsedError;
  String? get articlesOfCooperation => throw _privateConstructorUsedError;
  String? get byLaws => throw _privateConstructorUsedError;
  String? get audit => throw _privateConstructorUsedError;
  String? get letterAuth => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ValidationFilesCopyWith<ValidationFiles> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValidationFilesCopyWith<$Res> {
  factory $ValidationFilesCopyWith(
          ValidationFiles value, $Res Function(ValidationFiles) then) =
      _$ValidationFilesCopyWithImpl<$Res, ValidationFiles>;
  @useResult
  $Res call(
      {String? certificateOfRegistration,
      String? articlesOfCooperation,
      String? byLaws,
      String? audit,
      String? letterAuth});
}

/// @nodoc
class _$ValidationFilesCopyWithImpl<$Res, $Val extends ValidationFiles>
    implements $ValidationFilesCopyWith<$Res> {
  _$ValidationFilesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? certificateOfRegistration = freezed,
    Object? articlesOfCooperation = freezed,
    Object? byLaws = freezed,
    Object? audit = freezed,
    Object? letterAuth = freezed,
  }) {
    return _then(_value.copyWith(
      certificateOfRegistration: freezed == certificateOfRegistration
          ? _value.certificateOfRegistration
          : certificateOfRegistration // ignore: cast_nullable_to_non_nullable
              as String?,
      articlesOfCooperation: freezed == articlesOfCooperation
          ? _value.articlesOfCooperation
          : articlesOfCooperation // ignore: cast_nullable_to_non_nullable
              as String?,
      byLaws: freezed == byLaws
          ? _value.byLaws
          : byLaws // ignore: cast_nullable_to_non_nullable
              as String?,
      audit: freezed == audit
          ? _value.audit
          : audit // ignore: cast_nullable_to_non_nullable
              as String?,
      letterAuth: freezed == letterAuth
          ? _value.letterAuth
          : letterAuth // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ValidationFilesImplCopyWith<$Res>
    implements $ValidationFilesCopyWith<$Res> {
  factory _$$ValidationFilesImplCopyWith(_$ValidationFilesImpl value,
          $Res Function(_$ValidationFilesImpl) then) =
      __$$ValidationFilesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? certificateOfRegistration,
      String? articlesOfCooperation,
      String? byLaws,
      String? audit,
      String? letterAuth});
}

/// @nodoc
class __$$ValidationFilesImplCopyWithImpl<$Res>
    extends _$ValidationFilesCopyWithImpl<$Res, _$ValidationFilesImpl>
    implements _$$ValidationFilesImplCopyWith<$Res> {
  __$$ValidationFilesImplCopyWithImpl(
      _$ValidationFilesImpl _value, $Res Function(_$ValidationFilesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? certificateOfRegistration = freezed,
    Object? articlesOfCooperation = freezed,
    Object? byLaws = freezed,
    Object? audit = freezed,
    Object? letterAuth = freezed,
  }) {
    return _then(_$ValidationFilesImpl(
      certificateOfRegistration: freezed == certificateOfRegistration
          ? _value.certificateOfRegistration
          : certificateOfRegistration // ignore: cast_nullable_to_non_nullable
              as String?,
      articlesOfCooperation: freezed == articlesOfCooperation
          ? _value.articlesOfCooperation
          : articlesOfCooperation // ignore: cast_nullable_to_non_nullable
              as String?,
      byLaws: freezed == byLaws
          ? _value.byLaws
          : byLaws // ignore: cast_nullable_to_non_nullable
              as String?,
      audit: freezed == audit
          ? _value.audit
          : audit // ignore: cast_nullable_to_non_nullable
              as String?,
      letterAuth: freezed == letterAuth
          ? _value.letterAuth
          : letterAuth // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ValidationFilesImpl implements _ValidationFiles {
  _$ValidationFilesImpl(
      {this.certificateOfRegistration,
      this.articlesOfCooperation,
      this.byLaws,
      this.audit,
      this.letterAuth});

  factory _$ValidationFilesImpl.fromJson(Map<String, dynamic> json) =>
      _$$ValidationFilesImplFromJson(json);

  @override
  final String? certificateOfRegistration;
  @override
  final String? articlesOfCooperation;
  @override
  final String? byLaws;
  @override
  final String? audit;
  @override
  final String? letterAuth;

  @override
  String toString() {
    return 'ValidationFiles(certificateOfRegistration: $certificateOfRegistration, articlesOfCooperation: $articlesOfCooperation, byLaws: $byLaws, audit: $audit, letterAuth: $letterAuth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationFilesImpl &&
            (identical(other.certificateOfRegistration,
                    certificateOfRegistration) ||
                other.certificateOfRegistration == certificateOfRegistration) &&
            (identical(other.articlesOfCooperation, articlesOfCooperation) ||
                other.articlesOfCooperation == articlesOfCooperation) &&
            (identical(other.byLaws, byLaws) || other.byLaws == byLaws) &&
            (identical(other.audit, audit) || other.audit == audit) &&
            (identical(other.letterAuth, letterAuth) ||
                other.letterAuth == letterAuth));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, certificateOfRegistration,
      articlesOfCooperation, byLaws, audit, letterAuth);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationFilesImplCopyWith<_$ValidationFilesImpl> get copyWith =>
      __$$ValidationFilesImplCopyWithImpl<_$ValidationFilesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ValidationFilesImplToJson(
      this,
    );
  }
}

abstract class _ValidationFiles implements ValidationFiles {
  factory _ValidationFiles(
      {final String? certificateOfRegistration,
      final String? articlesOfCooperation,
      final String? byLaws,
      final String? audit,
      final String? letterAuth}) = _$ValidationFilesImpl;

  factory _ValidationFiles.fromJson(Map<String, dynamic> json) =
      _$ValidationFilesImpl.fromJson;

  @override
  String? get certificateOfRegistration;
  @override
  String? get articlesOfCooperation;
  @override
  String? get byLaws;
  @override
  String? get audit;
  @override
  String? get letterAuth;
  @override
  @JsonKey(ignore: true)
  _$$ValidationFilesImplCopyWith<_$ValidationFilesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
