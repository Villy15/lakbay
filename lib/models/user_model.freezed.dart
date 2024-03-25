// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get uid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get profilePic => throw _privateConstructorUsedError;
  String? get phoneNo => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get emergencyContact => throw _privateConstructorUsedError;
  bool get isAuthenticated => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  bool? get isCoopView => throw _privateConstructorUsedError;
  List<CooperativesJoined>? get cooperativesJoined =>
      throw _privateConstructorUsedError;
  String? get currentCoop => throw _privateConstructorUsedError;
  String? get validIdUrl => throw _privateConstructorUsedError;
  String? get birthCertificateUrl => throw _privateConstructorUsedError;
  List<UserReviews>? get reviews => throw _privateConstructorUsedError;
  String? get middleName => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get birthDate => throw _privateConstructorUsedError;
  num? get age => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  String? get religion => throw _privateConstructorUsedError;
  String? get nationality => throw _privateConstructorUsedError;
  String? get civilStatus => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String uid,
      String name,
      String profilePic,
      String? phoneNo,
      String? email,
      String? address,
      String? emergencyContact,
      bool isAuthenticated,
      String? imageUrl,
      String? firstName,
      String? lastName,
      bool? isCoopView,
      List<CooperativesJoined>? cooperativesJoined,
      String? currentCoop,
      String? validIdUrl,
      String? birthCertificateUrl,
      List<UserReviews>? reviews,
      String? middleName,
      @TimestampSerializer() DateTime? birthDate,
      num? age,
      String? gender,
      String? religion,
      String? nationality,
      String? civilStatus,
      @TimestampSerializer() DateTime? createdAt});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? profilePic = null,
    Object? phoneNo = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? emergencyContact = freezed,
    Object? isAuthenticated = null,
    Object? imageUrl = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? isCoopView = freezed,
    Object? cooperativesJoined = freezed,
    Object? currentCoop = freezed,
    Object? validIdUrl = freezed,
    Object? birthCertificateUrl = freezed,
    Object? reviews = freezed,
    Object? middleName = freezed,
    Object? birthDate = freezed,
    Object? age = freezed,
    Object? gender = freezed,
    Object? religion = freezed,
    Object? nationality = freezed,
    Object? civilStatus = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      profilePic: null == profilePic
          ? _value.profilePic
          : profilePic // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNo: freezed == phoneNo
          ? _value.phoneNo
          : phoneNo // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContact: freezed == emergencyContact
          ? _value.emergencyContact
          : emergencyContact // ignore: cast_nullable_to_non_nullable
              as String?,
      isAuthenticated: null == isAuthenticated
          ? _value.isAuthenticated
          : isAuthenticated // ignore: cast_nullable_to_non_nullable
              as bool,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      isCoopView: freezed == isCoopView
          ? _value.isCoopView
          : isCoopView // ignore: cast_nullable_to_non_nullable
              as bool?,
      cooperativesJoined: freezed == cooperativesJoined
          ? _value.cooperativesJoined
          : cooperativesJoined // ignore: cast_nullable_to_non_nullable
              as List<CooperativesJoined>?,
      currentCoop: freezed == currentCoop
          ? _value.currentCoop
          : currentCoop // ignore: cast_nullable_to_non_nullable
              as String?,
      validIdUrl: freezed == validIdUrl
          ? _value.validIdUrl
          : validIdUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      birthCertificateUrl: freezed == birthCertificateUrl
          ? _value.birthCertificateUrl
          : birthCertificateUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      reviews: freezed == reviews
          ? _value.reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as List<UserReviews>?,
      middleName: freezed == middleName
          ? _value.middleName
          : middleName // ignore: cast_nullable_to_non_nullable
              as String?,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      age: freezed == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as num?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      religion: freezed == religion
          ? _value.religion
          : religion // ignore: cast_nullable_to_non_nullable
              as String?,
      nationality: freezed == nationality
          ? _value.nationality
          : nationality // ignore: cast_nullable_to_non_nullable
              as String?,
      civilStatus: freezed == civilStatus
          ? _value.civilStatus
          : civilStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String name,
      String profilePic,
      String? phoneNo,
      String? email,
      String? address,
      String? emergencyContact,
      bool isAuthenticated,
      String? imageUrl,
      String? firstName,
      String? lastName,
      bool? isCoopView,
      List<CooperativesJoined>? cooperativesJoined,
      String? currentCoop,
      String? validIdUrl,
      String? birthCertificateUrl,
      List<UserReviews>? reviews,
      String? middleName,
      @TimestampSerializer() DateTime? birthDate,
      num? age,
      String? gender,
      String? religion,
      String? nationality,
      String? civilStatus,
      @TimestampSerializer() DateTime? createdAt});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? profilePic = null,
    Object? phoneNo = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? emergencyContact = freezed,
    Object? isAuthenticated = null,
    Object? imageUrl = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? isCoopView = freezed,
    Object? cooperativesJoined = freezed,
    Object? currentCoop = freezed,
    Object? validIdUrl = freezed,
    Object? birthCertificateUrl = freezed,
    Object? reviews = freezed,
    Object? middleName = freezed,
    Object? birthDate = freezed,
    Object? age = freezed,
    Object? gender = freezed,
    Object? religion = freezed,
    Object? nationality = freezed,
    Object? civilStatus = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$UserModelImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      profilePic: null == profilePic
          ? _value.profilePic
          : profilePic // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNo: freezed == phoneNo
          ? _value.phoneNo
          : phoneNo // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContact: freezed == emergencyContact
          ? _value.emergencyContact
          : emergencyContact // ignore: cast_nullable_to_non_nullable
              as String?,
      isAuthenticated: null == isAuthenticated
          ? _value.isAuthenticated
          : isAuthenticated // ignore: cast_nullable_to_non_nullable
              as bool,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      isCoopView: freezed == isCoopView
          ? _value.isCoopView
          : isCoopView // ignore: cast_nullable_to_non_nullable
              as bool?,
      cooperativesJoined: freezed == cooperativesJoined
          ? _value._cooperativesJoined
          : cooperativesJoined // ignore: cast_nullable_to_non_nullable
              as List<CooperativesJoined>?,
      currentCoop: freezed == currentCoop
          ? _value.currentCoop
          : currentCoop // ignore: cast_nullable_to_non_nullable
              as String?,
      validIdUrl: freezed == validIdUrl
          ? _value.validIdUrl
          : validIdUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      birthCertificateUrl: freezed == birthCertificateUrl
          ? _value.birthCertificateUrl
          : birthCertificateUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      reviews: freezed == reviews
          ? _value._reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as List<UserReviews>?,
      middleName: freezed == middleName
          ? _value.middleName
          : middleName // ignore: cast_nullable_to_non_nullable
              as String?,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      age: freezed == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as num?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      religion: freezed == religion
          ? _value.religion
          : religion // ignore: cast_nullable_to_non_nullable
              as String?,
      nationality: freezed == nationality
          ? _value.nationality
          : nationality // ignore: cast_nullable_to_non_nullable
              as String?,
      civilStatus: freezed == civilStatus
          ? _value.civilStatus
          : civilStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl extends _UserModel {
  _$UserModelImpl(
      {required this.uid,
      required this.name,
      required this.profilePic,
      this.phoneNo,
      this.email,
      this.address,
      this.emergencyContact,
      required this.isAuthenticated,
      this.imageUrl,
      this.firstName,
      this.lastName,
      this.isCoopView,
      final List<CooperativesJoined>? cooperativesJoined,
      this.currentCoop,
      this.validIdUrl,
      this.birthCertificateUrl,
      final List<UserReviews>? reviews,
      this.middleName,
      @TimestampSerializer() this.birthDate,
      this.age,
      this.gender,
      this.religion,
      this.nationality,
      this.civilStatus,
      @TimestampSerializer() this.createdAt})
      : _cooperativesJoined = cooperativesJoined,
        _reviews = reviews,
        super._();

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String uid;
  @override
  final String name;
  @override
  final String profilePic;
  @override
  final String? phoneNo;
  @override
  final String? email;
  @override
  final String? address;
  @override
  final String? emergencyContact;
  @override
  final bool isAuthenticated;
  @override
  final String? imageUrl;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final bool? isCoopView;
  final List<CooperativesJoined>? _cooperativesJoined;
  @override
  List<CooperativesJoined>? get cooperativesJoined {
    final value = _cooperativesJoined;
    if (value == null) return null;
    if (_cooperativesJoined is EqualUnmodifiableListView)
      return _cooperativesJoined;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? currentCoop;
  @override
  final String? validIdUrl;
  @override
  final String? birthCertificateUrl;
  final List<UserReviews>? _reviews;
  @override
  List<UserReviews>? get reviews {
    final value = _reviews;
    if (value == null) return null;
    if (_reviews is EqualUnmodifiableListView) return _reviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? middleName;
  @override
  @TimestampSerializer()
  final DateTime? birthDate;
  @override
  final num? age;
  @override
  final String? gender;
  @override
  final String? religion;
  @override
  final String? nationality;
  @override
  final String? civilStatus;
  @override
  @TimestampSerializer()
  final DateTime? createdAt;

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, profilePic: $profilePic, phoneNo: $phoneNo, email: $email, address: $address, emergencyContact: $emergencyContact, isAuthenticated: $isAuthenticated, imageUrl: $imageUrl, firstName: $firstName, lastName: $lastName, isCoopView: $isCoopView, cooperativesJoined: $cooperativesJoined, currentCoop: $currentCoop, validIdUrl: $validIdUrl, birthCertificateUrl: $birthCertificateUrl, reviews: $reviews, middleName: $middleName, birthDate: $birthDate, age: $age, gender: $gender, religion: $religion, nationality: $nationality, civilStatus: $civilStatus, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.profilePic, profilePic) ||
                other.profilePic == profilePic) &&
            (identical(other.phoneNo, phoneNo) || other.phoneNo == phoneNo) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.emergencyContact, emergencyContact) ||
                other.emergencyContact == emergencyContact) &&
            (identical(other.isAuthenticated, isAuthenticated) ||
                other.isAuthenticated == isAuthenticated) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.isCoopView, isCoopView) ||
                other.isCoopView == isCoopView) &&
            const DeepCollectionEquality()
                .equals(other._cooperativesJoined, _cooperativesJoined) &&
            (identical(other.currentCoop, currentCoop) ||
                other.currentCoop == currentCoop) &&
            (identical(other.validIdUrl, validIdUrl) ||
                other.validIdUrl == validIdUrl) &&
            (identical(other.birthCertificateUrl, birthCertificateUrl) ||
                other.birthCertificateUrl == birthCertificateUrl) &&
            const DeepCollectionEquality().equals(other._reviews, _reviews) &&
            (identical(other.middleName, middleName) ||
                other.middleName == middleName) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.religion, religion) ||
                other.religion == religion) &&
            (identical(other.nationality, nationality) ||
                other.nationality == nationality) &&
            (identical(other.civilStatus, civilStatus) ||
                other.civilStatus == civilStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        uid,
        name,
        profilePic,
        phoneNo,
        email,
        address,
        emergencyContact,
        isAuthenticated,
        imageUrl,
        firstName,
        lastName,
        isCoopView,
        const DeepCollectionEquality().hash(_cooperativesJoined),
        currentCoop,
        validIdUrl,
        birthCertificateUrl,
        const DeepCollectionEquality().hash(_reviews),
        middleName,
        birthDate,
        age,
        gender,
        religion,
        nationality,
        civilStatus,
        createdAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel extends UserModel {
  factory _UserModel(
      {required final String uid,
      required final String name,
      required final String profilePic,
      final String? phoneNo,
      final String? email,
      final String? address,
      final String? emergencyContact,
      required final bool isAuthenticated,
      final String? imageUrl,
      final String? firstName,
      final String? lastName,
      final bool? isCoopView,
      final List<CooperativesJoined>? cooperativesJoined,
      final String? currentCoop,
      final String? validIdUrl,
      final String? birthCertificateUrl,
      final List<UserReviews>? reviews,
      final String? middleName,
      @TimestampSerializer() final DateTime? birthDate,
      final num? age,
      final String? gender,
      final String? religion,
      final String? nationality,
      final String? civilStatus,
      @TimestampSerializer() final DateTime? createdAt}) = _$UserModelImpl;
  _UserModel._() : super._();

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get uid;
  @override
  String get name;
  @override
  String get profilePic;
  @override
  String? get phoneNo;
  @override
  String? get email;
  @override
  String? get address;
  @override
  String? get emergencyContact;
  @override
  bool get isAuthenticated;
  @override
  String? get imageUrl;
  @override
  String? get firstName;
  @override
  String? get lastName;
  @override
  bool? get isCoopView;
  @override
  List<CooperativesJoined>? get cooperativesJoined;
  @override
  String? get currentCoop;
  @override
  String? get validIdUrl;
  @override
  String? get birthCertificateUrl;
  @override
  List<UserReviews>? get reviews;
  @override
  String? get middleName;
  @override
  @TimestampSerializer()
  DateTime? get birthDate;
  @override
  num? get age;
  @override
  String? get gender;
  @override
  String? get religion;
  @override
  String? get nationality;
  @override
  String? get civilStatus;
  @override
  @TimestampSerializer()
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CooperativesJoined _$CooperativesJoinedFromJson(Map<String, dynamic> json) {
  return _CooperativesJoined.fromJson(json);
}

/// @nodoc
mixin _$CooperativesJoined {
  String get cooperativeId => throw _privateConstructorUsedError;
  String get cooperativeName => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CooperativesJoinedCopyWith<CooperativesJoined> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CooperativesJoinedCopyWith<$Res> {
  factory $CooperativesJoinedCopyWith(
          CooperativesJoined value, $Res Function(CooperativesJoined) then) =
      _$CooperativesJoinedCopyWithImpl<$Res, CooperativesJoined>;
  @useResult
  $Res call({String cooperativeId, String cooperativeName, String role});
}

/// @nodoc
class _$CooperativesJoinedCopyWithImpl<$Res, $Val extends CooperativesJoined>
    implements $CooperativesJoinedCopyWith<$Res> {
  _$CooperativesJoinedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cooperativeId = null,
    Object? cooperativeName = null,
    Object? role = null,
  }) {
    return _then(_value.copyWith(
      cooperativeId: null == cooperativeId
          ? _value.cooperativeId
          : cooperativeId // ignore: cast_nullable_to_non_nullable
              as String,
      cooperativeName: null == cooperativeName
          ? _value.cooperativeName
          : cooperativeName // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CooperativesJoinedImplCopyWith<$Res>
    implements $CooperativesJoinedCopyWith<$Res> {
  factory _$$CooperativesJoinedImplCopyWith(_$CooperativesJoinedImpl value,
          $Res Function(_$CooperativesJoinedImpl) then) =
      __$$CooperativesJoinedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String cooperativeId, String cooperativeName, String role});
}

/// @nodoc
class __$$CooperativesJoinedImplCopyWithImpl<$Res>
    extends _$CooperativesJoinedCopyWithImpl<$Res, _$CooperativesJoinedImpl>
    implements _$$CooperativesJoinedImplCopyWith<$Res> {
  __$$CooperativesJoinedImplCopyWithImpl(_$CooperativesJoinedImpl _value,
      $Res Function(_$CooperativesJoinedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cooperativeId = null,
    Object? cooperativeName = null,
    Object? role = null,
  }) {
    return _then(_$CooperativesJoinedImpl(
      cooperativeId: null == cooperativeId
          ? _value.cooperativeId
          : cooperativeId // ignore: cast_nullable_to_non_nullable
              as String,
      cooperativeName: null == cooperativeName
          ? _value.cooperativeName
          : cooperativeName // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CooperativesJoinedImpl implements _CooperativesJoined {
  _$CooperativesJoinedImpl(
      {required this.cooperativeId,
      required this.cooperativeName,
      required this.role});

  factory _$CooperativesJoinedImpl.fromJson(Map<String, dynamic> json) =>
      _$$CooperativesJoinedImplFromJson(json);

  @override
  final String cooperativeId;
  @override
  final String cooperativeName;
  @override
  final String role;

  @override
  String toString() {
    return 'CooperativesJoined(cooperativeId: $cooperativeId, cooperativeName: $cooperativeName, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CooperativesJoinedImpl &&
            (identical(other.cooperativeId, cooperativeId) ||
                other.cooperativeId == cooperativeId) &&
            (identical(other.cooperativeName, cooperativeName) ||
                other.cooperativeName == cooperativeName) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, cooperativeId, cooperativeName, role);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CooperativesJoinedImplCopyWith<_$CooperativesJoinedImpl> get copyWith =>
      __$$CooperativesJoinedImplCopyWithImpl<_$CooperativesJoinedImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CooperativesJoinedImplToJson(
      this,
    );
  }
}

abstract class _CooperativesJoined implements CooperativesJoined {
  factory _CooperativesJoined(
      {required final String cooperativeId,
      required final String cooperativeName,
      required final String role}) = _$CooperativesJoinedImpl;

  factory _CooperativesJoined.fromJson(Map<String, dynamic> json) =
      _$CooperativesJoinedImpl.fromJson;

  @override
  String get cooperativeId;
  @override
  String get cooperativeName;
  @override
  String get role;
  @override
  @JsonKey(ignore: true)
  _$$CooperativesJoinedImplCopyWith<_$CooperativesJoinedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserReviews _$UserReviewsFromJson(Map<String, dynamic> json) {
  return _UserReviews.fromJson(json);
}

/// @nodoc
mixin _$UserReviews {
  String get userId => throw _privateConstructorUsedError;
  String get reviewerId => throw _privateConstructorUsedError;
  String get listingId => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  String get review => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserReviewsCopyWith<UserReviews> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserReviewsCopyWith<$Res> {
  factory $UserReviewsCopyWith(
          UserReviews value, $Res Function(UserReviews) then) =
      _$UserReviewsCopyWithImpl<$Res, UserReviews>;
  @useResult
  $Res call(
      {String userId,
      String reviewerId,
      String listingId,
      @TimestampSerializer() DateTime? createdAt,
      String review});
}

/// @nodoc
class _$UserReviewsCopyWithImpl<$Res, $Val extends UserReviews>
    implements $UserReviewsCopyWith<$Res> {
  _$UserReviewsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? reviewerId = null,
    Object? listingId = null,
    Object? createdAt = freezed,
    Object? review = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewerId: null == reviewerId
          ? _value.reviewerId
          : reviewerId // ignore: cast_nullable_to_non_nullable
              as String,
      listingId: null == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      review: null == review
          ? _value.review
          : review // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserReviewsImplCopyWith<$Res>
    implements $UserReviewsCopyWith<$Res> {
  factory _$$UserReviewsImplCopyWith(
          _$UserReviewsImpl value, $Res Function(_$UserReviewsImpl) then) =
      __$$UserReviewsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String reviewerId,
      String listingId,
      @TimestampSerializer() DateTime? createdAt,
      String review});
}

/// @nodoc
class __$$UserReviewsImplCopyWithImpl<$Res>
    extends _$UserReviewsCopyWithImpl<$Res, _$UserReviewsImpl>
    implements _$$UserReviewsImplCopyWith<$Res> {
  __$$UserReviewsImplCopyWithImpl(
      _$UserReviewsImpl _value, $Res Function(_$UserReviewsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? reviewerId = null,
    Object? listingId = null,
    Object? createdAt = freezed,
    Object? review = null,
  }) {
    return _then(_$UserReviewsImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewerId: null == reviewerId
          ? _value.reviewerId
          : reviewerId // ignore: cast_nullable_to_non_nullable
              as String,
      listingId: null == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      review: null == review
          ? _value.review
          : review // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserReviewsImpl implements _UserReviews {
  _$UserReviewsImpl(
      {required this.userId,
      required this.reviewerId,
      required this.listingId,
      @TimestampSerializer() this.createdAt,
      required this.review});

  factory _$UserReviewsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserReviewsImplFromJson(json);

  @override
  final String userId;
  @override
  final String reviewerId;
  @override
  final String listingId;
  @override
  @TimestampSerializer()
  final DateTime? createdAt;
  @override
  final String review;

  @override
  String toString() {
    return 'UserReviews(userId: $userId, reviewerId: $reviewerId, listingId: $listingId, createdAt: $createdAt, review: $review)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserReviewsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.reviewerId, reviewerId) ||
                other.reviewerId == reviewerId) &&
            (identical(other.listingId, listingId) ||
                other.listingId == listingId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.review, review) || other.review == review));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, userId, reviewerId, listingId, createdAt, review);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserReviewsImplCopyWith<_$UserReviewsImpl> get copyWith =>
      __$$UserReviewsImplCopyWithImpl<_$UserReviewsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserReviewsImplToJson(
      this,
    );
  }
}

abstract class _UserReviews implements UserReviews {
  factory _UserReviews(
      {required final String userId,
      required final String reviewerId,
      required final String listingId,
      @TimestampSerializer() final DateTime? createdAt,
      required final String review}) = _$UserReviewsImpl;

  factory _UserReviews.fromJson(Map<String, dynamic> json) =
      _$UserReviewsImpl.fromJson;

  @override
  String get userId;
  @override
  String get reviewerId;
  @override
  String get listingId;
  @override
  @TimestampSerializer()
  DateTime? get createdAt;
  @override
  String get review;
  @override
  @JsonKey(ignore: true)
  _$$UserReviewsImplCopyWith<_$UserReviewsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
