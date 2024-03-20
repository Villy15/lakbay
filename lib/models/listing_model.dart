import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

part 'listing_model.freezed.dart';
part 'listing_model.g.dart';

@freezed
class ListingModel with _$ListingModel {
  factory ListingModel({
    required String address,
    List<AvailableDate>? availableDates,
    List<AvailableRoom>? availableRooms,
    required String category,
    num? cancellationRate,
    @TimestampSerializer() DateTime? checkIn,
    @TimestampSerializer() DateTime? checkOut,
    required String city,
    num? cancellationPeriod,
    required ListingCooperative cooperative,
    required String description,
    num? downpaymentRate,
    num? fixedCancellationRate,
    @TimeOfDayConverter()
    TimeOfDay? duration, //[Travel Duration, Entertainment Duration]
    List<ListingImages>? images,
    bool? isPublished,
    List<ListingCost>? listingCosts,
    num? numberOfUnits,
    @TimestampSerializer() DateTime? openingHours,
    @TimestampSerializer() DateTime? closingHours,
    @TimeOfDayConverter() TimeOfDay? travelDuration,
    num? pax,
    num? price,
    required String province,
    required String publisherId,
    required String publisherName,
    num? rating,
    List<BookingTask>? fixedTasks,
    @TimestampSerializer() DateTime? timestamp,
    required String title,
    String? type, //[Private, Public]
    List<FoodService>? availableDeals,
    List<ListingImages>? menuImgs,
    AvailableTransport? availableTransport,
    List<EntertainmentService>? availableEntertainment,
    String? uid,
  }) = _ListingModel;

  factory ListingModel.fromJson(Map<String, dynamic> json) =>
      _$ListingModelFromJson(json);
}

@freezed
class ListingCooperative with _$ListingCooperative {
  factory ListingCooperative({
    required String cooperativeId,
    required String cooperativeName,
  }) = _ListingCooperative;

  factory ListingCooperative.fromJson(Map<String, dynamic> json) =>
      _$ListingCooperativeFromJson(json);
}

@freezed
class ListingImages with _$ListingImages {
  factory ListingImages({
    required String path,
    String? url,
  }) = _ListingImages;

  factory ListingImages.fromJson(Map<String, dynamic> json) =>
      _$ListingImagesFromJson(json);
}

@freezed
class ListingCost with _$ListingCost {
  factory ListingCost({
    num? cost,
    String? name,
  }) = _ListingCost;

  factory ListingCost.fromJson(Map<String, dynamic> json) =>
      _$ListingCostFromJson(json);
}

@freezed
class AvailableRoom with _$AvailableRoom {
  factory AvailableRoom({
    String? uid,
    String? listingId,
    String? listingName,
    required bool available,
    required num bathrooms,
    required num bedrooms,
    required num beds,
    required num guests,
    required List<ListingImages>? images,
    required num price,
    required String roomId,
  }) = _AvailableRoom;

  factory AvailableRoom.fromJson(Map<String, dynamic> json) =>
      _$AvailableRoomFromJson(json);
}

@freezed
class AvailableTransport with _$AvailableTransport {
  factory AvailableTransport({
    String? uid,
    String? listingId,
    String? listingName,
    required bool available,
    required num guests,
    @TimeOfDayConverter() List<TimeOfDay>? departureTimes,
    required num price,
    required num luggage,
    required List<bool> workingDays,
    @TimeOfDayConverter() required TimeOfDay startTime,
    @TimeOfDayConverter() required TimeOfDay endTime,
    String? destination,
    String? travelTime,
    String? pickupPoint,
  }) = _AvailableTransport;

  factory AvailableTransport.fromJson(Map<String, dynamic> json) =>
      _$AvailableTransportFromJson(json);
}

@freezed
class FoodService with _$FoodService {
  factory FoodService({
    required String dealName,
    required String dealDescription,
    required num guests,
    required bool available,
    required num price,
    required List<ListingImages> dealImgs,
    required List<bool> workingDays,
    @TimeOfDayConverter() required TimeOfDay startTime,
    @TimeOfDayConverter() required TimeOfDay endTime,
  }) = _FoodService;

  factory FoodService.fromJson(Map<String, dynamic> json) =>
      _$FoodServiceFromJson(json);
}

@freezed
class EntertainmentService with _$EntertainmentService {
  factory EntertainmentService(
      String? uid, String? listingId, String? listingName,
      {required String entertainmentId,
      required num guests,
      required num price,
      required bool available,
      required List<ListingImages> entertainmentImgs}) = _EntertainmentService;

  factory EntertainmentService.fromJson(Map<String, dynamic> json) =>
      _$EntertainmentServiceFromJson(json);
}

@freezed
class AvailableDate with _$AvailableDate {
  factory AvailableDate({
    required bool available,
    required List<AvailableTime> availableTimes,
  }) = _AvailableDate;

  factory AvailableDate.fromJson(Map<String, dynamic> json) =>
      _$AvailableDateFromJson(json);
}

@freezed
class AvailableTime with _$AvailableTime {
  factory AvailableTime({
    required bool available,
    required num currentPax,
    required num maxPax,
    @TimestampSerializer() required DateTime time,
  }) = _AvailableTime;

  factory AvailableTime.fromJson(Map<String, dynamic> json) =>
      _$AvailableTimeFromJson(json);
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
