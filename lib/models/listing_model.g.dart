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
      availableTimes: (json['availableTimes'] as List<dynamic>?)
          ?.map((e) => AvailableTime.fromJson(e as Map<String, dynamic>))
          .toList(),
      availableRooms: (json['availableRooms'] as List<dynamic>?)
          ?.map((e) => AvailableRoom.fromJson(e as Map<String, dynamic>))
          .toList(),
      category: json['category'] as String,
      cancellationRate: json['cancellationRate'] as num?,
      checkIn: _$JsonConverterFromJson<Map<String, dynamic>, TimeOfDay>(
          json['checkIn'], const TimeOfDayConverter().fromJson),
      checkOut: _$JsonConverterFromJson<Map<String, dynamic>, TimeOfDay>(
          json['checkOut'], const TimeOfDayConverter().fromJson),
      city: json['city'] as String,
      cancellationPeriod: json['cancellationPeriod'] as num?,
      cooperative: ListingCooperative.fromJson(
          json['cooperative'] as Map<String, dynamic>),
      description: json['description'] as String,
      downpaymentRate: json['downpaymentRate'] as num?,
      fixedCancellationRate: json['fixedCancellationRate'] as num?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ListingImages.fromJson(e as Map<String, dynamic>))
          .toList(),
      isPublished: json['isPublished'] as bool?,
      listingCosts: (json['listingCosts'] as List<dynamic>?)
          ?.map((e) => ListingCost.fromJson(e as Map<String, dynamic>))
          .toList(),
      numberOfUnits: json['numberOfUnits'] as num?,
      openingHours: _$JsonConverterFromJson<Map<String, dynamic>, TimeOfDay>(
          json['openingHours'], const TimeOfDayConverter().fromJson),
      closingHours: _$JsonConverterFromJson<Map<String, dynamic>, TimeOfDay>(
          json['closingHours'], const TimeOfDayConverter().fromJson),
      duration: _$JsonConverterFromJson<Map<String, dynamic>, TimeOfDay>(
          json['duration'], const TimeOfDayConverter().fromJson),
      pax: json['pax'] as num?,
      price: json['price'] as num?,
      province: json['province'] as String,
      publisherId: json['publisherId'] as String,
      publisherName: json['publisherName'] as String,
      guestInfo: json['guestInfo'] as String?,
      rating: json['rating'] as num?,
      fixedTasks: (json['fixedTasks'] as List<dynamic>?)
          ?.map((e) => BookingTask.fromJson(e as Map<String, dynamic>))
          .toList(),
      timestamp:
          const TimestampSerializer().fromJson(json['timestamp'] as Timestamp?),
      workingDays: (json['workingDays'] as List<dynamic>?)
          ?.map((e) => e as bool)
          .toList(),
      title: json['title'] as String,
      type: json['type'] as String?,
      availableDeals: (json['availableDeals'] as List<dynamic>?)
          ?.map((e) => FoodService.fromJson(e as Map<String, dynamic>))
          .toList(),
      menuImgs: (json['menuImgs'] as List<dynamic>?)
          ?.map((e) => ListingImages.fromJson(e as Map<String, dynamic>))
          .toList(),
      availableTransport: json['availableTransport'] == null
          ? null
          : AvailableTransport.fromJson(
              json['availableTransport'] as Map<String, dynamic>),
      availableTables: (json['availableTables'] as List<dynamic>?)
          ?.map((e) => e as List<dynamic>)
          .toList(),
      uid: json['uid'] as String?,
    );

Map<String, dynamic> _$$ListingModelImplToJson(_$ListingModelImpl instance) =>
    <String, dynamic>{
      'address': instance.address,
      'availableDates':
          instance.availableDates?.map((e) => e.toJson()).toList(),
      'availableTimes':
          instance.availableTimes?.map((e) => e.toJson()).toList(),
      'availableRooms':
          instance.availableRooms?.map((e) => e.toJson()).toList(),
      'category': instance.category,
      'cancellationRate': instance.cancellationRate,
      'checkIn': _$JsonConverterToJson<Map<String, dynamic>, TimeOfDay>(
          instance.checkIn, const TimeOfDayConverter().toJson),
      'checkOut': _$JsonConverterToJson<Map<String, dynamic>, TimeOfDay>(
          instance.checkOut, const TimeOfDayConverter().toJson),
      'city': instance.city,
      'cancellationPeriod': instance.cancellationPeriod,
      'cooperative': instance.cooperative.toJson(),
      'description': instance.description,
      'downpaymentRate': instance.downpaymentRate,
      'fixedCancellationRate': instance.fixedCancellationRate,
      'images': instance.images?.map((e) => e.toJson()).toList(),
      'isPublished': instance.isPublished,
      'listingCosts': instance.listingCosts?.map((e) => e.toJson()).toList(),
      'numberOfUnits': instance.numberOfUnits,
      'openingHours': _$JsonConverterToJson<Map<String, dynamic>, TimeOfDay>(
          instance.openingHours, const TimeOfDayConverter().toJson),
      'closingHours': _$JsonConverterToJson<Map<String, dynamic>, TimeOfDay>(
          instance.closingHours, const TimeOfDayConverter().toJson),
      'duration': _$JsonConverterToJson<Map<String, dynamic>, TimeOfDay>(
          instance.duration, const TimeOfDayConverter().toJson),
      'pax': instance.pax,
      'price': instance.price,
      'province': instance.province,
      'publisherId': instance.publisherId,
      'publisherName': instance.publisherName,
      'guestInfo': instance.guestInfo,
      'rating': instance.rating,
      'fixedTasks': instance.fixedTasks?.map((e) => e.toJson()).toList(),
      'timestamp': const TimestampSerializer().toJson(instance.timestamp),
      'workingDays': instance.workingDays,
      'title': instance.title,
      'type': instance.type,
      'availableDeals':
          instance.availableDeals?.map((e) => e.toJson()).toList(),
      'menuImgs': instance.menuImgs?.map((e) => e.toJson()).toList(),
      'availableTransport': instance.availableTransport?.toJson(),
      'availableTables': instance.availableTables,
      'uid': instance.uid,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

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
      uid: json['uid'] as String?,
      listingId: json['listingId'] as String?,
      listingName: json['listingName'] as String?,
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
      'uid': instance.uid,
      'listingId': instance.listingId,
      'listingName': instance.listingName,
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
      uid: json['uid'] as String?,
      listingId: json['listingId'] as String?,
      listingName: json['listingName'] as String?,
      available: json['available'] as bool,
      guests: json['guests'] as num,
      departureTimes: (json['departureTimes'] as List<dynamic>?)
          ?.map((e) =>
              const TimeOfDayConverter().fromJson(e as Map<String, dynamic>))
          .toList(),
      price: json['price'] as num,
      luggage: json['luggage'] as num,
      workingDays:
          (json['workingDays'] as List<dynamic>).map((e) => e as bool).toList(),
      startTime: const TimeOfDayConverter()
          .fromJson(json['startTime'] as Map<String, dynamic>),
      endTime: const TimeOfDayConverter()
          .fromJson(json['endTime'] as Map<String, dynamic>),
      destination: json['destination'] as String?,
      pickupPoint: json['pickupPoint'] as String?,
      travelTime: json['travelTime'] as String?,
      priceByHour: json['priceByHour'] as num?,
    );

Map<String, dynamic> _$$AvailableTransportImplToJson(
        _$AvailableTransportImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'listingId': instance.listingId,
      'listingName': instance.listingName,
      'available': instance.available,
      'guests': instance.guests,
      'departureTimes': instance.departureTimes
          ?.map(const TimeOfDayConverter().toJson)
          .toList(),
      'price': instance.price,
      'luggage': instance.luggage,
      'workingDays': instance.workingDays,
      'startTime': const TimeOfDayConverter().toJson(instance.startTime),
      'endTime': const TimeOfDayConverter().toJson(instance.endTime),
      'destination': instance.destination,
      'pickupPoint': instance.pickupPoint,
      'travelTime': instance.travelTime,
      'priceByHour': instance.priceByHour,
    };

_$FoodServiceImpl _$$FoodServiceImplFromJson(Map<String, dynamic> json) =>
    _$FoodServiceImpl(
      dealName: json['dealName'] as String,
      dealDescription: json['dealDescription'] as String,
      guests: json['guests'] as num,
      available: json['available'] as bool,
      price: json['price'] as num,
      dealImgs: (json['dealImgs'] as List<dynamic>)
          .map((e) => ListingImages.fromJson(e as Map<String, dynamic>))
          .toList(),
      workingDays:
          (json['workingDays'] as List<dynamic>).map((e) => e as bool).toList(),
      startTime: const TimeOfDayConverter()
          .fromJson(json['startTime'] as Map<String, dynamic>),
      endTime: const TimeOfDayConverter()
          .fromJson(json['endTime'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FoodServiceImplToJson(_$FoodServiceImpl instance) =>
    <String, dynamic>{
      'dealName': instance.dealName,
      'dealDescription': instance.dealDescription,
      'guests': instance.guests,
      'available': instance.available,
      'price': instance.price,
      'dealImgs': instance.dealImgs.map((e) => e.toJson()).toList(),
      'workingDays': instance.workingDays,
      'startTime': const TimeOfDayConverter().toJson(instance.startTime),
      'endTime': const TimeOfDayConverter().toJson(instance.endTime),
    };

_$EntertainmentServiceImpl _$$EntertainmentServiceImplFromJson(
        Map<String, dynamic> json) =>
    _$EntertainmentServiceImpl(
      json['uid'] as String?,
      json['listingId'] as String?,
      json['listingName'] as String?,
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
      'uid': instance.uid,
      'listingId': instance.listingId,
      'listingName': instance.listingName,
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
      date: DateTime.parse(json['date'] as String),
      availableTimes: (json['availableTimes'] as List<dynamic>)
          .map((e) => AvailableTime.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AvailableDateImplToJson(_$AvailableDateImpl instance) =>
    <String, dynamic>{
      'available': instance.available,
      'date': instance.date.toIso8601String(),
      'availableTimes': instance.availableTimes.map((e) => e.toJson()).toList(),
    };

_$AvailableTimeImpl _$$AvailableTimeImplFromJson(Map<String, dynamic> json) =>
    _$AvailableTimeImpl(
      available: json['available'] as bool,
      currentPax: json['currentPax'] as num,
      maxPax: json['maxPax'] as num,
      time: const TimeOfDayConverter()
          .fromJson(json['time'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AvailableTimeImplToJson(_$AvailableTimeImpl instance) =>
    <String, dynamic>{
      'available': instance.available,
      'currentPax': instance.currentPax,
      'maxPax': instance.maxPax,
      'time': const TimeOfDayConverter().toJson(instance.time),
    };
