import 'package:freezed_annotation/freezed_annotation.dart';

part 'listing_model.freezed.dart';
part 'listing_model.g.dart';

@freezed
class ListingModel with _$ListingModel {
  factory ListingModel({
    String? uid,
    required String category,
    required String type,
    required String title,
    required String description,
    required num price,
    num? pax,
    num? bedrooms,
    num? beds,
    num? bathrooms,
    required String address,
    required String city,
    required String province,
    required ListingCooperative cooperative,
    List<ListingImages>? images,
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
