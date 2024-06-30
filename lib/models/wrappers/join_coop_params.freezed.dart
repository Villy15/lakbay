// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'join_coop_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

JoinCoopParams _$JoinCoopParamsFromJson(Map<String, dynamic> json) {
  return _JoinCoopParams.fromJson(json);
}

/// @nodoc
mixin _$JoinCoopParams {
  String? get uid => throw _privateConstructorUsedError;
  String? get coopId => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get userUid => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get timestamp => throw _privateConstructorUsedError;
  num? get age => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  String? get religion => throw _privateConstructorUsedError;
  String? get nationality => throw _privateConstructorUsedError;
  String? get civilStatus => throw _privateConstructorUsedError;
  String? get committee => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;
  String? get status =>
      throw _privateConstructorUsedError; //pending, rejected, completed
  HandledByModel? get updatedBy => throw _privateConstructorUsedError;
  List<ReqFile>? get reqFiles => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JoinCoopParamsCopyWith<JoinCoopParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JoinCoopParamsCopyWith<$Res> {
  factory $JoinCoopParamsCopyWith(
          JoinCoopParams value, $Res Function(JoinCoopParams) then) =
      _$JoinCoopParamsCopyWithImpl<$Res, JoinCoopParams>;
  @useResult
  $Res call(
      {String? uid,
      String? coopId,
      String? name,
      String? userUid,
      @TimestampSerializer() DateTime? timestamp,
      num? age,
      String? gender,
      String? religion,
      String? nationality,
      String? civilStatus,
      String? committee,
      String? role,
      String? status,
      HandledByModel? updatedBy,
      List<ReqFile>? reqFiles});

  $HandledByModelCopyWith<$Res>? get updatedBy;
}

/// @nodoc
class _$JoinCoopParamsCopyWithImpl<$Res, $Val extends JoinCoopParams>
    implements $JoinCoopParamsCopyWith<$Res> {
  _$JoinCoopParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? coopId = freezed,
    Object? name = freezed,
    Object? userUid = freezed,
    Object? timestamp = freezed,
    Object? age = freezed,
    Object? gender = freezed,
    Object? religion = freezed,
    Object? nationality = freezed,
    Object? civilStatus = freezed,
    Object? committee = freezed,
    Object? role = freezed,
    Object? status = freezed,
    Object? updatedBy = freezed,
    Object? reqFiles = freezed,
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
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      userUid: freezed == userUid
          ? _value.userUid
          : userUid // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
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
      committee: freezed == committee
          ? _value.committee
          : committee // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as HandledByModel?,
      reqFiles: freezed == reqFiles
          ? _value.reqFiles
          : reqFiles // ignore: cast_nullable_to_non_nullable
              as List<ReqFile>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $HandledByModelCopyWith<$Res>? get updatedBy {
    if (_value.updatedBy == null) {
      return null;
    }

    return $HandledByModelCopyWith<$Res>(_value.updatedBy!, (value) {
      return _then(_value.copyWith(updatedBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$JoinCoopParamsImplCopyWith<$Res>
    implements $JoinCoopParamsCopyWith<$Res> {
  factory _$$JoinCoopParamsImplCopyWith(_$JoinCoopParamsImpl value,
          $Res Function(_$JoinCoopParamsImpl) then) =
      __$$JoinCoopParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? uid,
      String? coopId,
      String? name,
      String? userUid,
      @TimestampSerializer() DateTime? timestamp,
      num? age,
      String? gender,
      String? religion,
      String? nationality,
      String? civilStatus,
      String? committee,
      String? role,
      String? status,
      HandledByModel? updatedBy,
      List<ReqFile>? reqFiles});

  @override
  $HandledByModelCopyWith<$Res>? get updatedBy;
}

/// @nodoc
class __$$JoinCoopParamsImplCopyWithImpl<$Res>
    extends _$JoinCoopParamsCopyWithImpl<$Res, _$JoinCoopParamsImpl>
    implements _$$JoinCoopParamsImplCopyWith<$Res> {
  __$$JoinCoopParamsImplCopyWithImpl(
      _$JoinCoopParamsImpl _value, $Res Function(_$JoinCoopParamsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? coopId = freezed,
    Object? name = freezed,
    Object? userUid = freezed,
    Object? timestamp = freezed,
    Object? age = freezed,
    Object? gender = freezed,
    Object? religion = freezed,
    Object? nationality = freezed,
    Object? civilStatus = freezed,
    Object? committee = freezed,
    Object? role = freezed,
    Object? status = freezed,
    Object? updatedBy = freezed,
    Object? reqFiles = freezed,
  }) {
    return _then(_$JoinCoopParamsImpl(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      coopId: freezed == coopId
          ? _value.coopId
          : coopId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      userUid: freezed == userUid
          ? _value.userUid
          : userUid // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
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
      committee: freezed == committee
          ? _value.committee
          : committee // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as HandledByModel?,
      reqFiles: freezed == reqFiles
          ? _value._reqFiles
          : reqFiles // ignore: cast_nullable_to_non_nullable
              as List<ReqFile>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JoinCoopParamsImpl implements _JoinCoopParams {
  _$JoinCoopParamsImpl(
      {this.uid,
      this.coopId,
      this.name,
      this.userUid,
      @TimestampSerializer() this.timestamp,
      this.age,
      this.gender,
      this.religion,
      this.nationality,
      this.civilStatus,
      this.committee,
      this.role,
      this.status,
      this.updatedBy,
      final List<ReqFile>? reqFiles})
      : _reqFiles = reqFiles;

  factory _$JoinCoopParamsImpl.fromJson(Map<String, dynamic> json) =>
      _$$JoinCoopParamsImplFromJson(json);

  @override
  final String? uid;
  @override
  final String? coopId;
  @override
  final String? name;
  @override
  final String? userUid;
  @override
  @TimestampSerializer()
  final DateTime? timestamp;
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
  final String? committee;
  @override
  final String? role;
  @override
  final String? status;
//pending, rejected, completed
  @override
  final HandledByModel? updatedBy;
  final List<ReqFile>? _reqFiles;
  @override
  List<ReqFile>? get reqFiles {
    final value = _reqFiles;
    if (value == null) return null;
    if (_reqFiles is EqualUnmodifiableListView) return _reqFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'JoinCoopParams(uid: $uid, coopId: $coopId, name: $name, userUid: $userUid, timestamp: $timestamp, age: $age, gender: $gender, religion: $religion, nationality: $nationality, civilStatus: $civilStatus, committee: $committee, role: $role, status: $status, updatedBy: $updatedBy, reqFiles: $reqFiles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JoinCoopParamsImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.coopId, coopId) || other.coopId == coopId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.userUid, userUid) || other.userUid == userUid) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.religion, religion) ||
                other.religion == religion) &&
            (identical(other.nationality, nationality) ||
                other.nationality == nationality) &&
            (identical(other.civilStatus, civilStatus) ||
                other.civilStatus == civilStatus) &&
            (identical(other.committee, committee) ||
                other.committee == committee) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy) &&
            const DeepCollectionEquality().equals(other._reqFiles, _reqFiles));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      coopId,
      name,
      userUid,
      timestamp,
      age,
      gender,
      religion,
      nationality,
      civilStatus,
      committee,
      role,
      status,
      updatedBy,
      const DeepCollectionEquality().hash(_reqFiles));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$JoinCoopParamsImplCopyWith<_$JoinCoopParamsImpl> get copyWith =>
      __$$JoinCoopParamsImplCopyWithImpl<_$JoinCoopParamsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JoinCoopParamsImplToJson(
      this,
    );
  }
}

abstract class _JoinCoopParams implements JoinCoopParams {
  factory _JoinCoopParams(
      {final String? uid,
      final String? coopId,
      final String? name,
      final String? userUid,
      @TimestampSerializer() final DateTime? timestamp,
      final num? age,
      final String? gender,
      final String? religion,
      final String? nationality,
      final String? civilStatus,
      final String? committee,
      final String? role,
      final String? status,
      final HandledByModel? updatedBy,
      final List<ReqFile>? reqFiles}) = _$JoinCoopParamsImpl;

  factory _JoinCoopParams.fromJson(Map<String, dynamic> json) =
      _$JoinCoopParamsImpl.fromJson;

  @override
  String? get uid;
  @override
  String? get coopId;
  @override
  String? get name;
  @override
  String? get userUid;
  @override
  @TimestampSerializer()
  DateTime? get timestamp;
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
  String? get committee;
  @override
  String? get role;
  @override
  String? get status;
  @override //pending, rejected, completed
  HandledByModel? get updatedBy;
  @override
  List<ReqFile>? get reqFiles;
  @override
  @JsonKey(ignore: true)
  _$$JoinCoopParamsImplCopyWith<_$JoinCoopParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HandledByModel _$HandledByModelFromJson(Map<String, dynamic> json) {
  return _HandledByModel.fromJson(json);
}

/// @nodoc
mixin _$HandledByModel {
  String? get uid => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HandledByModelCopyWith<HandledByModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HandledByModelCopyWith<$Res> {
  factory $HandledByModelCopyWith(
          HandledByModel value, $Res Function(HandledByModel) then) =
      _$HandledByModelCopyWithImpl<$Res, HandledByModel>;
  @useResult
  $Res call({String? uid, String? name});
}

/// @nodoc
class _$HandledByModelCopyWithImpl<$Res, $Val extends HandledByModel>
    implements $HandledByModelCopyWith<$Res> {
  _$HandledByModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HandledByModelImplCopyWith<$Res>
    implements $HandledByModelCopyWith<$Res> {
  factory _$$HandledByModelImplCopyWith(_$HandledByModelImpl value,
          $Res Function(_$HandledByModelImpl) then) =
      __$$HandledByModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? uid, String? name});
}

/// @nodoc
class __$$HandledByModelImplCopyWithImpl<$Res>
    extends _$HandledByModelCopyWithImpl<$Res, _$HandledByModelImpl>
    implements _$$HandledByModelImplCopyWith<$Res> {
  __$$HandledByModelImplCopyWithImpl(
      _$HandledByModelImpl _value, $Res Function(_$HandledByModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? name = freezed,
  }) {
    return _then(_$HandledByModelImpl(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HandledByModelImpl implements _HandledByModel {
  _$HandledByModelImpl({this.uid, this.name});

  factory _$HandledByModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HandledByModelImplFromJson(json);

  @override
  final String? uid;
  @override
  final String? name;

  @override
  String toString() {
    return 'HandledByModel(uid: $uid, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HandledByModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uid, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HandledByModelImplCopyWith<_$HandledByModelImpl> get copyWith =>
      __$$HandledByModelImplCopyWithImpl<_$HandledByModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HandledByModelImplToJson(
      this,
    );
  }
}

abstract class _HandledByModel implements HandledByModel {
  factory _HandledByModel({final String? uid, final String? name}) =
      _$HandledByModelImpl;

  factory _HandledByModel.fromJson(Map<String, dynamic> json) =
      _$HandledByModelImpl.fromJson;

  @override
  String? get uid;
  @override
  String? get name;
  @override
  @JsonKey(ignore: true)
  _$$HandledByModelImplCopyWith<_$HandledByModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReqFile _$ReqFileFromJson(Map<String, dynamic> json) {
  return _ReqFile.fromJson(json);
}

/// @nodoc
mixin _$ReqFile {
  String? get fileName => throw _privateConstructorUsedError;
  String? get fileTitle => throw _privateConstructorUsedError;
  String? get path => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReqFileCopyWith<ReqFile> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReqFileCopyWith<$Res> {
  factory $ReqFileCopyWith(ReqFile value, $Res Function(ReqFile) then) =
      _$ReqFileCopyWithImpl<$Res, ReqFile>;
  @useResult
  $Res call({String? fileName, String? fileTitle, String? path, String? url});
}

/// @nodoc
class _$ReqFileCopyWithImpl<$Res, $Val extends ReqFile>
    implements $ReqFileCopyWith<$Res> {
  _$ReqFileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = freezed,
    Object? fileTitle = freezed,
    Object? path = freezed,
    Object? url = freezed,
  }) {
    return _then(_value.copyWith(
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      fileTitle: freezed == fileTitle
          ? _value.fileTitle
          : fileTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      path: freezed == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReqFileImplCopyWith<$Res> implements $ReqFileCopyWith<$Res> {
  factory _$$ReqFileImplCopyWith(
          _$ReqFileImpl value, $Res Function(_$ReqFileImpl) then) =
      __$$ReqFileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? fileName, String? fileTitle, String? path, String? url});
}

/// @nodoc
class __$$ReqFileImplCopyWithImpl<$Res>
    extends _$ReqFileCopyWithImpl<$Res, _$ReqFileImpl>
    implements _$$ReqFileImplCopyWith<$Res> {
  __$$ReqFileImplCopyWithImpl(
      _$ReqFileImpl _value, $Res Function(_$ReqFileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = freezed,
    Object? fileTitle = freezed,
    Object? path = freezed,
    Object? url = freezed,
  }) {
    return _then(_$ReqFileImpl(
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      fileTitle: freezed == fileTitle
          ? _value.fileTitle
          : fileTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      path: freezed == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReqFileImpl implements _ReqFile {
  _$ReqFileImpl({this.fileName, this.fileTitle, this.path, this.url});

  factory _$ReqFileImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReqFileImplFromJson(json);

  @override
  final String? fileName;
  @override
  final String? fileTitle;
  @override
  final String? path;
  @override
  final String? url;

  @override
  String toString() {
    return 'ReqFile(fileName: $fileName, fileTitle: $fileTitle, path: $path, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReqFileImpl &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileTitle, fileTitle) ||
                other.fileTitle == fileTitle) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, fileName, fileTitle, path, url);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReqFileImplCopyWith<_$ReqFileImpl> get copyWith =>
      __$$ReqFileImplCopyWithImpl<_$ReqFileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReqFileImplToJson(
      this,
    );
  }
}

abstract class _ReqFile implements ReqFile {
  factory _ReqFile(
      {final String? fileName,
      final String? fileTitle,
      final String? path,
      final String? url}) = _$ReqFileImpl;

  factory _ReqFile.fromJson(Map<String, dynamic> json) = _$ReqFileImpl.fromJson;

  @override
  String? get fileName;
  @override
  String? get fileTitle;
  @override
  String? get path;
  @override
  String? get url;
  @override
  @JsonKey(ignore: true)
  _$$ReqFileImplCopyWith<_$ReqFileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
