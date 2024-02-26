import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_model.freezed.dart';
part 'sale_model.g.dart';

@freezed
class SaleModel with _$SaleModel {
  factory SaleModel({
    required String bookingId,
    required String category,
    required String cooperativeId,
    required String cooperativeName,
    required String customerId,
    required String customerName,
    num? expenses,
    required String listingId,
    required String listingName,
    required num listingPrice,
    required String paymentOption,
    required String tranasactionType,
    required num price,
    required String ownerId,
    required String ownerName,
    List<SaleModel>? relatedTransactions,
    num? guests,
    num? profit,
    required num salePrice,
    String? uid,
  }) = _SaleModel;

  factory SaleModel.fromJson(Map<String, dynamic> json) =>
      _$SaleModelFromJson(json);
}
