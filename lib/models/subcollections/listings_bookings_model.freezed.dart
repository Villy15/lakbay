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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ListingBookings _$ListingBookingsFromJson(Map<String, dynamic> json) {
  return _ListingBookings.fromJson(json);
}

/// @nodoc
mixin _$ListingBookings {
  String get category => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get emergencyContactName => throw _privateConstructorUsedError;
  String? get emergencyContactNo => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get endDate => throw _privateConstructorUsedError;
  List<Expense>? get expenses => throw _privateConstructorUsedError;
  String get governmentId => throw _privateConstructorUsedError;
  num get guests => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;
  bool get needsContributions => throw _privateConstructorUsedError;
  String get phoneNo => throw _privateConstructorUsedError;
  num get price => throw _privateConstructorUsedError;
  String get roomId => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get selectedDate => throw _privateConstructorUsedError;
  String? get selectedTime => throw _privateConstructorUsedError;
  @TimestampSerializer()
  DateTime? get startDate => throw _privateConstructorUsedError;
  num get totalPrice => throw _privateConstructorUsedError;
  String? get typeOfTrip => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;

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
      {String category,
      String email,
      String? emergencyContactName,
      String? emergencyContactNo,
      @TimestampSerializer() DateTime? endDate,
      List<Expense>? expenses,
      String governmentId,
      num guests,
      String? id,
      bool needsContributions,
      String phoneNo,
      num price,
      String roomId,
      @TimestampSerializer() DateTime? selectedDate,
      String? selectedTime,
      @TimestampSerializer() DateTime? startDate,
      num totalPrice,
      String? typeOfTrip,
      String userId});
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
    Object? category = null,
    Object? email = null,
    Object? emergencyContactName = freezed,
    Object? emergencyContactNo = freezed,
    Object? endDate = freezed,
    Object? expenses = freezed,
    Object? governmentId = null,
    Object? guests = null,
    Object? id = freezed,
    Object? needsContributions = null,
    Object? phoneNo = null,
    Object? price = null,
    Object? roomId = null,
    Object? selectedDate = freezed,
    Object? selectedTime = freezed,
    Object? startDate = freezed,
    Object? totalPrice = null,
    Object? typeOfTrip = freezed,
    Object? userId = null,
  }) {
    return _then(_value.copyWith(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
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
      governmentId: null == governmentId
          ? _value.governmentId
          : governmentId // ignore: cast_nullable_to_non_nullable
              as String,
      guests: null == guests
          ? _value.guests
          : guests // ignore: cast_nullable_to_non_nullable
              as num,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      needsContributions: null == needsContributions
          ? _value.needsContributions
          : needsContributions // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneNo: null == phoneNo
          ? _value.phoneNo
          : phoneNo // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as num,
      roomId: null == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
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
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as num,
      typeOfTrip: freezed == typeOfTrip
          ? _value.typeOfTrip
          : typeOfTrip // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
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
      {String category,
      String email,
      String? emergencyContactName,
      String? emergencyContactNo,
      @TimestampSerializer() DateTime? endDate,
      List<Expense>? expenses,
      String governmentId,
      num guests,
      String? id,
      bool needsContributions,
      String phoneNo,
      num price,
      String roomId,
      @TimestampSerializer() DateTime? selectedDate,
      String? selectedTime,
      @TimestampSerializer() DateTime? startDate,
      num totalPrice,
      String? typeOfTrip,
      String userId});
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
    Object? category = null,
    Object? email = null,
    Object? emergencyContactName = freezed,
    Object? emergencyContactNo = freezed,
    Object? endDate = freezed,
    Object? expenses = freezed,
    Object? governmentId = null,
    Object? guests = null,
    Object? id = freezed,
    Object? needsContributions = null,
    Object? phoneNo = null,
    Object? price = null,
    Object? roomId = null,
    Object? selectedDate = freezed,
    Object? selectedTime = freezed,
    Object? startDate = freezed,
    Object? totalPrice = null,
    Object? typeOfTrip = freezed,
    Object? userId = null,
  }) {
    return _then(_$ListingBookingsImpl(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
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
      governmentId: null == governmentId
          ? _value.governmentId
          : governmentId // ignore: cast_nullable_to_non_nullable
              as String,
      guests: null == guests
          ? _value.guests
          : guests // ignore: cast_nullable_to_non_nullable
              as num,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      needsContributions: null == needsContributions
          ? _value.needsContributions
          : needsContributions // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneNo: null == phoneNo
          ? _value.phoneNo
          : phoneNo // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as num,
      roomId: null == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
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
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as num,
      typeOfTrip: freezed == typeOfTrip
          ? _value.typeOfTrip
          : typeOfTrip // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListingBookingsImpl implements _ListingBookings {
  _$ListingBookingsImpl(
      {required this.category,
      required this.email,
      this.emergencyContactName,
      this.emergencyContactNo,
      @TimestampSerializer() this.endDate,
      final List<Expense>? expenses,
      required this.governmentId,
      required this.guests,
      this.id,
      required this.needsContributions,
      required this.phoneNo,
      required this.price,
      required this.roomId,
      @TimestampSerializer() this.selectedDate,
      this.selectedTime,
      @TimestampSerializer() this.startDate,
      required this.totalPrice,
      this.typeOfTrip,
      required this.userId})
      : _expenses = expenses;

  factory _$ListingBookingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListingBookingsImplFromJson(json);

  @override
  final String category;
  @override
  final String email;
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

  @override
  final String governmentId;
  @override
  final num guests;
  @override
  final String? id;
  @override
  final bool needsContributions;
  @override
  final String phoneNo;
  @override
  final num price;
  @override
  final String roomId;
  @override
  @TimestampSerializer()
  final DateTime? selectedDate;
  @override
  final String? selectedTime;
  @override
  @TimestampSerializer()
  final DateTime? startDate;
  @override
  final num totalPrice;
  @override
  final String? typeOfTrip;
  @override
  final String userId;

  @override
  String toString() {
    return 'ListingBookings(category: $category, email: $email, emergencyContactName: $emergencyContactName, emergencyContactNo: $emergencyContactNo, endDate: $endDate, expenses: $expenses, governmentId: $governmentId, guests: $guests, id: $id, needsContributions: $needsContributions, phoneNo: $phoneNo, price: $price, roomId: $roomId, selectedDate: $selectedDate, selectedTime: $selectedTime, startDate: $startDate, totalPrice: $totalPrice, typeOfTrip: $typeOfTrip, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListingBookingsImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.emergencyContactName, emergencyContactName) ||
                other.emergencyContactName == emergencyContactName) &&
            (identical(other.emergencyContactNo, emergencyContactNo) ||
                other.emergencyContactNo == emergencyContactNo) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality().equals(other._expenses, _expenses) &&
            (identical(other.governmentId, governmentId) ||
                other.governmentId == governmentId) &&
            (identical(other.guests, guests) || other.guests == guests) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.needsContributions, needsContributions) ||
                other.needsContributions == needsContributions) &&
            (identical(other.phoneNo, phoneNo) || other.phoneNo == phoneNo) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            (identical(other.selectedTime, selectedTime) ||
                other.selectedTime == selectedTime) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.typeOfTrip, typeOfTrip) ||
                other.typeOfTrip == typeOfTrip) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        category,
        email,
        emergencyContactName,
        emergencyContactNo,
        endDate,
        const DeepCollectionEquality().hash(_expenses),
        governmentId,
        guests,
        id,
        needsContributions,
        phoneNo,
        price,
        roomId,
        selectedDate,
        selectedTime,
        startDate,
        totalPrice,
        typeOfTrip,
        userId
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
      {required final String category,
      required final String email,
      final String? emergencyContactName,
      final String? emergencyContactNo,
      @TimestampSerializer() final DateTime? endDate,
      final List<Expense>? expenses,
      required final String governmentId,
      required final num guests,
      final String? id,
      required final bool needsContributions,
      required final String phoneNo,
      required final num price,
      required final String roomId,
      @TimestampSerializer() final DateTime? selectedDate,
      final String? selectedTime,
      @TimestampSerializer() final DateTime? startDate,
      required final num totalPrice,
      final String? typeOfTrip,
      required final String userId}) = _$ListingBookingsImpl;

  factory _ListingBookings.fromJson(Map<String, dynamic> json) =
      _$ListingBookingsImpl.fromJson;

  @override
  String get category;
  @override
  String get email;
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
  String get governmentId;
  @override
  num get guests;
  @override
  String? get id;
  @override
  bool get needsContributions;
  @override
  String get phoneNo;
  @override
  num get price;
  @override
  String get roomId;
  @override
  @TimestampSerializer()
  DateTime? get selectedDate;
  @override
  String? get selectedTime;
  @override
  @TimestampSerializer()
  DateTime? get startDate;
  @override
  num get totalPrice;
  @override
  String? get typeOfTrip;
  @override
  String get userId;
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
