// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listings_bookings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ListingBookings _$ListingBookingsFromJson(Map<String, dynamic> json) {
  return _ListingBookings.fromJson(json);
}

/// @nodoc
mixin _$ListingBookings {
  num? get amountPaid => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  String get customerName => throw _privateConstructorUsedError;
  String get customerPhoneNo => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get cooperativeId => throw _privateConstructorUsedError;
  String? get emergencyContactName => throw _privateConstructorUsedError;
  String? get emergencyContactNo => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get endDate => throw _privateConstructorUsedError;
  List<Expense>? get expenses => throw _privateConstructorUsedError;
  List<BookingTask>? get tasks => throw _privateConstructorUsedError;
  String get governmentId => throw _privateConstructorUsedError;
  num get guests => throw _privateConstructorUsedError;
  String get listingId => throw _privateConstructorUsedError;
  String get listingTitle => throw _privateConstructorUsedError;
  num? get luggage => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;
  bool get needsContributions => throw _privateConstructorUsedError;
  String? get paymentOption =>
      throw _privateConstructorUsedError; //Downpayment, Full Payment
  String? get paymentStatus =>
      throw _privateConstructorUsedError; //Partially Paid, Fully Paid, Cancelled
  num get price => throw _privateConstructorUsedError;
  String? get roomId => throw _privateConstructorUsedError;
  num? get vehicleNo => throw _privateConstructorUsedError;
  String? get vehicleUid => throw _privateConstructorUsedError;
  String? get roomUid => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get selectedDate => throw _privateConstructorUsedError;
  String? get selectedTime => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get startDate => throw _privateConstructorUsedError;
  String get bookingStatus =>
      throw _privateConstructorUsedError; //[Reserved, Cancelled, Completed, Refunded, Maintenance
  num? get totalPrice => throw _privateConstructorUsedError;
  String get tripUid => throw _privateConstructorUsedError;
  String get tripName => throw _privateConstructorUsedError;
  String? get typeOfTrip => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay? get startTime => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay? get endTime => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get serviceStart => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get serviceComplete => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ListingBookingsCopyWith<ListingBookings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListingBookingsCopyWith<$Res> {
  factory $ListingBookingsCopyWith(
          ListingBookings value, $Res Function(ListingBookings) then) =
      _$ListingBookingsCopyWithImpl<$Res, ListingBookings>;
  @useResult
  $Res call(
      {num? amountPaid,
      String customerId,
      String customerName,
      String customerPhoneNo,
      String category,
      String email,
      String? cooperativeId,
      String? emergencyContactName,
      String? emergencyContactNo,
      @TimestampSerializer() DateTime? endDate,
      List<Expense>? expenses,
      List<BookingTask>? tasks,
      String governmentId,
      num guests,
      String listingId,
      String listingTitle,
      num? luggage,
      String? id,
      bool needsContributions,
      String? paymentOption,
      String? paymentStatus,
      num price,
      String? roomId,
      num? vehicleNo,
      String? vehicleUid,
      String? roomUid,
      @TimestampSerializer() DateTime? selectedDate,
      String? selectedTime,
      @TimestampSerializer() DateTime? startDate,
      String bookingStatus,
      num? totalPrice,
      String tripUid,
      String tripName,
      String? typeOfTrip,
      @TimeOfDayConverter() TimeOfDay? startTime,
      @TimeOfDayConverter() TimeOfDay? endTime,
      @TimestampSerializer() DateTime? serviceStart,
      @TimestampSerializer() DateTime? serviceComplete});
}

/// @nodoc
class _$ListingBookingsCopyWithImpl<$Res, $Val extends ListingBookings>
    implements $ListingBookingsCopyWith<$Res> {
  _$ListingBookingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amountPaid = freezed,
    Object? customerId = null,
    Object? customerName = null,
    Object? customerPhoneNo = null,
    Object? category = null,
    Object? email = null,
    Object? cooperativeId = freezed,
    Object? emergencyContactName = freezed,
    Object? emergencyContactNo = freezed,
    Object? endDate = freezed,
    Object? expenses = freezed,
    Object? tasks = freezed,
    Object? governmentId = null,
    Object? guests = null,
    Object? listingId = null,
    Object? listingTitle = null,
    Object? luggage = freezed,
    Object? id = freezed,
    Object? needsContributions = null,
    Object? paymentOption = freezed,
    Object? paymentStatus = freezed,
    Object? price = null,
    Object? roomId = freezed,
    Object? vehicleNo = freezed,
    Object? vehicleUid = freezed,
    Object? roomUid = freezed,
    Object? selectedDate = freezed,
    Object? selectedTime = freezed,
    Object? startDate = freezed,
    Object? bookingStatus = null,
    Object? totalPrice = freezed,
    Object? tripUid = null,
    Object? tripName = null,
    Object? typeOfTrip = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? serviceStart = freezed,
    Object? serviceComplete = freezed,
  }) {
    return _then(_value.copyWith(
      amountPaid: freezed == amountPaid
          ? _value.amountPaid
          : amountPaid // ignore: cast_nullable_to_non_nullable
              as num?,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhoneNo: null == customerPhoneNo
          ? _value.customerPhoneNo
          : customerPhoneNo // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      cooperativeId: freezed == cooperativeId
          ? _value.cooperativeId
          : cooperativeId // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactName: freezed == emergencyContactName
          ? _value.emergencyContactName
          : emergencyContactName // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactNo: freezed == emergencyContactNo
          ? _value.emergencyContactNo
          : emergencyContactNo // ignore: cast_nullable_to_non_nullable
              as String?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expenses: freezed == expenses
          ? _value.expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as List<Expense>?,
      tasks: freezed == tasks
          ? _value.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<BookingTask>?,
      governmentId: null == governmentId
          ? _value.governmentId
          : governmentId // ignore: cast_nullable_to_non_nullable
              as String,
      guests: null == guests
          ? _value.guests
          : guests // ignore: cast_nullable_to_non_nullable
              as num,
      listingId: null == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String,
      listingTitle: null == listingTitle
          ? _value.listingTitle
          : listingTitle // ignore: cast_nullable_to_non_nullable
              as String,
      luggage: freezed == luggage
          ? _value.luggage
          : luggage // ignore: cast_nullable_to_non_nullable
              as num?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      needsContributions: null == needsContributions
          ? _value.needsContributions
          : needsContributions // ignore: cast_nullable_to_non_nullable
              as bool,
      paymentOption: freezed == paymentOption
          ? _value.paymentOption
          : paymentOption // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatus: freezed == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as num,
      roomId: freezed == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleNo: freezed == vehicleNo
          ? _value.vehicleNo
          : vehicleNo // ignore: cast_nullable_to_non_nullable
              as num?,
      vehicleUid: freezed == vehicleUid
          ? _value.vehicleUid
          : vehicleUid // ignore: cast_nullable_to_non_nullable
              as String?,
      roomUid: freezed == roomUid
          ? _value.roomUid
          : roomUid // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedDate: freezed == selectedDate
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      selectedTime: freezed == selectedTime
          ? _value.selectedTime
          : selectedTime // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      bookingStatus: null == bookingStatus
          ? _value.bookingStatus
          : bookingStatus // ignore: cast_nullable_to_non_nullable
              as String,
      totalPrice: freezed == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as num?,
      tripUid: null == tripUid
          ? _value.tripUid
          : tripUid // ignore: cast_nullable_to_non_nullable
              as String,
      tripName: null == tripName
          ? _value.tripName
          : tripName // ignore: cast_nullable_to_non_nullable
              as String,
      typeOfTrip: freezed == typeOfTrip
          ? _value.typeOfTrip
          : typeOfTrip // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      serviceStart: freezed == serviceStart
          ? _value.serviceStart
          : serviceStart // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serviceComplete: freezed == serviceComplete
          ? _value.serviceComplete
          : serviceComplete // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ListingBookingsImplCopyWith<$Res>
    implements $ListingBookingsCopyWith<$Res> {
  factory _$$ListingBookingsImplCopyWith(_$ListingBookingsImpl value,
          $Res Function(_$ListingBookingsImpl) then) =
      __$$ListingBookingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {num? amountPaid,
      String customerId,
      String customerName,
      String customerPhoneNo,
      String category,
      String email,
      String? cooperativeId,
      String? emergencyContactName,
      String? emergencyContactNo,
      @TimestampSerializer() DateTime? endDate,
      List<Expense>? expenses,
      List<BookingTask>? tasks,
      String governmentId,
      num guests,
      String listingId,
      String listingTitle,
      num? luggage,
      String? id,
      bool needsContributions,
      String? paymentOption,
      String? paymentStatus,
      num price,
      String? roomId,
      num? vehicleNo,
      String? vehicleUid,
      String? roomUid,
      @TimestampSerializer() DateTime? selectedDate,
      String? selectedTime,
      @TimestampSerializer() DateTime? startDate,
      String bookingStatus,
      num? totalPrice,
      String tripUid,
      String tripName,
      String? typeOfTrip,
      @TimeOfDayConverter() TimeOfDay? startTime,
      @TimeOfDayConverter() TimeOfDay? endTime,
      @TimestampSerializer() DateTime? serviceStart,
      @TimestampSerializer() DateTime? serviceComplete});
}

/// @nodoc
class __$$ListingBookingsImplCopyWithImpl<$Res>
    extends _$ListingBookingsCopyWithImpl<$Res, _$ListingBookingsImpl>
    implements _$$ListingBookingsImplCopyWith<$Res> {
  __$$ListingBookingsImplCopyWithImpl(
      _$ListingBookingsImpl _value, $Res Function(_$ListingBookingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amountPaid = freezed,
    Object? customerId = null,
    Object? customerName = null,
    Object? customerPhoneNo = null,
    Object? category = null,
    Object? email = null,
    Object? cooperativeId = freezed,
    Object? emergencyContactName = freezed,
    Object? emergencyContactNo = freezed,
    Object? endDate = freezed,
    Object? expenses = freezed,
    Object? tasks = freezed,
    Object? governmentId = null,
    Object? guests = null,
    Object? listingId = null,
    Object? listingTitle = null,
    Object? luggage = freezed,
    Object? id = freezed,
    Object? needsContributions = null,
    Object? paymentOption = freezed,
    Object? paymentStatus = freezed,
    Object? price = null,
    Object? roomId = freezed,
    Object? vehicleNo = freezed,
    Object? vehicleUid = freezed,
    Object? roomUid = freezed,
    Object? selectedDate = freezed,
    Object? selectedTime = freezed,
    Object? startDate = freezed,
    Object? bookingStatus = null,
    Object? totalPrice = freezed,
    Object? tripUid = null,
    Object? tripName = null,
    Object? typeOfTrip = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? serviceStart = freezed,
    Object? serviceComplete = freezed,
  }) {
    return _then(_$ListingBookingsImpl(
      amountPaid: freezed == amountPaid
          ? _value.amountPaid
          : amountPaid // ignore: cast_nullable_to_non_nullable
              as num?,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhoneNo: null == customerPhoneNo
          ? _value.customerPhoneNo
          : customerPhoneNo // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      cooperativeId: freezed == cooperativeId
          ? _value.cooperativeId
          : cooperativeId // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactName: freezed == emergencyContactName
          ? _value.emergencyContactName
          : emergencyContactName // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactNo: freezed == emergencyContactNo
          ? _value.emergencyContactNo
          : emergencyContactNo // ignore: cast_nullable_to_non_nullable
              as String?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expenses: freezed == expenses
          ? _value._expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as List<Expense>?,
      tasks: freezed == tasks
          ? _value._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<BookingTask>?,
      governmentId: null == governmentId
          ? _value.governmentId
          : governmentId // ignore: cast_nullable_to_non_nullable
              as String,
      guests: null == guests
          ? _value.guests
          : guests // ignore: cast_nullable_to_non_nullable
              as num,
      listingId: null == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String,
      listingTitle: null == listingTitle
          ? _value.listingTitle
          : listingTitle // ignore: cast_nullable_to_non_nullable
              as String,
      luggage: freezed == luggage
          ? _value.luggage
          : luggage // ignore: cast_nullable_to_non_nullable
              as num?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      needsContributions: null == needsContributions
          ? _value.needsContributions
          : needsContributions // ignore: cast_nullable_to_non_nullable
              as bool,
      paymentOption: freezed == paymentOption
          ? _value.paymentOption
          : paymentOption // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatus: freezed == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as num,
      roomId: freezed == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleNo: freezed == vehicleNo
          ? _value.vehicleNo
          : vehicleNo // ignore: cast_nullable_to_non_nullable
              as num?,
      vehicleUid: freezed == vehicleUid
          ? _value.vehicleUid
          : vehicleUid // ignore: cast_nullable_to_non_nullable
              as String?,
      roomUid: freezed == roomUid
          ? _value.roomUid
          : roomUid // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedDate: freezed == selectedDate
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      selectedTime: freezed == selectedTime
          ? _value.selectedTime
          : selectedTime // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      bookingStatus: null == bookingStatus
          ? _value.bookingStatus
          : bookingStatus // ignore: cast_nullable_to_non_nullable
              as String,
      totalPrice: freezed == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as num?,
      tripUid: null == tripUid
          ? _value.tripUid
          : tripUid // ignore: cast_nullable_to_non_nullable
              as String,
      tripName: null == tripName
          ? _value.tripName
          : tripName // ignore: cast_nullable_to_non_nullable
              as String,
      typeOfTrip: freezed == typeOfTrip
          ? _value.typeOfTrip
          : typeOfTrip // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      serviceStart: freezed == serviceStart
          ? _value.serviceStart
          : serviceStart // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serviceComplete: freezed == serviceComplete
          ? _value.serviceComplete
          : serviceComplete // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListingBookingsImpl extends _ListingBookings {
  _$ListingBookingsImpl(
      {this.amountPaid,
      required this.customerId,
      required this.customerName,
      required this.customerPhoneNo,
      required this.category,
      required this.email,
      this.cooperativeId,
      this.emergencyContactName,
      this.emergencyContactNo,
      @TimestampSerializer() this.endDate,
      final List<Expense>? expenses,
      final List<BookingTask>? tasks,
      required this.governmentId,
      required this.guests,
      required this.listingId,
      required this.listingTitle,
      this.luggage,
      this.id,
      required this.needsContributions,
      this.paymentOption,
      this.paymentStatus,
      required this.price,
      this.roomId,
      this.vehicleNo,
      this.vehicleUid,
      this.roomUid,
      @TimestampSerializer() this.selectedDate,
      this.selectedTime,
      @TimestampSerializer() this.startDate,
      required this.bookingStatus,
      this.totalPrice,
      required this.tripUid,
      required this.tripName,
      this.typeOfTrip,
      @TimeOfDayConverter() this.startTime,
      @TimeOfDayConverter() this.endTime,
      @TimestampSerializer() this.serviceStart,
      @TimestampSerializer() this.serviceComplete})
      : _expenses = expenses,
        _tasks = tasks,
        super._();

  factory _$ListingBookingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListingBookingsImplFromJson(json);

  @override
  final num? amountPaid;
  @override
  final String customerId;
  @override
  final String customerName;
  @override
  final String customerPhoneNo;
  @override
  final String category;
  @override
  final String email;
  @override
  final String? cooperativeId;
  @override
  final String? emergencyContactName;
  @override
  final String? emergencyContactNo;
  @override
  @TimestampSerializer()
  final DateTime? endDate;
  final List<Expense>? _expenses;
  @override
  List<Expense>? get expenses {
    final value = _expenses;
    if (value == null) return null;
    if (_expenses is EqualUnmodifiableListView) return _expenses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<BookingTask>? _tasks;
  @override
  List<BookingTask>? get tasks {
    final value = _tasks;
    if (value == null) return null;
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String governmentId;
  @override
  final num guests;
  @override
  final String listingId;
  @override
  final String listingTitle;
  @override
  final num? luggage;
  @override
  final String? id;
  @override
  final bool needsContributions;
  @override
  final String? paymentOption;
//Downpayment, Full Payment
  @override
  final String? paymentStatus;
//Partially Paid, Fully Paid, Cancelled
  @override
  final num price;
  @override
  final String? roomId;
  @override
  final num? vehicleNo;
  @override
  final String? vehicleUid;
  @override
  final String? roomUid;
  @override
  @TimestampSerializer()
  final DateTime? selectedDate;
  @override
  final String? selectedTime;
  @override
  @TimestampSerializer()
  final DateTime? startDate;
  @override
  final String bookingStatus;
//[Reserved, Cancelled, Completed, Refunded, Maintenance
  @override
  final num? totalPrice;
  @override
  final String tripUid;
  @override
  final String tripName;
  @override
  final String? typeOfTrip;
  @override
  @TimeOfDayConverter()
  final TimeOfDay? startTime;
  @override
  @TimeOfDayConverter()
  final TimeOfDay? endTime;
  @override
  @TimestampSerializer()
  final DateTime? serviceStart;
  @override
  @TimestampSerializer()
  final DateTime? serviceComplete;

  @override
  String toString() {
    return 'ListingBookings(amountPaid: $amountPaid, customerId: $customerId, customerName: $customerName, customerPhoneNo: $customerPhoneNo, category: $category, email: $email, cooperativeId: $cooperativeId, emergencyContactName: $emergencyContactName, emergencyContactNo: $emergencyContactNo, endDate: $endDate, expenses: $expenses, tasks: $tasks, governmentId: $governmentId, guests: $guests, listingId: $listingId, listingTitle: $listingTitle, luggage: $luggage, id: $id, needsContributions: $needsContributions, paymentOption: $paymentOption, paymentStatus: $paymentStatus, price: $price, roomId: $roomId, vehicleNo: $vehicleNo, vehicleUid: $vehicleUid, roomUid: $roomUid, selectedDate: $selectedDate, selectedTime: $selectedTime, startDate: $startDate, bookingStatus: $bookingStatus, totalPrice: $totalPrice, tripUid: $tripUid, tripName: $tripName, typeOfTrip: $typeOfTrip, startTime: $startTime, endTime: $endTime, serviceStart: $serviceStart, serviceComplete: $serviceComplete)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListingBookingsImpl &&
            (identical(other.amountPaid, amountPaid) ||
                other.amountPaid == amountPaid) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhoneNo, customerPhoneNo) ||
                other.customerPhoneNo == customerPhoneNo) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.cooperativeId, cooperativeId) ||
                other.cooperativeId == cooperativeId) &&
            (identical(other.emergencyContactName, emergencyContactName) ||
                other.emergencyContactName == emergencyContactName) &&
            (identical(other.emergencyContactNo, emergencyContactNo) ||
                other.emergencyContactNo == emergencyContactNo) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality().equals(other._expenses, _expenses) &&
            const DeepCollectionEquality().equals(other._tasks, _tasks) &&
            (identical(other.governmentId, governmentId) ||
                other.governmentId == governmentId) &&
            (identical(other.guests, guests) || other.guests == guests) &&
            (identical(other.listingId, listingId) ||
                other.listingId == listingId) &&
            (identical(other.listingTitle, listingTitle) ||
                other.listingTitle == listingTitle) &&
            (identical(other.luggage, luggage) || other.luggage == luggage) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.needsContributions, needsContributions) ||
                other.needsContributions == needsContributions) &&
            (identical(other.paymentOption, paymentOption) ||
                other.paymentOption == paymentOption) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.vehicleNo, vehicleNo) ||
                other.vehicleNo == vehicleNo) &&
            (identical(other.vehicleUid, vehicleUid) ||
                other.vehicleUid == vehicleUid) &&
            (identical(other.roomUid, roomUid) || other.roomUid == roomUid) &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            (identical(other.selectedTime, selectedTime) ||
                other.selectedTime == selectedTime) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.bookingStatus, bookingStatus) ||
                other.bookingStatus == bookingStatus) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.tripUid, tripUid) || other.tripUid == tripUid) &&
            (identical(other.tripName, tripName) ||
                other.tripName == tripName) &&
            (identical(other.typeOfTrip, typeOfTrip) ||
                other.typeOfTrip == typeOfTrip) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.serviceStart, serviceStart) ||
                other.serviceStart == serviceStart) &&
            (identical(other.serviceComplete, serviceComplete) ||
                other.serviceComplete == serviceComplete));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        amountPaid,
        customerId,
        customerName,
        customerPhoneNo,
        category,
        email,
        cooperativeId,
        emergencyContactName,
        emergencyContactNo,
        endDate,
        const DeepCollectionEquality().hash(_expenses),
        const DeepCollectionEquality().hash(_tasks),
        governmentId,
        guests,
        listingId,
        listingTitle,
        luggage,
        id,
        needsContributions,
        paymentOption,
        paymentStatus,
        price,
        roomId,
        vehicleNo,
        vehicleUid,
        roomUid,
        selectedDate,
        selectedTime,
        startDate,
        bookingStatus,
        totalPrice,
        tripUid,
        tripName,
        typeOfTrip,
        startTime,
        endTime,
        serviceStart,
        serviceComplete
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ListingBookingsImplCopyWith<_$ListingBookingsImpl> get copyWith =>
      __$$ListingBookingsImplCopyWithImpl<_$ListingBookingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListingBookingsImplToJson(
      this,
    );
  }
}

abstract class _ListingBookings extends ListingBookings {
  factory _ListingBookings(
          {final num? amountPaid,
          required final String customerId,
          required final String customerName,
          required final String customerPhoneNo,
          required final String category,
          required final String email,
          final String? cooperativeId,
          final String? emergencyContactName,
          final String? emergencyContactNo,
          @TimestampSerializer() final DateTime? endDate,
          final List<Expense>? expenses,
          final List<BookingTask>? tasks,
          required final String governmentId,
          required final num guests,
          required final String listingId,
          required final String listingTitle,
          final num? luggage,
          final String? id,
          required final bool needsContributions,
          final String? paymentOption,
          final String? paymentStatus,
          required final num price,
          final String? roomId,
          final num? vehicleNo,
          final String? vehicleUid,
          final String? roomUid,
          @TimestampSerializer() final DateTime? selectedDate,
          final String? selectedTime,
          @TimestampSerializer() final DateTime? startDate,
          required final String bookingStatus,
          final num? totalPrice,
          required final String tripUid,
          required final String tripName,
          final String? typeOfTrip,
          @TimeOfDayConverter() final TimeOfDay? startTime,
          @TimeOfDayConverter() final TimeOfDay? endTime,
          @TimestampSerializer() final DateTime? serviceStart,
          @TimestampSerializer() final DateTime? serviceComplete}) =
      _$ListingBookingsImpl;
  _ListingBookings._() : super._();

  factory _ListingBookings.fromJson(Map<String, dynamic> json) =
      _$ListingBookingsImpl.fromJson;

  @override
  num? get amountPaid;
  @override
  String get customerId;
  @override
  String get customerName;
  @override
  String get customerPhoneNo;
  @override
  String get category;
  @override
  String get email;
  @override
  String? get cooperativeId;
  @override
  String? get emergencyContactName;
  @override
  String? get emergencyContactNo;
  @override
  @TimestampSerializer()
  DateTime? get endDate;
  @override
  List<Expense>? get expenses;
  @override
  List<BookingTask>? get tasks;
  @override
  String get governmentId;
  @override
  num get guests;
  @override
  String get listingId;
  @override
  String get listingTitle;
  @override
  num? get luggage;
  @override
  String? get id;
  @override
  bool get needsContributions;
  @override
  String? get paymentOption;
  @override //Downpayment, Full Payment
  String? get paymentStatus;
  @override //Partially Paid, Fully Paid, Cancelled
  num get price;
  @override
  String? get roomId;
  @override
  num? get vehicleNo;
  @override
  String? get vehicleUid;
  @override
  String? get roomUid;
  @override
  @TimestampSerializer()
  DateTime? get selectedDate;
  @override
  String? get selectedTime;
  @override
  @TimestampSerializer()
  DateTime? get startDate;
  @override
  String get bookingStatus;
  @override //[Reserved, Cancelled, Completed, Refunded, Maintenance
  num? get totalPrice;
  @override
  String get tripUid;
  @override
  String get tripName;
  @override
  String? get typeOfTrip;
  @override
  @TimeOfDayConverter()
  TimeOfDay? get startTime;
  @override
  @TimeOfDayConverter()
  TimeOfDay? get endTime;
  @override
  @TimestampSerializer()
  DateTime? get serviceStart;
  @override
  @TimestampSerializer()
  DateTime? get serviceComplete;
  @override
  @JsonKey(ignore: true)
  _$$ListingBookingsImplCopyWith<_$ListingBookingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Expense _$ExpenseFromJson(Map<String, dynamic> json) {
  return _Expense.fromJson(json);
}

/// @nodoc
mixin _$Expense {
  num get cost => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExpenseCopyWith<Expense> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseCopyWith<$Res> {
  factory $ExpenseCopyWith(Expense value, $Res Function(Expense) then) =
      _$ExpenseCopyWithImpl<$Res, Expense>;
  @useResult
  $Res call({num cost, String name});
}

/// @nodoc
class _$ExpenseCopyWithImpl<$Res, $Val extends Expense>
    implements $ExpenseCopyWith<$Res> {
  _$ExpenseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cost = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as num,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseImplCopyWith<$Res> implements $ExpenseCopyWith<$Res> {
  factory _$$ExpenseImplCopyWith(
          _$ExpenseImpl value, $Res Function(_$ExpenseImpl) then) =
      __$$ExpenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({num cost, String name});
}

/// @nodoc
class __$$ExpenseImplCopyWithImpl<$Res>
    extends _$ExpenseCopyWithImpl<$Res, _$ExpenseImpl>
    implements _$$ExpenseImplCopyWith<$Res> {
  __$$ExpenseImplCopyWithImpl(
      _$ExpenseImpl _value, $Res Function(_$ExpenseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cost = null,
    Object? name = null,
  }) {
    return _then(_$ExpenseImpl(
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as num,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseImpl implements _Expense {
  _$ExpenseImpl({required this.cost, required this.name});

  factory _$ExpenseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseImplFromJson(json);

  @override
  final num cost;
  @override
  final String name;

  @override
  String toString() {
    return 'Expense(cost: $cost, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseImpl &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, cost, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseImplCopyWith<_$ExpenseImpl> get copyWith =>
      __$$ExpenseImplCopyWithImpl<_$ExpenseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseImplToJson(
      this,
    );
  }
}

abstract class _Expense implements Expense {
  factory _Expense({required final num cost, required final String name}) =
      _$ExpenseImpl;

  factory _Expense.fromJson(Map<String, dynamic> json) = _$ExpenseImpl.fromJson;

  @override
  num get cost;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$ExpenseImplCopyWith<_$ExpenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingTask _$BookingTaskFromJson(Map<String, dynamic> json) {
  return _BookingTask.fromJson(json);
}

/// @nodoc
mixin _$BookingTask {
  String? get uid => throw _privateConstructorUsedError;
  String? get bookingId => throw _privateConstructorUsedError;
  String get listingName => throw _privateConstructorUsedError;
  String? get listingId => throw _privateConstructorUsedError;
  String? get roomId => throw _privateConstructorUsedError;
  List<String> get assignedIds => throw _privateConstructorUsedError;
  List<String> get assignedNames => throw _privateConstructorUsedError;
  List<String>? get contributorsIds => throw _privateConstructorUsedError;
  List<String>? get contributorsNames => throw _privateConstructorUsedError;
  String get committee => throw _privateConstructorUsedError;
  bool get complete => throw _privateConstructorUsedError;
  List<BookingTaskMessage>? get notes => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; //Pending, Incomplete, Completed
  bool get openContribution => throw _privateConstructorUsedError;
  List<TaskImages>? get imageProof => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookingTaskCopyWith<BookingTask> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingTaskCopyWith<$Res> {
  factory $BookingTaskCopyWith(
          BookingTask value, $Res Function(BookingTask) then) =
      _$BookingTaskCopyWithImpl<$Res, BookingTask>;
  @useResult
  $Res call(
      {String? uid,
      String? bookingId,
      String listingName,
      String? listingId,
      String? roomId,
      List<String> assignedIds,
      List<String> assignedNames,
      List<String>? contributorsIds,
      List<String>? contributorsNames,
      String committee,
      bool complete,
      List<BookingTaskMessage>? notes,
      String status,
      bool openContribution,
      List<TaskImages>? imageProof,
      String name});
}

/// @nodoc
class _$BookingTaskCopyWithImpl<$Res, $Val extends BookingTask>
    implements $BookingTaskCopyWith<$Res> {
  _$BookingTaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? bookingId = freezed,
    Object? listingName = null,
    Object? listingId = freezed,
    Object? roomId = freezed,
    Object? assignedIds = null,
    Object? assignedNames = null,
    Object? contributorsIds = freezed,
    Object? contributorsNames = freezed,
    Object? committee = null,
    Object? complete = null,
    Object? notes = freezed,
    Object? status = null,
    Object? openContribution = null,
    Object? imageProof = freezed,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
      listingName: null == listingName
          ? _value.listingName
          : listingName // ignore: cast_nullable_to_non_nullable
              as String,
      listingId: freezed == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String?,
      roomId: freezed == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedIds: null == assignedIds
          ? _value.assignedIds
          : assignedIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      assignedNames: null == assignedNames
          ? _value.assignedNames
          : assignedNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
      contributorsIds: freezed == contributorsIds
          ? _value.contributorsIds
          : contributorsIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      contributorsNames: freezed == contributorsNames
          ? _value.contributorsNames
          : contributorsNames // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      committee: null == committee
          ? _value.committee
          : committee // ignore: cast_nullable_to_non_nullable
              as String,
      complete: null == complete
          ? _value.complete
          : complete // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<BookingTaskMessage>?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      openContribution: null == openContribution
          ? _value.openContribution
          : openContribution // ignore: cast_nullable_to_non_nullable
              as bool,
      imageProof: freezed == imageProof
          ? _value.imageProof
          : imageProof // ignore: cast_nullable_to_non_nullable
              as List<TaskImages>?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingTaskImplCopyWith<$Res>
    implements $BookingTaskCopyWith<$Res> {
  factory _$$BookingTaskImplCopyWith(
          _$BookingTaskImpl value, $Res Function(_$BookingTaskImpl) then) =
      __$$BookingTaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? uid,
      String? bookingId,
      String listingName,
      String? listingId,
      String? roomId,
      List<String> assignedIds,
      List<String> assignedNames,
      List<String>? contributorsIds,
      List<String>? contributorsNames,
      String committee,
      bool complete,
      List<BookingTaskMessage>? notes,
      String status,
      bool openContribution,
      List<TaskImages>? imageProof,
      String name});
}

/// @nodoc
class __$$BookingTaskImplCopyWithImpl<$Res>
    extends _$BookingTaskCopyWithImpl<$Res, _$BookingTaskImpl>
    implements _$$BookingTaskImplCopyWith<$Res> {
  __$$BookingTaskImplCopyWithImpl(
      _$BookingTaskImpl _value, $Res Function(_$BookingTaskImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? bookingId = freezed,
    Object? listingName = null,
    Object? listingId = freezed,
    Object? roomId = freezed,
    Object? assignedIds = null,
    Object? assignedNames = null,
    Object? contributorsIds = freezed,
    Object? contributorsNames = freezed,
    Object? committee = null,
    Object? complete = null,
    Object? notes = freezed,
    Object? status = null,
    Object? openContribution = null,
    Object? imageProof = freezed,
    Object? name = null,
  }) {
    return _then(_$BookingTaskImpl(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
      listingName: null == listingName
          ? _value.listingName
          : listingName // ignore: cast_nullable_to_non_nullable
              as String,
      listingId: freezed == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String?,
      roomId: freezed == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedIds: null == assignedIds
          ? _value._assignedIds
          : assignedIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      assignedNames: null == assignedNames
          ? _value._assignedNames
          : assignedNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
      contributorsIds: freezed == contributorsIds
          ? _value._contributorsIds
          : contributorsIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      contributorsNames: freezed == contributorsNames
          ? _value._contributorsNames
          : contributorsNames // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      committee: null == committee
          ? _value.committee
          : committee // ignore: cast_nullable_to_non_nullable
              as String,
      complete: null == complete
          ? _value.complete
          : complete // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value._notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<BookingTaskMessage>?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      openContribution: null == openContribution
          ? _value.openContribution
          : openContribution // ignore: cast_nullable_to_non_nullable
              as bool,
      imageProof: freezed == imageProof
          ? _value._imageProof
          : imageProof // ignore: cast_nullable_to_non_nullable
              as List<TaskImages>?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingTaskImpl implements _BookingTask {
  _$BookingTaskImpl(
      {this.uid,
      this.bookingId,
      required this.listingName,
      this.listingId,
      this.roomId,
      required final List<String> assignedIds,
      required final List<String> assignedNames,
      final List<String>? contributorsIds,
      final List<String>? contributorsNames,
      required this.committee,
      required this.complete,
      final List<BookingTaskMessage>? notes,
      required this.status,
      required this.openContribution,
      final List<TaskImages>? imageProof,
      required this.name})
      : _assignedIds = assignedIds,
        _assignedNames = assignedNames,
        _contributorsIds = contributorsIds,
        _contributorsNames = contributorsNames,
        _notes = notes,
        _imageProof = imageProof;

  factory _$BookingTaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingTaskImplFromJson(json);

  @override
  final String? uid;
  @override
  final String? bookingId;
  @override
  final String listingName;
  @override
  final String? listingId;
  @override
  final String? roomId;
  final List<String> _assignedIds;
  @override
  List<String> get assignedIds {
    if (_assignedIds is EqualUnmodifiableListView) return _assignedIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assignedIds);
  }

  final List<String> _assignedNames;
  @override
  List<String> get assignedNames {
    if (_assignedNames is EqualUnmodifiableListView) return _assignedNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assignedNames);
  }

  final List<String>? _contributorsIds;
  @override
  List<String>? get contributorsIds {
    final value = _contributorsIds;
    if (value == null) return null;
    if (_contributorsIds is EqualUnmodifiableListView) return _contributorsIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _contributorsNames;
  @override
  List<String>? get contributorsNames {
    final value = _contributorsNames;
    if (value == null) return null;
    if (_contributorsNames is EqualUnmodifiableListView)
      return _contributorsNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String committee;
  @override
  final bool complete;
  final List<BookingTaskMessage>? _notes;
  @override
  List<BookingTaskMessage>? get notes {
    final value = _notes;
    if (value == null) return null;
    if (_notes is EqualUnmodifiableListView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String status;
//Pending, Incomplete, Completed
  @override
  final bool openContribution;
  final List<TaskImages>? _imageProof;
  @override
  List<TaskImages>? get imageProof {
    final value = _imageProof;
    if (value == null) return null;
    if (_imageProof is EqualUnmodifiableListView) return _imageProof;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String name;

  @override
  String toString() {
    return 'BookingTask(uid: $uid, bookingId: $bookingId, listingName: $listingName, listingId: $listingId, roomId: $roomId, assignedIds: $assignedIds, assignedNames: $assignedNames, contributorsIds: $contributorsIds, contributorsNames: $contributorsNames, committee: $committee, complete: $complete, notes: $notes, status: $status, openContribution: $openContribution, imageProof: $imageProof, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingTaskImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.listingName, listingName) ||
                other.listingName == listingName) &&
            (identical(other.listingId, listingId) ||
                other.listingId == listingId) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            const DeepCollectionEquality()
                .equals(other._assignedIds, _assignedIds) &&
            const DeepCollectionEquality()
                .equals(other._assignedNames, _assignedNames) &&
            const DeepCollectionEquality()
                .equals(other._contributorsIds, _contributorsIds) &&
            const DeepCollectionEquality()
                .equals(other._contributorsNames, _contributorsNames) &&
            (identical(other.committee, committee) ||
                other.committee == committee) &&
            (identical(other.complete, complete) ||
                other.complete == complete) &&
            const DeepCollectionEquality().equals(other._notes, _notes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.openContribution, openContribution) ||
                other.openContribution == openContribution) &&
            const DeepCollectionEquality()
                .equals(other._imageProof, _imageProof) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      bookingId,
      listingName,
      listingId,
      roomId,
      const DeepCollectionEquality().hash(_assignedIds),
      const DeepCollectionEquality().hash(_assignedNames),
      const DeepCollectionEquality().hash(_contributorsIds),
      const DeepCollectionEquality().hash(_contributorsNames),
      committee,
      complete,
      const DeepCollectionEquality().hash(_notes),
      status,
      openContribution,
      const DeepCollectionEquality().hash(_imageProof),
      name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingTaskImplCopyWith<_$BookingTaskImpl> get copyWith =>
      __$$BookingTaskImplCopyWithImpl<_$BookingTaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingTaskImplToJson(
      this,
    );
  }
}

abstract class _BookingTask implements BookingTask {
  factory _BookingTask(
      {final String? uid,
      final String? bookingId,
      required final String listingName,
      final String? listingId,
      final String? roomId,
      required final List<String> assignedIds,
      required final List<String> assignedNames,
      final List<String>? contributorsIds,
      final List<String>? contributorsNames,
      required final String committee,
      required final bool complete,
      final List<BookingTaskMessage>? notes,
      required final String status,
      required final bool openContribution,
      final List<TaskImages>? imageProof,
      required final String name}) = _$BookingTaskImpl;

  factory _BookingTask.fromJson(Map<String, dynamic> json) =
      _$BookingTaskImpl.fromJson;

  @override
  String? get uid;
  @override
  String? get bookingId;
  @override
  String get listingName;
  @override
  String? get listingId;
  @override
  String? get roomId;
  @override
  List<String> get assignedIds;
  @override
  List<String> get assignedNames;
  @override
  List<String>? get contributorsIds;
  @override
  List<String>? get contributorsNames;
  @override
  String get committee;
  @override
  bool get complete;
  @override
  List<BookingTaskMessage>? get notes;
  @override
  String get status;
  @override //Pending, Incomplete, Completed
  bool get openContribution;
  @override
  List<TaskImages>? get imageProof;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$BookingTaskImplCopyWith<_$BookingTaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingTaskMessage _$BookingTaskMessageFromJson(Map<String, dynamic> json) {
  return _BookingTaskMessage.fromJson(json);
}

/// @nodoc
mixin _$BookingTaskMessage {
  String? get uid => throw _privateConstructorUsedError;
  String? get bookingId => throw _privateConstructorUsedError;
  String get listingName => throw _privateConstructorUsedError;
  String? get listingId => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  String get taskId => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime get timestamp => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookingTaskMessageCopyWith<BookingTaskMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingTaskMessageCopyWith<$Res> {
  factory $BookingTaskMessageCopyWith(
          BookingTaskMessage value, $Res Function(BookingTaskMessage) then) =
      _$BookingTaskMessageCopyWithImpl<$Res, BookingTaskMessage>;
  @useResult
  $Res call(
      {String? uid,
      String? bookingId,
      String listingName,
      String? listingId,
      String senderId,
      String senderName,
      String taskId,
      @TimestampSerializer() DateTime timestamp,
      String content});
}

/// @nodoc
class _$BookingTaskMessageCopyWithImpl<$Res, $Val extends BookingTaskMessage>
    implements $BookingTaskMessageCopyWith<$Res> {
  _$BookingTaskMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? bookingId = freezed,
    Object? listingName = null,
    Object? listingId = freezed,
    Object? senderId = null,
    Object? senderName = null,
    Object? taskId = null,
    Object? timestamp = null,
    Object? content = null,
  }) {
    return _then(_value.copyWith(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
      listingName: null == listingName
          ? _value.listingName
          : listingName // ignore: cast_nullable_to_non_nullable
              as String,
      listingId: freezed == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String?,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingTaskMessageImplCopyWith<$Res>
    implements $BookingTaskMessageCopyWith<$Res> {
  factory _$$BookingTaskMessageImplCopyWith(_$BookingTaskMessageImpl value,
          $Res Function(_$BookingTaskMessageImpl) then) =
      __$$BookingTaskMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? uid,
      String? bookingId,
      String listingName,
      String? listingId,
      String senderId,
      String senderName,
      String taskId,
      @TimestampSerializer() DateTime timestamp,
      String content});
}

/// @nodoc
class __$$BookingTaskMessageImplCopyWithImpl<$Res>
    extends _$BookingTaskMessageCopyWithImpl<$Res, _$BookingTaskMessageImpl>
    implements _$$BookingTaskMessageImplCopyWith<$Res> {
  __$$BookingTaskMessageImplCopyWithImpl(_$BookingTaskMessageImpl _value,
      $Res Function(_$BookingTaskMessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? bookingId = freezed,
    Object? listingName = null,
    Object? listingId = freezed,
    Object? senderId = null,
    Object? senderName = null,
    Object? taskId = null,
    Object? timestamp = null,
    Object? content = null,
  }) {
    return _then(_$BookingTaskMessageImpl(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
      listingName: null == listingName
          ? _value.listingName
          : listingName // ignore: cast_nullable_to_non_nullable
              as String,
      listingId: freezed == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String?,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingTaskMessageImpl implements _BookingTaskMessage {
  _$BookingTaskMessageImpl(
      {this.uid,
      this.bookingId,
      required this.listingName,
      this.listingId,
      required this.senderId,
      required this.senderName,
      required this.taskId,
      @TimestampSerializer() required this.timestamp,
      required this.content});

  factory _$BookingTaskMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingTaskMessageImplFromJson(json);

  @override
  final String? uid;
  @override
  final String? bookingId;
  @override
  final String listingName;
  @override
  final String? listingId;
  @override
  final String senderId;
  @override
  final String senderName;
  @override
  final String taskId;
  @override
  @TimestampSerializer()
  final DateTime timestamp;
  @override
  final String content;

  @override
  String toString() {
    return 'BookingTaskMessage(uid: $uid, bookingId: $bookingId, listingName: $listingName, listingId: $listingId, senderId: $senderId, senderName: $senderName, taskId: $taskId, timestamp: $timestamp, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingTaskMessageImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.listingName, listingName) ||
                other.listingName == listingName) &&
            (identical(other.listingId, listingId) ||
                other.listingId == listingId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uid, bookingId, listingName,
      listingId, senderId, senderName, taskId, timestamp, content);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingTaskMessageImplCopyWith<_$BookingTaskMessageImpl> get copyWith =>
      __$$BookingTaskMessageImplCopyWithImpl<_$BookingTaskMessageImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingTaskMessageImplToJson(
      this,
    );
  }
}

abstract class _BookingTaskMessage implements BookingTaskMessage {
  factory _BookingTaskMessage(
      {final String? uid,
      final String? bookingId,
      required final String listingName,
      final String? listingId,
      required final String senderId,
      required final String senderName,
      required final String taskId,
      @TimestampSerializer() required final DateTime timestamp,
      required final String content}) = _$BookingTaskMessageImpl;

  factory _BookingTaskMessage.fromJson(Map<String, dynamic> json) =
      _$BookingTaskMessageImpl.fromJson;

  @override
  String? get uid;
  @override
  String? get bookingId;
  @override
  String get listingName;
  @override
  String? get listingId;
  @override
  String get senderId;
  @override
  String get senderName;
  @override
  String get taskId;
  @override
  @TimestampSerializer()
  DateTime get timestamp;
  @override
  String get content;
  @override
  @JsonKey(ignore: true)
  _$$BookingTaskMessageImplCopyWith<_$BookingTaskMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskImages _$TaskImagesFromJson(Map<String, dynamic> json) {
  return _TaskImages.fromJson(json);
}

/// @nodoc
mixin _$TaskImages {
  String get path => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TaskImagesCopyWith<TaskImages> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskImagesCopyWith<$Res> {
  factory $TaskImagesCopyWith(
          TaskImages value, $Res Function(TaskImages) then) =
      _$TaskImagesCopyWithImpl<$Res, TaskImages>;
  @useResult
  $Res call({String path, String? url});
}

/// @nodoc
class _$TaskImagesCopyWithImpl<$Res, $Val extends TaskImages>
    implements $TaskImagesCopyWith<$Res> {
  _$TaskImagesCopyWithImpl(this._value, this._then);

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
abstract class _$$TaskImagesImplCopyWith<$Res>
    implements $TaskImagesCopyWith<$Res> {
  factory _$$TaskImagesImplCopyWith(
          _$TaskImagesImpl value, $Res Function(_$TaskImagesImpl) then) =
      __$$TaskImagesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String path, String? url});
}

/// @nodoc
class __$$TaskImagesImplCopyWithImpl<$Res>
    extends _$TaskImagesCopyWithImpl<$Res, _$TaskImagesImpl>
    implements _$$TaskImagesImplCopyWith<$Res> {
  __$$TaskImagesImplCopyWithImpl(
      _$TaskImagesImpl _value, $Res Function(_$TaskImagesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? url = freezed,
  }) {
    return _then(_$TaskImagesImpl(
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
class _$TaskImagesImpl implements _TaskImages {
  _$TaskImagesImpl({required this.path, this.url});

  factory _$TaskImagesImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskImagesImplFromJson(json);

  @override
  final String path;
  @override
  final String? url;

  @override
  String toString() {
    return 'TaskImages(path: $path, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskImagesImpl &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, path, url);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskImagesImplCopyWith<_$TaskImagesImpl> get copyWith =>
      __$$TaskImagesImplCopyWithImpl<_$TaskImagesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskImagesImplToJson(
      this,
    );
  }
}

abstract class _TaskImages implements TaskImages {
  factory _TaskImages({required final String path, final String? url}) =
      _$TaskImagesImpl;

  factory _TaskImages.fromJson(Map<String, dynamic> json) =
      _$TaskImagesImpl.fromJson;

  @override
  String get path;
  @override
  String? get url;
  @override
  @JsonKey(ignore: true)
  _$$TaskImagesImplCopyWith<_$TaskImagesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
