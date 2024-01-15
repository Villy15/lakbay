// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listings_bookings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListingBookingsImpl _$$ListingBookingsImplFromJson(
        Map<String, dynamic> json) =>
    _$ListingBookingsImpl(
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
      phoneNo: json['phoneNo'] as String,
      roomId: json['roomId'] as String,
      selectedDate: const TimestampSerializer()
          .fromJson(json['selectedDate'] as Timestamp?),
      selectedTime: json['selectedTime'] as String?,
      startDate:
          const TimestampSerializer().fromJson(json['startDate'] as Timestamp?),
      typeOfTrip: json['typeOfTrip'] as String?,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$$ListingBookingsImplToJson(
        _$ListingBookingsImpl instance) =>
    <String, dynamic>{
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
      'phoneNo': instance.phoneNo,
      'roomId': instance.roomId,
      'selectedDate': const TimestampSerializer().toJson(instance.selectedDate),
      'selectedTime': instance.selectedTime,
      'startDate': const TimestampSerializer().toJson(instance.startDate),
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
