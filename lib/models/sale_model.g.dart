// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SaleModelImpl _$$SaleModelImplFromJson(Map<String, dynamic> json) =>
    _$SaleModelImpl(
      bookingId: json['bookingId'] as String,
      category: json['category'] as String,
      cooperativeId: json['cooperativeId'] as String,
      cooperativeName: json['cooperativeName'] as String,
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      expenses: json['expenses'] as num?,
      listingId: json['listingId'] as String,
      listingName: json['listingName'] as String,
      listingPrice: json['listingPrice'] as num,
      paymentOption: json['paymentOption'] as String,
      tranasactionType: json['tranasactionType'] as String,
      price: json['price'] as num,
      ownerId: json['ownerId'] as String,
      ownerName: json['ownerName'] as String,
      relatedTransactions: (json['relatedTransactions'] as List<dynamic>?)
          ?.map((e) => SaleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      guests: json['guests'] as num?,
      profit: json['profit'] as num?,
      salePrice: json['salePrice'] as num,
      uid: json['uid'] as String?,
    );

Map<String, dynamic> _$$SaleModelImplToJson(_$SaleModelImpl instance) =>
    <String, dynamic>{
      'bookingId': instance.bookingId,
      'category': instance.category,
      'cooperativeId': instance.cooperativeId,
      'cooperativeName': instance.cooperativeName,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'expenses': instance.expenses,
      'listingId': instance.listingId,
      'listingName': instance.listingName,
      'listingPrice': instance.listingPrice,
      'paymentOption': instance.paymentOption,
      'tranasactionType': instance.tranasactionType,
      'price': instance.price,
      'ownerId': instance.ownerId,
      'ownerName': instance.ownerName,
      'relatedTransactions':
          instance.relatedTransactions?.map((e) => e.toJson()).toList(),
      'guests': instance.guests,
      'profit': instance.profit,
      'salePrice': instance.salePrice,
      'uid': instance.uid,
    };
