// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListingModelImpl _$$ListingModelImplFromJson(Map<String, dynamic> json) =>
    _$ListingModelImpl(
      uid: json['uid'] as String?,
      category: json['category'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as num,
      pax: json['pax'] as num?,
      bedrooms: json['bedrooms'] as num?,
      beds: json['beds'] as num?,
      bathrooms: json['bathrooms'] as num?,
      address: json['address'] as String,
      city: json['city'] as String,
      province: json['province'] as String,
      cooperative: ListingCooperative.fromJson(
          json['cooperative'] as Map<String, dynamic>),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ListingImages.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ListingModelImplToJson(_$ListingModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'category': instance.category,
      'type': instance.type,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'pax': instance.pax,
      'bedrooms': instance.bedrooms,
      'beds': instance.beds,
      'bathrooms': instance.bathrooms,
      'address': instance.address,
      'city': instance.city,
      'province': instance.province,
      'cooperative': instance.cooperative.toJson(),
      'images': instance.images?.map((e) => e.toJson()).toList(),
    };

_$ListingCooperativeImpl _$$ListingCooperativeImplFromJson(
        Map<String, dynamic> json) =>
    _$ListingCooperativeImpl(
      cooperativeId: json['cooperativeId'] as String,
      cooperativeName: json['cooperativeName'] as String,
    );

Map<String, dynamic> _$$ListingCooperativeImplToJson(
        _$ListingCooperativeImpl instance) =>
    <String, dynamic>{
      'cooperativeId': instance.cooperativeId,
      'cooperativeName': instance.cooperativeName,
    };

_$ListingImagesImpl _$$ListingImagesImplFromJson(Map<String, dynamic> json) =>
    _$ListingImagesImpl(
      path: json['path'] as String,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$$ListingImagesImplToJson(_$ListingImagesImpl instance) =>
    <String, dynamic>{
      'path': instance.path,
      'url': instance.url,
    };
