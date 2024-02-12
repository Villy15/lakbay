import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/listings/listing_repository.dart';
import 'package:lakbay/features/sales/sales_repository.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/sale_model.dart';
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

// getAllBookingsProvider
final getAllBookingsProvider = StreamProvider.autoDispose
    .family<List<ListingBookings>, String>((ref, listingId) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getAllBookings(listingId);
});

final getBookingByIdProvider = StreamProvider.autoDispose
    .family<ListingBookings, (String listingId, String bookingId)>(
        (ref, params) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getBookingById(params.$1,
      params.$2); // Assuming getBooking is the method to fetch a single booking
});

// getAllBookingsByIdProvider
final getAllBookingsByIdProvider = StreamProvider.autoDispose
    .family<List<ListingBookings>, (String coopId, String eventId)>(
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

  void addBooking(ListingBookings booking, ListingModel listing,
      BuildContext context) async {
    state = true;
    final result = await _listingRepository.addBooking(listing.uid!, booking);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        context.pop;
        showSnackBar(context, l.message);
      },
      (bookingUid) async {
        state = false;
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        // _ref.read(salesRepositoryProvider).addSale(SaleModel(
        //     bookingId: booking.id!,
        //     category: booking.category,
        //     cooperativeId: listing.cooperative.cooperativeId,
        //     cooperativeName: listing.cooperative.cooperativeName,
        //     customerId: _ref.read(userProvider)!.uid,
        //     customerName: _ref.read(userProvider)!.name,
        //     listingId: listing.uid!,
        //     listingName: listing.title,
        //     listingPrice: booking.price,
        //     price: booking.totalPrice,
        //     ownerId: listing.publisherId,
        //     ownerName: listing.publisherName,
        //     salePrice: booking.totalPrice));

        // showSnackBar(context, 'Room booked successfully');
        context.push(
            '/market/${booking.category}/customer_accommodation_receipt',
            extra: {'booking': booking, 'listing': listing});
      },
    );
  }

  void updateListing(BuildContext context, ListingModel listing) {
    state = true;
    _listingRepository.updateListing(listing).then((result) {
      state = false;
      result.fold(
        (l) => showSnackBar(context, l.message),
        (r) {
          context.pop();
          showSnackBar(context, 'Listing Updated');
        },
      );
    });
  }

  void updateBooking(BuildContext context, String listingId,
      ListingBookings booking, String message) {
    state = true;
    _listingRepository.updateBooking(listingId, booking).then((result) {
      state = false;
      result.fold(
        (l) => showSnackBar(context, l.message),
        (r) {
          context.pop();
          showSnackBar(context, message);
        },
      );
    });
  }

  void updateTasks(BuildContext context, String listingId,
      ListingBookings booking, String message) {
    state = true;
    _listingRepository.updateBooking(listingId, booking).then((result) {
      state = false;
      result.fold(
        (l) => showSnackBar(context, l.message),
        (r) {
          // context.pop();
          // showSnackBar(context, message);
        },
      );
    });
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

  // Read a listing
  Stream<List<ListingBookings>> getAllBookings(String listingId) {
    return _listingRepository.readBookings(listingId);
  }

  // Read all bookings by roomId
  Stream<List<ListingBookings>> getAllBookingsById(
      String listingId, String roomId) {
    return _listingRepository.readBookingsByRoomId(listingId, roomId);
  }

  // Read specific booking
  Stream<ListingBookings> getBookingById(String listingId, String bookingId) {
    return _listingRepository.readBookingById(listingId, bookingId);
  }
}
