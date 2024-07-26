import 'package:flutter/material.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

List<String> getUnavailableRoomUids(
    List<ListingBookings> bookings, DateTime startDate, DateTime endDate, List<ListingModel>? filteredListings) {
  List<String> unavailableRoomUids = [];
  Map<String, List<DateTimeRange>> rooms = {};

  if (filteredListings == null) {
    for (ListingBookings booking in bookings) {
      // Create a DateTimeRange for the booking
      DateTimeRange bookingRange = DateTimeRange(start: booking.startDate!, end: booking.endDate!);
      // Add the booking range to the room's list of booked date ranges
      if (rooms.containsKey(booking.roomUid)) {
        rooms[booking.roomUid]!.add(bookingRange);
      } else {
        rooms[booking.roomUid!] = [bookingRange];
      }
    }
  } else {
    Set<String?>? listingUids = filteredListings.map((listing) => listing.uid).toSet();
    List<ListingBookings> filteredBookings = bookings.where((booking) => listingUids.contains(booking.listingId)).toList();
    for (ListingBookings booking in filteredBookings) {
      DateTimeRange bookingRange = DateTimeRange(start: booking.startDate!, end: booking.endDate!);
      if (rooms.containsKey(booking.roomUid)) {
        rooms[booking.roomUid]!.add(bookingRange);
      } else {
        rooms[booking.roomUid!] = [bookingRange];
      }
    }
  }

  DateTimeRange desiredRange = DateTimeRange(start: startDate, end: endDate);
  rooms.forEach((roomUid, bookingRanges) {
    for (DateTimeRange bookingRange in bookingRanges) {
      if (bookingRange.start.isBefore(desiredRange.end) && bookingRange.end.isAfter(desiredRange.start)) {
        unavailableRoomUids.add(roomUid);
        break; // No need to check other bookings for this room since it's already marked as unavailable
      }
    }
  });

  return unavailableRoomUids;
}