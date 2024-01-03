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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get uid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get profilePic => throw _privateConstructorUsedError;
  bool get isAuthenticated => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  bool? get isCoopView => throw _privateConstructorUsedError;
  List<CooperativesJoined>? get cooperativesJoined =>
      throw _privateConstructorUsedError;
  String? get currentCoop => throw _privateConstructorUsedError;

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
      bool isAuthenticated,
      String? imageUrl,
      String? firstName,
      String? lastName,
      bool? isCoopView,
      List<CooperativesJoined>? cooperativesJoined,
      String? currentCoop});
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
    Object? isAuthenticated = null,
    Object? imageUrl = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? isCoopView = freezed,
    Object? cooperativesJoined = freezed,
    Object? currentCoop = freezed,
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
      bool isAuthenticated,
      String? imageUrl,
      String? firstName,
      String? lastName,
      bool? isCoopView,
      List<CooperativesJoined>? cooperativesJoined,
      String? currentCoop});
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
    Object? isAuthenticated = null,
    Object? imageUrl = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? isCoopView = freezed,
    Object? cooperativesJoined = freezed,
    Object? currentCoop = freezed,
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
      required this.isAuthenticated,
      this.imageUrl,
      this.firstName,
      this.lastName,
      this.isCoopView,
      final List<CooperativesJoined>? cooperativesJoined,
      this.currentCoop})
      : _cooperativesJoined = cooperativesJoined,
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
  String toString() {
    return 'UserModel(uid: $uid, name: $name, profilePic: $profilePic, isAuthenticated: $isAuthenticated, imageUrl: $imageUrl, firstName: $firstName, lastName: $lastName, isCoopView: $isCoopView, cooperativesJoined: $cooperativesJoined, currentCoop: $currentCoop)';
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
                other.currentCoop == currentCoop));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      name,
      profilePic,
      isAuthenticated,
      imageUrl,
      firstName,
      lastName,
      isCoopView,
      const DeepCollectionEquality().hash(_cooperativesJoined),
      currentCoop);

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
      required final bool isAuthenticated,
      final String? imageUrl,
      final String? firstName,
      final String? lastName,
      final bool? isCoopView,
      final List<CooperativesJoined>? cooperativesJoined,
      final String? currentCoop}) = _$UserModelImpl;
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
