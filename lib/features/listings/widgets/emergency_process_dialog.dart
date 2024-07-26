import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/location/map_repository.dart';
import 'package:lakbay/features/notifications/notifications_controller.dart';
import 'package:lakbay/features/trips/plan/components/room_card.dart';
import 'package:lakbay/features/trips/plan/plan_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/notifications_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

Future<dynamic> emergencyProcess(
    WidgetRef ref, BuildContext context, String category,
    {ListingBookings? booking,
    DepartureModel? departureDetails,
    List<ListingBookings>? bookings}) {
  return showDialog(
    context: context,
    builder: (context) {
      Map<String, Map<String, Map<String, dynamic>>> reasons = {
        'Accommodation': {
          'Find a room replacement': {
            'action': () => onTapFindRoomReplacement(ref, context, booking),
            'subtitle':
                'This will search for a room replacement within the same cooperative.',
          },
          "Unforeseen circumstances made the room unavailable": {
            'action': () => onTapRefundGuest(ref, context, booking),
            'subtitle':
                'This will prompt guests to either rebook their scheduled date or cancel their booking.',
          },
        },
        'Transport': {
          'There is no driver available': {
            'action': () {},
            'subtitle':
                'Search through registered drivers within your cooperative to find one capable and available',
          },
          'Vehicle broke down during transit': {
            'action': () => onTapFindVehicle(ref, context, departureDetails),
            'subtitle':
                'This will search for an available rescue vehicle within the same cooperative.',
          },
        },
        'Entertainment': {
          // 'Assigned tour guide is no longer available': {
          //   'action': () {},
          //   'subtitle':
          //       'Search through registered tour guides within your cooperative to find one capable and available',
          // },
          "Uncontrollable circumstances made the service unavailable": {
            'action': () => onTapRefundGuests(ref, context, bookings),
            'subtitle':
                'This will prompt guests to either rebook their scheduled date or cancel their booking.',
          },
        }
      };
      Map<String, dynamic> categoryReason = reasons.entries
          .firstWhere((element) => element.key == category)
          .value;

      return StatefulBuilder(builder: (context, setDialogState) {
        return Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.pop();
                  context.pop();
                },
              ),
            ),
            body: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Text(
                    "Select the appropriate solution",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 20,
                ),
                Column(
                  children: categoryReason.entries.map((entry) {
                    final reason = entry.key;
                    return Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: entry.value['action'],
                            child: ListTile(
                              title: Text(reason),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios_rounded),
                              subtitle: Text(entry.value['subtitle']),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.grey[300],
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      });
    },
  );
}

onTapRefundGuest(
    WidgetRef ref, BuildContext context, ListingBookings? booking) {
  final refundDetails = {
    "Number of Guests": "${booking!.guests}",
    "Amount Refundable": "₱${booking.amountPaid!.toStringAsFixed(2)} PHP",
  };
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            bottomNavigationBar: PreferredSize(
              preferredSize: Size.fromHeight(MediaQuery.sizeOf(context).height /
                  30), // Adjust the height as needed
              child: BottomAppBar(
                surfaceTintColor: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: FilledButton(
                        onPressed: () {
                          final updatedBooking = booking.copyWith(
                              bookingStatus: "Emergency Request");
                          ref
                              .read(listingControllerProvider.notifier)
                              .updateBooking(context, updatedBooking.listingId,
                                  updatedBooking, "");
                          context.pop();
                          context.pop();
                          context.pop();
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Adjust the value as needed
                          ),
                        ),
                        child: const Text(
                          'Confirm Request',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Text(
                    "Request Customer Cancellation or Re-Booking",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 20,
                ),
                ...refundDetails.entries.map((entry) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 15.0, left: 15, right: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key.toString(),
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              entry.value,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey[200],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      });
}

onTapRefundGuests(
    WidgetRef ref, BuildContext context, List<ListingBookings>? bookings) {
  debugPrint("$bookings");
  final refundDetails = {
    "Number of Bookings": "${bookings!.length}",
    "Amount Refundable": "₱${bookings.fold<num>(0, (num sum, booking) {
      return sum + booking.price;
    }).toStringAsFixed(2)} PHP",
  };
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            bottomNavigationBar: PreferredSize(
              preferredSize: Size.fromHeight(MediaQuery.sizeOf(context).height /
                  30), // Adjust the height as needed
              child: BottomAppBar(
                surfaceTintColor: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: FilledButton(
                        onPressed: () async {
                          for (var booking in bookings) {
                            final updatedBooking = booking.copyWith(
                                bookingStatus: "Emergency Request");
                            ref
                                .read(listingControllerProvider.notifier)
                                .updateBooking(
                                    context,
                                    updatedBooking.listingId,
                                    updatedBooking,
                                    "");
                            // send a notif to customers that are part of the booking
                            final cancelledBookingNotif = NotificationsModel(
                              title: 'Emergency Request',
                              message: 'There was an emergency request for your booking. Please rebook or cancel your booking.',
                              ownerId: booking.customerId,
                              bookingId: booking.id,
                              listingId: booking.listingId,
                              type: 'listing',
                              createdAt: DateTime.now(),
                              isRead: false
                            );

                            await ref.read(notificationControllerProvider.notifier).addNotification(cancelledBookingNotif, context);
                          }



                          // ignore: use_build_context_synchronously
                          context.pop();
                          // ignore: use_build_context_synchronously
                          context.pop();
                          // ignore: use_build_context_synchronously
                          context.pop();

                          
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Adjust the value as needed
                          ),
                        ),
                        child: const Text(
                          'Confirm Request',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Text(
                    "Request Customer Cancellation or Re-Booking",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 20,
                ),
                ...refundDetails.entries.map((entry) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 15.0, left: 15, right: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key.toString(),
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              entry.value,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey[200],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      });
}

onTapFindVehicle(
    WidgetRef ref, BuildContext context, DepartureModel? departureDetails) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Vehicle'),
          content: const Text(
              'Search for an available vehicle owned by the same cooperative.'),
          actions: [
            FilledButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Close'),
            ),
            FilledButton(
              onPressed: () async {
                final mapRepository = ref.read(mapRepositoryProvider);

                final Position position = await _getCurrentLocation();
                final List<Placemark> placemarks =
                    await mapRepository.getAddressFromLatLng(
                        position.latitude, position.longitude);
                Query query = FirebaseFirestore.instance
                    .collectionGroup('availableTransport')
                    .where('listingId',
                        isEqualTo: departureDetails!.listingId!);
                Query departureQuery = FirebaseFirestore.instance
                    .collectionGroup('departures')
                    .where('listingId', isEqualTo: departureDetails.listingId!);
                final vehicles = await ref
                    .watch(getTransportByPropertiesProvider((query)).future);
                final departures = await ref.watch(
                    getDeparturesByPropertiesProvider((departureQuery)).future);
                List<DepartureModel> todayDepartures = [];
                List<AvailableTransport> filteredVehicles = [];
                filteredVehicles.toList(growable: true);
                if (departures.isNotEmpty) {
                  filteredVehicles = vehicles;
                } else {
                  for (var dbDeparture in departures) {
                    if (dbDeparture.departure!.month ==
                            departureDetails.departure!.month &&
                        dbDeparture.departure!.day ==
                            departureDetails.departure!.day) {
                      todayDepartures.add(dbDeparture);
                    }
                  }
                }

                for (var todayDeparture in todayDepartures) {
                  if (todayDeparture.departure!
                      .isAfter(DateTime.now().add(const Duration(hours: 2)))) {
                    filteredVehicles
                        .add(todayDeparture.vehicles!.first.vehicle!);
                  }
                }
                List<AvailableTransport> currentFilteredVehicles =
                    List.from(filteredVehicles);
                for (var departureVehicle in departureDetails.vehicles!) {
                  for (var filteredVehicle in currentFilteredVehicles) {
                    if (filteredVehicle.vehicleNo ==
                        departureVehicle.vehicle!.vehicleNo) {
                      filteredVehicles.remove(filteredVehicle);
                    }
                  }
                }
                context.mounted
                    ? showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            contentPadding: const EdgeInsets.all(0),
                            title: const Text('Search Vehicle'),
                            content: Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              width: MediaQuery.of(context).size.width,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              .4,
                                      width: MediaQuery.sizeOf(context).width,
                                      child: MapWidget(
                                          address: placemarks.first.street
                                              .toString(),
                                          radius: true),
                                    ),
                                    filteredVehicles.isNotEmpty
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: filteredVehicles.length,
                                            itemBuilder:
                                                (context, vehicleIndex) {
                                              final vehicle = filteredVehicles[
                                                  vehicleIndex];
                                              return ListTile(
                                                onTap: () async {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              "Request Rescue"),
                                                          content: Text(
                                                              'Request to be rescued by Vehicle No: ${vehicle.vehicleNo} at your current location'),
                                                          actions: [
                                                            FilledButton(
                                                              onPressed: () {
                                                                context.pop();
                                                              },
                                                              child: const Text(
                                                                  'Close'),
                                                            ),
                                                            FilledButton(
                                                                onPressed:
                                                                    () async {
                                                                  DepartureModel rescureDeparture = departureDetails.copyWith(
                                                                      destination:
                                                                          departureDetails
                                                                              .destination,
                                                                      pickUp: placemarks
                                                                          .first
                                                                          .street,
                                                                      departure:
                                                                          DateTime
                                                                              .now(),
                                                                      departureStatus:
                                                                          'Emergency');
                                                                  ListingModel
                                                                      listing =
                                                                      await ref.read(
                                                                          getListingProvider(rescureDeparture.listingId!)
                                                                              .future);
                                                                  if (context
                                                                      .mounted) {
                                                                    ref.read(listingControllerProvider.notifier).addDeparture(
                                                                        context,
                                                                        listing,
                                                                        rescureDeparture);
                                                                    context
                                                                        .pop();
                                                                  }
                                                                },
                                                                child: const Text(
                                                                    'Request'))
                                                          ],
                                                        );
                                                      }).then((value) {
                                                    context.pop();
                                                  });
                                                },
                                                dense: true,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                horizontalTitleGap: 10,
                                                title: Text(
                                                  "Vehicle No: ${vehicle.vehicleNo}",
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                                subtitle: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start, // Align content to the right
                                                  children: [
                                                    Text(
                                                      'Capacity: ${vehicle.guests} | ',
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                    Text(
                                                      'Luggage: ${vehicle.luggage}',
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ],
                                                ),
                                                trailing: const Icon(Icons
                                                    .arrow_forward_ios_rounded),
                                              );
                                            },
                                          )
                                        : const Text('No Vehicles Available'),
                                  ],
                                ),
                              ),
                            ),
                            actions: [
                              FilledButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Use Navigator.of(context) instead of context.pop()
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        }).then(
                        (value) {
                          context.pop();
                          context.pop();
                          context.pop();
                        },
                      )
                    : null;
              },
              child: const Text('Search'),
            )
          ],
        );
      });
}

Future<dynamic> onTapFindRoomReplacement(
    WidgetRef ref, BuildContext context, ListingBookings? booking) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Room'),
          content: const Text(
              'Search for an available room offered by the same cooperative.'),
          actions: [
            FilledButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Close'),
            ),
            FilledButton(
              onPressed: () async {
                final query = FirebaseFirestore.instance
                    .collectionGroup(
                        'bookings') // Perform collection group query for 'bookings'
                    .where('category', isEqualTo: booking!.category)
                    .where('bookingStatus', isEqualTo: "Reserved")
                    .where('startDate', isGreaterThan: booking.startDate);
                final bookings = await ref
                    .watch(getBookingsByPropertiesProvider((query)).future);

                Query secondQuery = FirebaseFirestore.instance
                    .collectionGroup('availableRooms')
                    .where('listingId', isEqualTo: booking.listingId);
                debugPrint('listingId: ${booking.listingId}');
                context.mounted
                    ? showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog.fullscreen(
                              child: Scaffold(
                            appBar: AppBar(
                              leading: IconButton(
                                onPressed: () {
                                  context.pop();
                                  context.pop();
                                },
                                icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded),
                              ),
                              title: const Text(''),
                            ),
                            body: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: RoomCard(
                                  category: booking.category,
                                  bookings: bookings,
                                  customerBooking: booking,
                                  reason: 'emergency',
                                  guests: booking.guests,
                                  startDate: booking.startDate,
                                  endDate: booking.endDate,
                                  query: secondQuery,
                                ),
                              ),
                            ),
                          ));
                        }).then(
                        (value) {
                          context.pop();
                          context.pop();
                          context.pop();
                        },
                      )
                    : null;
              },
              child: const Text('Search'),
            )
          ],
        );
      });
}

Future<Position> _getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.deniedForever) {
    throw Exception(
        'Location permissions are permantly denied, we cannot request permissions.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      throw Exception(
          'Location permissions are denied (actual value: $permission).');
    }
  }

  return await Geolocator.getCurrentPosition();
}
