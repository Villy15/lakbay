import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lakbay/core/util/utils.dart';

part 'listings_bookings_model.freezed.dart';
part 'listings_bookings_model.g.dart';

@freezed
class ListingBookings with _$ListingBookings {
  factory ListingBookings({
    required String category,
    required String email,
    String? emergencyContactName,
    String? emergencyContactNo,
    @TimestampSerializer() DateTime? endDate,
    List<Expense>? expenses,
    required String governmentId,
    required num guests,
    String? id,
    required bool needsContributions,
    required String phoneNo,
    required String roomId,
    @TimestampSerializer() DateTime? selectedDate,
    String? selectedTime,
    @TimestampSerializer() DateTime? startDate,
    String? typeOfTrip,
    required String userId,
  }) = _ListingBookings;

  factory ListingBookings.fromJson(Map<String, dynamic> json) =>
      _$ListingBookingsFromJson(json);
}

@freezed
class Expense with _$Expense {
  factory Expense({
    required num cost,
    required String name,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}
