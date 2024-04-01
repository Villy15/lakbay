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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ListingModel _$ListingModelFromJson(Map<String, dynamic> json) {
  return _ListingModel.fromJson(json);
}

/// @nodoc
mixin _$ListingModel {
  String get address => throw _privateConstructorUsedError;
  List<AvailableDate>? get availableDates => throw _privateConstructorUsedError;
  List<AvailableTime>? get availableTimes => throw _privateConstructorUsedError;
  List<AvailableRoom>? get availableRooms => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  num? get cancellationRate => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay? get checkIn => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay? get checkOut => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  num? get cancellationPeriod => throw _privateConstructorUsedError;
  ListingCooperative get cooperative => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String>? get driverNames => throw _privateConstructorUsedError;
  List<String>? get driverIds => throw _privateConstructorUsedError;
  num? get downpaymentRate => throw _privateConstructorUsedError;
  num? get fixedCancellationRate => throw _privateConstructorUsedError;
  List<ListingImages>? get images => throw _privateConstructorUsedError;
  bool? get isPublished => throw _privateConstructorUsedError;
  List<ListingCost>? get listingCosts => throw _privateConstructorUsedError;
  num? get numberOfUnits => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay? get openingHours => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay? get closingHours => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay? get duration =>
      throw _privateConstructorUsedError; //[Travel Duration, Entertainment Duration]
  num? get pax => throw _privateConstructorUsedError;
  num? get price => throw _privateConstructorUsedError;
  String get province => throw _privateConstructorUsedError;
  String get publisherId => throw _privateConstructorUsedError;
  String get publisherName => throw _privateConstructorUsedError;
  String? get pickUp => throw _privateConstructorUsedError;
  String? get destination => throw _privateConstructorUsedError;
  String? get guestInfo => throw _privateConstructorUsedError;
  num? get rating => throw _privateConstructorUsedError;
  List<BookingTask>? get fixedTasks => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get timestamp => throw _privateConstructorUsedError;
  List<AvailableDay>? get availableDays => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get type =>
      throw _privateConstructorUsedError; //[Private, Public, Rentals, Watching/Performances, Activities]
  List<FoodService>? get availableDeals => throw _privateConstructorUsedError;
  List<ListingImages>? get menuImgs => throw _privateConstructorUsedError;
  AvailableTransport? get availableTransport =>
      throw _privateConstructorUsedError; // add the map of available tables here
  List<List<dynamic>>? get availableTables =>
      throw _privateConstructorUsedError;
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
      List<AvailableTime>? availableTimes,
      List<AvailableRoom>? availableRooms,
      String category,
      num? cancellationRate,
      @TimeOfDayConverter() TimeOfDay? checkIn,
      @TimeOfDayConverter() TimeOfDay? checkOut,
      String city,
      num? cancellationPeriod,
      ListingCooperative cooperative,
      String description,
      List<String>? driverNames,
      List<String>? driverIds,
      num? downpaymentRate,
      num? fixedCancellationRate,
      List<ListingImages>? images,
      bool? isPublished,
      List<ListingCost>? listingCosts,
      num? numberOfUnits,
      @TimeOfDayConverter() TimeOfDay? openingHours,
      @TimeOfDayConverter() TimeOfDay? closingHours,
      @TimeOfDayConverter() TimeOfDay? duration,
      num? pax,
      num? price,
      String province,
      String publisherId,
      String publisherName,
      String? pickUp,
      String? destination,
      String? guestInfo,
      num? rating,
      List<BookingTask>? fixedTasks,
      @TimestampSerializer() DateTime? timestamp,
      List<AvailableDay>? availableDays,
      String title,
      String? type,
      List<FoodService>? availableDeals,
      List<ListingImages>? menuImgs,
      AvailableTransport? availableTransport,
      List<List<dynamic>>? availableTables,
      String? uid});

  $ListingCooperativeCopyWith<$Res> get cooperative;
  $AvailableTransportCopyWith<$Res>? get availableTransport;
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
    Object? availableTimes = freezed,
    Object? availableRooms = freezed,
    Object? category = null,
    Object? cancellationRate = freezed,
    Object? checkIn = freezed,
    Object? checkOut = freezed,
    Object? city = null,
    Object? cancellationPeriod = freezed,
    Object? cooperative = null,
    Object? description = null,
    Object? driverNames = freezed,
    Object? driverIds = freezed,
    Object? downpaymentRate = freezed,
    Object? fixedCancellationRate = freezed,
    Object? images = freezed,
    Object? isPublished = freezed,
    Object? listingCosts = freezed,
    Object? numberOfUnits = freezed,
    Object? openingHours = freezed,
    Object? closingHours = freezed,
    Object? duration = freezed,
    Object? pax = freezed,
    Object? price = freezed,
    Object? province = null,
    Object? publisherId = null,
    Object? publisherName = null,
    Object? pickUp = freezed,
    Object? destination = freezed,
    Object? guestInfo = freezed,
    Object? rating = freezed,
    Object? fixedTasks = freezed,
    Object? timestamp = freezed,
    Object? availableDays = freezed,
    Object? title = null,
    Object? type = freezed,
    Object? availableDeals = freezed,
    Object? menuImgs = freezed,
    Object? availableTransport = freezed,
    Object? availableTables = freezed,
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
      availableTimes: freezed == availableTimes
          ? _value.availableTimes
          : availableTimes // ignore: cast_nullable_to_non_nullable
              as List<AvailableTime>?,
      availableRooms: freezed == availableRooms
          ? _value.availableRooms
          : availableRooms // ignore: cast_nullable_to_non_nullable
              as List<AvailableRoom>?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      cancellationRate: freezed == cancellationRate
          ? _value.cancellationRate
          : cancellationRate // ignore: cast_nullable_to_non_nullable
              as num?,
      checkIn: freezed == checkIn
          ? _value.checkIn
          : checkIn // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      checkOut: freezed == checkOut
          ? _value.checkOut
          : checkOut // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      cancellationPeriod: freezed == cancellationPeriod
          ? _value.cancellationPeriod
          : cancellationPeriod // ignore: cast_nullable_to_non_nullable
              as num?,
      cooperative: null == cooperative
          ? _value.cooperative
          : cooperative // ignore: cast_nullable_to_non_nullable
              as ListingCooperative,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      driverNames: freezed == driverNames
          ? _value.driverNames
          : driverNames // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      driverIds: freezed == driverIds
          ? _value.driverIds
          : driverIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      downpaymentRate: freezed == downpaymentRate
          ? _value.downpaymentRate
          : downpaymentRate // ignore: cast_nullable_to_non_nullable
              as num?,
      fixedCancellationRate: freezed == fixedCancellationRate
          ? _value.fixedCancellationRate
          : fixedCancellationRate // ignore: cast_nullable_to_non_nullable
              as num?,
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
      numberOfUnits: freezed == numberOfUnits
          ? _value.numberOfUnits
          : numberOfUnits // ignore: cast_nullable_to_non_nullable
              as num?,
      openingHours: freezed == openingHours
          ? _value.openingHours
          : openingHours // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      closingHours: freezed == closingHours
          ? _value.closingHours
          : closingHours // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
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
      publisherName: null == publisherName
          ? _value.publisherName
          : publisherName // ignore: cast_nullable_to_non_nullable
              as String,
      pickUp: freezed == pickUp
          ? _value.pickUp
          : pickUp // ignore: cast_nullable_to_non_nullable
              as String?,
      destination: freezed == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String?,
      guestInfo: freezed == guestInfo
          ? _value.guestInfo
          : guestInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as num?,
      fixedTasks: freezed == fixedTasks
          ? _value.fixedTasks
          : fixedTasks // ignore: cast_nullable_to_non_nullable
              as List<BookingTask>?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      availableDays: freezed == availableDays
          ? _value.availableDays
          : availableDays // ignore: cast_nullable_to_non_nullable
              as List<AvailableDay>?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      availableDeals: freezed == availableDeals
          ? _value.availableDeals
          : availableDeals // ignore: cast_nullable_to_non_nullable
              as List<FoodService>?,
      menuImgs: freezed == menuImgs
          ? _value.menuImgs
          : menuImgs // ignore: cast_nullable_to_non_nullable
              as List<ListingImages>?,
      availableTransport: freezed == availableTransport
          ? _value.availableTransport
          : availableTransport // ignore: cast_nullable_to_non_nullable
              as AvailableTransport?,
      availableTables: freezed == availableTables
          ? _value.availableTables
          : availableTables // ignore: cast_nullable_to_non_nullable
              as List<List<dynamic>>?,
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

  @override
  @pragma('vm:prefer-inline')
  $AvailableTransportCopyWith<$Res>? get availableTransport {
    if (_value.availableTransport == null) {
      return null;
    }

    return $AvailableTransportCopyWith<$Res>(_value.availableTransport!,
        (value) {
      return _then(_value.copyWith(availableTransport: value) as $Val);
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
      List<AvailableTime>? availableTimes,
      List<AvailableRoom>? availableRooms,
      String category,
      num? cancellationRate,
      @TimeOfDayConverter() TimeOfDay? checkIn,
      @TimeOfDayConverter() TimeOfDay? checkOut,
      String city,
      num? cancellationPeriod,
      ListingCooperative cooperative,
      String description,
      List<String>? driverNames,
      List<String>? driverIds,
      num? downpaymentRate,
      num? fixedCancellationRate,
      List<ListingImages>? images,
      bool? isPublished,
      List<ListingCost>? listingCosts,
      num? numberOfUnits,
      @TimeOfDayConverter() TimeOfDay? openingHours,
      @TimeOfDayConverter() TimeOfDay? closingHours,
      @TimeOfDayConverter() TimeOfDay? duration,
      num? pax,
      num? price,
      String province,
      String publisherId,
      String publisherName,
      String? pickUp,
      String? destination,
      String? guestInfo,
      num? rating,
      List<BookingTask>? fixedTasks,
      @TimestampSerializer() DateTime? timestamp,
      List<AvailableDay>? availableDays,
      String title,
      String? type,
      List<FoodService>? availableDeals,
      List<ListingImages>? menuImgs,
      AvailableTransport? availableTransport,
      List<List<dynamic>>? availableTables,
      String? uid});

  @override
  $ListingCooperativeCopyWith<$Res> get cooperative;
  @override
  $AvailableTransportCopyWith<$Res>? get availableTransport;
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
    Object? availableTimes = freezed,
    Object? availableRooms = freezed,
    Object? category = null,
    Object? cancellationRate = freezed,
    Object? checkIn = freezed,
    Object? checkOut = freezed,
    Object? city = null,
    Object? cancellationPeriod = freezed,
    Object? cooperative = null,
    Object? description = null,
    Object? driverNames = freezed,
    Object? driverIds = freezed,
    Object? downpaymentRate = freezed,
    Object? fixedCancellationRate = freezed,
    Object? images = freezed,
    Object? isPublished = freezed,
    Object? listingCosts = freezed,
    Object? numberOfUnits = freezed,
    Object? openingHours = freezed,
    Object? closingHours = freezed,
    Object? duration = freezed,
    Object? pax = freezed,
    Object? price = freezed,
    Object? province = null,
    Object? publisherId = null,
    Object? publisherName = null,
    Object? pickUp = freezed,
    Object? destination = freezed,
    Object? guestInfo = freezed,
    Object? rating = freezed,
    Object? fixedTasks = freezed,
    Object? timestamp = freezed,
    Object? availableDays = freezed,
    Object? title = null,
    Object? type = freezed,
    Object? availableDeals = freezed,
    Object? menuImgs = freezed,
    Object? availableTransport = freezed,
    Object? availableTables = freezed,
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
      availableTimes: freezed == availableTimes
          ? _value._availableTimes
          : availableTimes // ignore: cast_nullable_to_non_nullable
              as List<AvailableTime>?,
      availableRooms: freezed == availableRooms
          ? _value._availableRooms
          : availableRooms // ignore: cast_nullable_to_non_nullable
              as List<AvailableRoom>?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      cancellationRate: freezed == cancellationRate
          ? _value.cancellationRate
          : cancellationRate // ignore: cast_nullable_to_non_nullable
              as num?,
      checkIn: freezed == checkIn
          ? _value.checkIn
          : checkIn // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      checkOut: freezed == checkOut
          ? _value.checkOut
          : checkOut // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      cancellationPeriod: freezed == cancellationPeriod
          ? _value.cancellationPeriod
          : cancellationPeriod // ignore: cast_nullable_to_non_nullable
              as num?,
      cooperative: null == cooperative
          ? _value.cooperative
          : cooperative // ignore: cast_nullable_to_non_nullable
              as ListingCooperative,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      driverNames: freezed == driverNames
          ? _value._driverNames
          : driverNames // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      driverIds: freezed == driverIds
          ? _value._driverIds
          : driverIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      downpaymentRate: freezed == downpaymentRate
          ? _value.downpaymentRate
          : downpaymentRate // ignore: cast_nullable_to_non_nullable
              as num?,
      fixedCancellationRate: freezed == fixedCancellationRate
          ? _value.fixedCancellationRate
          : fixedCancellationRate // ignore: cast_nullable_to_non_nullable
              as num?,
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
      numberOfUnits: freezed == numberOfUnits
          ? _value.numberOfUnits
          : numberOfUnits // ignore: cast_nullable_to_non_nullable
              as num?,
      openingHours: freezed == openingHours
          ? _value.openingHours
          : openingHours // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      closingHours: freezed == closingHours
          ? _value.closingHours
          : closingHours // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
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
      publisherName: null == publisherName
          ? _value.publisherName
          : publisherName // ignore: cast_nullable_to_non_nullable
              as String,
      pickUp: freezed == pickUp
          ? _value.pickUp
          : pickUp // ignore: cast_nullable_to_non_nullable
              as String?,
      destination: freezed == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String?,
      guestInfo: freezed == guestInfo
          ? _value.guestInfo
          : guestInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as num?,
      fixedTasks: freezed == fixedTasks
          ? _value._fixedTasks
          : fixedTasks // ignore: cast_nullable_to_non_nullable
              as List<BookingTask>?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      availableDays: freezed == availableDays
          ? _value._availableDays
          : availableDays // ignore: cast_nullable_to_non_nullable
              as List<AvailableDay>?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      availableDeals: freezed == availableDeals
          ? _value._availableDeals
          : availableDeals // ignore: cast_nullable_to_non_nullable
              as List<FoodService>?,
      menuImgs: freezed == menuImgs
          ? _value._menuImgs
          : menuImgs // ignore: cast_nullable_to_non_nullable
              as List<ListingImages>?,
      availableTransport: freezed == availableTransport
          ? _value.availableTransport
          : availableTransport // ignore: cast_nullable_to_non_nullable
              as AvailableTransport?,
      availableTables: freezed == availableTables
          ? _value._availableTables
          : availableTables // ignore: cast_nullable_to_non_nullable
              as List<List<dynamic>>?,
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
      final List<AvailableTime>? availableTimes,
      final List<AvailableRoom>? availableRooms,
      required this.category,
      this.cancellationRate,
      @TimeOfDayConverter() this.checkIn,
      @TimeOfDayConverter() this.checkOut,
      required this.city,
      this.cancellationPeriod,
      required this.cooperative,
      required this.description,
      final List<String>? driverNames,
      final List<String>? driverIds,
      this.downpaymentRate,
      this.fixedCancellationRate,
      final List<ListingImages>? images,
      this.isPublished,
      final List<ListingCost>? listingCosts,
      this.numberOfUnits,
      @TimeOfDayConverter() this.openingHours,
      @TimeOfDayConverter() this.closingHours,
      @TimeOfDayConverter() this.duration,
      this.pax,
      this.price,
      required this.province,
      required this.publisherId,
      required this.publisherName,
      this.pickUp,
      this.destination,
      this.guestInfo,
      this.rating,
      final List<BookingTask>? fixedTasks,
      @TimestampSerializer() this.timestamp,
      final List<AvailableDay>? availableDays,
      required this.title,
      this.type,
      final List<FoodService>? availableDeals,
      final List<ListingImages>? menuImgs,
      this.availableTransport,
      final List<List<dynamic>>? availableTables,
      this.uid})
      : _availableDates = availableDates,
        _availableTimes = availableTimes,
        _availableRooms = availableRooms,
        _driverNames = driverNames,
        _driverIds = driverIds,
        _images = images,
        _listingCosts = listingCosts,
        _fixedTasks = fixedTasks,
        _availableDays = availableDays,
        _availableDeals = availableDeals,
        _menuImgs = menuImgs,
        _availableTables = availableTables;

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

  final List<AvailableTime>? _availableTimes;
  @override
  List<AvailableTime>? get availableTimes {
    final value = _availableTimes;
    if (value == null) return null;
    if (_availableTimes is EqualUnmodifiableListView) return _availableTimes;
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
  final num? cancellationRate;
  @override
  @TimeOfDayConverter()
  final TimeOfDay? checkIn;
  @override
  @TimeOfDayConverter()
  final TimeOfDay? checkOut;
  @override
  final String city;
  @override
  final num? cancellationPeriod;
  @override
  final ListingCooperative cooperative;
  @override
  final String description;
  final List<String>? _driverNames;
  @override
  List<String>? get driverNames {
    final value = _driverNames;
    if (value == null) return null;
    if (_driverNames is EqualUnmodifiableListView) return _driverNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _driverIds;
  @override
  List<String>? get driverIds {
    final value = _driverIds;
    if (value == null) return null;
    if (_driverIds is EqualUnmodifiableListView) return _driverIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final num? downpaymentRate;
  @override
  final num? fixedCancellationRate;
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
  final num? numberOfUnits;
  @override
  @TimeOfDayConverter()
  final TimeOfDay? openingHours;
  @override
  @TimeOfDayConverter()
  final TimeOfDay? closingHours;
  @override
  @TimeOfDayConverter()
  final TimeOfDay? duration;
//[Travel Duration, Entertainment Duration]
  @override
  final num? pax;
  @override
  final num? price;
  @override
  final String province;
  @override
  final String publisherId;
  @override
  final String publisherName;
  @override
  final String? pickUp;
  @override
  final String? destination;
  @override
  final String? guestInfo;
  @override
  final num? rating;
  final List<BookingTask>? _fixedTasks;
  @override
  List<BookingTask>? get fixedTasks {
    final value = _fixedTasks;
    if (value == null) return null;
    if (_fixedTasks is EqualUnmodifiableListView) return _fixedTasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @TimestampSerializer()
  final DateTime? timestamp;
  final List<AvailableDay>? _availableDays;
  @override
  List<AvailableDay>? get availableDays {
    final value = _availableDays;
    if (value == null) return null;
    if (_availableDays is EqualUnmodifiableListView) return _availableDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String title;
  @override
  final String? type;
//[Private, Public, Rentals, Watching/Performances, Activities]
  final List<FoodService>? _availableDeals;
//[Private, Public, Rentals, Watching/Performances, Activities]
  @override
  List<FoodService>? get availableDeals {
    final value = _availableDeals;
    if (value == null) return null;
    if (_availableDeals is EqualUnmodifiableListView) return _availableDeals;
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

  @override
  final AvailableTransport? availableTransport;
// add the map of available tables here
  final List<List<dynamic>>? _availableTables;
// add the map of available tables here
  @override
  List<List<dynamic>>? get availableTables {
    final value = _availableTables;
    if (value == null) return null;
    if (_availableTables is EqualUnmodifiableListView) return _availableTables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? uid;

  @override
  String toString() {
    return 'ListingModel(address: $address, availableDates: $availableDates, availableTimes: $availableTimes, availableRooms: $availableRooms, category: $category, cancellationRate: $cancellationRate, checkIn: $checkIn, checkOut: $checkOut, city: $city, cancellationPeriod: $cancellationPeriod, cooperative: $cooperative, description: $description, driverNames: $driverNames, driverIds: $driverIds, downpaymentRate: $downpaymentRate, fixedCancellationRate: $fixedCancellationRate, images: $images, isPublished: $isPublished, listingCosts: $listingCosts, numberOfUnits: $numberOfUnits, openingHours: $openingHours, closingHours: $closingHours, duration: $duration, pax: $pax, price: $price, province: $province, publisherId: $publisherId, publisherName: $publisherName, pickUp: $pickUp, destination: $destination, guestInfo: $guestInfo, rating: $rating, fixedTasks: $fixedTasks, timestamp: $timestamp, availableDays: $availableDays, title: $title, type: $type, availableDeals: $availableDeals, menuImgs: $menuImgs, availableTransport: $availableTransport, availableTables: $availableTables, uid: $uid)';
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
                .equals(other._availableTimes, _availableTimes) &&
            const DeepCollectionEquality()
                .equals(other._availableRooms, _availableRooms) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.cancellationRate, cancellationRate) ||
                other.cancellationRate == cancellationRate) &&
            (identical(other.checkIn, checkIn) || other.checkIn == checkIn) &&
            (identical(other.checkOut, checkOut) ||
                other.checkOut == checkOut) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.cancellationPeriod, cancellationPeriod) ||
                other.cancellationPeriod == cancellationPeriod) &&
            (identical(other.cooperative, cooperative) ||
                other.cooperative == cooperative) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._driverNames, _driverNames) &&
            const DeepCollectionEquality()
                .equals(other._driverIds, _driverIds) &&
            (identical(other.downpaymentRate, downpaymentRate) ||
                other.downpaymentRate == downpaymentRate) &&
            (identical(other.fixedCancellationRate, fixedCancellationRate) ||
                other.fixedCancellationRate == fixedCancellationRate) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.isPublished, isPublished) ||
                other.isPublished == isPublished) &&
            const DeepCollectionEquality()
                .equals(other._listingCosts, _listingCosts) &&
            (identical(other.numberOfUnits, numberOfUnits) ||
                other.numberOfUnits == numberOfUnits) &&
            (identical(other.openingHours, openingHours) ||
                other.openingHours == openingHours) &&
            (identical(other.closingHours, closingHours) ||
                other.closingHours == closingHours) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.pax, pax) || other.pax == pax) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.province, province) ||
                other.province == province) &&
            (identical(other.publisherId, publisherId) ||
                other.publisherId == publisherId) &&
            (identical(other.publisherName, publisherName) ||
                other.publisherName == publisherName) &&
            (identical(other.pickUp, pickUp) || other.pickUp == pickUp) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.guestInfo, guestInfo) ||
                other.guestInfo == guestInfo) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            const DeepCollectionEquality()
                .equals(other._fixedTasks, _fixedTasks) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality()
                .equals(other._availableDays, _availableDays) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._availableDeals, _availableDeals) &&
            const DeepCollectionEquality().equals(other._menuImgs, _menuImgs) &&
            (identical(other.availableTransport, availableTransport) ||
                other.availableTransport == availableTransport) &&
            const DeepCollectionEquality()
                .equals(other._availableTables, _availableTables) &&
            (identical(other.uid, uid) || other.uid == uid));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        address,
        const DeepCollectionEquality().hash(_availableDates),
        const DeepCollectionEquality().hash(_availableTimes),
        const DeepCollectionEquality().hash(_availableRooms),
        category,
        cancellationRate,
        checkIn,
        checkOut,
        city,
        cancellationPeriod,
        cooperative,
        description,
        const DeepCollectionEquality().hash(_driverNames),
        const DeepCollectionEquality().hash(_driverIds),
        downpaymentRate,
        fixedCancellationRate,
        const DeepCollectionEquality().hash(_images),
        isPublished,
        const DeepCollectionEquality().hash(_listingCosts),
        numberOfUnits,
        openingHours,
        closingHours,
        duration,
        pax,
        price,
        province,
        publisherId,
        publisherName,
        pickUp,
        destination,
        guestInfo,
        rating,
        const DeepCollectionEquality().hash(_fixedTasks),
        timestamp,
        const DeepCollectionEquality().hash(_availableDays),
        title,
        type,
        const DeepCollectionEquality().hash(_availableDeals),
        const DeepCollectionEquality().hash(_menuImgs),
        availableTransport,
        const DeepCollectionEquality().hash(_availableTables),
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
      final List<AvailableTime>? availableTimes,
      final List<AvailableRoom>? availableRooms,
      required final String category,
      final num? cancellationRate,
      @TimeOfDayConverter() final TimeOfDay? checkIn,
      @TimeOfDayConverter() final TimeOfDay? checkOut,
      required final String city,
      final num? cancellationPeriod,
      required final ListingCooperative cooperative,
      required final String description,
      final List<String>? driverNames,
      final List<String>? driverIds,
      final num? downpaymentRate,
      final num? fixedCancellationRate,
      final List<ListingImages>? images,
      final bool? isPublished,
      final List<ListingCost>? listingCosts,
      final num? numberOfUnits,
      @TimeOfDayConverter() final TimeOfDay? openingHours,
      @TimeOfDayConverter() final TimeOfDay? closingHours,
      @TimeOfDayConverter() final TimeOfDay? duration,
      final num? pax,
      final num? price,
      required final String province,
      required final String publisherId,
      required final String publisherName,
      final String? pickUp,
      final String? destination,
      final String? guestInfo,
      final num? rating,
      final List<BookingTask>? fixedTasks,
      @TimestampSerializer() final DateTime? timestamp,
      final List<AvailableDay>? availableDays,
      required final String title,
      final String? type,
      final List<FoodService>? availableDeals,
      final List<ListingImages>? menuImgs,
      final AvailableTransport? availableTransport,
      final List<List<dynamic>>? availableTables,
      final String? uid}) = _$ListingModelImpl;

  factory _ListingModel.fromJson(Map<String, dynamic> json) =
      _$ListingModelImpl.fromJson;

  @override
  String get address;
  @override
  List<AvailableDate>? get availableDates;
  @override
  List<AvailableTime>? get availableTimes;
  @override
  List<AvailableRoom>? get availableRooms;
  @override
  String get category;
  @override
  num? get cancellationRate;
  @override
  @TimeOfDayConverter()
  TimeOfDay? get checkIn;
  @override
  @TimeOfDayConverter()
  TimeOfDay? get checkOut;
  @override
  String get city;
  @override
  num? get cancellationPeriod;
  @override
  ListingCooperative get cooperative;
  @override
  String get description;
  @override
  List<String>? get driverNames;
  @override
  List<String>? get driverIds;
  @override
  num? get downpaymentRate;
  @override
  num? get fixedCancellationRate;
  @override
  List<ListingImages>? get images;
  @override
  bool? get isPublished;
  @override
  List<ListingCost>? get listingCosts;
  @override
  num? get numberOfUnits;
  @override
  @TimeOfDayConverter()
  TimeOfDay? get openingHours;
  @override
  @TimeOfDayConverter()
  TimeOfDay? get closingHours;
  @override
  @TimeOfDayConverter()
  TimeOfDay? get duration;
  @override //[Travel Duration, Entertainment Duration]
  num? get pax;
  @override
  num? get price;
  @override
  String get province;
  @override
  String get publisherId;
  @override
  String get publisherName;
  @override
  String? get pickUp;
  @override
  String? get destination;
  @override
  String? get guestInfo;
  @override
  num? get rating;
  @override
  List<BookingTask>? get fixedTasks;
  @override
  @TimestampSerializer()
  DateTime? get timestamp;
  @override
  List<AvailableDay>? get availableDays;
  @override
  String get title;
  @override
  String? get type;
  @override //[Private, Public, Rentals, Watching/Performances, Activities]
  List<FoodService>? get availableDeals;
  @override
  List<ListingImages>? get menuImgs;
  @override
  AvailableTransport? get availableTransport;
  @override // add the map of available tables here
  List<List<dynamic>>? get availableTables;
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
  String? get uid => throw _privateConstructorUsedError;
  String? get listingId => throw _privateConstructorUsedError;
  String? get listingName => throw _privateConstructorUsedError;
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
      {String? uid,
      String? listingId,
      String? listingName,
      bool available,
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
    Object? uid = freezed,
    Object? listingId = freezed,
    Object? listingName = freezed,
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
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      listingId: freezed == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String?,
      listingName: freezed == listingName
          ? _value.listingName
          : listingName // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {String? uid,
      String? listingId,
      String? listingName,
      bool available,
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
    Object? uid = freezed,
    Object? listingId = freezed,
    Object? listingName = freezed,
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
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      listingId: freezed == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String?,
      listingName: freezed == listingName
          ? _value.listingName
          : listingName // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {this.uid,
      this.listingId,
      this.listingName,
      required this.available,
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
  final String? uid;
  @override
  final String? listingId;
  @override
  final String? listingName;
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
    return 'AvailableRoom(uid: $uid, listingId: $listingId, listingName: $listingName, available: $available, bathrooms: $bathrooms, bedrooms: $bedrooms, beds: $beds, guests: $guests, images: $images, price: $price, roomId: $roomId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailableRoomImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.listingId, listingId) ||
                other.listingId == listingId) &&
            (identical(other.listingName, listingName) ||
                other.listingName == listingName) &&
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
      uid,
      listingId,
      listingName,
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
      {final String? uid,
      final String? listingId,
      final String? listingName,
      required final bool available,
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
  String? get uid;
  @override
  String? get listingId;
  @override
  String? get listingName;
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
  String? get uid => throw _privateConstructorUsedError;
  String? get listingId => throw _privateConstructorUsedError;
  String? get listingName => throw _privateConstructorUsedError;
  bool get available => throw _privateConstructorUsedError;
  num get guests => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  List<TimeOfDay>? get departureTimes => throw _privateConstructorUsedError;
  num? get vehicleNo => throw _privateConstructorUsedError;
  num get luggage => throw _privateConstructorUsedError;
  List<bool>? get workingDays => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay? get startTime => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay? get endTime => throw _privateConstructorUsedError;
  num? get priceByHour => throw _privateConstructorUsedError;

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
      {String? uid,
      String? listingId,
      String? listingName,
      bool available,
      num guests,
      @TimeOfDayConverter() List<TimeOfDay>? departureTimes,
      num? vehicleNo,
      num luggage,
      List<bool>? workingDays,
      @TimeOfDayConverter() TimeOfDay? startTime,
      @TimeOfDayConverter() TimeOfDay? endTime,
      num? priceByHour});
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
    Object? uid = freezed,
    Object? listingId = freezed,
    Object? listingName = freezed,
    Object? available = null,
    Object? guests = null,
    Object? departureTimes = freezed,
    Object? vehicleNo = freezed,
    Object? luggage = null,
    Object? workingDays = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? priceByHour = freezed,
  }) {
    return _then(_value.copyWith(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      listingId: freezed == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String?,
      listingName: freezed == listingName
          ? _value.listingName
          : listingName // ignore: cast_nullable_to_non_nullable
              as String?,
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
      guests: null == guests
          ? _value.guests
          : guests // ignore: cast_nullable_to_non_nullable
              as num,
      departureTimes: freezed == departureTimes
          ? _value.departureTimes
          : departureTimes // ignore: cast_nullable_to_non_nullable
              as List<TimeOfDay>?,
      vehicleNo: freezed == vehicleNo
          ? _value.vehicleNo
          : vehicleNo // ignore: cast_nullable_to_non_nullable
              as num?,
      luggage: null == luggage
          ? _value.luggage
          : luggage // ignore: cast_nullable_to_non_nullable
              as num,
      workingDays: freezed == workingDays
          ? _value.workingDays
          : workingDays // ignore: cast_nullable_to_non_nullable
              as List<bool>?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      priceByHour: freezed == priceByHour
          ? _value.priceByHour
          : priceByHour // ignore: cast_nullable_to_non_nullable
              as num?,
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
      {String? uid,
      String? listingId,
      String? listingName,
      bool available,
      num guests,
      @TimeOfDayConverter() List<TimeOfDay>? departureTimes,
      num? vehicleNo,
      num luggage,
      List<bool>? workingDays,
      @TimeOfDayConverter() TimeOfDay? startTime,
      @TimeOfDayConverter() TimeOfDay? endTime,
      num? priceByHour});
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
    Object? uid = freezed,
    Object? listingId = freezed,
    Object? listingName = freezed,
    Object? available = null,
    Object? guests = null,
    Object? departureTimes = freezed,
    Object? vehicleNo = freezed,
    Object? luggage = null,
    Object? workingDays = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? priceByHour = freezed,
  }) {
    return _then(_$AvailableTransportImpl(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      listingId: freezed == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String?,
      listingName: freezed == listingName
          ? _value.listingName
          : listingName // ignore: cast_nullable_to_non_nullable
              as String?,
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
      guests: null == guests
          ? _value.guests
          : guests // ignore: cast_nullable_to_non_nullable
              as num,
      departureTimes: freezed == departureTimes
          ? _value._departureTimes
          : departureTimes // ignore: cast_nullable_to_non_nullable
              as List<TimeOfDay>?,
      vehicleNo: freezed == vehicleNo
          ? _value.vehicleNo
          : vehicleNo // ignore: cast_nullable_to_non_nullable
              as num?,
      luggage: null == luggage
          ? _value.luggage
          : luggage // ignore: cast_nullable_to_non_nullable
              as num,
      workingDays: freezed == workingDays
          ? _value._workingDays
          : workingDays // ignore: cast_nullable_to_non_nullable
              as List<bool>?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      priceByHour: freezed == priceByHour
          ? _value.priceByHour
          : priceByHour // ignore: cast_nullable_to_non_nullable
              as num?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailableTransportImpl implements _AvailableTransport {
  _$AvailableTransportImpl(
      {this.uid,
      this.listingId,
      this.listingName,
      required this.available,
      required this.guests,
      @TimeOfDayConverter() final List<TimeOfDay>? departureTimes,
      this.vehicleNo,
      required this.luggage,
      final List<bool>? workingDays,
      @TimeOfDayConverter() this.startTime,
      @TimeOfDayConverter() this.endTime,
      this.priceByHour})
      : _departureTimes = departureTimes,
        _workingDays = workingDays;

  factory _$AvailableTransportImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailableTransportImplFromJson(json);

  @override
  final String? uid;
  @override
  final String? listingId;
  @override
  final String? listingName;
  @override
  final bool available;
  @override
  final num guests;
  final List<TimeOfDay>? _departureTimes;
  @override
  @TimeOfDayConverter()
  List<TimeOfDay>? get departureTimes {
    final value = _departureTimes;
    if (value == null) return null;
    if (_departureTimes is EqualUnmodifiableListView) return _departureTimes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final num? vehicleNo;
  @override
  final num luggage;
  final List<bool>? _workingDays;
  @override
  List<bool>? get workingDays {
    final value = _workingDays;
    if (value == null) return null;
    if (_workingDays is EqualUnmodifiableListView) return _workingDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @TimeOfDayConverter()
  final TimeOfDay? startTime;
  @override
  @TimeOfDayConverter()
  final TimeOfDay? endTime;
  @override
  final num? priceByHour;

  @override
  String toString() {
    return 'AvailableTransport(uid: $uid, listingId: $listingId, listingName: $listingName, available: $available, guests: $guests, departureTimes: $departureTimes, vehicleNo: $vehicleNo, luggage: $luggage, workingDays: $workingDays, startTime: $startTime, endTime: $endTime, priceByHour: $priceByHour)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailableTransportImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.listingId, listingId) ||
                other.listingId == listingId) &&
            (identical(other.listingName, listingName) ||
                other.listingName == listingName) &&
            (identical(other.available, available) ||
                other.available == available) &&
            (identical(other.guests, guests) || other.guests == guests) &&
            const DeepCollectionEquality()
                .equals(other._departureTimes, _departureTimes) &&
            (identical(other.vehicleNo, vehicleNo) ||
                other.vehicleNo == vehicleNo) &&
            (identical(other.luggage, luggage) || other.luggage == luggage) &&
            const DeepCollectionEquality()
                .equals(other._workingDays, _workingDays) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.priceByHour, priceByHour) ||
                other.priceByHour == priceByHour));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      listingId,
      listingName,
      available,
      guests,
      const DeepCollectionEquality().hash(_departureTimes),
      vehicleNo,
      luggage,
      const DeepCollectionEquality().hash(_workingDays),
      startTime,
      endTime,
      priceByHour);

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
      {final String? uid,
      final String? listingId,
      final String? listingName,
      required final bool available,
      required final num guests,
      @TimeOfDayConverter() final List<TimeOfDay>? departureTimes,
      final num? vehicleNo,
      required final num luggage,
      final List<bool>? workingDays,
      @TimeOfDayConverter() final TimeOfDay? startTime,
      @TimeOfDayConverter() final TimeOfDay? endTime,
      final num? priceByHour}) = _$AvailableTransportImpl;

  factory _AvailableTransport.fromJson(Map<String, dynamic> json) =
      _$AvailableTransportImpl.fromJson;

  @override
  String? get uid;
  @override
  String? get listingId;
  @override
  String? get listingName;
  @override
  bool get available;
  @override
  num get guests;
  @override
  @TimeOfDayConverter()
  List<TimeOfDay>? get departureTimes;
  @override
  num? get vehicleNo;
  @override
  num get luggage;
  @override
  List<bool>? get workingDays;
  @override
  @TimeOfDayConverter()
  TimeOfDay? get startTime;
  @override
  @TimeOfDayConverter()
  TimeOfDay? get endTime;
  @override
  num? get priceByHour;
  @override
  @JsonKey(ignore: true)
  _$$AvailableTransportImplCopyWith<_$AvailableTransportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DepartureModel _$DepartureModelFromJson(Map<String, dynamic> json) {
  return _DepartureModel.fromJson(json);
}

/// @nodoc
mixin _$DepartureModel {
  String? get uid => throw _privateConstructorUsedError;
  String? get listingName => throw _privateConstructorUsedError;
  String? get listingId => throw _privateConstructorUsedError;
  List<ListingBookings> get passengers => throw _privateConstructorUsedError;
  List<AssignedVehicle>? get vehicles => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get arrival => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get departure => throw _privateConstructorUsedError;
  String? get departureStatus => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DepartureModelCopyWith<DepartureModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DepartureModelCopyWith<$Res> {
  factory $DepartureModelCopyWith(
          DepartureModel value, $Res Function(DepartureModel) then) =
      _$DepartureModelCopyWithImpl<$Res, DepartureModel>;
  @useResult
  $Res call(
      {String? uid,
      String? listingName,
      String? listingId,
      List<ListingBookings> passengers,
      List<AssignedVehicle>? vehicles,
      @TimestampSerializer() DateTime? arrival,
      @TimestampSerializer() DateTime? departure,
      String? departureStatus});
}

/// @nodoc
class _$DepartureModelCopyWithImpl<$Res, $Val extends DepartureModel>
    implements $DepartureModelCopyWith<$Res> {
  _$DepartureModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? listingName = freezed,
    Object? listingId = freezed,
    Object? passengers = null,
    Object? vehicles = freezed,
    Object? arrival = freezed,
    Object? departure = freezed,
    Object? departureStatus = freezed,
  }) {
    return _then(_value.copyWith(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      listingName: freezed == listingName
          ? _value.listingName
          : listingName // ignore: cast_nullable_to_non_nullable
              as String?,
      listingId: freezed == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String?,
      passengers: null == passengers
          ? _value.passengers
          : passengers // ignore: cast_nullable_to_non_nullable
              as List<ListingBookings>,
      vehicles: freezed == vehicles
          ? _value.vehicles
          : vehicles // ignore: cast_nullable_to_non_nullable
              as List<AssignedVehicle>?,
      arrival: freezed == arrival
          ? _value.arrival
          : arrival // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      departure: freezed == departure
          ? _value.departure
          : departure // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      departureStatus: freezed == departureStatus
          ? _value.departureStatus
          : departureStatus // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DepartureModelImplCopyWith<$Res>
    implements $DepartureModelCopyWith<$Res> {
  factory _$$DepartureModelImplCopyWith(_$DepartureModelImpl value,
          $Res Function(_$DepartureModelImpl) then) =
      __$$DepartureModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? uid,
      String? listingName,
      String? listingId,
      List<ListingBookings> passengers,
      List<AssignedVehicle>? vehicles,
      @TimestampSerializer() DateTime? arrival,
      @TimestampSerializer() DateTime? departure,
      String? departureStatus});
}

/// @nodoc
class __$$DepartureModelImplCopyWithImpl<$Res>
    extends _$DepartureModelCopyWithImpl<$Res, _$DepartureModelImpl>
    implements _$$DepartureModelImplCopyWith<$Res> {
  __$$DepartureModelImplCopyWithImpl(
      _$DepartureModelImpl _value, $Res Function(_$DepartureModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? listingName = freezed,
    Object? listingId = freezed,
    Object? passengers = null,
    Object? vehicles = freezed,
    Object? arrival = freezed,
    Object? departure = freezed,
    Object? departureStatus = freezed,
  }) {
    return _then(_$DepartureModelImpl(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      listingName: freezed == listingName
          ? _value.listingName
          : listingName // ignore: cast_nullable_to_non_nullable
              as String?,
      listingId: freezed == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String?,
      passengers: null == passengers
          ? _value._passengers
          : passengers // ignore: cast_nullable_to_non_nullable
              as List<ListingBookings>,
      vehicles: freezed == vehicles
          ? _value._vehicles
          : vehicles // ignore: cast_nullable_to_non_nullable
              as List<AssignedVehicle>?,
      arrival: freezed == arrival
          ? _value.arrival
          : arrival // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      departure: freezed == departure
          ? _value.departure
          : departure // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      departureStatus: freezed == departureStatus
          ? _value.departureStatus
          : departureStatus // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DepartureModelImpl implements _DepartureModel {
  _$DepartureModelImpl(
      {this.uid,
      this.listingName,
      this.listingId,
      required final List<ListingBookings> passengers,
      final List<AssignedVehicle>? vehicles,
      @TimestampSerializer() this.arrival,
      @TimestampSerializer() this.departure,
      this.departureStatus})
      : _passengers = passengers,
        _vehicles = vehicles;

  factory _$DepartureModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DepartureModelImplFromJson(json);

  @override
  final String? uid;
  @override
  final String? listingName;
  @override
  final String? listingId;
  final List<ListingBookings> _passengers;
  @override
  List<ListingBookings> get passengers {
    if (_passengers is EqualUnmodifiableListView) return _passengers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_passengers);
  }

  final List<AssignedVehicle>? _vehicles;
  @override
  List<AssignedVehicle>? get vehicles {
    final value = _vehicles;
    if (value == null) return null;
    if (_vehicles is EqualUnmodifiableListView) return _vehicles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @TimestampSerializer()
  final DateTime? arrival;
  @override
  @TimestampSerializer()
  final DateTime? departure;
  @override
  final String? departureStatus;

  @override
  String toString() {
    return 'DepartureModel(uid: $uid, listingName: $listingName, listingId: $listingId, passengers: $passengers, vehicles: $vehicles, arrival: $arrival, departure: $departure, departureStatus: $departureStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DepartureModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.listingName, listingName) ||
                other.listingName == listingName) &&
            (identical(other.listingId, listingId) ||
                other.listingId == listingId) &&
            const DeepCollectionEquality()
                .equals(other._passengers, _passengers) &&
            const DeepCollectionEquality().equals(other._vehicles, _vehicles) &&
            (identical(other.arrival, arrival) || other.arrival == arrival) &&
            (identical(other.departure, departure) ||
                other.departure == departure) &&
            (identical(other.departureStatus, departureStatus) ||
                other.departureStatus == departureStatus));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      listingName,
      listingId,
      const DeepCollectionEquality().hash(_passengers),
      const DeepCollectionEquality().hash(_vehicles),
      arrival,
      departure,
      departureStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DepartureModelImplCopyWith<_$DepartureModelImpl> get copyWith =>
      __$$DepartureModelImplCopyWithImpl<_$DepartureModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DepartureModelImplToJson(
      this,
    );
  }
}

abstract class _DepartureModel implements DepartureModel {
  factory _DepartureModel(
      {final String? uid,
      final String? listingName,
      final String? listingId,
      required final List<ListingBookings> passengers,
      final List<AssignedVehicle>? vehicles,
      @TimestampSerializer() final DateTime? arrival,
      @TimestampSerializer() final DateTime? departure,
      final String? departureStatus}) = _$DepartureModelImpl;

  factory _DepartureModel.fromJson(Map<String, dynamic> json) =
      _$DepartureModelImpl.fromJson;

  @override
  String? get uid;
  @override
  String? get listingName;
  @override
  String? get listingId;
  @override
  List<ListingBookings> get passengers;
  @override
  List<AssignedVehicle>? get vehicles;
  @override
  @TimestampSerializer()
  DateTime? get arrival;
  @override
  @TimestampSerializer()
  DateTime? get departure;
  @override
  String? get departureStatus;
  @override
  @JsonKey(ignore: true)
  _$$DepartureModelImplCopyWith<_$DepartureModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AssignedVehicle _$AssignedVehicleFromJson(Map<String, dynamic> json) {
  return _AssignedVehicle.fromJson(json);
}

/// @nodoc
mixin _$AssignedVehicle {
  AvailableTransport? get vehicle => throw _privateConstructorUsedError;
  List<ListingBookings>? get passengers => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AssignedVehicleCopyWith<AssignedVehicle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssignedVehicleCopyWith<$Res> {
  factory $AssignedVehicleCopyWith(
          AssignedVehicle value, $Res Function(AssignedVehicle) then) =
      _$AssignedVehicleCopyWithImpl<$Res, AssignedVehicle>;
  @useResult
  $Res call({AvailableTransport? vehicle, List<ListingBookings>? passengers});

  $AvailableTransportCopyWith<$Res>? get vehicle;
}

/// @nodoc
class _$AssignedVehicleCopyWithImpl<$Res, $Val extends AssignedVehicle>
    implements $AssignedVehicleCopyWith<$Res> {
  _$AssignedVehicleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vehicle = freezed,
    Object? passengers = freezed,
  }) {
    return _then(_value.copyWith(
      vehicle: freezed == vehicle
          ? _value.vehicle
          : vehicle // ignore: cast_nullable_to_non_nullable
              as AvailableTransport?,
      passengers: freezed == passengers
          ? _value.passengers
          : passengers // ignore: cast_nullable_to_non_nullable
              as List<ListingBookings>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AvailableTransportCopyWith<$Res>? get vehicle {
    if (_value.vehicle == null) {
      return null;
    }

    return $AvailableTransportCopyWith<$Res>(_value.vehicle!, (value) {
      return _then(_value.copyWith(vehicle: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AssignedVehicleImplCopyWith<$Res>
    implements $AssignedVehicleCopyWith<$Res> {
  factory _$$AssignedVehicleImplCopyWith(_$AssignedVehicleImpl value,
          $Res Function(_$AssignedVehicleImpl) then) =
      __$$AssignedVehicleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AvailableTransport? vehicle, List<ListingBookings>? passengers});

  @override
  $AvailableTransportCopyWith<$Res>? get vehicle;
}

/// @nodoc
class __$$AssignedVehicleImplCopyWithImpl<$Res>
    extends _$AssignedVehicleCopyWithImpl<$Res, _$AssignedVehicleImpl>
    implements _$$AssignedVehicleImplCopyWith<$Res> {
  __$$AssignedVehicleImplCopyWithImpl(
      _$AssignedVehicleImpl _value, $Res Function(_$AssignedVehicleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vehicle = freezed,
    Object? passengers = freezed,
  }) {
    return _then(_$AssignedVehicleImpl(
      vehicle: freezed == vehicle
          ? _value.vehicle
          : vehicle // ignore: cast_nullable_to_non_nullable
              as AvailableTransport?,
      passengers: freezed == passengers
          ? _value._passengers
          : passengers // ignore: cast_nullable_to_non_nullable
              as List<ListingBookings>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssignedVehicleImpl implements _AssignedVehicle {
  _$AssignedVehicleImpl({this.vehicle, final List<ListingBookings>? passengers})
      : _passengers = passengers;

  factory _$AssignedVehicleImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssignedVehicleImplFromJson(json);

  @override
  final AvailableTransport? vehicle;
  final List<ListingBookings>? _passengers;
  @override
  List<ListingBookings>? get passengers {
    final value = _passengers;
    if (value == null) return null;
    if (_passengers is EqualUnmodifiableListView) return _passengers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'AssignedVehicle(vehicle: $vehicle, passengers: $passengers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssignedVehicleImpl &&
            (identical(other.vehicle, vehicle) || other.vehicle == vehicle) &&
            const DeepCollectionEquality()
                .equals(other._passengers, _passengers));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, vehicle, const DeepCollectionEquality().hash(_passengers));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AssignedVehicleImplCopyWith<_$AssignedVehicleImpl> get copyWith =>
      __$$AssignedVehicleImplCopyWithImpl<_$AssignedVehicleImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssignedVehicleImplToJson(
      this,
    );
  }
}

abstract class _AssignedVehicle implements AssignedVehicle {
  factory _AssignedVehicle(
      {final AvailableTransport? vehicle,
      final List<ListingBookings>? passengers}) = _$AssignedVehicleImpl;

  factory _AssignedVehicle.fromJson(Map<String, dynamic> json) =
      _$AssignedVehicleImpl.fromJson;

  @override
  AvailableTransport? get vehicle;
  @override
  List<ListingBookings>? get passengers;
  @override
  @JsonKey(ignore: true)
  _$$AssignedVehicleImplCopyWith<_$AssignedVehicleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FoodService _$FoodServiceFromJson(Map<String, dynamic> json) {
  return _FoodService.fromJson(json);
}

/// @nodoc
mixin _$FoodService {
  String get dealName => throw _privateConstructorUsedError;
  String get dealDescription => throw _privateConstructorUsedError;
  num get guests => throw _privateConstructorUsedError;
  bool get available => throw _privateConstructorUsedError;
  num get price => throw _privateConstructorUsedError;
  List<ListingImages> get dealImgs => throw _privateConstructorUsedError;
  List<bool> get workingDays => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay get startTime => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay get endTime => throw _privateConstructorUsedError;

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
  $Res call(
      {String dealName,
      String dealDescription,
      num guests,
      bool available,
      num price,
      List<ListingImages> dealImgs,
      List<bool> workingDays,
      @TimeOfDayConverter() TimeOfDay startTime,
      @TimeOfDayConverter() TimeOfDay endTime});
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
    Object? dealName = null,
    Object? dealDescription = null,
    Object? guests = null,
    Object? available = null,
    Object? price = null,
    Object? dealImgs = null,
    Object? workingDays = null,
    Object? startTime = null,
    Object? endTime = null,
  }) {
    return _then(_value.copyWith(
      dealName: null == dealName
          ? _value.dealName
          : dealName // ignore: cast_nullable_to_non_nullable
              as String,
      dealDescription: null == dealDescription
          ? _value.dealDescription
          : dealDescription // ignore: cast_nullable_to_non_nullable
              as String,
      guests: null == guests
          ? _value.guests
          : guests // ignore: cast_nullable_to_non_nullable
              as num,
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as num,
      dealImgs: null == dealImgs
          ? _value.dealImgs
          : dealImgs // ignore: cast_nullable_to_non_nullable
              as List<ListingImages>,
      workingDays: null == workingDays
          ? _value.workingDays
          : workingDays // ignore: cast_nullable_to_non_nullable
              as List<bool>,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
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
  $Res call(
      {String dealName,
      String dealDescription,
      num guests,
      bool available,
      num price,
      List<ListingImages> dealImgs,
      List<bool> workingDays,
      @TimeOfDayConverter() TimeOfDay startTime,
      @TimeOfDayConverter() TimeOfDay endTime});
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
    Object? dealName = null,
    Object? dealDescription = null,
    Object? guests = null,
    Object? available = null,
    Object? price = null,
    Object? dealImgs = null,
    Object? workingDays = null,
    Object? startTime = null,
    Object? endTime = null,
  }) {
    return _then(_$FoodServiceImpl(
      dealName: null == dealName
          ? _value.dealName
          : dealName // ignore: cast_nullable_to_non_nullable
              as String,
      dealDescription: null == dealDescription
          ? _value.dealDescription
          : dealDescription // ignore: cast_nullable_to_non_nullable
              as String,
      guests: null == guests
          ? _value.guests
          : guests // ignore: cast_nullable_to_non_nullable
              as num,
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as num,
      dealImgs: null == dealImgs
          ? _value._dealImgs
          : dealImgs // ignore: cast_nullable_to_non_nullable
              as List<ListingImages>,
      workingDays: null == workingDays
          ? _value._workingDays
          : workingDays // ignore: cast_nullable_to_non_nullable
              as List<bool>,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodServiceImpl implements _FoodService {
  _$FoodServiceImpl(
      {required this.dealName,
      required this.dealDescription,
      required this.guests,
      required this.available,
      required this.price,
      required final List<ListingImages> dealImgs,
      required final List<bool> workingDays,
      @TimeOfDayConverter() required this.startTime,
      @TimeOfDayConverter() required this.endTime})
      : _dealImgs = dealImgs,
        _workingDays = workingDays;

  factory _$FoodServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodServiceImplFromJson(json);

  @override
  final String dealName;
  @override
  final String dealDescription;
  @override
  final num guests;
  @override
  final bool available;
  @override
  final num price;
  final List<ListingImages> _dealImgs;
  @override
  List<ListingImages> get dealImgs {
    if (_dealImgs is EqualUnmodifiableListView) return _dealImgs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dealImgs);
  }

  final List<bool> _workingDays;
  @override
  List<bool> get workingDays {
    if (_workingDays is EqualUnmodifiableListView) return _workingDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workingDays);
  }

  @override
  @TimeOfDayConverter()
  final TimeOfDay startTime;
  @override
  @TimeOfDayConverter()
  final TimeOfDay endTime;

  @override
  String toString() {
    return 'FoodService(dealName: $dealName, dealDescription: $dealDescription, guests: $guests, available: $available, price: $price, dealImgs: $dealImgs, workingDays: $workingDays, startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodServiceImpl &&
            (identical(other.dealName, dealName) ||
                other.dealName == dealName) &&
            (identical(other.dealDescription, dealDescription) ||
                other.dealDescription == dealDescription) &&
            (identical(other.guests, guests) || other.guests == guests) &&
            (identical(other.available, available) ||
                other.available == available) &&
            (identical(other.price, price) || other.price == price) &&
            const DeepCollectionEquality().equals(other._dealImgs, _dealImgs) &&
            const DeepCollectionEquality()
                .equals(other._workingDays, _workingDays) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      dealName,
      dealDescription,
      guests,
      available,
      price,
      const DeepCollectionEquality().hash(_dealImgs),
      const DeepCollectionEquality().hash(_workingDays),
      startTime,
      endTime);

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
          {required final String dealName,
          required final String dealDescription,
          required final num guests,
          required final bool available,
          required final num price,
          required final List<ListingImages> dealImgs,
          required final List<bool> workingDays,
          @TimeOfDayConverter() required final TimeOfDay startTime,
          @TimeOfDayConverter() required final TimeOfDay endTime}) =
      _$FoodServiceImpl;

  factory _FoodService.fromJson(Map<String, dynamic> json) =
      _$FoodServiceImpl.fromJson;

  @override
  String get dealName;
  @override
  String get dealDescription;
  @override
  num get guests;
  @override
  bool get available;
  @override
  num get price;
  @override
  List<ListingImages> get dealImgs;
  @override
  List<bool> get workingDays;
  @override
  @TimeOfDayConverter()
  TimeOfDay get startTime;
  @override
  @TimeOfDayConverter()
  TimeOfDay get endTime;
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
  String? get uid => throw _privateConstructorUsedError;
  String? get listingId => throw _privateConstructorUsedError;
  String? get listingName => throw _privateConstructorUsedError;
  String get entertainmentId => throw _privateConstructorUsedError;
  num get guests => throw _privateConstructorUsedError;
  num get price => throw _privateConstructorUsedError;
  bool get available => throw _privateConstructorUsedError;
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
      {String? uid,
      String? listingId,
      String? listingName,
      String entertainmentId,
      num guests,
      num price,
      bool available,
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
    Object? uid = freezed,
    Object? listingId = freezed,
    Object? listingName = freezed,
    Object? entertainmentId = null,
    Object? guests = null,
    Object? price = null,
    Object? available = null,
    Object? entertainmentImgs = null,
  }) {
    return _then(_value.copyWith(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      listingId: freezed == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String?,
      listingName: freezed == listingName
          ? _value.listingName
          : listingName // ignore: cast_nullable_to_non_nullable
              as String?,
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
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
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
      {String? uid,
      String? listingId,
      String? listingName,
      String entertainmentId,
      num guests,
      num price,
      bool available,
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
    Object? uid = freezed,
    Object? listingId = freezed,
    Object? listingName = freezed,
    Object? entertainmentId = null,
    Object? guests = null,
    Object? price = null,
    Object? available = null,
    Object? entertainmentImgs = null,
  }) {
    return _then(_$EntertainmentServiceImpl(
      freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == listingName
          ? _value.listingName
          : listingName // ignore: cast_nullable_to_non_nullable
              as String?,
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
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
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
  _$EntertainmentServiceImpl(this.uid, this.listingId, this.listingName,
      {required this.entertainmentId,
      required this.guests,
      required this.price,
      required this.available,
      required final List<ListingImages> entertainmentImgs})
      : _entertainmentImgs = entertainmentImgs;

  factory _$EntertainmentServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$EntertainmentServiceImplFromJson(json);

  @override
  final String? uid;
  @override
  final String? listingId;
  @override
  final String? listingName;
  @override
  final String entertainmentId;
  @override
  final num guests;
  @override
  final num price;
  @override
  final bool available;
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
    return 'EntertainmentService(uid: $uid, listingId: $listingId, listingName: $listingName, entertainmentId: $entertainmentId, guests: $guests, price: $price, available: $available, entertainmentImgs: $entertainmentImgs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntertainmentServiceImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.listingId, listingId) ||
                other.listingId == listingId) &&
            (identical(other.listingName, listingName) ||
                other.listingName == listingName) &&
            (identical(other.entertainmentId, entertainmentId) ||
                other.entertainmentId == entertainmentId) &&
            (identical(other.guests, guests) || other.guests == guests) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.available, available) ||
                other.available == available) &&
            const DeepCollectionEquality()
                .equals(other._entertainmentImgs, _entertainmentImgs));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      listingId,
      listingName,
      entertainmentId,
      guests,
      price,
      available,
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
          final String? uid, final String? listingId, final String? listingName,
          {required final String entertainmentId,
          required final num guests,
          required final num price,
          required final bool available,
          required final List<ListingImages> entertainmentImgs}) =
      _$EntertainmentServiceImpl;

  factory _EntertainmentService.fromJson(Map<String, dynamic> json) =
      _$EntertainmentServiceImpl.fromJson;

  @override
  String? get uid;
  @override
  String? get listingId;
  @override
  String? get listingName;
  @override
  String get entertainmentId;
  @override
  num get guests;
  @override
  num get price;
  @override
  bool get available;
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
  @TimestampSerializer()
  DateTime get date => throw _privateConstructorUsedError;
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
  $Res call(
      {bool available,
      @TimestampSerializer() DateTime date,
      List<AvailableTime> availableTimes});
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
    Object? date = null,
    Object? availableTimes = null,
  }) {
    return _then(_value.copyWith(
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
  $Res call(
      {bool available,
      @TimestampSerializer() DateTime date,
      List<AvailableTime> availableTimes});
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
    Object? date = null,
    Object? availableTimes = null,
  }) {
    return _then(_$AvailableDateImpl(
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      @TimestampSerializer() required this.date,
      required final List<AvailableTime> availableTimes})
      : _availableTimes = availableTimes;

  factory _$AvailableDateImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailableDateImplFromJson(json);

  @override
  final bool available;
  @override
  @TimestampSerializer()
  final DateTime date;
  final List<AvailableTime> _availableTimes;
  @override
  List<AvailableTime> get availableTimes {
    if (_availableTimes is EqualUnmodifiableListView) return _availableTimes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableTimes);
  }

  @override
  String toString() {
    return 'AvailableDate(available: $available, date: $date, availableTimes: $availableTimes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailableDateImpl &&
            (identical(other.available, available) ||
                other.available == available) &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality()
                .equals(other._availableTimes, _availableTimes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, available, date,
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
      @TimestampSerializer() required final DateTime date,
      required final List<AvailableTime> availableTimes}) = _$AvailableDateImpl;

  factory _AvailableDate.fromJson(Map<String, dynamic> json) =
      _$AvailableDateImpl.fromJson;

  @override
  bool get available;
  @override
  @TimestampSerializer()
  DateTime get date;
  @override
  List<AvailableTime> get availableTimes;
  @override
  @JsonKey(ignore: true)
  _$$AvailableDateImplCopyWith<_$AvailableDateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AvailableDay _$AvailableDayFromJson(Map<String, dynamic> json) {
  return _AvailableDay.fromJson(json);
}

/// @nodoc
mixin _$AvailableDay {
  bool get available => throw _privateConstructorUsedError;
  String get day => throw _privateConstructorUsedError;
  List<AvailableTime> get availableTimes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AvailableDayCopyWith<AvailableDay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailableDayCopyWith<$Res> {
  factory $AvailableDayCopyWith(
          AvailableDay value, $Res Function(AvailableDay) then) =
      _$AvailableDayCopyWithImpl<$Res, AvailableDay>;
  @useResult
  $Res call({bool available, String day, List<AvailableTime> availableTimes});
}

/// @nodoc
class _$AvailableDayCopyWithImpl<$Res, $Val extends AvailableDay>
    implements $AvailableDayCopyWith<$Res> {
  _$AvailableDayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? available = null,
    Object? day = null,
    Object? availableTimes = null,
  }) {
    return _then(_value.copyWith(
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as String,
      availableTimes: null == availableTimes
          ? _value.availableTimes
          : availableTimes // ignore: cast_nullable_to_non_nullable
              as List<AvailableTime>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AvailableDayImplCopyWith<$Res>
    implements $AvailableDayCopyWith<$Res> {
  factory _$$AvailableDayImplCopyWith(
          _$AvailableDayImpl value, $Res Function(_$AvailableDayImpl) then) =
      __$$AvailableDayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool available, String day, List<AvailableTime> availableTimes});
}

/// @nodoc
class __$$AvailableDayImplCopyWithImpl<$Res>
    extends _$AvailableDayCopyWithImpl<$Res, _$AvailableDayImpl>
    implements _$$AvailableDayImplCopyWith<$Res> {
  __$$AvailableDayImplCopyWithImpl(
      _$AvailableDayImpl _value, $Res Function(_$AvailableDayImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? available = null,
    Object? day = null,
    Object? availableTimes = null,
  }) {
    return _then(_$AvailableDayImpl(
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as String,
      availableTimes: null == availableTimes
          ? _value._availableTimes
          : availableTimes // ignore: cast_nullable_to_non_nullable
              as List<AvailableTime>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailableDayImpl implements _AvailableDay {
  _$AvailableDayImpl(
      {required this.available,
      required this.day,
      required final List<AvailableTime> availableTimes})
      : _availableTimes = availableTimes;

  factory _$AvailableDayImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailableDayImplFromJson(json);

  @override
  final bool available;
  @override
  final String day;
  final List<AvailableTime> _availableTimes;
  @override
  List<AvailableTime> get availableTimes {
    if (_availableTimes is EqualUnmodifiableListView) return _availableTimes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableTimes);
  }

  @override
  String toString() {
    return 'AvailableDay(available: $available, day: $day, availableTimes: $availableTimes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailableDayImpl &&
            (identical(other.available, available) ||
                other.available == available) &&
            (identical(other.day, day) || other.day == day) &&
            const DeepCollectionEquality()
                .equals(other._availableTimes, _availableTimes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, available, day,
      const DeepCollectionEquality().hash(_availableTimes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailableDayImplCopyWith<_$AvailableDayImpl> get copyWith =>
      __$$AvailableDayImplCopyWithImpl<_$AvailableDayImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailableDayImplToJson(
      this,
    );
  }
}

abstract class _AvailableDay implements AvailableDay {
  factory _AvailableDay(
      {required final bool available,
      required final String day,
      required final List<AvailableTime> availableTimes}) = _$AvailableDayImpl;

  factory _AvailableDay.fromJson(Map<String, dynamic> json) =
      _$AvailableDayImpl.fromJson;

  @override
  bool get available;
  @override
  String get day;
  @override
  List<AvailableTime> get availableTimes;
  @override
  @JsonKey(ignore: true)
  _$$AvailableDayImplCopyWith<_$AvailableDayImpl> get copyWith =>
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
  @TimeOfDayConverter()
  TimeOfDay get time => throw _privateConstructorUsedError;

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
      @TimeOfDayConverter() TimeOfDay time});
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
              as TimeOfDay,
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
      @TimeOfDayConverter() TimeOfDay time});
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
              as TimeOfDay,
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
      @TimeOfDayConverter() required this.time});

  factory _$AvailableTimeImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailableTimeImplFromJson(json);

  @override
  final bool available;
  @override
  final num currentPax;
  @override
  final num maxPax;
  @override
  @TimeOfDayConverter()
  final TimeOfDay time;

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
          @TimeOfDayConverter() required final TimeOfDay time}) =
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
  @TimeOfDayConverter()
  TimeOfDay get time;
  @override
  @JsonKey(ignore: true)
  _$$AvailableTimeImplCopyWith<_$AvailableTimeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
