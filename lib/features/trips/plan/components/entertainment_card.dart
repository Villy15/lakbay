import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/providers/days_provider.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/listing_model.dart';

class EntertainmentCard extends ConsumerStatefulWidget {
  final String category;
  final List<ListingModel>? entertainmentListings;
  const EntertainmentCard(
      {super.key, required this.category, required this.entertainmentListings});

  @override
  ConsumerState<EntertainmentCard> createState() => _EntertainmentCardState();
}

class _EntertainmentCardState extends ConsumerState<EntertainmentCard> {
  @override
  Widget build(BuildContext context) {
    final startDate = ref.read(planStartDateProvider);
    final endDate = ref.read(planEndDateProvider);
    final daysPlan = ref.read(daysPlanProvider);

    // if (widget.entertainmentListings != null) {
    //   return SizedBox(
    //       width: double.infinity,
    //       child: ListView.builder(
    //           physics: const NeverScrollableScrollPhysics(),
    //           shrinkWrap: true,
    //           itemCount: widget.entertainmentListings!.length,
    //           itemBuilder: ((context, index) {
    //             final List<String?> imageUrls = widget
    //                 .entertainmentListings![index].images!
    //                 .map((listingImage) => listingImage.url)
    //                 .toList();
    //             final entertainment = widget.entertainmentListings![index];
    //             return SizedBox(
    //               // height: MediaQuery.sizeOf(context).height / 2,
    //               width: MediaQuery.sizeOf(context).width / 2,
    //               child: Card(
    //                   child: Column(
    //                 children: [
    //                   ImageSlider(
    //                       images: imageUrls,
    //                       height: MediaQuery.sizeOf(context).height / 4,
    //                       width: MediaQuery.sizeOf(context).width / 2,
    //                       radius: BorderRadius.circular(10)),
    //                   Padding(
    //                     padding: const EdgeInsets.only(
    //                         left: 20.0,
    //                         right: 10,
    //                         top: 10,
    //                         bottom: 10), // Reduced overall padding
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       children: [
    //                         Row(
    //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                           children: [
    //                             Column(
    //                               crossAxisAlignment: CrossAxisAlignment.start,
    //                               children: [
    //                                 Text(
    //                                   entertainment.title,
    //                                   style: const TextStyle(
    //                                     fontSize:
    //                                         18, // Increased font size, larger than the previous one
    //                                     fontWeight:
    //                                         FontWeight.bold, // Bold text
    //                                   ),
    //                                 ),
    //                                 Text(
    //                                   entertainment.title,
    //                                   style: const TextStyle(
    //                                     fontSize:
    //                                         14, // Increased font size, larger than the previous one
    //                                     fontWeight:
    //                                         FontWeight.w500, // Bold text
    //                                   ),
    //                                 ),
    //                                 RichText(
    //                                   text: TextSpan(
    //                                     children: [
    //                                       TextSpan(
    //                                         text: "₱${entertainment.price}",
    //                                         style: TextStyle(
    //                                             fontSize:
    //                                                 14, // Size for the price
    //                                             fontWeight: FontWeight
    //                                                 .w500, // Bold for the price
    //                                             color: Theme.of(context)
    //                                                 .colorScheme
    //                                                 .onSurface),
    //                                       ),
    //                                       TextSpan(
    //                                         text:
    //                                             " /${entertainment.duration!.hour}:${entertainment.duration!.minute}",
    //                                         style: TextStyle(
    //                                             fontSize:
    //                                                 14, // Smaller size for 'per night'
    //                                             fontStyle: FontStyle
    //                                                 .italic, // Italicized 'per night'
    //                                             fontWeight: FontWeight
    //                                                 .normal, // Normal weight for 'per night'
    //                                             color: Theme.of(context)
    //                                                 .colorScheme
    //                                                 .onSurface),
    //                                       ),
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           ],
    //                         ),
    //                         SizedBox(
    //                           height: MediaQuery.sizeOf(context).height / 30,
    //                         ),
    //                         Row(
    //                             mainAxisAlignment:
    //                                 MainAxisAlignment.spaceEvenly,
    //                             children: [
    //                               ElevatedButton(
    //                                   onPressed: () {
    //                                     context.push(
    //                                         '/market/${widget.category}',
    //                                         extra: entertainment);
    //                                   },
    //                                   style: ElevatedButton.styleFrom(
    //                                       padding: const EdgeInsets.symmetric(
    //                                           horizontal: 25, vertical: 5)),
    //                                   child: const Text('View Listing',
    //                                       style: TextStyle(fontSize: 14))),
    //                               ElevatedButton(
    //                                   onPressed: () async {
    //                                     final bookings = await ref.watch(
    //                                         getAllBookingsProvider(
    //                                                 entertainment.uid!)
    //                                             .future);

    //                                     if (context.mounted) {
    //                                       showDialog(
    //                                           context: context,
    //                                           builder: (context) {
    //                                             return AlertDialog(
    //                                               title: const Text(
    //                                                   'Select a Departure Time',
    //                                                   style: TextStyle(
    //                                                       fontSize: 20,
    //                                                       fontWeight:
    //                                                           FontWeight.bold)),
    //                                               content: SizedBox(
    //                                                   height: MediaQuery
    //                                                               .sizeOf(
    //                                                                   context)
    //                                                           .height /
    //                                                       3.5,
    //                                                   width: MediaQuery.sizeOf(
    //                                                               context)
    //                                                           .width /
    //                                                       1.5,
    //                                                   child: Column(
    //                                                       children: entertainment
    //                                                           .availableDates!
    //                                                           .map((availableDate) =>
    //                                                               availableDate
    //                                                                   .availableTimes
    //                                                                   .map(
    //                                                                       (availableTime) {
    //                                                                 return null;
    //                                                               }))
    //                                                           .map(
    //                                                               (departureTime) {
    //                                                     DateTime dateTimeSlot =
    //                                                         DateTime(
    //                                                             daysPlan
    //                                                                 .currentDay!
    //                                                                 .year,
    //                                                             daysPlan
    //                                                                 .currentDay!
    //                                                                 .month,
    //                                                             daysPlan
    //                                                                 .currentDay!
    //                                                                 .day,
    //                                                             departureTime
    //                                                                 .hour,
    //                                                             departureTime
    //                                                                 .minute);
    //                                                     List<ListingBookings>
    //                                                         bookingsCopy =
    //                                                         bookings;
    //                                                     Map<DateTime?, num>
    //                                                         deptTimeAndGuests =
    //                                                         {
    //                                                       dateTimeSlot: transport
    //                                                           .availableTransport!
    //                                                           .guests
    //                                                     };
    //                                                     // format the currentDate
    //                                                     String
    //                                                         formattedCurrentDate =
    //                                                         DateFormat(
    //                                                                 'yyyy-MM-dd')
    //                                                             .format(daysPlan
    //                                                                 .currentDay!);

    //                                                     for (ListingBookings booking
    //                                                         in bookingsCopy) {
    //                                                       // only get the date and not the time from booking.startDate. trim it to only get the date

    //                                                       DateTime
    //                                                           bookingStartDate =
    //                                                           booking
    //                                                               .startDate!;
    //                                                       String formattedDate =
    //                                                           DateFormat(
    //                                                                   'yyyy-MM-dd')
    //                                                               .format(
    //                                                                   bookingStartDate);

    //                                                       // check the formattedCurrentDate and the formattedDate if they are the same
    //                                                       if (formattedCurrentDate ==
    //                                                           formattedDate) {
    //                                                         // remove duplicates of departure time, and get the total number of guests for each departure time

    //                                                         if (deptTimeAndGuests
    //                                                             .containsKey(
    //                                                                 bookingStartDate)) {
    //                                                           deptTimeAndGuests[
    //                                                                   bookingStartDate] =
    //                                                               deptTimeAndGuests[
    //                                                                       bookingStartDate]! -
    //                                                                   booking
    //                                                                       .guests;
    //                                                         }
    //                                                         //  else {
    //                                                         //   deptTimeAndGuests[
    //                                                         //       booking
    //                                                         //           .startDate] = booking
    //                                                         //       .guests;
    //                                                         // }
    //                                                         // check if the selected departure time's availability through the number of guests. guests must not exceed the available transport's capacity
    //                                                       }
    //                                                     }
    //                                                     return ListTile(
    //                                                         title: Text(
    //                                                             departureTime
    //                                                                 .format(
    //                                                                     context)),
    //                                                         trailing: Text(
    //                                                             'Slots Left: ${deptTimeAndGuests[dateTimeSlot]}'),
    //                                                         onTap: () async {
    //                                                           if (deptTimeAndGuests[
    //                                                                   dateTimeSlot] !=
    //                                                               null) {
    //                                                             if (deptTimeAndGuests[
    //                                                                     dateTimeSlot]! ==
    //                                                                 0) {
    //                                                               // show an alert dialog that the selected departure time is already full
    //                                                               showDialog(
    //                                                                   context:
    //                                                                       context,
    //                                                                   builder:
    //                                                                       (context) {
    //                                                                     return AlertDialog(
    //                                                                         title:
    //                                                                             const Text('Departure Time is Full'),
    //                                                                         content: Text('The time ${departureTime.format(context)} has reached its capacity of ${deptTimeAndGuests[dateTimeSlot]}.  Please select another time.'),
    //                                                                         actions: [
    //                                                                           TextButton(
    //                                                                               onPressed: () {
    //                                                                                 Navigator.pop(context);
    //                                                                               },
    //                                                                               child: const Text('Close'))
    //                                                                         ]);
    //                                                                   });
    //                                                             } else {
    //                                                               // show confirm booking
    //                                                               showConfirmBooking(
    //                                                                       transport
    //                                                                           .availableTransport!,
    //                                                                       transport,
    //                                                                       daysPlan
    //                                                                           .currentDay!,
    //                                                                       daysPlan
    //                                                                           .currentDay!,
    //                                                                       departureTime,
    //                                                                       'Public')
    //                                                                   .then(
    //                                                                       (value) {});
    //                                                             }
    //                                                           } else {
    //                                                             // show confirm booking
    //                                                             showConfirmBooking(
    //                                                                 transport
    //                                                                     .availableTransport!,
    //                                                                 transport,
    //                                                                 daysPlan
    //                                                                     .currentDay!,
    //                                                                 daysPlan
    //                                                                     .currentDay!,
    //                                                                 departureTime,
    //                                                                 'Public');
    //                                                           }
    //                                                         });
    //                                                   }).toList())),
    //                                               actions: [
    //                                                 FilledButton(
    //                                                     onPressed: () {
    //                                                       context.pop();
    //                                                     },
    //                                                     child:
    //                                                         const Text("Back"))
    //                                               ],
    //                                             );
    //                                             // });
    //                                           });
    //                                     }
    //                                     // showConfirmBooking(transport, listing, DateTime.now(), DateTime.now(), , endTime, typeOfTrip);
    //                                   },
    //                                   style: ElevatedButton.styleFrom(
    //                                       padding: const EdgeInsets.symmetric(
    //                                           horizontal: 25, vertical: 5)),
    //                                   child: const Text('Book Now',
    //                                       style: TextStyle(fontSize: 14)))
    //                             ]),
    //                         Row(
    //                             mainAxisAlignment:
    //                                 MainAxisAlignment.spaceBetween,
    //                             children: [
    //                               Expanded(
    //                                   child: Row(children: [
    //                                 const Icon(Icons.car_rental),
    //                                 const SizedBox(width: 5),
    //                                 Text(widget.category,
    //                                     style: const TextStyle(
    //                                         fontSize: 16,
    //                                         fontWeight: FontWeight.bold))
    //                               ])),
    //                               TextButton(
    //                                   onPressed: () {
    //                                     showDialog(
    //                                       context: context,
    //                                       builder: (BuildContext context) {
    //                                         return AlertDialog(
    //                                           title: const Text(
    //                                               "Transport Details"),
    //                                           content: SizedBox(
    //                                             height:
    //                                                 MediaQuery.sizeOf(context)
    //                                                         .height /
    //                                                     4,
    //                                             width:
    //                                                 MediaQuery.sizeOf(context)
    //                                                         .width /
    //                                                     1.5,
    //                                             child: Column(
    //                                               children: [
    //                                                 Row(
    //                                                   children: [
    //                                                     const Icon(
    //                                                         Icons
    //                                                             .people_alt_outlined,
    //                                                         size: 30),
    //                                                     Text(
    //                                                       "Guests: ${transport.availableTransport!.guests}",
    //                                                       style:
    //                                                           const TextStyle(
    //                                                               fontSize: 18),
    //                                                     ),
    //                                                   ],
    //                                                 ),
    //                                                 const SizedBox(
    //                                                   height: 10,
    //                                                 ),
    //                                                 Row(
    //                                                   children: [
    //                                                     const Icon(
    //                                                         Icons.luggage,
    //                                                         size: 30),
    //                                                     Text(
    //                                                       "Luggages: ${transport.availableTransport!.luggage}",
    //                                                       style:
    //                                                           const TextStyle(
    //                                                               fontSize: 18),
    //                                                     ),
    //                                                   ],
    //                                                 ),
    //                                                 const SizedBox(
    //                                                   height: 10,
    //                                                 ),
    //                                               ],
    //                                             ),
    //                                           ),
    //                                           actions: [
    //                                             TextButton(
    //                                               child: const Text("Close"),
    //                                               onPressed: () {
    //                                                 Navigator.of(context).pop();
    //                                               },
    //                                             ),
    //                                           ],
    //                                         );
    //                                       },
    //                                     );
    //                                   },
    //                                   child: RichText(
    //                                     text: TextSpan(
    //                                       children: [
    //                                         TextSpan(
    //                                           text: "Transport Details",
    //                                           style: TextStyle(
    //                                               // color: Colors.grey,
    //                                               color: Theme.of(context)
    //                                                   .colorScheme
    //                                                   .onSurface
    //                                                   .withOpacity(0.5),
    //                                               fontStyle: FontStyle
    //                                                   .italic // Underline for emphasis
    //                                               ),
    //                                         ),
    //                                         const WidgetSpan(
    //                                           child: Icon(
    //                                             Icons
    //                                                 .keyboard_arrow_down, // Arrow pointing down icon
    //                                             size:
    //                                                 16.0, // Adjust the size to fit your design
    //                                             color: Colors.grey,
    //                                           ),
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   ))
    //                             ])
    //                       ],
    //                     ),
    //                   )
    //                 ],
    //               )),
    //             );
    //           })));
    // } else {
    return Center(
      child: Column(
        children: [
          const Text("No Transportation Available"),
          Text(
              "(${DateFormat('MMMM dd').format(startDate!)} - ${DateFormat('MMMM dd').format(endDate!)})")
        ],
      ),
    );
  }
}
// }
