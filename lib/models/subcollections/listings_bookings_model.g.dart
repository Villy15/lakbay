// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listings_bookings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListingBookingsImpl _$$ListingBookingsImplFromJson(
        Map<String, dynamic> json) =>
    _$ListingBookingsImpl(
      customerName: json['customerName'] as String,
      customerPhoneNo: json['customerPhoneNo'] as String,
      category: json['category'] as String,
      email: json['email'] as String,
      emergencyContactName: json['emergencyContactName'] as String?,
      emergencyContactNo: json['emergencyContactNo'] as String?,
      endDate:
          const TimestampSerializer().fromJson(json['endDate'] as Timestamp?),
      expenses: (json['expenses'] as List<dynamic>?)
          ?.map((e) => Expense.fromJson(e as Map<String, dynamic>))
          .toList(),
      governmentId: json['governmentId'] as String,
      guests: json['guests'] as num,
      id: json['id'] as String?,
      needsContributions: json['needsContributions'] as bool,
      paymentOption: json['paymentOption'] as String?,
      price: json['price'] as num,
      roomId: json['roomId'] as String,
      selectedDate: const TimestampSerializer()
          .fromJson(json['selectedDate'] as Timestamp?),
      selectedTime: json['selectedTime'] as String?,
      startDate:
          const TimestampSerializer().fromJson(json['startDate'] as Timestamp?),
      bookingStatus: json['bookingStatus'] as String,
      tasks: (json['tasks'] as List<dynamic>?)
          ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPrice: json['totalPrice'] as num?,
      typeOfTrip: json['typeOfTrip'] as String?,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$$ListingBookingsImplToJson(
        _$ListingBookingsImpl instance) =>
    <String, dynamic>{
      'customerName': instance.customerName,
      'customerPhoneNo': instance.customerPhoneNo,
      'category': instance.category,
      'email': instance.email,
      'emergencyContactName': instance.emergencyContactName,
      'emergencyContactNo': instance.emergencyContactNo,
      'endDate': const TimestampSerializer().toJson(instance.endDate),
      'expenses': instance.expenses?.map((e) => e.toJson()).toList(),
      'governmentId': instance.governmentId,
      'guests': instance.guests,
      'id': instance.id,
      'needsContributions': instance.needsContributions,
      'paymentOption': instance.paymentOption,
      'price': instance.price,
      'roomId': instance.roomId,
      'selectedDate': const TimestampSerializer().toJson(instance.selectedDate),
      'selectedTime': instance.selectedTime,
      'startDate': const TimestampSerializer().toJson(instance.startDate),
      'bookingStatus': instance.bookingStatus,
      'tasks': instance.tasks?.map((e) => e.toJson()).toList(),
      'totalPrice': instance.totalPrice,
      'typeOfTrip': instance.typeOfTrip,
      'userId': instance.userId,
    };

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

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
      assigned:
          (json['assigned'] as List<dynamic>).map((e) => e as String).toList(),
      committee: json['committee'] as String,
      complete: json['complete'] as bool,
      openContribution: json['openContribution'] as bool,
      imageProof: (json['imageProof'] as List<dynamic>?)
          ?.map((e) => TaskImages.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'assigned': instance.assigned,
      'committee': instance.committee,
      'complete': instance.complete,
      'openContribution': instance.openContribution,
      'imageProof': instance.imageProof?.map((e) => e.toJson()).toList(),
      'name': instance.name,
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
