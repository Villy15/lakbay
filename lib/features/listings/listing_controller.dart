import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/listings/listing_repository.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

// getListingsByCoop Family Provider
final getListingsByCoopProvider =
    StreamProvider.autoDispose.family<List<ListingModel>, String>((ref, uid) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getListingsByCoopId(uid);
});

// getAllListings Provider
final getAllListingsProvider =
    StreamProvider.autoDispose<List<ListingModel>>((ref) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getAllListings();
});

// getListingProvider
final getListingProvider =
    StreamProvider.autoDispose.family<ListingModel, String>((ref, uid) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getListing(uid);
});

// getAllBookingsByIdProvider
final getAllBookingsByIdProvider = StreamProvider.autoDispose
    .family<List<ListingBookings>, (String listingId, String roomId)>(
        (ref, params) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getAllBookingsById(params.$1, params.$2);
});

final listingControllerProvider =
    StateNotifierProvider<ListingController, bool>((ref) {
  final listingRepository = ref.watch(listingRepositoryProvider);
  return ListingController(listingRepository: listingRepository, ref: ref);
});

// NameController
class ListingController extends StateNotifier<bool> {
  final ListingRepository _listingRepository;
  final Ref _ref;

  ListingController({
    required ListingRepository listingRepository,
    required Ref ref,
  })  : _listingRepository = listingRepository,
        _ref = ref,
        super(false);

  // Add a listing
  void addListing(ListingModel listing, BuildContext context) async {
    state = true;
    final result = await _listingRepository.addListing(listing);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        showSnackBar(context, l.message);
      },
      (listingUid) async {
        state = false;
        showSnackBar(context, 'Listing added successfully');
        context.pop();
        _ref.read(navBarVisibilityProvider.notifier).show();
      },
    );
  }

  void addBooking(
      ListingBookings booking, String listingId, BuildContext context) async {
    state = true;
    final result = await _listingRepository.addBooking(listingId, booking);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        showSnackBar(context, l.message);
      },
      (bookingUid) async {
        state = false;
        context.pop;
        showSnackBar(context, 'Booking added successfully');
      },
    );
  }

  // Read all listings
  Stream<List<ListingModel>> getAllListings() {
    return _listingRepository.readListings();
  }

  // Read all listings by CoopID
  Stream<List<ListingModel>> getListingsByCoopId(String coopId) {
    return _listingRepository.readListingsByCoopId(coopId);
  }

  // Read a listing
  Stream<ListingModel> getListing(String uid) {
    return _listingRepository.readListing(uid);
  }

  // Read all bookings by roomId
  Stream<List<ListingBookings>> getAllBookingsById(
      String listingId, String roomId) {
    return _listingRepository.readBookingsByRoomId(listingId, roomId);
  }
}
