// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

EventModel _$EventModelFromJson(Map<String, dynamic> json) {
  return _EventModel.fromJson(json);
}

/// @nodoc
mixin _$EventModel {
  String? get uid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get province => throw _privateConstructorUsedError;
  String get imagePath => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  List<String> get members => throw _privateConstructorUsedError;
  List<String> get managers => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  EventCooperative get cooperative => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventModelCopyWith<EventModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventModelCopyWith<$Res> {
  factory $EventModelCopyWith(
          EventModel value, $Res Function(EventModel) then) =
      _$EventModelCopyWithImpl<$Res, EventModel>;
  @useResult
  $Res call(
      {String? uid,
      String name,
      String? description,
      String address,
      String city,
      String province,
      String imagePath,
      String? imageUrl,
      List<String> members,
      List<String> managers,
      DateTime startDate,
      DateTime endDate,
      EventCooperative cooperative});

  $EventCooperativeCopyWith<$Res> get cooperative;
}

/// @nodoc
class _$EventModelCopyWithImpl<$Res, $Val extends EventModel>
    implements $EventModelCopyWith<$Res> {
  _$EventModelCopyWithImpl(this._value, this._then);

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
    Object? address = null,
    Object? city = null,
    Object? province = null,
    Object? imagePath = null,
    Object? imageUrl = freezed,
    Object? members = null,
    Object? managers = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? cooperative = null,
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
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
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
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<String>,
      managers: null == managers
          ? _value.managers
          : managers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cooperative: null == cooperative
          ? _value.cooperative
          : cooperative // ignore: cast_nullable_to_non_nullable
              as EventCooperative,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $EventCooperativeCopyWith<$Res> get cooperative {
    return $EventCooperativeCopyWith<$Res>(_value.cooperative, (value) {
      return _then(_value.copyWith(cooperative: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventModelImplCopyWith<$Res>
    implements $EventModelCopyWith<$Res> {
  factory _$$EventModelImplCopyWith(
          _$EventModelImpl value, $Res Function(_$EventModelImpl) then) =
      __$$EventModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? uid,
      String name,
      String? description,
      String address,
      String city,
      String province,
      String imagePath,
      String? imageUrl,
      List<String> members,
      List<String> managers,
      DateTime startDate,
      DateTime endDate,
      EventCooperative cooperative});

  @override
  $EventCooperativeCopyWith<$Res> get cooperative;
}

/// @nodoc
class __$$EventModelImplCopyWithImpl<$Res>
    extends _$EventModelCopyWithImpl<$Res, _$EventModelImpl>
    implements _$$EventModelImplCopyWith<$Res> {
  __$$EventModelImplCopyWithImpl(
      _$EventModelImpl _value, $Res Function(_$EventModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? address = null,
    Object? city = null,
    Object? province = null,
    Object? imagePath = null,
    Object? imageUrl = freezed,
    Object? members = null,
    Object? managers = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? cooperative = null,
  }) {
    return _then(_$EventModelImpl(
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
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
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
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<String>,
      managers: null == managers
          ? _value._managers
          : managers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cooperative: null == cooperative
          ? _value.cooperative
          : cooperative // ignore: cast_nullable_to_non_nullable
              as EventCooperative,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventModelImpl implements _EventModel {
  _$EventModelImpl(
      {this.uid,
      required this.name,
      this.description,
      required this.address,
      required this.city,
      required this.province,
      required this.imagePath,
      this.imageUrl,
      required final List<String> members,
      required final List<String> managers,
      required this.startDate,
      required this.endDate,
      required this.cooperative})
      : _members = members,
        _managers = managers;

  factory _$EventModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventModelImplFromJson(json);

  @override
  final String? uid;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String address;
  @override
  final String city;
  @override
  final String province;
  @override
  final String imagePath;
  @override
  final String? imageUrl;
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
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final EventCooperative cooperative;

  @override
  String toString() {
    return 'EventModel(uid: $uid, name: $name, description: $description, address: $address, city: $city, province: $province, imagePath: $imagePath, imageUrl: $imageUrl, members: $members, managers: $managers, startDate: $startDate, endDate: $endDate, cooperative: $cooperative)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventModelImpl &&
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
            const DeepCollectionEquality().equals(other._members, _members) &&
            const DeepCollectionEquality().equals(other._managers, _managers) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.cooperative, cooperative) ||
                other.cooperative == cooperative));
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
      const DeepCollectionEquality().hash(_members),
      const DeepCollectionEquality().hash(_managers),
      startDate,
      endDate,
      cooperative);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventModelImplCopyWith<_$EventModelImpl> get copyWith =>
      __$$EventModelImplCopyWithImpl<_$EventModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventModelImplToJson(
      this,
    );
  }
}

abstract class _EventModel implements EventModel {
  factory _EventModel(
      {final String? uid,
      required final String name,
      final String? description,
      required final String address,
      required final String city,
      required final String province,
      required final String imagePath,
      final String? imageUrl,
      required final List<String> members,
      required final List<String> managers,
      required final DateTime startDate,
      required final DateTime endDate,
      required final EventCooperative cooperative}) = _$EventModelImpl;

  factory _EventModel.fromJson(Map<String, dynamic> json) =
      _$EventModelImpl.fromJson;

  @override
  String? get uid;
  @override
  String get name;
  @override
  String? get description;
  @override
  String get address;
  @override
  String get city;
  @override
  String get province;
  @override
  String get imagePath;
  @override
  String? get imageUrl;
  @override
  List<String> get members;
  @override
  List<String> get managers;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  EventCooperative get cooperative;
  @override
  @JsonKey(ignore: true)
  _$$EventModelImplCopyWith<_$EventModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventCooperative _$EventCooperativeFromJson(Map<String, dynamic> json) {
  return _EventCooperative.fromJson(json);
}

/// @nodoc
mixin _$EventCooperative {
  String get cooperativeId => throw _privateConstructorUsedError;
  String get cooperativeName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventCooperativeCopyWith<EventCooperative> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCooperativeCopyWith<$Res> {
  factory $EventCooperativeCopyWith(
          EventCooperative value, $Res Function(EventCooperative) then) =
      _$EventCooperativeCopyWithImpl<$Res, EventCooperative>;
  @useResult
  $Res call({String cooperativeId, String cooperativeName});
}

/// @nodoc
class _$EventCooperativeCopyWithImpl<$Res, $Val extends EventCooperative>
    implements $EventCooperativeCopyWith<$Res> {
  _$EventCooperativeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cooperativeId = null,
    Object? cooperativeName = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventCooperativeImplCopyWith<$Res>
    implements $EventCooperativeCopyWith<$Res> {
  factory _$$EventCooperativeImplCopyWith(_$EventCooperativeImpl value,
          $Res Function(_$EventCooperativeImpl) then) =
      __$$EventCooperativeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String cooperativeId, String cooperativeName});
}

/// @nodoc
class __$$EventCooperativeImplCopyWithImpl<$Res>
    extends _$EventCooperativeCopyWithImpl<$Res, _$EventCooperativeImpl>
    implements _$$EventCooperativeImplCopyWith<$Res> {
  __$$EventCooperativeImplCopyWithImpl(_$EventCooperativeImpl _value,
      $Res Function(_$EventCooperativeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cooperativeId = null,
    Object? cooperativeName = null,
  }) {
    return _then(_$EventCooperativeImpl(
      cooperativeId: null == cooperativeId
          ? _value.cooperativeId
          : cooperativeId // ignore: cast_nullable_to_non_nullable
              as String,
      cooperativeName: null == cooperativeName
          ? _value.cooperativeName
          : cooperativeName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventCooperativeImpl implements _EventCooperative {
  _$EventCooperativeImpl(
      {required this.cooperativeId, required this.cooperativeName});

  factory _$EventCooperativeImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventCooperativeImplFromJson(json);

  @override
  final String cooperativeId;
  @override
  final String cooperativeName;

  @override
  String toString() {
    return 'EventCooperative(cooperativeId: $cooperativeId, cooperativeName: $cooperativeName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventCooperativeImpl &&
            (identical(other.cooperativeId, cooperativeId) ||
                other.cooperativeId == cooperativeId) &&
            (identical(other.cooperativeName, cooperativeName) ||
                other.cooperativeName == cooperativeName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, cooperativeId, cooperativeName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventCooperativeImplCopyWith<_$EventCooperativeImpl> get copyWith =>
      __$$EventCooperativeImplCopyWithImpl<_$EventCooperativeImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventCooperativeImplToJson(
      this,
    );
  }
}

abstract class _EventCooperative implements EventCooperative {
  factory _EventCooperative(
      {required final String cooperativeId,
      required final String cooperativeName}) = _$EventCooperativeImpl;

  factory _EventCooperative.fromJson(Map<String, dynamic> json) =
      _$EventCooperativeImpl.fromJson;

  @override
  String get cooperativeId;
  @override
  String get cooperativeName;
  @override
  @JsonKey(ignore: true)
  _$$EventCooperativeImplCopyWith<_$EventCooperativeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
