import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/listings/listing_repository.dart';
import 'package:lakbay/features/trips/plan/plan_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/plan_model.dart';
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

// getBookingByIdProvider
final getBookingByIdProvider = StreamProvider.autoDispose
    .family<ListingBookings, (String listingId, String bookingId)>(
        (ref, params) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getBookingById(params.$1,
      params.$2); // Assuming getBooking is the method to fetch a single booking
});

// getAllBookingsByIdProvider
final getAllBookingsByIdProvider = StreamProvider.autoDispose
    .family<List<ListingBookings>, (String coopId, String roomId)>(
        (ref, params) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getAllBookingsById(params.$1, params.$2);
});

// getAllBookingsByCustomerIdProvider
final getAllBookingsByCustomerIdProvider = StreamProvider.autoDispose
    .family<List<ListingBookings>, String>((ref, listingId) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getBookingsByCustomerId(listingId);
});

// getAllBookingsByProperties
final getBookingsByPropertiesProvider = StreamProvider.autoDispose
    .family<List<ListingBookings>, (String category, DateTime startDate)>(
        (ref, params) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getBookingsByProperties(params.$1, params.$2);
});

// getRoomByIdProvider
final getRoomByIdProvider = StreamProvider.autoDispose
    .family<AvailableRoom, (String listingId, String roomId)>((ref, params) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getRoomById(params.$1,
      params.$2); // Assuming getBooking is the method to fetch a single booking
});

// getRoomByPropertiesProvider
final getRoomByPropertiesProvider = StreamProvider.autoDispose.family<
    List<AvailableRoom>,
    ({List<String>? unavailableRoomUids, num? guests})>((ref, params) {
  final listingController = ref.watch(listingControllerProvider.notifier);

  return listingController.getRoomByProperties(
      unavailableRoomIds: params.unavailableRoomUids, guests: params.guests);
});

// getRoomByPropertiesProvider
final getTransportByPropertiesProvider = StreamProvider.autoDispose
    .family<List<AvailableTransport>, ({num? guests})>((ref, params) {
  final listingController = ref.watch(listingControllerProvider.notifier);

  return listingController.getTransportByProperties(guests: params.guests);
});

// getRoomByPropertiesProvider
final getEntertainmentByPropertiesProvider = StreamProvider.autoDispose
    .family<List<EntertainmentService>, ({num? guests})>((ref, params) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getEntertainmentByProperties(guests: params.guests);
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
  void addListing(
    ListingModel listing,
    BuildContext context, {
    List<AvailableRoom>? rooms,
    List<AvailableTransport>? transport,
    List<EntertainmentService>? entertainment,
  }) async {
    state = true;
    final result = await _listingRepository.addListing(listing);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        showSnackBar(context, l.message);
      },
      (listingUid) async {
        rooms?.forEach((room) async {
          await _listingRepository.addRoom(listingUid, listing, room);
        });
        transport?.forEach((transport) async {
          await _listingRepository.addTransport(listingUid, listing, transport);
        });
        entertainment?.forEach((entertainment) async {
          await _listingRepository.addEntertainment(
              listingUid, listing, entertainment);
        });
        state = false;
        context.pop();
        context.pop();
        showSnackBar(context, 'Listing added successfully');
        _ref.read(navBarVisibilityProvider.notifier).show();
      },
    );
  }

  void addBooking(ListingBookings booking, ListingModel listing,
      BuildContext context) async {
    state = true;
    final result = await _listingRepository.addBooking(listing.uid!, booking);
    final selectedDate = _ref.read(selectedDateProvider);
    final planUid = _ref.read(currentPlanIdProvider);
    result.fold(
      (l) {
        // Handle the error here
        state = false;
        context.pop;
        showSnackBar(context, l.message);
      },
      (bookingUid) async {
        state = false;
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
        ListingBookings updatedBooking = booking.copyWith(id: bookingUid);

        PlanActivity activity = PlanActivity(
          // Create a random key for the activity
          key: DateTime.now().millisecondsSinceEpoch.toString(),
          listingId: listing.uid,
          category: listing.category,
          dateTime: selectedDate,
          title: listing.title,
          imageUrl: listing.images!.first.url,
          description: listing.description,
        );

        _ref
            .read(plansControllerProvider.notifier)
            .addActivityToPlan(planUid!, activity, context);
        context.push('/market/${booking.category}/customer_receipt',
            extra: {'booking': updatedBooking, 'listing': listing});
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

  // Read booking by bookingId
  Stream<ListingBookings> getBookingById(String listingId, String bookingId) {
    return _listingRepository.readBookingById(listingId, bookingId);
  }

  // Read booking by customer id
  Stream<List<ListingBookings>> getBookingsByCustomerId(String customerId) {
    return _listingRepository.readBookingsByCustomerId(customerId);
  }

  // Read booking by date conflicts
  Stream<List<ListingBookings>> getBookingsByProperties(
      String category, DateTime startDate) {
    return _listingRepository.readBookingsByProperties(category, startDate);
  }

  // Read room by roomId
  Stream<AvailableRoom> getRoomById(String listingId, String roomId) {
    return _listingRepository.readRoomById(listingId, roomId);
  }

  // Read room by customer properties
  Stream<List<AvailableRoom>> getRoomByProperties(
      {List<String>? unavailableRoomIds, num? guests}) {
    return _listingRepository.readRoomByProperties(
        unavailableRoomIds: unavailableRoomIds, guests: guests);
  }

  // Read transport by customer properties
  Stream<List<AvailableTransport>> getTransportByProperties({num? guests}) {
    return _listingRepository.readTransportByProperties(guests: guests);
  }

  // Read entertainment by customer properties
  Stream<List<EntertainmentService>> getEntertainmentByProperties(
      {num? guests}) {
    return _listingRepository.readEntertainmentByProperties(guests: guests);
  }
}
