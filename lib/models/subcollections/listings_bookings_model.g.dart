// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listings_bookings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListingBookingsImpl _$$ListingBookingsImplFromJson(
        Map<String, dynamic> json) =>
    _$ListingBookingsImpl(
      amountPaid: json['amountPaid'] as num?,
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      customerPhoneNo: json['customerPhoneNo'] as String,
      category: json['category'] as String,
      email: json['email'] as String,
      cooperativeId: json['cooperativeId'] as String?,
      emergencyContactName: json['emergencyContactName'] as String?,
      emergencyContactNo: json['emergencyContactNo'] as String?,
      endDate:
          const TimestampSerializer().fromJson(json['endDate'] as Timestamp?),
      expenses: (json['expenses'] as List<dynamic>?)
          ?.map((e) => Expense.fromJson(e as Map<String, dynamic>))
          .toList(),
      tasks: (json['tasks'] as List<dynamic>?)
          ?.map((e) => BookingTask.fromJson(e as Map<String, dynamic>))
          .toList(),
      governmentId: json['governmentId'] as String,
      guests: json['guests'] as num,
      listingId: json['listingId'] as String,
      listingTitle: json['listingTitle'] as String,
      luggage: json['luggage'] as num?,
      id: json['id'] as String?,
      needsContributions: json['needsContributions'] as bool,
      paymentOption: json['paymentOption'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      price: json['price'] as num,
      roomId: json['roomId'] as String?,
      vehicleNo: json['vehicleNo'] as num?,
      roomUid: json['roomUid'] as String?,
      selectedDate: const TimestampSerializer()
          .fromJson(json['selectedDate'] as Timestamp?),
      selectedTime: json['selectedTime'] as String?,
      startDate:
          const TimestampSerializer().fromJson(json['startDate'] as Timestamp?),
      bookingStatus: json['bookingStatus'] as String,
      totalPrice: json['totalPrice'] as num?,
      tripUid: json['tripUid'] as String,
      tripName: json['tripName'] as String,
      typeOfTrip: json['typeOfTrip'] as String?,
      startTime: _$JsonConverterFromJson<Map<String, dynamic>, TimeOfDay>(
          json['startTime'], const TimeOfDayConverter().fromJson),
      endTime: _$JsonConverterFromJson<Map<String, dynamic>, TimeOfDay>(
          json['endTime'], const TimeOfDayConverter().fromJson),
    );

Map<String, dynamic> _$$ListingBookingsImplToJson(
        _$ListingBookingsImpl instance) =>
    <String, dynamic>{
      'amountPaid': instance.amountPaid,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'customerPhoneNo': instance.customerPhoneNo,
      'category': instance.category,
      'email': instance.email,
      'cooperativeId': instance.cooperativeId,
      'emergencyContactName': instance.emergencyContactName,
      'emergencyContactNo': instance.emergencyContactNo,
      'endDate': const TimestampSerializer().toJson(instance.endDate),
      'expenses': instance.expenses?.map((e) => e.toJson()).toList(),
      'tasks': instance.tasks?.map((e) => e.toJson()).toList(),
      'governmentId': instance.governmentId,
      'guests': instance.guests,
      'listingId': instance.listingId,
      'listingTitle': instance.listingTitle,
      'luggage': instance.luggage,
      'id': instance.id,
      'needsContributions': instance.needsContributions,
      'paymentOption': instance.paymentOption,
      'paymentStatus': instance.paymentStatus,
      'price': instance.price,
      'roomId': instance.roomId,
      'vehicleNo': instance.vehicleNo,
      'roomUid': instance.roomUid,
      'selectedDate': const TimestampSerializer().toJson(instance.selectedDate),
      'selectedTime': instance.selectedTime,
      'startDate': const TimestampSerializer().toJson(instance.startDate),
      'bookingStatus': instance.bookingStatus,
      'totalPrice': instance.totalPrice,
      'tripUid': instance.tripUid,
      'tripName': instance.tripName,
      'typeOfTrip': instance.typeOfTrip,
      'startTime': _$JsonConverterToJson<Map<String, dynamic>, TimeOfDay>(
          instance.startTime, const TimeOfDayConverter().toJson),
      'endTime': _$JsonConverterToJson<Map<String, dynamic>, TimeOfDay>(
          instance.endTime, const TimeOfDayConverter().toJson),
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

_$ExpenseImpl _$$ExpenseImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseImpl(
      cost: json['cost'] as num,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$ExpenseImplToJson(_$ExpenseImpl instance) =>
    <String, dynamic>{
      'cost': instance.cost,
      'name': instance.name,
    };

_$BookingTaskImpl _$$BookingTaskImplFromJson(Map<String, dynamic> json) =>
    _$BookingTaskImpl(
      uid: json['uid'] as String?,
      bookingId: json['bookingId'] as String?,
      listingName: json['listingName'] as String,
      listingId: json['listingId'] as String?,
      roomId: json['roomId'] as String?,
      assignedIds: (json['assignedIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      assignedNames: (json['assignedNames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      contributorsIds: (json['contributorsIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      contributorsNames: (json['contributorsNames'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      committee: json['committee'] as String,
      complete: json['complete'] as bool,
      notes: (json['notes'] as List<dynamic>?)
          ?.map((e) => BookingTaskMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,
      openContribution: json['openContribution'] as bool,
      imageProof: (json['imageProof'] as List<dynamic>?)
          ?.map((e) => TaskImages.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$$BookingTaskImplToJson(_$BookingTaskImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'bookingId': instance.bookingId,
      'listingName': instance.listingName,
      'listingId': instance.listingId,
      'roomId': instance.roomId,
      'assignedIds': instance.assignedIds,
      'assignedNames': instance.assignedNames,
      'contributorsIds': instance.contributorsIds,
      'contributorsNames': instance.contributorsNames,
      'committee': instance.committee,
      'complete': instance.complete,
      'notes': instance.notes?.map((e) => e.toJson()).toList(),
      'status': instance.status,
      'openContribution': instance.openContribution,
      'imageProof': instance.imageProof?.map((e) => e.toJson()).toList(),
      'name': instance.name,
    };

_$BookingTaskMessageImpl _$$BookingTaskMessageImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingTaskMessageImpl(
      uid: json['uid'] as String?,
      bookingId: json['bookingId'] as String?,
      listingName: json['listingName'] as String,
      listingId: json['listingId'] as String?,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      taskId: json['taskId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      content: json['content'] as String,
    );

Map<String, dynamic> _$$BookingTaskMessageImplToJson(
        _$BookingTaskMessageImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'bookingId': instance.bookingId,
      'listingName': instance.listingName,
      'listingId': instance.listingId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'taskId': instance.taskId,
      'timestamp': instance.timestamp.toIso8601String(),
      'content': instance.content,
    };

_$TaskImagesImpl _$$TaskImagesImplFromJson(Map<String, dynamic> json) =>
    _$TaskImagesImpl(
      path: json['path'] as String,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$$TaskImagesImplToJson(_$TaskImagesImpl instance) =>
    <String, dynamic>{
      'path': instance.path,
      'url': instance.url,
    };
