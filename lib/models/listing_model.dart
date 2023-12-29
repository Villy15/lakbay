import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lakbay/core/util/utils.dart';

part 'listing_model.freezed.dart';
part 'listing_model.g.dart';

@freezed
class ListingModel with _$ListingModel {
  factory ListingModel({
    required String address,
    List<AvailableDate>? availableDates,
    List<AvailableRoom>? availableRooms,
    required String category,
    required String city,
    required ListingCooperative cooperative,
    required String description,
    List<ListingImages>? images,
    bool? isPublished,
    List<ListingCost>? listingCosts,
    num? pax,
    num? price,
    required String province,
    required String publisherId,
    num? rating,
    @TimestampSerializer() DateTime? timestamp,
    required String title,
    required String type,
    String? typeOfTrip,
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
