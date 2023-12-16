// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listing_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ListingModel _$ListingModelFromJson(Map<String, dynamic> json) {
  return _ListingModel.fromJson(json);
}

/// @nodoc
mixin _$ListingModel {
  String? get uid => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  num get price => throw _privateConstructorUsedError;
  num? get pax => throw _privateConstructorUsedError;
  num? get bedrooms => throw _privateConstructorUsedError;
  num? get beds => throw _privateConstructorUsedError;
  num? get bathrooms => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get province => throw _privateConstructorUsedError;
  ListingCooperative get cooperative => throw _privateConstructorUsedError;
  List<ListingImages>? get images => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ListingModelCopyWith<ListingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListingModelCopyWith<$Res> {
  factory $ListingModelCopyWith(
          ListingModel value, $Res Function(ListingModel) then) =
      _$ListingModelCopyWithImpl<$Res, ListingModel>;
  @useResult
  $Res call(
      {String? uid,
      String category,
      String title,
      String description,
      num price,
      num? pax,
      num? bedrooms,
      num? beds,
      num? bathrooms,
      String address,
      String city,
      String province,
      ListingCooperative cooperative,
      List<ListingImages>? images});

  $ListingCooperativeCopyWith<$Res> get cooperative;
}

/// @nodoc
class _$ListingModelCopyWithImpl<$Res, $Val extends ListingModel>
    implements $ListingModelCopyWith<$Res> {
  _$ListingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? category = null,
    Object? title = null,
    Object? description = null,
    Object? price = null,
    Object? pax = freezed,
    Object? bedrooms = freezed,
    Object? beds = freezed,
    Object? bathrooms = freezed,
    Object? address = null,
    Object? city = null,
    Object? province = null,
    Object? cooperative = null,
    Object? images = freezed,
  }) {
    return _then(_value.copyWith(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as num,
      pax: freezed == pax
          ? _value.pax
          : pax // ignore: cast_nullable_to_non_nullable
              as num?,
      bedrooms: freezed == bedrooms
          ? _value.bedrooms
          : bedrooms // ignore: cast_nullable_to_non_nullable
              as num?,
      beds: freezed == beds
          ? _value.beds
          : beds // ignore: cast_nullable_to_non_nullable
              as num?,
      bathrooms: freezed == bathrooms
          ? _value.bathrooms
          : bathrooms // ignore: cast_nullable_to_non_nullable
              as num?,
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
      cooperative: null == cooperative
          ? _value.cooperative
          : cooperative // ignore: cast_nullable_to_non_nullable
              as ListingCooperative,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ListingImages>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ListingCooperativeCopyWith<$Res> get cooperative {
    return $ListingCooperativeCopyWith<$Res>(_value.cooperative, (value) {
      return _then(_value.copyWith(cooperative: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ListingModelImplCopyWith<$Res>
    implements $ListingModelCopyWith<$Res> {
  factory _$$ListingModelImplCopyWith(
          _$ListingModelImpl value, $Res Function(_$ListingModelImpl) then) =
      __$$ListingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? uid,
      String category,
      String title,
      String description,
      num price,
      num? pax,
      num? bedrooms,
      num? beds,
      num? bathrooms,
      String address,
      String city,
      String province,
      ListingCooperative cooperative,
      List<ListingImages>? images});

  @override
  $ListingCooperativeCopyWith<$Res> get cooperative;
}

/// @nodoc
class __$$ListingModelImplCopyWithImpl<$Res>
    extends _$ListingModelCopyWithImpl<$Res, _$ListingModelImpl>
    implements _$$ListingModelImplCopyWith<$Res> {
  __$$ListingModelImplCopyWithImpl(
      _$ListingModelImpl _value, $Res Function(_$ListingModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? category = null,
    Object? title = null,
    Object? description = null,
    Object? price = null,
    Object? pax = freezed,
    Object? bedrooms = freezed,
    Object? beds = freezed,
    Object? bathrooms = freezed,
    Object? address = null,
    Object? city = null,
    Object? province = null,
    Object? cooperative = null,
    Object? images = freezed,
  }) {
    return _then(_$ListingModelImpl(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as num,
      pax: freezed == pax
          ? _value.pax
          : pax // ignore: cast_nullable_to_non_nullable
              as num?,
      bedrooms: freezed == bedrooms
          ? _value.bedrooms
          : bedrooms // ignore: cast_nullable_to_non_nullable
              as num?,
      beds: freezed == beds
          ? _value.beds
          : beds // ignore: cast_nullable_to_non_nullable
              as num?,
      bathrooms: freezed == bathrooms
          ? _value.bathrooms
          : bathrooms // ignore: cast_nullable_to_non_nullable
              as num?,
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
      cooperative: null == cooperative
          ? _value.cooperative
          : cooperative // ignore: cast_nullable_to_non_nullable
              as ListingCooperative,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ListingImages>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListingModelImpl implements _ListingModel {
  _$ListingModelImpl(
      {this.uid,
      required this.category,
      required this.title,
      required this.description,
      required this.price,
      this.pax,
      this.bedrooms,
      this.beds,
      this.bathrooms,
      required this.address,
      required this.city,
      required this.province,
      required this.cooperative,
      final List<ListingImages>? images})
      : _images = images;

  factory _$ListingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListingModelImplFromJson(json);

  @override
  final String? uid;
  @override
  final String category;
  @override
  final String title;
  @override
  final String description;
  @override
  final num price;
  @override
  final num? pax;
  @override
  final num? bedrooms;
  @override
  final num? beds;
  @override
  final num? bathrooms;
  @override
  final String address;
  @override
  final String city;
  @override
  final String province;
  @override
  final ListingCooperative cooperative;
  final List<ListingImages>? _images;
  @override
  List<ListingImages>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ListingModel(uid: $uid, category: $category, title: $title, description: $description, price: $price, pax: $pax, bedrooms: $bedrooms, beds: $beds, bathrooms: $bathrooms, address: $address, city: $city, province: $province, cooperative: $cooperative, images: $images)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListingModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.pax, pax) || other.pax == pax) &&
            (identical(other.bedrooms, bedrooms) ||
                other.bedrooms == bedrooms) &&
            (identical(other.beds, beds) || other.beds == beds) &&
            (identical(other.bathrooms, bathrooms) ||
                other.bathrooms == bathrooms) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.province, province) ||
                other.province == province) &&
            (identical(other.cooperative, cooperative) ||
                other.cooperative == cooperative) &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      category,
      title,
      description,
      price,
      pax,
      bedrooms,
      beds,
      bathrooms,
      address,
      city,
      province,
      cooperative,
      const DeepCollectionEquality().hash(_images));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ListingModelImplCopyWith<_$ListingModelImpl> get copyWith =>
      __$$ListingModelImplCopyWithImpl<_$ListingModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListingModelImplToJson(
      this,
    );
  }
}

abstract class _ListingModel implements ListingModel {
  factory _ListingModel(
      {final String? uid,
      required final String category,
      required final String title,
      required final String description,
      required final num price,
      final num? pax,
      final num? bedrooms,
      final num? beds,
      final num? bathrooms,
      required final String address,
      required final String city,
      required final String province,
      required final ListingCooperative cooperative,
      final List<ListingImages>? images}) = _$ListingModelImpl;

  factory _ListingModel.fromJson(Map<String, dynamic> json) =
      _$ListingModelImpl.fromJson;

  @override
  String? get uid;
  @override
  String get category;
  @override
  String get title;
  @override
  String get description;
  @override
  num get price;
  @override
  num? get pax;
  @override
  num? get bedrooms;
  @override
  num? get beds;
  @override
  num? get bathrooms;
  @override
  String get address;
  @override
  String get city;
  @override
  String get province;
  @override
  ListingCooperative get cooperative;
  @override
  List<ListingImages>? get images;
  @override
  @JsonKey(ignore: true)
  _$$ListingModelImplCopyWith<_$ListingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ListingCooperative _$ListingCooperativeFromJson(Map<String, dynamic> json) {
  return _ListingCooperative.fromJson(json);
}

/// @nodoc
mixin _$ListingCooperative {
  String get cooperativeId => throw _privateConstructorUsedError;
  String get cooperativeName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ListingCooperativeCopyWith<ListingCooperative> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListingCooperativeCopyWith<$Res> {
  factory $ListingCooperativeCopyWith(
          ListingCooperative value, $Res Function(ListingCooperative) then) =
      _$ListingCooperativeCopyWithImpl<$Res, ListingCooperative>;
  @useResult
  $Res call({String cooperativeId, String cooperativeName});
}

/// @nodoc
class _$ListingCooperativeCopyWithImpl<$Res, $Val extends ListingCooperative>
    implements $ListingCooperativeCopyWith<$Res> {
  _$ListingCooperativeCopyWithImpl(this._value, this._then);

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
abstract class _$$ListingCooperativeImplCopyWith<$Res>
    implements $ListingCooperativeCopyWith<$Res> {
  factory _$$ListingCooperativeImplCopyWith(_$ListingCooperativeImpl value,
          $Res Function(_$ListingCooperativeImpl) then) =
      __$$ListingCooperativeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String cooperativeId, String cooperativeName});
}

/// @nodoc
class __$$ListingCooperativeImplCopyWithImpl<$Res>
    extends _$ListingCooperativeCopyWithImpl<$Res, _$ListingCooperativeImpl>
    implements _$$ListingCooperativeImplCopyWith<$Res> {
  __$$ListingCooperativeImplCopyWithImpl(_$ListingCooperativeImpl _value,
      $Res Function(_$ListingCooperativeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cooperativeId = null,
    Object? cooperativeName = null,
  }) {
    return _then(_$ListingCooperativeImpl(
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
class _$ListingCooperativeImpl implements _ListingCooperative {
  _$ListingCooperativeImpl(
      {required this.cooperativeId, required this.cooperativeName});

  factory _$ListingCooperativeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListingCooperativeImplFromJson(json);

  @override
  final String cooperativeId;
  @override
  final String cooperativeName;

  @override
  String toString() {
    return 'ListingCooperative(cooperativeId: $cooperativeId, cooperativeName: $cooperativeName)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListingCooperativeImpl &&
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
  _$$ListingCooperativeImplCopyWith<_$ListingCooperativeImpl> get copyWith =>
      __$$ListingCooperativeImplCopyWithImpl<_$ListingCooperativeImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListingCooperativeImplToJson(
      this,
    );
  }
}

abstract class _ListingCooperative implements ListingCooperative {
  factory _ListingCooperative(
      {required final String cooperativeId,
      required final String cooperativeName}) = _$ListingCooperativeImpl;

  factory _ListingCooperative.fromJson(Map<String, dynamic> json) =
      _$ListingCooperativeImpl.fromJson;

  @override
  String get cooperativeId;
  @override
  String get cooperativeName;
  @override
  @JsonKey(ignore: true)
  _$$ListingCooperativeImplCopyWith<_$ListingCooperativeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ListingImages _$ListingImagesFromJson(Map<String, dynamic> json) {
  return _ListingImages.fromJson(json);
}

/// @nodoc
mixin _$ListingImages {
  String get path => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ListingImagesCopyWith<ListingImages> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListingImagesCopyWith<$Res> {
  factory $ListingImagesCopyWith(
          ListingImages value, $Res Function(ListingImages) then) =
      _$ListingImagesCopyWithImpl<$Res, ListingImages>;
  @useResult
  $Res call({String path, String? url});
}

/// @nodoc
class _$ListingImagesCopyWithImpl<$Res, $Val extends ListingImages>
    implements $ListingImagesCopyWith<$Res> {
  _$ListingImagesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? url = freezed,
  }) {
    return _then(_value.copyWith(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ListingImagesImplCopyWith<$Res>
    implements $ListingImagesCopyWith<$Res> {
  factory _$$ListingImagesImplCopyWith(
          _$ListingImagesImpl value, $Res Function(_$ListingImagesImpl) then) =
      __$$ListingImagesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String path, String? url});
}

/// @nodoc
class __$$ListingImagesImplCopyWithImpl<$Res>
    extends _$ListingImagesCopyWithImpl<$Res, _$ListingImagesImpl>
    implements _$$ListingImagesImplCopyWith<$Res> {
  __$$ListingImagesImplCopyWithImpl(
      _$ListingImagesImpl _value, $Res Function(_$ListingImagesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? url = freezed,
  }) {
    return _then(_$ListingImagesImpl(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListingImagesImpl implements _ListingImages {
  _$ListingImagesImpl({required this.path, this.url});

  factory _$ListingImagesImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListingImagesImplFromJson(json);

  @override
  final String path;
  @override
  final String? url;

  @override
  String toString() {
    return 'ListingImages(path: $path, url: $url)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListingImagesImpl &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, path, url);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ListingImagesImplCopyWith<_$ListingImagesImpl> get copyWith =>
      __$$ListingImagesImplCopyWithImpl<_$ListingImagesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListingImagesImplToJson(
      this,
    );
  }
}

abstract class _ListingImages implements ListingImages {
  factory _ListingImages({required final String path, final String? url}) =
      _$ListingImagesImpl;

  factory _ListingImages.fromJson(Map<String, dynamic> json) =
      _$ListingImagesImpl.fromJson;

  @override
  String get path;
  @override
  String? get url;
  @override
  @JsonKey(ignore: true)
  _$$ListingImagesImplCopyWith<_$ListingImagesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
