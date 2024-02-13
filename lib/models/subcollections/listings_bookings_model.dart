import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lakbay/core/util/utils.dart';

part 'listings_bookings_model.freezed.dart';
part 'listings_bookings_model.g.dart';

@freezed
class ListingBookings with _$ListingBookings {
  factory ListingBookings({
    num? amountPaid,
    required String customerName,
    required String customerPhoneNo,
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
    String? paymentOption,
    required num price,
    required String roomId,
    @TimestampSerializer() DateTime? selectedDate,
    String? selectedTime,
    @TimestampSerializer() DateTime? startDate,
    required String bookingStatus,
    List<Task>? tasks,
    num? totalPrice,
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

@freezed
class Task with _$Task {
  factory Task({
    required List<String> assigned,
    required String committee,
    required bool complete,
    required bool openContribution,
    List<TaskImages>? imageProof,
    required String name,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}

@freezed
class TaskImages with _$TaskImages {
  factory TaskImages({
    required String path,
    String? url,
  }) = _TaskImages;

  factory TaskImages.fromJson(Map<String, dynamic> json) =>
      _$TaskImagesFromJson(json);
}
