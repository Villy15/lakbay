import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lakbay/core/util/utils.dart';

part 'listings_bookings_model.freezed.dart';
part 'listings_bookings_model.g.dart';

@freezed
class ListingBookings with _$ListingBookings {
  const ListingBookings._();

  factory ListingBookings({
    num? amountPaid,
    required String customerId,
    required String customerName,
    required String customerPhoneNo,
    required String category,
    required String email,
    String? cooperativeId,
    String? emergencyContactName,
    String? emergencyContactNo,
    @TimestampSerializer() DateTime? endDate,
    List<Expense>? expenses,
    List<BookingTask>? tasks,
    required String governmentId,
    required num guests,
    required String listingId,
    required String listingTitle,
    num? luggage,
    String? id,
    required bool needsContributions,
    String? paymentOption, //Downpayment, Full Payment
    String? paymentStatus, //Partially Paid, Fully Paid, Cancelled
    required num price,
    String? roomId,
    num? vehicleNo,
    String? roomUid,
    @TimestampSerializer() DateTime? selectedDate,
    String? selectedTime,
    @TimestampSerializer() DateTime? startDate,
    required String
        bookingStatus, //[Reserved, Cancelled, Completed, Refunded, Maintenance
    num? totalPrice,
    required String tripUid,
    required String tripName,
    String? typeOfTrip,
    @TimeOfDayConverter() TimeOfDay? startTime,
    @TimeOfDayConverter() TimeOfDay? endTime,
  }) = _ListingBookings;

  factory ListingBookings.fromJson(Map<String, dynamic> json) =>
      _$ListingBookingsFromJson(json);

  // Get number of tasks that need contributions
  int get tasksNeedContributions {
    return tasks?.where((task) => task.openContribution).length ?? 0;
  }
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
class BookingTask with _$BookingTask {
  factory BookingTask({
    String? uid,
    String? bookingId,
    required String listingName,
    String? listingId,
    String? roomId,
    required List<String> assignedIds,
    required List<String> assignedNames,
    List<String>? contributorsIds,
    List<String>? contributorsNames,
    required String committee,
    required bool complete,
    List<BookingTaskMessage>? notes,
    required String status, //Pending, Incomplete, Completed
    required bool openContribution,
    List<TaskImages>? imageProof,
    required String name,
  }) = _BookingTask;

  factory BookingTask.fromJson(Map<String, dynamic> json) =>
      _$BookingTaskFromJson(json);
}

@freezed
class BookingTaskMessage with _$BookingTaskMessage {
  factory BookingTaskMessage({
    String? uid,
    String? bookingId,
    required String listingName,
    String? listingId,
    required String senderId,
    required String senderName,
    required String taskId,
    @TimestampSerializer() required DateTime timestamp,
    required String content,
  }) = _BookingTaskMessage;

  factory BookingTaskMessage.fromJson(Map<String, dynamic> json) =>
      _$BookingTaskMessageFromJson(json);
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

class TimeOfDayConverter
    implements JsonConverter<TimeOfDay, Map<String, dynamic>> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(Map<String, dynamic> json) {
    return TimeOfDay(hour: json['hour'], minute: json['minute']);
  }

  @override
  Map<String, dynamic> toJson(TimeOfDay object) {
    return {
      'hour': object.hour,
      'minute': object.minute,
    };
  }
}
