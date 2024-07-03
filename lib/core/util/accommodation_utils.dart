import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

List<String> getUnavailableRoomUids(
    List<ListingBookings> bookings, DateTime startDate, DateTime endDate) {
  List<String> unavailableRoomUids = [];
  Map<String, List<DateTime>> rooms = {};

// Put all the dates booked under a certain room uid in map with its corresponding value being a list of all the dates
  for (ListingBookings booking in bookings) {
    DateTime currentDate = booking.startDate!;
    if (_isDateInRange(currentDate, startDate, booking.endDate!) == true) {
      while ((currentDate.isBefore(booking.endDate!))) {
        if (rooms.containsKey(booking.roomUid)) {
          rooms[booking.roomUid!]!.add(currentDate);
        } else {
          rooms[booking.roomUid!] = [currentDate];
        }
        // Move to the next day
        currentDate = currentDate.add(const Duration(days: 1));
      }
      // Sort the list of dates for the room UID
      rooms[booking.roomUid!]!.sort();
    }
  }

// for each room in the map, you check if there is a date overlap, trying to find if there is any availability that fits your desired plan dates

  rooms.forEach((roomUid, dateList) {
    if (isDateOverlap(startDate, endDate, dateList) == true) {
      unavailableRoomUids.add(roomUid);
    }
  });
  return unavailableRoomUids;
}

bool _isDateInRange(DateTime date, DateTime planStart, DateTime planEnd) {
  return date.isAfter(planStart.subtract(const Duration(days: 1))) &&
      date.isBefore(planEnd.add(const Duration(days: 1)));
}

bool isDateOverlap(
    DateTime startDate, DateTime endDate, List<DateTime> dateList) {
  // Loop through each date in the list
  for (DateTime date in dateList) {
    // debugPrint('dateList: $dateList');
    // debugPrint('startDate: $startDate');
    // debugPrint('endDate: $endDate');
    // Check if the current date falls within the range
    if (_isDateInRange(date, startDate, endDate) == false) {
      return false;
    }
  }
  if (dateList.first.difference(startDate).inDays >= 1 ||
      endDate.difference(dateList.last).inDays >= 1) {
    return false;
  } else {
    return true;
  }
}