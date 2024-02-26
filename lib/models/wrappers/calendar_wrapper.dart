import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lakbay/core/util/utils.dart';

part 'calendar_wrapper.freezed.dart';
part 'calendar_wrapper.g.dart';

@freezed
class CalendarEvent with _$CalendarEvent {
  factory CalendarEvent({
    String? imageUrl,
    String? type,
    String? title,
    @TimestampSerializer() DateTime? startDate,
    @TimestampSerializer() DateTime? endDate,
    String? guests,
    String? bookingStatus,
    String? listingId,
    String? eventId,
  }) = _CalendarEvent;

  factory CalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);
}
