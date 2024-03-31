import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/firebase_notif_api.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/listings/listing_repository.dart';
import 'package:lakbay/features/sales/sales_controller.dart';
import 'package:lakbay/features/trips/plan/plan_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/plan_model.dart';
import 'package:lakbay/models/sale_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/wrappers/rooms_params.dart';

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

// getListingByPropertiesProvider
final getListingsByPropertiesProvider =
    StreamProvider.autoDispose.family<List<ListingModel>, Query>((ref, query) {
  final listingController = ref.watch(listingControllerProvider.notifier);

  return listingController.getListingsByProperties(query);
});

//getListingsByOwnerId
final getListingsByOwnerIdProvider =
    StreamProvider.autoDispose.family<List<ListingModel>, String>((ref, uid) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getListingsByOwnerId(uid);
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
    .family<List<ListingBookings>, String>((ref, customerId) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getBookingsByCustomerId(customerId);
});

// getAllBookingsByProperties
final getBookingsByPropertiesProvider = StreamProvider.autoDispose
    .family<List<ListingBookings>, Query>((ref, query) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getBookingsByProperties(query);
});

// getAllBookingsByCoopId
final getAllBookingsByCoopIdProvider = StreamProvider.autoDispose
    .family<List<ListingBookings>, String>((ref, coopId) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getAllBookingsByCoopId(coopId);
});

// getBookingTasksByBookingId
final getBookingTasksByBookingId = StreamProvider.autoDispose
    .family<List<BookingTask>, (String listingId, String bookingId)>(
        (ref, params) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getBookingTasksByBookingId(params.$1, params.$2);
});

// getBookingTasksByMemberId
final getBookingTasksByMemberId = StreamProvider.autoDispose
    .family<List<BookingTask>, String>((ref, memberId) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getBookingTasksByMemberId(memberId);
});

// getBookingTasksByContributorId
final getBookingTasksByContributorId = StreamProvider.autoDispose
    .family<List<BookingTask>, String>((ref, contributorId) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getBookingTasksByContributorId(contributorId);
});

// getBookingTaskByTaskId
final getBookingTaskByTaskId = StreamProvider.autoDispose
    .family<BookingTask?, String>((ref, bookingTaskId) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getBookingTaskByTaskId(bookingTaskId);
});

// getRoomByIdProvider
final getAllRoomsByListingIdProvider = StreamProvider.autoDispose
    .family<List<AvailableRoom>, String>((ref, listingId) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getAllRoomsbyListingId(
      listingId); // Assuming getBooking is the method to fetch a single booking
});

// getRoomByIdProvider
final getRoomByIdProvider = StreamProvider.autoDispose
    .family<AvailableRoom, (String listingId, String roomId)>((ref, params) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getRoomById(params.$1,
      params.$2); // Assuming getBooking is the method to fetch a single booking
});

// getRoomByPropertiesProvider
final getRoomByPropertiesProvider = StreamProvider.autoDispose
    .family<List<AvailableRoom>, RoomsParams>((ref, params) {
  final listingController = ref.watch(listingControllerProvider.notifier);

  return listingController.getRoomByProperties(
      params.unavailableRoomUids, params.guests);
});

// getRoomByPropertiesProvider
final getTransportByPropertiesProvider = StreamProvider.autoDispose
    .family<List<AvailableTransport>, Query>((ref, query) {
  final listingController = ref.watch(listingControllerProvider.notifier);

  return listingController.getTransportByProperties(query);
});

// getRoomByPropertiesProvider
final getEntertainmentByPropertiesProvider = StreamProvider.autoDispose
    .family<List<EntertainmentService>, ({num? guests})>((ref, params) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getEntertainmentByProperties(guests: params.guests);
});

// getAllBookingsByProperties
final getDeparturesByPropertiesProvider = StreamProvider.autoDispose
    .family<List<DepartureModel>, Query>((ref, query) {
  final listingController = ref.watch(listingControllerProvider.notifier);
  return listingController.getDeparturesByProperties(query);
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
    List<AvailableTransport>? transports,
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
        transports?.forEach((transport) async {
          await _listingRepository.addTransport(listingUid, listing, transport);
        });
        // use code below incase transport will need availableTransport
        // if (transport != null) {
        //   await _listingRepository.addTransport(listingUid, listing, transport);
        // }

        entertainment?.forEach((entertainment) async {
          await _listingRepository.addEntertainment(
              listingUid, listing, entertainment);
        });
        state = false;
        if (context.mounted) {
          context.pop();
          context.pop();
          showSnackBar(context, 'Listing added successfully');
        }
        _ref.read(navBarVisibilityProvider.notifier).show();
      },
    );
  }

  void addBooking(
      ListingBookings booking, ListingModel listing, BuildContext context,
      {Query? query}) async {
    state = true;
    final result = await _listingRepository.addBooking(listing.uid!, booking);
    final selectedDate = _ref.read(selectedDateProvider);
    final planUid = _ref.read(currentPlanIdProvider);
    ListingBookings? updatedBooking;
    result.fold((l) {
      // Handle the error here
      state = false;
      context.pop;
      showSnackBar(context, l.message);
    }, (bookingUid) async {
      updatedBooking = booking.copyWith(id: bookingUid);

      state = false;

      sendNotification('Listing Booked: ${listing.title}',
          'Dates: ${DateFormat('MMM d, H:mm').format(booking.startDate!)} - ${DateFormat('MMM d, H:mm').format(booking.endDate!)}');

      booking.tasks?.forEach((element) async {
        switch (booking.category) {
          case 'Accommodation':
            {
              element = element.copyWith(
                roomId: booking.roomId,
                listingId: listing.uid,
                bookingId: bookingUid,
              );
              _ref
                  .read(listingControllerProvider.notifier)
                  .addBookingTask(context, listing.uid!, element);
            }
          case 'Transport':
            {
              element = element.copyWith(
                listingId: listing.uid,
                bookingId: bookingUid,
              );
              if (await _listingRepository
                      .readBookingTasksByBookingId(listing.uid!, bookingUid)
                      .isEmpty &&
                  context.mounted) {
                _ref
                    .read(listingControllerProvider.notifier)
                    .addBookingTask(context, listing.uid!, element);
              }
            }
        }
      });
      if (booking.category == 'Transport') {
        Query transportQuery = FirebaseFirestore.instance
            .collectionGroup('availableTransport')
            .where('listingId', isEqualTo: listing.uid);
        final departures =
            await _ref.read(getDeparturesByPropertiesProvider(query!).future);
        final vehicles = await _ref
            .read(getTransportByPropertiesProvider(transportQuery).future);
        List<AssignedVehicle> filteredVehicles = [];
        for (var vehicle in vehicles) {
          if (vehicle.departureTimes!
                  .contains(TimeOfDay.fromDateTime(booking.startDate!)) ==
              true) {
            filteredVehicles.add(AssignedVehicle(vehicle: vehicle));
          }
        }
        debugPrint('departures: $departures');
        if (departures.isEmpty) {
          DepartureModel updatedDeparture = DepartureModel(
            listingName: listing.title,
            listingId: listing.uid,
            passengers: [updatedBooking!],
            arrival: updatedBooking!.endDate,
            departure: updatedBooking!.startDate,
            vehicles: filteredVehicles,
          );
          if (context.mounted) {
            _ref.read(listingControllerProvider.notifier).addDeparture(
                context, listing, updatedBooking!, updatedDeparture);
          }
        } else {
          List<ListingBookings> currentPassengers = [];
          for (var booking in departures.first.passengers) {
            currentPassengers.add(booking);
          }
          currentPassengers.add(booking);
          DepartureModel updatedDeparture = departures.first.copyWith(
              passengers: currentPassengers, departureStatus: 'Waiting');
          if (context.mounted) {
            _ref
                .read(listingControllerProvider.notifier)
                .updateDeparture(context, updatedDeparture, '');
          }
        }
      }
      if (context.mounted) {
        _ref.read(salesControllerProvider.notifier).addSale(
            context,
            SaleModel(
              bookingId: bookingUid,
              category: booking.category,
              cooperativeId: listing.cooperative.cooperativeId,
              cooperativeName: listing.cooperative.cooperativeName,
              customerId: _ref.read(userProvider)!.uid,
              customerName: _ref.read(userProvider)!.name,
              listingId: listing.uid!,
              listingName: listing.title,
              listingPrice: booking.price,
              amount: booking.totalPrice!,
              ownerId: listing.publisherId,
              ownerName: listing.publisherName,
              saleAmount: booking.totalPrice!,
              paymentOption: booking.paymentOption!,
              transactionType: booking.paymentOption!,
            ));
      }

      // check if the booking.startDate's time is set to 00:00:00 and if so, set it to booking.startTime
      if (booking.startDate?.hour == 0 &&
          booking.startDate?.minute == 0 &&
          booking.startDate?.second == 0) {
        DateTime mergedDate = DateTime(
          booking.startDate!.year,
          booking.startDate!.month,
          booking.startDate!.day,
          booking.startTime!.hour,
          booking.startTime!.minute,
        );

        booking = booking.copyWith(startDate: mergedDate);
      }

      // check if the booking.endDate's time is set to 00:00:00 and if so, set it to booking.endTime
      if (booking.endDate?.hour == 0 &&
          booking.endDate?.minute == 0 &&
          booking.endDate?.second == 0) {
        DateTime mergedDate = DateTime(
          booking.endDate!.year,
          booking.endDate!.month,
          booking.endDate!.day,
          booking.endTime!.hour,
          booking.endTime!.minute,
        );

        booking = booking.copyWith(endDate: mergedDate);
      }

      PlanActivity activity = PlanActivity(
        // Create a random key for the activity
        key: DateTime.now().millisecondsSinceEpoch.toString(),
        listingId: listing.uid,
        bookingId: bookingUid,
        category: listing.category,
        dateTime: selectedDate,
        startTime: booking.startDate,
        endTime: booking.endDate,
        title: listing.title,
        imageUrl: listing.images!.first.url,
        description: listing.description,
      );

      if (context.mounted) {
        _ref
            .read(plansControllerProvider.notifier)
            .addActivityToPlan(planUid!, activity, context);

        context.pop();
        context.push('/market/${booking.category}/customer_receipt',
            extra: {'booking': updatedBooking, 'listing': listing});
      }
    });
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
          if (message.isNotEmpty) {
            showSnackBar(context, message);
          }
        },
      );
    });
  }

  void addBookingTask(
      BuildContext context, String listingId, BookingTask task) async {
    state = true;
    final result = await _listingRepository.addBookingTask(listingId, task);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        context.pop;
        showSnackBar(context, l.message);
      },
      (bookingUid) async {
        state = false;
      },
    );
  }

  void updateBookingTask(BuildContext context, String listingId,
      BookingTask bookingTask, String message) {
    state = true;
    _listingRepository.updateBookingTask(listingId, bookingTask).then((result) {
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

  // Read bookingTasks by bookingId
  Stream<List<BookingTask>> getBookingTasksByBookingId(
      String listingId, String bookingId) {
    return _listingRepository.readBookingTasksByBookingId(listingId, bookingId);
  }

  // Read bookingTasks by memberId
  Stream<List<BookingTask>> getBookingTasksByMemberId(String memberId) {
    return _listingRepository.readBookingTasksByMemberId(memberId);
  }

  // Read bookingTasks by contributorId
  Stream<List<BookingTask>> getBookingTasksByContributorId(
      String contributorId) {
    return _listingRepository.readBookingTasksByContributorId(contributorId);
  }

  // Read bookingTasks by memberId
  Stream<BookingTask?> getBookingTaskByTaskId(String bookingTaskId) {
    return _listingRepository.readBookingTaskByTaskId(bookingTaskId);
  }

  // Read all listings
  Stream<List<ListingModel>> getAllListings() {
    return _listingRepository.readListings();
  }

  // Read all listings by ownerId
  Stream<List<ListingModel>> getListingsByOwnerId(String ownerId) {
    return _listingRepository.readListingsByOwner(ownerId);
  }

  // Read all listings by CoopID
  Stream<List<ListingModel>> getListingsByCoopId(String coopId) {
    return _listingRepository.readListingsByCoopId(coopId);
  }

  // Read a listing
  Stream<ListingModel> getListing(String uid) {
    return _listingRepository.readListing(uid);
  }

  // Read room by customer properties
  Stream<List<ListingModel>> getListingsByProperties(Query query) {
    return _listingRepository.readListingsByProperties(query);
  }

  // Read a listing
  Stream<List<ListingBookings>> getAllBookings(String listingId) {
    return _listingRepository.readBookings(listingId);
  }

  // Read all bookings by cooperativeId
  Stream<List<ListingBookings>> getAllBookingsByCoopId(String coopId) {
    return _listingRepository.readBookingsByCoopId(coopId);
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
  Stream<List<ListingBookings>> getBookingsByProperties(Query query) {
    return _listingRepository.readBookingsByProperties(query);
  }

  // Add Room
  void addRoom(
      BuildContext context, ListingModel listing, AvailableRoom room) async {
    state = true;
    final result =
        await _listingRepository.addRoom(listing.uid!, listing, room);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        showSnackBar(context, l.message);
      },
      (roomUid) async {
        state = false;
        if (context.mounted) {
          context.pop();
          showSnackBar(context, 'Room added successfully');
        }
        // _ref.read(navBarVisibilityProvider.notifier).show();
      },
    );
  }

  // Read room by roomId
  Stream<List<AvailableRoom>> getAllRoomsbyListingId(String listingId) {
    return _listingRepository.readRoomsByListingId(listingId);
  }

  // Read room by roomId
  Stream<AvailableRoom> getRoomById(String listingId, String roomId) {
    return _listingRepository.readRoomById(listingId, roomId);
  }

  // Read room by customer properties
  Stream<List<AvailableRoom>> getRoomByProperties(
      List<String> unavailableRoomIds, num guests) {
    return _listingRepository.readRoomByProperties(unavailableRoomIds, guests);
  }

  void addTransport(BuildContext context, ListingModel listing,
      AvailableTransport transport) async {
    state = true;
    final result =
        await _listingRepository.addTransport(listing.uid!, listing, transport);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        showSnackBar(context, l.message);
      },
      (roomUid) async {
        state = false;
        if (context.mounted) {
          context.pop();
          showSnackBar(context, 'Vehicle added successfully');
        }
      },
    );
  }

  // Read transport by customer properties
  Stream<List<AvailableTransport>> getTransportByProperties(Query query) {
    return _listingRepository.readTransportByProperties(query);
  }

  // Read entertainment by customer properties
  Stream<List<EntertainmentService>> getEntertainmentByProperties(
      {num? guests}) {
    return _listingRepository.readEntertainmentByProperties(guests: guests);
  }

  // Read entertainment by customer properties
  Stream<List<DepartureModel>> getDeparturesByProperties(Query query) {
    return _listingRepository.readDeparturesByPoperties(query);
  }

  void addDeparture(BuildContext context, ListingModel listing,
      ListingBookings booking, DepartureModel departure) async {
    state = true;
    final result = await _listingRepository.addDeparture(listing, departure);

    result.fold(
      (l) {
        // Handle the error here
        state = false;
        context.pop;
        showSnackBar(context, l.message);
      },
      (departureUid) async {
        state = false;
      },
    );
  }

  void updateDeparture(
      BuildContext context, DepartureModel departure, String message) {
    state = true;
    _listingRepository.updateDeparture(departure).then((result) {
      state = false;
      result.fold(
        (l) => showSnackBar(context, l.message),
        (r) {
          if (message.isNotEmpty) {
            showSnackBar(context, message);
          }
        },
      );
    });
  }
}
