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
  List<Task>? get tasks => throw _privateConstructorUsedError;
  String get governmentId => throw _privateConstructorUsedError;
  num get guests => throw _privateConstructorUsedError;
  String get listingId => throw _privateConstructorUsedError;
  String get listingTitle => throw _privateConstructorUsedError;
  num? get luggage => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;
  bool get needsContributions => throw _privateConstructorUsedError;
  String? get paymentOption => throw _privateConstructorUsedError;
  num get price => throw _privateConstructorUsedError;
  String? get roomId => throw _privateConstructorUsedError;
  String? get roomUid => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get selectedDate => throw _privateConstructorUsedError;
  String? get selectedTime => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get startDate => throw _privateConstructorUsedError;
  String get bookingStatus => throw _privateConstructorUsedError;
  num? get totalPrice => throw _privateConstructorUsedError;
  String? get typeOfTrip => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay? get startTime => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay? get endTime => throw _privateConstructorUsedError;

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
      List<Task>? tasks,
      String governmentId,
      num guests,
      String listingId,
      String listingTitle,
      num? luggage,
      String? id,
      bool needsContributions,
      String? paymentOption,
      num price,
      String? roomId,
      String? roomUid,
      @TimestampSerializer() DateTime? selectedDate,
      String? selectedTime,
      @TimestampSerializer() DateTime? startDate,
      String bookingStatus,
      num? totalPrice,
      String? typeOfTrip,
      @TimeOfDayConverter() TimeOfDay? startTime,
      @TimeOfDayConverter() TimeOfDay? endTime});
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
    Object? price = null,
    Object? roomId = freezed,
    Object? roomUid = freezed,
    Object? selectedDate = freezed,
    Object? selectedTime = freezed,
    Object? startDate = freezed,
    Object? bookingStatus = null,
    Object? totalPrice = freezed,
    Object? typeOfTrip = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
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
              as List<Task>?,
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
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as num,
      roomId: freezed == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
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
      List<Task>? tasks,
      String governmentId,
      num guests,
      String listingId,
      String listingTitle,
      num? luggage,
      String? id,
      bool needsContributions,
      String? paymentOption,
      num price,
      String? roomId,
      String? roomUid,
      @TimestampSerializer() DateTime? selectedDate,
      String? selectedTime,
      @TimestampSerializer() DateTime? startDate,
      String bookingStatus,
      num? totalPrice,
      String? typeOfTrip,
      @TimeOfDayConverter() TimeOfDay? startTime,
      @TimeOfDayConverter() TimeOfDay? endTime});
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
    Object? price = null,
    Object? roomId = freezed,
    Object? roomUid = freezed,
    Object? selectedDate = freezed,
    Object? selectedTime = freezed,
    Object? startDate = freezed,
    Object? bookingStatus = null,
    Object? totalPrice = freezed,
    Object? typeOfTrip = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
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
              as List<Task>?,
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
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as num,
      roomId: freezed == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListingBookingsImpl implements _ListingBookings {
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
      final List<Task>? tasks,
      required this.governmentId,
      required this.guests,
      required this.listingId,
      required this.listingTitle,
      this.luggage,
      this.id,
      required this.needsContributions,
      this.paymentOption,
      required this.price,
      this.roomId,
      this.roomUid,
      @TimestampSerializer() this.selectedDate,
      this.selectedTime,
      @TimestampSerializer() this.startDate,
      required this.bookingStatus,
      this.totalPrice,
      this.typeOfTrip,
      @TimeOfDayConverter() this.startTime,
      @TimeOfDayConverter() this.endTime})
      : _expenses = expenses,
        _tasks = tasks;

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

  final List<Task>? _tasks;
  @override
  List<Task>? get tasks {
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
  @override
  final num price;
  @override
  final String? roomId;
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
  @override
  final num? totalPrice;
  @override
  final String? typeOfTrip;
  @override
  @TimeOfDayConverter()
  final TimeOfDay? startTime;
  @override
  @TimeOfDayConverter()
  final TimeOfDay? endTime;

  @override
  String toString() {
    return 'ListingBookings(amountPaid: $amountPaid, customerId: $customerId, customerName: $customerName, customerPhoneNo: $customerPhoneNo, category: $category, email: $email, cooperativeId: $cooperativeId, emergencyContactName: $emergencyContactName, emergencyContactNo: $emergencyContactNo, endDate: $endDate, expenses: $expenses, tasks: $tasks, governmentId: $governmentId, guests: $guests, listingId: $listingId, listingTitle: $listingTitle, luggage: $luggage, id: $id, needsContributions: $needsContributions, paymentOption: $paymentOption, price: $price, roomId: $roomId, roomUid: $roomUid, selectedDate: $selectedDate, selectedTime: $selectedTime, startDate: $startDate, bookingStatus: $bookingStatus, totalPrice: $totalPrice, typeOfTrip: $typeOfTrip, startTime: $startTime, endTime: $endTime)';
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
            (identical(other.price, price) || other.price == price) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
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
            (identical(other.typeOfTrip, typeOfTrip) ||
                other.typeOfTrip == typeOfTrip) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
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
        price,
        roomId,
        roomUid,
        selectedDate,
        selectedTime,
        startDate,
        bookingStatus,
        totalPrice,
        typeOfTrip,
        startTime,
        endTime
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

abstract class _ListingBookings implements ListingBookings {
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
      final List<Task>? tasks,
      required final String governmentId,
      required final num guests,
      required final String listingId,
      required final String listingTitle,
      final num? luggage,
      final String? id,
      required final bool needsContributions,
      final String? paymentOption,
      required final num price,
      final String? roomId,
      final String? roomUid,
      @TimestampSerializer() final DateTime? selectedDate,
      final String? selectedTime,
      @TimestampSerializer() final DateTime? startDate,
      required final String bookingStatus,
      final num? totalPrice,
      final String? typeOfTrip,
      @TimeOfDayConverter() final TimeOfDay? startTime,
      @TimeOfDayConverter() final TimeOfDay? endTime}) = _$ListingBookingsImpl;

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
  List<Task>? get tasks;
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
  @override
  num get price;
  @override
  String? get roomId;
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
  @override
  num? get totalPrice;
  @override
  String? get typeOfTrip;
  @override
  @TimeOfDayConverter()
  TimeOfDay? get startTime;
  @override
  @TimeOfDayConverter()
  TimeOfDay? get endTime;
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

Task _$TaskFromJson(Map<String, dynamic> json) {
  return _Task.fromJson(json);
}

/// @nodoc
mixin _$Task {
  List<String> get assigned => throw _privateConstructorUsedError;
  String get committee => throw _privateConstructorUsedError;
  bool get complete => throw _privateConstructorUsedError;
  bool get openContribution => throw _privateConstructorUsedError;
  List<TaskImages>? get imageProof => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TaskCopyWith<Task> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) then) =
      _$TaskCopyWithImpl<$Res, Task>;
  @useResult
  $Res call(
      {List<String> assigned,
      String committee,
      bool complete,
      bool openContribution,
      List<TaskImages>? imageProof,
      String name});
}

/// @nodoc
class _$TaskCopyWithImpl<$Res, $Val extends Task>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assigned = null,
    Object? committee = null,
    Object? complete = null,
    Object? openContribution = null,
    Object? imageProof = freezed,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      assigned: null == assigned
          ? _value.assigned
          : assigned // ignore: cast_nullable_to_non_nullable
              as List<String>,
      committee: null == committee
          ? _value.committee
          : committee // ignore: cast_nullable_to_non_nullable
              as String,
      complete: null == complete
          ? _value.complete
          : complete // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$TaskImplCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$$TaskImplCopyWith(
          _$TaskImpl value, $Res Function(_$TaskImpl) then) =
      __$$TaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> assigned,
      String committee,
      bool complete,
      bool openContribution,
      List<TaskImages>? imageProof,
      String name});
}

/// @nodoc
class __$$TaskImplCopyWithImpl<$Res>
    extends _$TaskCopyWithImpl<$Res, _$TaskImpl>
    implements _$$TaskImplCopyWith<$Res> {
  __$$TaskImplCopyWithImpl(_$TaskImpl _value, $Res Function(_$TaskImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assigned = null,
    Object? committee = null,
    Object? complete = null,
    Object? openContribution = null,
    Object? imageProof = freezed,
    Object? name = null,
  }) {
    return _then(_$TaskImpl(
      assigned: null == assigned
          ? _value._assigned
          : assigned // ignore: cast_nullable_to_non_nullable
              as List<String>,
      committee: null == committee
          ? _value.committee
          : committee // ignore: cast_nullable_to_non_nullable
              as String,
      complete: null == complete
          ? _value.complete
          : complete // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$TaskImpl implements _Task {
  _$TaskImpl(
      {required final List<String> assigned,
      required this.committee,
      required this.complete,
      required this.openContribution,
      final List<TaskImages>? imageProof,
      required this.name})
      : _assigned = assigned,
        _imageProof = imageProof;

  factory _$TaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskImplFromJson(json);

  final List<String> _assigned;
  @override
  List<String> get assigned {
    if (_assigned is EqualUnmodifiableListView) return _assigned;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assigned);
  }

  @override
  final String committee;
  @override
  final bool complete;
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
    return 'Task(assigned: $assigned, committee: $committee, complete: $complete, openContribution: $openContribution, imageProof: $imageProof, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskImpl &&
            const DeepCollectionEquality().equals(other._assigned, _assigned) &&
            (identical(other.committee, committee) ||
                other.committee == committee) &&
            (identical(other.complete, complete) ||
                other.complete == complete) &&
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
      const DeepCollectionEquality().hash(_assigned),
      committee,
      complete,
      openContribution,
      const DeepCollectionEquality().hash(_imageProof),
      name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      __$$TaskImplCopyWithImpl<_$TaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskImplToJson(
      this,
    );
  }
}

abstract class _Task implements Task {
  factory _Task(
      {required final List<String> assigned,
      required final String committee,
      required final bool complete,
      required final bool openContribution,
      final List<TaskImages>? imageProof,
      required final String name}) = _$TaskImpl;

  factory _Task.fromJson(Map<String, dynamic> json) = _$TaskImpl.fromJson;

  @override
  List<String> get assigned;
  @override
  String get committee;
  @override
  bool get complete;
  @override
  bool get openContribution;
  @override
  List<TaskImages>? get imageProof;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
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
