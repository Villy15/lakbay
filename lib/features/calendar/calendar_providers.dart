// List of Bookings Provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

final listBookingsProvider =
    StateNotifierProvider<ListBookingsProvider, List<ListingBookings>?>(
  (ref) => ListBookingsProvider(),
);

class ListBookingsProvider extends StateNotifier<List<ListingBookings>?> {
  ListBookingsProvider() : super(null);

  void setListBookings(List<ListingBookings> listBookings) {
    state = listBookings;
  }
}
