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
      checkIn:
          const TimestampSerializer().fromJson(json['checkIn'] as Timestamp?),
      checkOut:
          const TimestampSerializer().fromJson(json['checkOut'] as Timestamp?),
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
      publisherName: json['publisherName'] as String,
      rating: json['rating'] as num?,
      timestamp:
          const TimestampSerializer().fromJson(json['timestamp'] as Timestamp?),
      title: json['title'] as String,
      type: json['type'] as String,
      availableTables: (json['availableTables'] as List<dynamic>?)
          ?.map((e) => FoodService.fromJson(e as Map<String, dynamic>))
          .toList(),
      menuImgs: (json['menuImgs'] as List<dynamic>?)
          ?.map((e) => ListingImages.fromJson(e as Map<String, dynamic>))
          .toList(),
      availableTransport: json['availableTransport'] == null
          ? null
          : AvailableTransport.fromJson(
              json['availableTransport'] as Map<String, dynamic>),
      availableEntertainment: (json['availableEntertainment'] as List<dynamic>?)
          ?.map((e) => EntertainmentService.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      'checkIn': const TimestampSerializer().toJson(instance.checkIn),
      'checkOut': const TimestampSerializer().toJson(instance.checkOut),
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
      'publisherName': instance.publisherName,
      'rating': instance.rating,
      'timestamp': const TimestampSerializer().toJson(instance.timestamp),
      'title': instance.title,
      'type': instance.type,
      'availableTables':
          instance.availableTables?.map((e) => e.toJson()).toList(),
      'menuImgs': instance.menuImgs?.map((e) => e.toJson()).toList(),
      'availableTransport': instance.availableTransport?.toJson(),
      'availableEntertainment':
          instance.availableEntertainment?.map((e) => e.toJson()).toList(),
      'typeOfTrip': instance.typeOfTrip,
      'uid': instance.uid,
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
      available: json['available'] as bool,
      bathrooms: json['bathrooms'] as num,
      bedrooms: json['bedrooms'] as num,
      beds: json['beds'] as num,
      guests: json['guests'] as num,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ListingImages.fromJson(e as Map<String, dynamic>))
          .toList(),
      price: json['price'] as num,
      roomId: json['roomId'] as String,
    );

Map<String, dynamic> _$$AvailableRoomImplToJson(_$AvailableRoomImpl instance) =>
    <String, dynamic>{
      'available': instance.available,
      'bathrooms': instance.bathrooms,
      'bedrooms': instance.bedrooms,
      'beds': instance.beds,
      'guests': instance.guests,
      'images': instance.images?.map((e) => e.toJson()).toList(),
      'price': instance.price,
      'roomId': instance.roomId,
    };

_$AvailableTransportImpl _$$AvailableTransportImplFromJson(
        Map<String, dynamic> json) =>
    _$AvailableTransportImpl(
      available: json['available'] as bool,
      guests: json['guests'] as num,
      price: json['price'] as num,
      luggage: json['luggage'] as num,
    );

Map<String, dynamic> _$$AvailableTransportImplToJson(
        _$AvailableTransportImpl instance) =>
    <String, dynamic>{
      'available': instance.available,
      'guests': instance.guests,
      'price': instance.price,
      'luggage': instance.luggage,
    };

_$FoodServiceImpl _$$FoodServiceImplFromJson(Map<String, dynamic> json) =>
    _$FoodServiceImpl(
      tableId: json['tableId'] as String,
      guests: json['guests'] as num,
      isReserved: json['isReserved'] as bool,
    );

Map<String, dynamic> _$$FoodServiceImplToJson(_$FoodServiceImpl instance) =>
    <String, dynamic>{
      'tableId': instance.tableId,
      'guests': instance.guests,
      'isReserved': instance.isReserved,
    };

_$EntertainmentServiceImpl _$$EntertainmentServiceImplFromJson(
        Map<String, dynamic> json) =>
    _$EntertainmentServiceImpl(
      entertainmentId: json['entertainmentId'] as String,
      guests: json['guests'] as num,
      price: json['price'] as num,
      available: json['available'] as bool,
      entertainmentImgs: (json['entertainmentImgs'] as List<dynamic>)
          .map((e) => ListingImages.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$EntertainmentServiceImplToJson(
        _$EntertainmentServiceImpl instance) =>
    <String, dynamic>{
      'entertainmentId': instance.entertainmentId,
      'guests': instance.guests,
      'price': instance.price,
      'available': instance.available,
      'entertainmentImgs':
          instance.entertainmentImgs.map((e) => e.toJson()).toList(),
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
      time: DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$$AvailableTimeImplToJson(_$AvailableTimeImpl instance) =>
    <String, dynamic>{
      'available': instance.available,
      'currentPax': instance.currentPax,
      'maxPax': instance.maxPax,
      'time': instance.time.toIso8601String(),
    };
