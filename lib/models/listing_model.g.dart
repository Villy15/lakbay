// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListingModelImpl _$$ListingModelImplFromJson(Map<String, dynamic> json) =>
    _$ListingModelImpl(
      address: json['address'] as String,
      availableDates: (json['availableDates'] as List<dynamic>?)
          ?.map((e) => AvailableDate.fromJson(e as Map<String, dynamic>))
          .toList(),
      availableRooms: (json['availableRooms'] as List<dynamic>?)
          ?.map((e) => AvailableRoom.fromJson(e as Map<String, dynamic>))
          .toList(),
      category: json['category'] as String,
      city: json['city'] as String,
      cooperative: ListingCooperative.fromJson(
          json['cooperative'] as Map<String, dynamic>),
      description: json['description'] as String,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ListingImages.fromJson(e as Map<String, dynamic>))
          .toList(),
      isPublished: json['isPublished'] as bool?,
      listingCosts: (json['listingCosts'] as List<dynamic>?)
          ?.map((e) => ListingCost.fromJson(e as Map<String, dynamic>))
          .toList(),
      pax: json['pax'] as num?,
      price: json['price'] as num?,
      province: json['province'] as String,
      publisherId: json['publisherId'] as String,
      rating: json['rating'] as num?,
      timestamp: const TimestampSerializer().fromJson(json['timestamp']),
      title: json['title'] as String,
      type: json['type'] as String,
      typeOfTrip: json['typeOfTrip'] as String?,
      uid: json['uid'] as String?,
    );

Map<String, dynamic> _$$ListingModelImplToJson(_$ListingModelImpl instance) =>
    <String, dynamic>{
      'address': instance.address,
      'availableDates':
          instance.availableDates?.map((e) => e.toJson()).toList(),
      'availableRooms':
          instance.availableRooms?.map((e) => e.toJson()).toList(),
      'category': instance.category,
      'city': instance.city,
      'cooperative': instance.cooperative.toJson(),
      'description': instance.description,
      'images': instance.images?.map((e) => e.toJson()).toList(),
      'isPublished': instance.isPublished,
      'listingCosts': instance.listingCosts?.map((e) => e.toJson()).toList(),
      'pax': instance.pax,
      'price': instance.price,
      'province': instance.province,
      'publisherId': instance.publisherId,
      'rating': instance.rating,
      'timestamp': _$JsonConverterToJson<dynamic, DateTime>(
          instance.timestamp, const TimestampSerializer().toJson),
      'title': instance.title,
      'type': instance.type,
      'typeOfTrip': instance.typeOfTrip,
      'uid': instance.uid,
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

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

_$ListingCostImpl _$$ListingCostImplFromJson(Map<String, dynamic> json) =>
    _$ListingCostImpl(
      cost: json['cost'] as num?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$ListingCostImplToJson(_$ListingCostImpl instance) =>
    <String, dynamic>{
      'cost': instance.cost,
      'name': instance.name,
    };

_$AvailableRoomImpl _$$AvailableRoomImplFromJson(Map<String, dynamic> json) =>
    _$AvailableRoomImpl(
      roomId: json['roomId'] as String,
      bathrooms: json['bathrooms'] as num,
      bedrooms: json['bedrooms'] as num,
      beds: json['beds'] as num,
      guests: json['guests'] as num,
      price: json['price'] as num,
    );

Map<String, dynamic> _$$AvailableRoomImplToJson(_$AvailableRoomImpl instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'bathrooms': instance.bathrooms,
      'bedrooms': instance.bedrooms,
      'beds': instance.beds,
      'guests': instance.guests,
      'price': instance.price,
    };

_$AvailableDateImpl _$$AvailableDateImplFromJson(Map<String, dynamic> json) =>
    _$AvailableDateImpl(
      available: json['available'] as bool,
      availableTimes: (json['availableTimes'] as List<dynamic>)
          .map((e) => AvailableTime.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AvailableDateImplToJson(_$AvailableDateImpl instance) =>
    <String, dynamic>{
      'available': instance.available,
      'availableTimes': instance.availableTimes.map((e) => e.toJson()).toList(),
    };

_$AvailableTimeImpl _$$AvailableTimeImplFromJson(Map<String, dynamic> json) =>
    _$AvailableTimeImpl(
      available: json['available'] as bool,
      currentPax: json['currentPax'] as num,
      maxPax: json['maxPax'] as num,
      time: const TimestampSerializer().fromJson(json['time']),
    );

Map<String, dynamic> _$$AvailableTimeImplToJson(_$AvailableTimeImpl instance) =>
    <String, dynamic>{
      'available': instance.available,
      'currentPax': instance.currentPax,
      'maxPax': instance.maxPax,
      'time': const TimestampSerializer().toJson(instance.time),
    };
