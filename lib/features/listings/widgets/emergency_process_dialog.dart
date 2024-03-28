import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/trips/plan/components/room_card.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

Future<dynamic> emergencyProcess(
    WidgetRef ref, BuildContext context, ListingBookings booking) {
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
          'Cancel booking': {
            'action': () {},
            'subtitle': 'Cancel the booking and refund the customer.'
          },
        },
        'Tranport': {
          'There is no driver available': {
            'action': () => onTapFindVehicle(context, booking)
          },
          'Vehicle broke down during transit': {'': () {}},
        }
      };
      Map<String, dynamic> categoryReason = reasons.entries
          .firstWhere((element) => element.key == booking.category)
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
                    "Select your preferred solution",
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

onTapFindVehicle(BuildContext context, ListingBookings booking) {}

Future<dynamic> onTapFindRoomReplacement(
    WidgetRef ref, BuildContext context, ListingBookings booking) {
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
                    .where('category', isEqualTo: booking.category)
                    .where('bookingStatus', isEqualTo: "Reserved")
                    .where('startDate', isGreaterThan: booking.startDate);
                final bookings = await ref
                    .watch(getBookingsByPropertiesProvider((query)).future);

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
                                    endDate: booking.endDate),
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
