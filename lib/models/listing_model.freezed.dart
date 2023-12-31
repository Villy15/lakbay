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
  String get address => throw _privateConstructorUsedError;
  List<AvailableDate>? get availableDates => throw _privateConstructorUsedError;
  List<AvailableRoom>? get availableRooms => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  ListingCooperative get cooperative => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<ListingImages>? get images => throw _privateConstructorUsedError;
  bool? get isPublished => throw _privateConstructorUsedError;
  List<ListingCost>? get listingCosts => throw _privateConstructorUsedError;
  num? get pax => throw _privateConstructorUsedError;
  num? get price => throw _privateConstructorUsedError;
  String get province => throw _privateConstructorUsedError;
  String get publisherId => throw _privateConstructorUsedError;
  num? get rating => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get timestamp => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  List<FoodService>? get availableTables => throw _privateConstructorUsedError;
  List<ListingImages>? get menuImgs => throw _privateConstructorUsedError;
  List<AvailableTransport>? get availableTransport =>
      throw _privateConstructorUsedError;
  List<EntertainmentService>? get availableEntertainment =>
      throw _privateConstructorUsedError;
  String? get typeOfTrip => throw _privateConstructorUsedError;
  String? get uid => throw _privateConstructorUsedError;

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
      {String address,
      List<AvailableDate>? availableDates,
      List<AvailableRoom>? availableRooms,
      String category,
      String city,
      ListingCooperative cooperative,
      String description,
      List<ListingImages>? images,
      bool? isPublished,
      List<ListingCost>? listingCosts,
      num? pax,
      num? price,
      String province,
      String publisherId,
      num? rating,
      @TimestampSerializer() DateTime? timestamp,
      String title,
      String type,
      List<FoodService>? availableTables,
      List<ListingImages>? menuImgs,
      List<AvailableTransport>? availableTransport,
      List<EntertainmentService>? availableEntertainment,
      String? typeOfTrip,
      String? uid});

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
    Object? address = null,
    Object? availableDates = freezed,
    Object? availableRooms = freezed,
    Object? category = null,
    Object? city = null,
    Object? cooperative = null,
    Object? description = null,
    Object? images = freezed,
    Object? isPublished = freezed,
    Object? listingCosts = freezed,
    Object? pax = freezed,
    Object? price = freezed,
    Object? province = null,
    Object? publisherId = null,
    Object? rating = freezed,
    Object? timestamp = freezed,
    Object? title = null,
    Object? type = null,
    Object? availableTables = freezed,
    Object? menuImgs = freezed,
    Object? availableTransport = freezed,
    Object? availableEntertainment = freezed,
    Object? typeOfTrip = freezed,
    Object? uid = freezed,
  }) {
    return _then(_value.copyWith(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      availableDates: freezed == availableDates
          ? _value.availableDates
          : availableDates // ignore: cast_nullable_to_non_nullable
              as List<AvailableDate>?,
      availableRooms: freezed == availableRooms
          ? _value.availableRooms
          : availableRooms // ignore: cast_nullable_to_non_nullable
              as List<AvailableRoom>?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      cooperative: null == cooperative
          ? _value.cooperative
          : cooperative // ignore: cast_nullable_to_non_nullable
              as ListingCooperative,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ListingImages>?,
      isPublished: freezed == isPublished
          ? _value.isPublished
          : isPublished // ignore: cast_nullable_to_non_nullable
              as bool?,
      listingCosts: freezed == listingCosts
          ? _value.listingCosts
          : listingCosts // ignore: cast_nullable_to_non_nullable
              as List<ListingCost>?,
      pax: freezed == pax
          ? _value.pax
          : pax // ignore: cast_nullable_to_non_nullable
              as num?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as num?,
      province: null == province
          ? _value.province
          : province // ignore: cast_nullable_to_non_nullable
              as String,
      publisherId: null == publisherId
          ? _value.publisherId
          : publisherId // ignore: cast_nullable_to_non_nullable
              as String,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as num?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      availableTables: freezed == availableTables
          ? _value.availableTables
          : availableTables // ignore: cast_nullable_to_non_nullable
              as List<FoodService>?,
      menuImgs: freezed == menuImgs
          ? _value.menuImgs
          : menuImgs // ignore: cast_nullable_to_non_nullable
              as List<ListingImages>?,
      availableTransport: freezed == availableTransport
          ? _value.availableTransport
          : availableTransport // ignore: cast_nullable_to_non_nullable
              as List<AvailableTransport>?,
      availableEntertainment: freezed == availableEntertainment
          ? _value.availableEntertainment
          : availableEntertainment // ignore: cast_nullable_to_non_nullable
              as List<EntertainmentService>?,
      typeOfTrip: freezed == typeOfTrip
          ? _value.typeOfTrip
          : typeOfTrip // ignore: cast_nullable_to_non_nullable
              as String?,
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {String address,
      List<AvailableDate>? availableDates,
      List<AvailableRoom>? availableRooms,
      String category,
      String city,
      ListingCooperative cooperative,
      String description,
      List<ListingImages>? images,
      bool? isPublished,
      List<ListingCost>? listingCosts,
      num? pax,
      num? price,
      String province,
      String publisherId,
      num? rating,
      @TimestampSerializer() DateTime? timestamp,
      String title,
      String type,
      List<FoodService>? availableTables,
      List<ListingImages>? menuImgs,
      List<AvailableTransport>? availableTransport,
      List<EntertainmentService>? availableEntertainment,
      String? typeOfTrip,
      String? uid});

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
    Object? address = null,
    Object? availableDates = freezed,
    Object? availableRooms = freezed,
    Object? category = null,
    Object? city = null,
    Object? cooperative = null,
    Object? description = null,
    Object? images = freezed,
    Object? isPublished = freezed,
    Object? listingCosts = freezed,
    Object? pax = freezed,
    Object? price = freezed,
    Object? province = null,
    Object? publisherId = null,
    Object? rating = freezed,
    Object? timestamp = freezed,
    Object? title = null,
    Object? type = null,
    Object? availableTables = freezed,
    Object? menuImgs = freezed,
    Object? availableTransport = freezed,
    Object? availableEntertainment = freezed,
    Object? typeOfTrip = freezed,
    Object? uid = freezed,
  }) {
    return _then(_$ListingModelImpl(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      availableDates: freezed == availableDates
          ? _value._availableDates
          : availableDates // ignore: cast_nullable_to_non_nullable
              as List<AvailableDate>?,
      availableRooms: freezed == availableRooms
          ? _value._availableRooms
          : availableRooms // ignore: cast_nullable_to_non_nullable
              as List<AvailableRoom>?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      cooperative: null == cooperative
          ? _value.cooperative
          : cooperative // ignore: cast_nullable_to_non_nullable
              as ListingCooperative,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ListingImages>?,
      isPublished: freezed == isPublished
          ? _value.isPublished
          : isPublished // ignore: cast_nullable_to_non_nullable
              as bool?,
      listingCosts: freezed == listingCosts
          ? _value._listingCosts
          : listingCosts // ignore: cast_nullable_to_non_nullable
              as List<ListingCost>?,
      pax: freezed == pax
          ? _value.pax
          : pax // ignore: cast_nullable_to_non_nullable
              as num?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as num?,
      province: null == province
          ? _value.province
          : province // ignore: cast_nullable_to_non_nullable
              as String,
      publisherId: null == publisherId
          ? _value.publisherId
          : publisherId // ignore: cast_nullable_to_non_nullable
              as String,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as num?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      availableTables: freezed == availableTables
          ? _value._availableTables
          : availableTables // ignore: cast_nullable_to_non_nullable
              as List<FoodService>?,
      menuImgs: freezed == menuImgs
          ? _value._menuImgs
          : menuImgs // ignore: cast_nullable_to_non_nullable
              as List<ListingImages>?,
      availableTransport: freezed == availableTransport
          ? _value._availableTransport
          : availableTransport // ignore: cast_nullable_to_non_nullable
              as List<AvailableTransport>?,
      availableEntertainment: freezed == availableEntertainment
          ? _value._availableEntertainment
          : availableEntertainment // ignore: cast_nullable_to_non_nullable
              as List<EntertainmentService>?,
      typeOfTrip: freezed == typeOfTrip
          ? _value.typeOfTrip
          : typeOfTrip // ignore: cast_nullable_to_non_nullable
              as String?,
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListingModelImpl implements _ListingModel {
  _$ListingModelImpl(
      {required this.address,
      final List<AvailableDate>? availableDates,
      final List<AvailableRoom>? availableRooms,
      required this.category,
      required this.city,
      required this.cooperative,
      required this.description,
      final List<ListingImages>? images,
      this.isPublished,
      final List<ListingCost>? listingCosts,
      this.pax,
      this.price,
      required this.province,
      required this.publisherId,
      this.rating,
      @TimestampSerializer() this.timestamp,
      required this.title,
      required this.type,
      final List<FoodService>? availableTables,
      final List<ListingImages>? menuImgs,
      final List<AvailableTransport>? availableTransport,
      final List<EntertainmentService>? availableEntertainment,
      this.typeOfTrip,
      this.uid})
      : _availableDates = availableDates,
        _availableRooms = availableRooms,
        _images = images,
        _listingCosts = listingCosts,
        _availableTables = availableTables,
        _menuImgs = menuImgs,
        _availableTransport = availableTransport,
        _availableEntertainment = availableEntertainment;

  factory _$ListingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListingModelImplFromJson(json);

  @override
  final String address;
  final List<AvailableDate>? _availableDates;
  @override
  List<AvailableDate>? get availableDates {
    final value = _availableDates;
    if (value == null) return null;
    if (_availableDates is EqualUnmodifiableListView) return _availableDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<AvailableRoom>? _availableRooms;
  @override
  List<AvailableRoom>? get availableRooms {
    final value = _availableRooms;
    if (value == null) return null;
    if (_availableRooms is EqualUnmodifiableListView) return _availableRooms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String category;
  @override
  final String city;
  @override
  final ListingCooperative cooperative;
  @override
  final String description;
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
  final bool? isPublished;
  final List<ListingCost>? _listingCosts;
  @override
  List<ListingCost>? get listingCosts {
    final value = _listingCosts;
    if (value == null) return null;
    if (_listingCosts is EqualUnmodifiableListView) return _listingCosts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final num? pax;
  @override
  final num? price;
  @override
  final String province;
  @override
  final String publisherId;
  @override
  final num? rating;
  @override
  @TimestampSerializer()
  final DateTime? timestamp;
  @override
  final String title;
  @override
  final String type;
  final List<FoodService>? _availableTables;
  @override
  List<FoodService>? get availableTables {
    final value = _availableTables;
    if (value == null) return null;
    if (_availableTables is EqualUnmodifiableListView) return _availableTables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ListingImages>? _menuImgs;
  @override
  List<ListingImages>? get menuImgs {
    final value = _menuImgs;
    if (value == null) return null;
    if (_menuImgs is EqualUnmodifiableListView) return _menuImgs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<AvailableTransport>? _availableTransport;
  @override
  List<AvailableTransport>? get availableTransport {
    final value = _availableTransport;
    if (value == null) return null;
    if (_availableTransport is EqualUnmodifiableListView)
      return _availableTransport;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<EntertainmentService>? _availableEntertainment;
  @override
  List<EntertainmentService>? get availableEntertainment {
    final value = _availableEntertainment;
    if (value == null) return null;
    if (_availableEntertainment is EqualUnmodifiableListView)
      return _availableEntertainment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? typeOfTrip;
  @override
  final String? uid;

  @override
  String toString() {
    return 'ListingModel(address: $address, availableDates: $availableDates, availableRooms: $availableRooms, category: $category, city: $city, cooperative: $cooperative, description: $description, images: $images, isPublished: $isPublished, listingCosts: $listingCosts, pax: $pax, price: $price, province: $province, publisherId: $publisherId, rating: $rating, timestamp: $timestamp, title: $title, type: $type, availableTables: $availableTables, menuImgs: $menuImgs, availableTransport: $availableTransport, availableEntertainment: $availableEntertainment, typeOfTrip: $typeOfTrip, uid: $uid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListingModelImpl &&
            (identical(other.address, address) || other.address == address) &&
            const DeepCollectionEquality()
                .equals(other._availableDates, _availableDates) &&
            const DeepCollectionEquality()
                .equals(other._availableRooms, _availableRooms) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.cooperative, cooperative) ||
                other.cooperative == cooperative) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.isPublished, isPublished) ||
                other.isPublished == isPublished) &&
            const DeepCollectionEquality()
                .equals(other._listingCosts, _listingCosts) &&
            (identical(other.pax, pax) || other.pax == pax) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.province, province) ||
                other.province == province) &&
            (identical(other.publisherId, publisherId) ||
                other.publisherId == publisherId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._availableTables, _availableTables) &&
            const DeepCollectionEquality().equals(other._menuImgs, _menuImgs) &&
            const DeepCollectionEquality()
                .equals(other._availableTransport, _availableTransport) &&
            const DeepCollectionEquality().equals(
                other._availableEntertainment, _availableEntertainment) &&
            (identical(other.typeOfTrip, typeOfTrip) ||
                other.typeOfTrip == typeOfTrip) &&
            (identical(other.uid, uid) || other.uid == uid));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        address,
        const DeepCollectionEquality().hash(_availableDates),
        const DeepCollectionEquality().hash(_availableRooms),
        category,
        city,
        cooperative,
        description,
        const DeepCollectionEquality().hash(_images),
        isPublished,
        const DeepCollectionEquality().hash(_listingCosts),
        pax,
        price,
        province,
        publisherId,
        rating,
        timestamp,
        title,
        type,
        const DeepCollectionEquality().hash(_availableTables),
        const DeepCollectionEquality().hash(_menuImgs),
        const DeepCollectionEquality().hash(_availableTransport),
        const DeepCollectionEquality().hash(_availableEntertainment),
        typeOfTrip,
        uid
      ]);

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
      {required final String address,
      final List<AvailableDate>? availableDates,
      final List<AvailableRoom>? availableRooms,
      required final String category,
      required final String city,
      required final ListingCooperative cooperative,
      required final String description,
      final List<ListingImages>? images,
      final bool? isPublished,
      final List<ListingCost>? listingCosts,
      final num? pax,
      final num? price,
      required final String province,
      required final String publisherId,
      final num? rating,
      @TimestampSerializer() final DateTime? timestamp,
      required final String title,
      required final String type,
      final List<FoodService>? availableTables,
      final List<ListingImages>? menuImgs,
      final List<AvailableTransport>? availableTransport,
      final List<EntertainmentService>? availableEntertainment,
      final String? typeOfTrip,
      final String? uid}) = _$ListingModelImpl;

  factory _ListingModel.fromJson(Map<String, dynamic> json) =
      _$ListingModelImpl.fromJson;

  @override
  String get address;
  @override
  List<AvailableDate>? get availableDates;
  @override
  List<AvailableRoom>? get availableRooms;
  @override
  String get category;
  @override
  String get city;
  @override
  ListingCooperative get cooperative;
  @override
  String get description;
  @override
  List<ListingImages>? get images;
  @override
  bool? get isPublished;
  @override
  List<ListingCost>? get listingCosts;
  @override
  num? get pax;
  @override
  num? get price;
  @override
  String get province;
  @override
  String get publisherId;
  @override
  num? get rating;
  @override
  @TimestampSerializer()
  DateTime? get timestamp;
  @override
  String get title;
  @override
  String get type;
  @override
  List<FoodService>? get availableTables;
  @override
  List<ListingImages>? get menuImgs;
  @override
  List<AvailableTransport>? get availableTransport;
  @override
  List<EntertainmentService>? get availableEntertainment;
  @override
  String? get typeOfTrip;
  @override
  String? get uid;
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
  bool operator ==(Object other) {
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
  bool operator ==(Object other) {
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

ListingCost _$ListingCostFromJson(Map<String, dynamic> json) {
  return _ListingCost.fromJson(json);
}

/// @nodoc
mixin _$ListingCost {
  num? get cost => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ListingCostCopyWith<ListingCost> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListingCostCopyWith<$Res> {
  factory $ListingCostCopyWith(
          ListingCost value, $Res Function(ListingCost) then) =
      _$ListingCostCopyWithImpl<$Res, ListingCost>;
  @useResult
  $Res call({num? cost, String? name});
}

/// @nodoc
class _$ListingCostCopyWithImpl<$Res, $Val extends ListingCost>
    implements $ListingCostCopyWith<$Res> {
  _$ListingCostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cost = freezed,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      cost: freezed == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as num?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ListingCostImplCopyWith<$Res>
    implements $ListingCostCopyWith<$Res> {
  factory _$$ListingCostImplCopyWith(
          _$ListingCostImpl value, $Res Function(_$ListingCostImpl) then) =
      __$$ListingCostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({num? cost, String? name});
}

/// @nodoc
class __$$ListingCostImplCopyWithImpl<$Res>
    extends _$ListingCostCopyWithImpl<$Res, _$ListingCostImpl>
    implements _$$ListingCostImplCopyWith<$Res> {
  __$$ListingCostImplCopyWithImpl(
      _$ListingCostImpl _value, $Res Function(_$ListingCostImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cost = freezed,
    Object? name = freezed,
  }) {
    return _then(_$ListingCostImpl(
      cost: freezed == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as num?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListingCostImpl implements _ListingCost {
  _$ListingCostImpl({this.cost, this.name});

  factory _$ListingCostImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListingCostImplFromJson(json);

  @override
  final num? cost;
  @override
  final String? name;

  @override
  String toString() {
    return 'ListingCost(cost: $cost, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListingCostImpl &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, cost, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ListingCostImplCopyWith<_$ListingCostImpl> get copyWith =>
      __$$ListingCostImplCopyWithImpl<_$ListingCostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListingCostImplToJson(
      this,
    );
  }
}

abstract class _ListingCost implements ListingCost {
  factory _ListingCost({final num? cost, final String? name}) =
      _$ListingCostImpl;

  factory _ListingCost.fromJson(Map<String, dynamic> json) =
      _$ListingCostImpl.fromJson;

  @override
  num? get cost;
  @override
  String? get name;
  @override
  @JsonKey(ignore: true)
  _$$ListingCostImplCopyWith<_$ListingCostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AvailableRoom _$AvailableRoomFromJson(Map<String, dynamic> json) {
  return _AvailableRoom.fromJson(json);
}

/// @nodoc
mixin _$AvailableRoom {
  bool get available => throw _privateConstructorUsedError;
  num get bathrooms => throw _privateConstructorUsedError;
  num get bedrooms => throw _privateConstructorUsedError;
  num get beds => throw _privateConstructorUsedError;
  num get guests => throw _privateConstructorUsedError;
  List<ListingImages>? get images => throw _privateConstructorUsedError;
  num get price => throw _privateConstructorUsedError;
  String get roomId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AvailableRoomCopyWith<AvailableRoom> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailableRoomCopyWith<$Res> {
  factory $AvailableRoomCopyWith(
          AvailableRoom value, $Res Function(AvailableRoom) then) =
      _$AvailableRoomCopyWithImpl<$Res, AvailableRoom>;
  @useResult
  $Res call(
      {bool available,
      num bathrooms,
      num bedrooms,
      num beds,
      num guests,
      List<ListingImages>? images,
      num price,
      String roomId});
}

/// @nodoc
class _$AvailableRoomCopyWithImpl<$Res, $Val extends AvailableRoom>
    implements $AvailableRoomCopyWith<$Res> {
  _$AvailableRoomCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? available = null,
    Object? bathrooms = null,
    Object? bedrooms = null,
    Object? beds = null,
    Object? guests = null,
    Object? images = freezed,
    Object? price = null,
    Object? roomId = null,
  }) {
    return _then(_value.copyWith(
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
      bathrooms: null == bathrooms
          ? _value.bathrooms
          : bathrooms // ignore: cast_nullable_to_non_nullable
              as num,
      bedrooms: null == bedrooms
          ? _value.bedrooms
          : bedrooms // ignore: cast_nullable_to_non_nullable
              as num,
      beds: null == beds
          ? _value.beds
          : beds // ignore: cast_nullable_to_non_nullable
              as num,
      guests: null == guests
          ? _value.guests
          : guests // ignore: cast_nullable_to_non_nullable
              as num,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ListingImages>?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as num,
      roomId: null == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AvailableRoomImplCopyWith<$Res>
    implements $AvailableRoomCopyWith<$Res> {
  factory _$$AvailableRoomImplCopyWith(
          _$AvailableRoomImpl value, $Res Function(_$AvailableRoomImpl) then) =
      __$$AvailableRoomImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool available,
      num bathrooms,
      num bedrooms,
      num beds,
      num guests,
      List<ListingImages>? images,
      num price,
      String roomId});
}

/// @nodoc
class __$$AvailableRoomImplCopyWithImpl<$Res>
    extends _$AvailableRoomCopyWithImpl<$Res, _$AvailableRoomImpl>
    implements _$$AvailableRoomImplCopyWith<$Res> {
  __$$AvailableRoomImplCopyWithImpl(
      _$AvailableRoomImpl _value, $Res Function(_$AvailableRoomImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? available = null,
    Object? bathrooms = null,
    Object? bedrooms = null,
    Object? beds = null,
    Object? guests = null,
    Object? images = freezed,
    Object? price = null,
    Object? roomId = null,
  }) {
    return _then(_$AvailableRoomImpl(
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
      bathrooms: null == bathrooms
          ? _value.bathrooms
          : bathrooms // ignore: cast_nullable_to_non_nullable
              as num,
      bedrooms: null == bedrooms
          ? _value.bedrooms
          : bedrooms // ignore: cast_nullable_to_non_nullable
              as num,
      beds: null == beds
          ? _value.beds
          : beds // ignore: cast_nullable_to_non_nullable
              as num,
      guests: null == guests
          ? _value.guests
          : guests // ignore: cast_nullable_to_non_nullable
              as num,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ListingImages>?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as num,
      roomId: null == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailableRoomImpl implements _AvailableRoom {
  _$AvailableRoomImpl(
      {required this.available,
      required this.bathrooms,
      required this.bedrooms,
      required this.beds,
      required this.guests,
      required final List<ListingImages>? images,
      required this.price,
      required this.roomId})
      : _images = images;

  factory _$AvailableRoomImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailableRoomImplFromJson(json);

  @override
  final bool available;
  @override
  final num bathrooms;
  @override
  final num bedrooms;
  @override
  final num beds;
  @override
  final num guests;
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
  final num price;
  @override
  final String roomId;

  @override
  String toString() {
    return 'AvailableRoom(available: $available, bathrooms: $bathrooms, bedrooms: $bedrooms, beds: $beds, guests: $guests, images: $images, price: $price, roomId: $roomId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailableRoomImpl &&
            (identical(other.available, available) ||
                other.available == available) &&
            (identical(other.bathrooms, bathrooms) ||
                other.bathrooms == bathrooms) &&
            (identical(other.bedrooms, bedrooms) ||
                other.bedrooms == bedrooms) &&
            (identical(other.beds, beds) || other.beds == beds) &&
            (identical(other.guests, guests) || other.guests == guests) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.roomId, roomId) || other.roomId == roomId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      available,
      bathrooms,
      bedrooms,
      beds,
      guests,
      const DeepCollectionEquality().hash(_images),
      price,
      roomId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailableRoomImplCopyWith<_$AvailableRoomImpl> get copyWith =>
      __$$AvailableRoomImplCopyWithImpl<_$AvailableRoomImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailableRoomImplToJson(
      this,
    );
  }
}

abstract class _AvailableRoom implements AvailableRoom {
  factory _AvailableRoom(
      {required final bool available,
      required final num bathrooms,
      required final num bedrooms,
      required final num beds,
      required final num guests,
      required final List<ListingImages>? images,
      required final num price,
      required final String roomId}) = _$AvailableRoomImpl;

  factory _AvailableRoom.fromJson(Map<String, dynamic> json) =
      _$AvailableRoomImpl.fromJson;

  @override
  bool get available;
  @override
  num get bathrooms;
  @override
  num get bedrooms;
  @override
  num get beds;
  @override
  num get guests;
  @override
  List<ListingImages>? get images;
  @override
  num get price;
  @override
  String get roomId;
  @override
  @JsonKey(ignore: true)
  _$$AvailableRoomImplCopyWith<_$AvailableRoomImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AvailableTransport _$AvailableTransportFromJson(Map<String, dynamic> json) {
  return _AvailableTransport.fromJson(json);
}

/// @nodoc
mixin _$AvailableTransport {
  String get transportId => throw _privateConstructorUsedError;
  num get guests => throw _privateConstructorUsedError;
  num get price => throw _privateConstructorUsedError;
  List<ListingImages> get images => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AvailableTransportCopyWith<AvailableTransport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailableTransportCopyWith<$Res> {
  factory $AvailableTransportCopyWith(
          AvailableTransport value, $Res Function(AvailableTransport) then) =
      _$AvailableTransportCopyWithImpl<$Res, AvailableTransport>;
  @useResult
  $Res call(
      {String transportId, num guests, num price, List<ListingImages> images});
}

/// @nodoc
class _$AvailableTransportCopyWithImpl<$Res, $Val extends AvailableTransport>
    implements $AvailableTransportCopyWith<$Res> {
  _$AvailableTransportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transportId = null,
    Object? guests = null,
    Object? price = null,
    Object? images = null,
  }) {
    return _then(_value.copyWith(
      transportId: null == transportId
          ? _value.transportId
          : transportId // ignore: cast_nullable_to_non_nullable
              as String,
      guests: null == guests
          ? _value.guests
          : guests // ignore: cast_nullable_to_non_nullable
              as num,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as num,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ListingImages>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AvailableTransportImplCopyWith<$Res>
    implements $AvailableTransportCopyWith<$Res> {
  factory _$$AvailableTransportImplCopyWith(_$AvailableTransportImpl value,
          $Res Function(_$AvailableTransportImpl) then) =
      __$$AvailableTransportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String transportId, num guests, num price, List<ListingImages> images});
}

/// @nodoc
class __$$AvailableTransportImplCopyWithImpl<$Res>
    extends _$AvailableTransportCopyWithImpl<$Res, _$AvailableTransportImpl>
    implements _$$AvailableTransportImplCopyWith<$Res> {
  __$$AvailableTransportImplCopyWithImpl(_$AvailableTransportImpl _value,
      $Res Function(_$AvailableTransportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transportId = null,
    Object? guests = null,
    Object? price = null,
    Object? images = null,
  }) {
    return _then(_$AvailableTransportImpl(
      transportId: null == transportId
          ? _value.transportId
          : transportId // ignore: cast_nullable_to_non_nullable
              as String,
      guests: null == guests
          ? _value.guests
          : guests // ignore: cast_nullable_to_non_nullable
              as num,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as num,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ListingImages>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailableTransportImpl implements _AvailableTransport {
  _$AvailableTransportImpl(
      {required this.transportId,
      required this.guests,
      required this.price,
      required final List<ListingImages> images})
      : _images = images;

  factory _$AvailableTransportImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailableTransportImplFromJson(json);

  @override
  final String transportId;
  @override
  final num guests;
  @override
  final num price;
  final List<ListingImages> _images;
  @override
  List<ListingImages> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  String toString() {
    return 'AvailableTransport(transportId: $transportId, guests: $guests, price: $price, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailableTransportImpl &&
            (identical(other.transportId, transportId) ||
                other.transportId == transportId) &&
            (identical(other.guests, guests) || other.guests == guests) &&
            (identical(other.price, price) || other.price == price) &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, transportId, guests, price,
      const DeepCollectionEquality().hash(_images));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailableTransportImplCopyWith<_$AvailableTransportImpl> get copyWith =>
      __$$AvailableTransportImplCopyWithImpl<_$AvailableTransportImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailableTransportImplToJson(
      this,
    );
  }
}

abstract class _AvailableTransport implements AvailableTransport {
  factory _AvailableTransport(
      {required final String transportId,
      required final num guests,
      required final num price,
      required final List<ListingImages> images}) = _$AvailableTransportImpl;

  factory _AvailableTransport.fromJson(Map<String, dynamic> json) =
      _$AvailableTransportImpl.fromJson;

  @override
  String get transportId;
  @override
  num get guests;
  @override
  num get price;
  @override
  List<ListingImages> get images;
  @override
  @JsonKey(ignore: true)
  _$$AvailableTransportImplCopyWith<_$AvailableTransportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FoodService _$FoodServiceFromJson(Map<String, dynamic> json) {
  return _FoodService.fromJson(json);
}

/// @nodoc
mixin _$FoodService {
  String get tableId => throw _privateConstructorUsedError;
  num get guests => throw _privateConstructorUsedError;
  bool get isReserved => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FoodServiceCopyWith<FoodService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodServiceCopyWith<$Res> {
  factory $FoodServiceCopyWith(
          FoodService value, $Res Function(FoodService) then) =
      _$FoodServiceCopyWithImpl<$Res, FoodService>;
  @useResult
  $Res call({String tableId, num guests, bool isReserved});
}

/// @nodoc
class _$FoodServiceCopyWithImpl<$Res, $Val extends FoodService>
    implements $FoodServiceCopyWith<$Res> {
  _$FoodServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tableId = null,
    Object? guests = null,
    Object? isReserved = null,
  }) {
    return _then(_value.copyWith(
      tableId: null == tableId
          ? _value.tableId
          : tableId // ignore: cast_nullable_to_non_nullable
              as String,
      guests: null == guests
          ? _value.guests
          : guests // ignore: cast_nullable_to_non_nullable
              as num,
      isReserved: null == isReserved
          ? _value.isReserved
          : isReserved // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FoodServiceImplCopyWith<$Res>
    implements $FoodServiceCopyWith<$Res> {
  factory _$$FoodServiceImplCopyWith(
          _$FoodServiceImpl value, $Res Function(_$FoodServiceImpl) then) =
      __$$FoodServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String tableId, num guests, bool isReserved});
}

/// @nodoc
class __$$FoodServiceImplCopyWithImpl<$Res>
    extends _$FoodServiceCopyWithImpl<$Res, _$FoodServiceImpl>
    implements _$$FoodServiceImplCopyWith<$Res> {
  __$$FoodServiceImplCopyWithImpl(
      _$FoodServiceImpl _value, $Res Function(_$FoodServiceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tableId = null,
    Object? guests = null,
    Object? isReserved = null,
  }) {
    return _then(_$FoodServiceImpl(
      tableId: null == tableId
          ? _value.tableId
          : tableId // ignore: cast_nullable_to_non_nullable
              as String,
      guests: null == guests
          ? _value.guests
          : guests // ignore: cast_nullable_to_non_nullable
              as num,
      isReserved: null == isReserved
          ? _value.isReserved
          : isReserved // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodServiceImpl implements _FoodService {
  _$FoodServiceImpl(
      {required this.tableId, required this.guests, required this.isReserved});

  factory _$FoodServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodServiceImplFromJson(json);

  @override
  final String tableId;
  @override
  final num guests;
  @override
  final bool isReserved;

  @override
  String toString() {
    return 'FoodService(tableId: $tableId, guests: $guests, isReserved: $isReserved)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodServiceImpl &&
            (identical(other.tableId, tableId) || other.tableId == tableId) &&
            (identical(other.guests, guests) || other.guests == guests) &&
            (identical(other.isReserved, isReserved) ||
                other.isReserved == isReserved));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, tableId, guests, isReserved);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodServiceImplCopyWith<_$FoodServiceImpl> get copyWith =>
      __$$FoodServiceImplCopyWithImpl<_$FoodServiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodServiceImplToJson(
      this,
    );
  }
}

abstract class _FoodService implements FoodService {
  factory _FoodService(
      {required final String tableId,
      required final num guests,
      required final bool isReserved}) = _$FoodServiceImpl;

  factory _FoodService.fromJson(Map<String, dynamic> json) =
      _$FoodServiceImpl.fromJson;

  @override
  String get tableId;
  @override
  num get guests;
  @override
  bool get isReserved;
  @override
  @JsonKey(ignore: true)
  _$$FoodServiceImplCopyWith<_$FoodServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EntertainmentService _$EntertainmentServiceFromJson(Map<String, dynamic> json) {
  return _EntertainmentService.fromJson(json);
}

/// @nodoc
mixin _$EntertainmentService {
  String get entertainmentId => throw _privateConstructorUsedError;
  num get guests => throw _privateConstructorUsedError;
  num get price => throw _privateConstructorUsedError;
  List<ListingImages> get entertainmentImgs =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EntertainmentServiceCopyWith<EntertainmentService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntertainmentServiceCopyWith<$Res> {
  factory $EntertainmentServiceCopyWith(EntertainmentService value,
          $Res Function(EntertainmentService) then) =
      _$EntertainmentServiceCopyWithImpl<$Res, EntertainmentService>;
  @useResult
  $Res call(
      {String entertainmentId,
      num guests,
      num price,
      List<ListingImages> entertainmentImgs});
}

/// @nodoc
class _$EntertainmentServiceCopyWithImpl<$Res,
        $Val extends EntertainmentService>
    implements $EntertainmentServiceCopyWith<$Res> {
  _$EntertainmentServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entertainmentId = null,
    Object? guests = null,
    Object? price = null,
    Object? entertainmentImgs = null,
  }) {
    return _then(_value.copyWith(
      entertainmentId: null == entertainmentId
          ? _value.entertainmentId
          : entertainmentId // ignore: cast_nullable_to_non_nullable
              as String,
      guests: null == guests
          ? _value.guests
          : guests // ignore: cast_nullable_to_non_nullable
              as num,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as num,
      entertainmentImgs: null == entertainmentImgs
          ? _value.entertainmentImgs
          : entertainmentImgs // ignore: cast_nullable_to_non_nullable
              as List<ListingImages>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EntertainmentServiceImplCopyWith<$Res>
    implements $EntertainmentServiceCopyWith<$Res> {
  factory _$$EntertainmentServiceImplCopyWith(_$EntertainmentServiceImpl value,
          $Res Function(_$EntertainmentServiceImpl) then) =
      __$$EntertainmentServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String entertainmentId,
      num guests,
      num price,
      List<ListingImages> entertainmentImgs});
}

/// @nodoc
class __$$EntertainmentServiceImplCopyWithImpl<$Res>
    extends _$EntertainmentServiceCopyWithImpl<$Res, _$EntertainmentServiceImpl>
    implements _$$EntertainmentServiceImplCopyWith<$Res> {
  __$$EntertainmentServiceImplCopyWithImpl(_$EntertainmentServiceImpl _value,
      $Res Function(_$EntertainmentServiceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entertainmentId = null,
    Object? guests = null,
    Object? price = null,
    Object? entertainmentImgs = null,
  }) {
    return _then(_$EntertainmentServiceImpl(
      entertainmentId: null == entertainmentId
          ? _value.entertainmentId
          : entertainmentId // ignore: cast_nullable_to_non_nullable
              as String,
      guests: null == guests
          ? _value.guests
          : guests // ignore: cast_nullable_to_non_nullable
              as num,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as num,
      entertainmentImgs: null == entertainmentImgs
          ? _value._entertainmentImgs
          : entertainmentImgs // ignore: cast_nullable_to_non_nullable
              as List<ListingImages>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EntertainmentServiceImpl implements _EntertainmentService {
  _$EntertainmentServiceImpl(
      {required this.entertainmentId,
      required this.guests,
      required this.price,
      required final List<ListingImages> entertainmentImgs})
      : _entertainmentImgs = entertainmentImgs;

  factory _$EntertainmentServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$EntertainmentServiceImplFromJson(json);

  @override
  final String entertainmentId;
  @override
  final num guests;
  @override
  final num price;
  final List<ListingImages> _entertainmentImgs;
  @override
  List<ListingImages> get entertainmentImgs {
    if (_entertainmentImgs is EqualUnmodifiableListView)
      return _entertainmentImgs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entertainmentImgs);
  }

  @override
  String toString() {
    return 'EntertainmentService(entertainmentId: $entertainmentId, guests: $guests, price: $price, entertainmentImgs: $entertainmentImgs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntertainmentServiceImpl &&
            (identical(other.entertainmentId, entertainmentId) ||
                other.entertainmentId == entertainmentId) &&
            (identical(other.guests, guests) || other.guests == guests) &&
            (identical(other.price, price) || other.price == price) &&
            const DeepCollectionEquality()
                .equals(other._entertainmentImgs, _entertainmentImgs));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, entertainmentId, guests, price,
      const DeepCollectionEquality().hash(_entertainmentImgs));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EntertainmentServiceImplCopyWith<_$EntertainmentServiceImpl>
      get copyWith =>
          __$$EntertainmentServiceImplCopyWithImpl<_$EntertainmentServiceImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EntertainmentServiceImplToJson(
      this,
    );
  }
}

abstract class _EntertainmentService implements EntertainmentService {
  factory _EntertainmentService(
          {required final String entertainmentId,
          required final num guests,
          required final num price,
          required final List<ListingImages> entertainmentImgs}) =
      _$EntertainmentServiceImpl;

  factory _EntertainmentService.fromJson(Map<String, dynamic> json) =
      _$EntertainmentServiceImpl.fromJson;

  @override
  String get entertainmentId;
  @override
  num get guests;
  @override
  num get price;
  @override
  List<ListingImages> get entertainmentImgs;
  @override
  @JsonKey(ignore: true)
  _$$EntertainmentServiceImplCopyWith<_$EntertainmentServiceImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AvailableDate _$AvailableDateFromJson(Map<String, dynamic> json) {
  return _AvailableDate.fromJson(json);
}

/// @nodoc
mixin _$AvailableDate {
  bool get available => throw _privateConstructorUsedError;
  List<AvailableTime> get availableTimes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AvailableDateCopyWith<AvailableDate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailableDateCopyWith<$Res> {
  factory $AvailableDateCopyWith(
          AvailableDate value, $Res Function(AvailableDate) then) =
      _$AvailableDateCopyWithImpl<$Res, AvailableDate>;
  @useResult
  $Res call({bool available, List<AvailableTime> availableTimes});
}

/// @nodoc
class _$AvailableDateCopyWithImpl<$Res, $Val extends AvailableDate>
    implements $AvailableDateCopyWith<$Res> {
  _$AvailableDateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? available = null,
    Object? availableTimes = null,
  }) {
    return _then(_value.copyWith(
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
      availableTimes: null == availableTimes
          ? _value.availableTimes
          : availableTimes // ignore: cast_nullable_to_non_nullable
              as List<AvailableTime>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AvailableDateImplCopyWith<$Res>
    implements $AvailableDateCopyWith<$Res> {
  factory _$$AvailableDateImplCopyWith(
          _$AvailableDateImpl value, $Res Function(_$AvailableDateImpl) then) =
      __$$AvailableDateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool available, List<AvailableTime> availableTimes});
}

/// @nodoc
class __$$AvailableDateImplCopyWithImpl<$Res>
    extends _$AvailableDateCopyWithImpl<$Res, _$AvailableDateImpl>
    implements _$$AvailableDateImplCopyWith<$Res> {
  __$$AvailableDateImplCopyWithImpl(
      _$AvailableDateImpl _value, $Res Function(_$AvailableDateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? available = null,
    Object? availableTimes = null,
  }) {
    return _then(_$AvailableDateImpl(
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
      availableTimes: null == availableTimes
          ? _value._availableTimes
          : availableTimes // ignore: cast_nullable_to_non_nullable
              as List<AvailableTime>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailableDateImpl implements _AvailableDate {
  _$AvailableDateImpl(
      {required this.available,
      required final List<AvailableTime> availableTimes})
      : _availableTimes = availableTimes;

  factory _$AvailableDateImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailableDateImplFromJson(json);

  @override
  final bool available;
  final List<AvailableTime> _availableTimes;
  @override
  List<AvailableTime> get availableTimes {
    if (_availableTimes is EqualUnmodifiableListView) return _availableTimes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableTimes);
  }

  @override
  String toString() {
    return 'AvailableDate(available: $available, availableTimes: $availableTimes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailableDateImpl &&
            (identical(other.available, available) ||
                other.available == available) &&
            const DeepCollectionEquality()
                .equals(other._availableTimes, _availableTimes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, available,
      const DeepCollectionEquality().hash(_availableTimes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailableDateImplCopyWith<_$AvailableDateImpl> get copyWith =>
      __$$AvailableDateImplCopyWithImpl<_$AvailableDateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailableDateImplToJson(
      this,
    );
  }
}

abstract class _AvailableDate implements AvailableDate {
  factory _AvailableDate(
      {required final bool available,
      required final List<AvailableTime> availableTimes}) = _$AvailableDateImpl;

  factory _AvailableDate.fromJson(Map<String, dynamic> json) =
      _$AvailableDateImpl.fromJson;

  @override
  bool get available;
  @override
  List<AvailableTime> get availableTimes;
  @override
  @JsonKey(ignore: true)
  _$$AvailableDateImplCopyWith<_$AvailableDateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AvailableTime _$AvailableTimeFromJson(Map<String, dynamic> json) {
  return _AvailableTime.fromJson(json);
}

/// @nodoc
mixin _$AvailableTime {
  bool get available => throw _privateConstructorUsedError;
  num get currentPax => throw _privateConstructorUsedError;
  num get maxPax => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime get time => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AvailableTimeCopyWith<AvailableTime> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailableTimeCopyWith<$Res> {
  factory $AvailableTimeCopyWith(
          AvailableTime value, $Res Function(AvailableTime) then) =
      _$AvailableTimeCopyWithImpl<$Res, AvailableTime>;
  @useResult
  $Res call(
      {bool available,
      num currentPax,
      num maxPax,
      @TimestampSerializer() DateTime time});
}

/// @nodoc
class _$AvailableTimeCopyWithImpl<$Res, $Val extends AvailableTime>
    implements $AvailableTimeCopyWith<$Res> {
  _$AvailableTimeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? available = null,
    Object? currentPax = null,
    Object? maxPax = null,
    Object? time = null,
  }) {
    return _then(_value.copyWith(
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPax: null == currentPax
          ? _value.currentPax
          : currentPax // ignore: cast_nullable_to_non_nullable
              as num,
      maxPax: null == maxPax
          ? _value.maxPax
          : maxPax // ignore: cast_nullable_to_non_nullable
              as num,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AvailableTimeImplCopyWith<$Res>
    implements $AvailableTimeCopyWith<$Res> {
  factory _$$AvailableTimeImplCopyWith(
          _$AvailableTimeImpl value, $Res Function(_$AvailableTimeImpl) then) =
      __$$AvailableTimeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool available,
      num currentPax,
      num maxPax,
      @TimestampSerializer() DateTime time});
}

/// @nodoc
class __$$AvailableTimeImplCopyWithImpl<$Res>
    extends _$AvailableTimeCopyWithImpl<$Res, _$AvailableTimeImpl>
    implements _$$AvailableTimeImplCopyWith<$Res> {
  __$$AvailableTimeImplCopyWithImpl(
      _$AvailableTimeImpl _value, $Res Function(_$AvailableTimeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? available = null,
    Object? currentPax = null,
    Object? maxPax = null,
    Object? time = null,
  }) {
    return _then(_$AvailableTimeImpl(
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPax: null == currentPax
          ? _value.currentPax
          : currentPax // ignore: cast_nullable_to_non_nullable
              as num,
      maxPax: null == maxPax
          ? _value.maxPax
          : maxPax // ignore: cast_nullable_to_non_nullable
              as num,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailableTimeImpl implements _AvailableTime {
  _$AvailableTimeImpl(
      {required this.available,
      required this.currentPax,
      required this.maxPax,
      @TimestampSerializer() required this.time});

  factory _$AvailableTimeImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailableTimeImplFromJson(json);

  @override
  final bool available;
  @override
  final num currentPax;
  @override
  final num maxPax;
  @override
  @TimestampSerializer()
  final DateTime time;

  @override
  String toString() {
    return 'AvailableTime(available: $available, currentPax: $currentPax, maxPax: $maxPax, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailableTimeImpl &&
            (identical(other.available, available) ||
                other.available == available) &&
            (identical(other.currentPax, currentPax) ||
                other.currentPax == currentPax) &&
            (identical(other.maxPax, maxPax) || other.maxPax == maxPax) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, available, currentPax, maxPax, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailableTimeImplCopyWith<_$AvailableTimeImpl> get copyWith =>
      __$$AvailableTimeImplCopyWithImpl<_$AvailableTimeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailableTimeImplToJson(
      this,
    );
  }
}

abstract class _AvailableTime implements AvailableTime {
  factory _AvailableTime(
          {required final bool available,
          required final num currentPax,
          required final num maxPax,
          @TimestampSerializer() required final DateTime time}) =
      _$AvailableTimeImpl;

  factory _AvailableTime.fromJson(Map<String, dynamic> json) =
      _$AvailableTimeImpl.fromJson;

  @override
  bool get available;
  @override
  num get currentPax;
  @override
  num get maxPax;
  @override
  @TimestampSerializer()
  DateTime get time;
  @override
  @JsonKey(ignore: true)
  _$$AvailableTimeImplCopyWith<_$AvailableTimeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
