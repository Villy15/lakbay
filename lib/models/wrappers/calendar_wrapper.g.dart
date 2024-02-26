// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_wrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CalendarEventImpl _$$CalendarEventImplFromJson(Map<String, dynamic> json) =>
    _$CalendarEventImpl(
      imageUrl: json['imageUrl'] as String?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      startDate:
          const TimestampSerializer().fromJson(json['startDate'] as Timestamp?),
      endDate:
          const TimestampSerializer().fromJson(json['endDate'] as Timestamp?),
      guests: json['guests'] as String?,
      bookingStatus: json['bookingStatus'] as String?,
      listingId: json['listingId'] as String?,
      eventId: json['eventId'] as String?,
    );

Map<String, dynamic> _$$CalendarEventImplToJson(_$CalendarEventImpl instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'type': instance.type,
      'title': instance.title,
      'startDate': const TimestampSerializer().toJson(instance.startDate),
      'endDate': const TimestampSerializer().toJson(instance.endDate),
      'guests': instance.guests,
      'bookingStatus': instance.bookingStatus,
      'listingId': instance.listingId,
      'eventId': instance.eventId,
    };
