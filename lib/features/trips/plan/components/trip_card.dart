import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/providers/days_provider.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/listings/crud/customer_touring_checkout.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class TripCard extends ConsumerStatefulWidget {
  final String category;
  final List<ListingModel>? tripListings;
  const TripCard(
      {super.key, required this.category, required this.tripListings});

  @override
  ConsumerState<TripCard> createState() => _TripCardState();
}

class _TripCardState extends ConsumerState<TripCard> {
  @override
  Widget build(BuildContext context) {
    final daysPlan = ref.read(daysPlanProvider);
    if (widget.tripListings != null) {
      return SizedBox(
          width: double.infinity,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.tripListings!.length,
              itemBuilder: ((context, index) {
                final trip = widget.tripListings![index];

                return tripTypeController(
                    trip, trip.type, daysPlan.currentDay!);
              })));
    } else {
      return Center(
        child: Column(
          children: [
            const Text("No Trip Available"),
            Text("(${DateFormat('MMMM dd').format(daysPlan.currentDay!)})")
          ],
        ),
      );
    }
  }

  Widget tripTypeController(
      ListingModel listing, String? type, DateTime currentDate) {
    final List<String?> imageUrls =
        listing.images!.map((listingImage) => listingImage.url).toList();
    switch (type) {
      case 'Day Trip':
        return dayTripCard(listing, imageUrls, currentDate);
      default:
        return dayTripCard(listing, imageUrls, currentDate);
    }
  }

  Widget dayTripCard(
      ListingModel listing, List<String?> imageUrls, DateTime currentDate) {
    return SizedBox(
      // height: MediaQuery.sizeOf(context).height / 2,
      width: MediaQuery.sizeOf(context).width / 2,
      child: Card(
          child: Column(
        children: [
          ImageSlider(
              images: imageUrls,
              height: MediaQuery.sizeOf(context).height / 4,
              width: MediaQuery.sizeOf(context).width / 2,
              radius: BorderRadius.circular(10)),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0,
                right: 10,
                top: 10,
                bottom: 10), // Reduced overall padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listing.title,
                          style: const TextStyle(
                            fontSize:
                                14, // Increased font size, larger than the previous one
                            fontWeight: FontWeight.w500, // Bold text
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "₱${listing.price}",
                                style: TextStyle(
                                    fontSize: 14, // Size for the price
                                    fontWeight:
                                        FontWeight.w500, // Bold for the price
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                              TextSpan(
                                text: listing.duration!.hour == 0
                                    ? ' /${listing.duration!.minute}mins'
                                    : ' /${listing.duration!.hour}:${listing.duration!.minute} hr:mins',
                                style: TextStyle(
                                    fontSize:
                                        14, // Smaller size for 'per night'
                                    fontStyle: FontStyle
                                        .italic, // Italicized 'per night'
                                    fontWeight: FontWeight
                                        .normal, // Normal weight for 'per night'
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 30,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            context.push('/market/${widget.category}',
                                extra: listing);
                          },
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 5)),
                          child: const Text('View Listing',
                              style: TextStyle(fontSize: 14))),
                      ElevatedButton(
                          onPressed: () async {
                            final bookings = await ref.watch(
                                getAllBookingsProvider(listing.uid!).future);
                            if (context.mounted) {
                              showDialog(
                                  // ignore: use_build_context_synchronously
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                          'Select a Departure Time',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      content: SingleChildScrollView(
                                        child: SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                1.5,
                                            child: Column(
                                                children: listing
                                                    .availableTimes!
                                                    .map((availableTime) {
                                              {
                                                DateTime dateTimeSlot =
                                                    DateTime(
                                                        currentDate.year,
                                                        currentDate.month,
                                                        currentDate.day,
                                                        availableTime.time.hour,
                                                        availableTime
                                                            .time.minute);
                                                List<ListingBookings>
                                                    bookingsCopy = bookings;
                                                Map<DateTime?, num>
                                                    availableTimeAndCapacity = {
                                                  dateTimeSlot:
                                                      listing.numberOfUnits! *
                                                          availableTime.maxPax
                                                };
                                                // format the currentDate
                                                String formattedCurrentDate =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(currentDate);

                                                for (ListingBookings booking
                                                    in bookingsCopy) {
                                                  // only get the date and not the time from booking.startDate. trim it to only get the date

                                                  DateTime bookingStartDate =
                                                      booking.startDate!;
                                                  String formattedDate =
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(
                                                              bookingStartDate);

                                                  // check the formattedCurrentDate and the formattedDate if they are the same
                                                  if (formattedCurrentDate ==
                                                      formattedDate) {
                                                    // remove duplicates of departure time, and get the total number of guests for each departure time

                                                    if (availableTimeAndCapacity
                                                        .containsKey(
                                                            bookingStartDate)) {
                                                      availableTimeAndCapacity[
                                                              bookingStartDate] =
                                                          availableTimeAndCapacity[
                                                                  bookingStartDate]! -
                                                              booking.guests;
                                                    }
                                                    //  else {
                                                    //   deptTimeAndGuests[
                                                    //       booking
                                                    //           .startDate] = booking
                                                    //       .guests;
                                                    // }
                                                    // check if the selected departure time's availability through the number of guests. guests must not exceed the available transport's capacity
                                                  }
                                                }
                                                return ListTile(
                                                    title: Text(availableTime
                                                        .time
                                                        .format(context)),
                                                    trailing: Text(
                                                        'Slots Left: ${availableTimeAndCapacity[dateTimeSlot]}'),
                                                    onTap: () async {
                                                      num capacity =
                                                          availableTimeAndCapacity[
                                                                  dateTimeSlot] ??
                                                              0;

                                                      if (capacity == 0) {
                                                        // show an alert dialog that the selected departure time is already full
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                  title: const Text(
                                                                      'No units available'),
                                                                  content: Text(
                                                                      'The time ${availableTime.time.format(context)} has reached its capacity of ${availableTimeAndCapacity[dateTimeSlot]}.  Please select another time.'),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: const Text(
                                                                            'Close'))
                                                                  ]);
                                                            });
                                                      } else {
                                                        showConfirmBooking(
                                                            availableTime,
                                                            listing,
                                                            currentDate);
                                                      }
                                                    });
                                              }
                                            }).toList())),
                                      ),
                                      actions: [
                                        FilledButton(
                                            onPressed: () {
                                              context.pop();
                                            },
                                            child: const Text("Back"))
                                      ],
                                    );
                                    // });
                                  });
                            }
                            // showConfirmBooking(transport, listing, DateTime.now(), DateTime.now(), , endTime, typeOfTrip);
                          },
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 5)),
                          child: const Text('Book Now',
                              style: TextStyle(fontSize: 14)))
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Row(children: [
                        const Icon(Icons.key),
                        const SizedBox(width: 5),
                        Text(listing.type!,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold))
                      ])),
                      TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Trip Details"),
                                  content: const Placeholder(),
                                  actions: [
                                    TextButton(
                                      child: const Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Trip Details",
                                  style: TextStyle(
                                      // color: Colors.grey,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.5),
                                      fontStyle: FontStyle
                                          .italic // Underline for emphasis
                                      ),
                                ),
                                const WidgetSpan(
                                  child: Icon(
                                    Icons
                                        .keyboard_arrow_down, // Arrow pointing down icon
                                    size:
                                        16.0, // Adjust the size to fit your design
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ))
                    ])
              ],
            ),
          )
        ],
      )),
    );
  }

  Future<dynamic> showConfirmBooking(
      AvailableTime availableTime, ListingModel listing, DateTime currentDate) {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) {
          num guests = 0;
          final user = ref.read(userProvider);

          TextEditingController phoneNoController =
              TextEditingController(text: user?.phoneNo);
          TextEditingController emergencyContactNameController =
              TextEditingController();
          TextEditingController emergencyContactNoController =
              TextEditingController();
          bool governmentId = true;
          String formattedStartDate =
              DateFormat('MMMM dd, yyyy').format(currentDate);
          return Dialog.fullscreen(
              child: StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBar(
                      leading: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      title: Text(
                        formattedStartDate,
                        style: const TextStyle(fontSize: 18),
                      ),
                      elevation: 0, // Optional: Remove shadow
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText:
                                  'Number of Guests (Max: ${listing.pax})',
                              border: const OutlineInputBorder(),
                              floatingLabelBehavior: FloatingLabelBehavior
                                  .always, // Keep the label always visible
                              hintText: "1",
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              guests = int.tryParse(value) ?? 0;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: phoneNoController,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              prefixText: "+63 ",
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: emergencyContactNameController,
                            decoration: const InputDecoration(
                              labelText: 'Emergency Contact Name',
                              border: OutlineInputBorder(),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintText: "Lastname Firstname",
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: emergencyContactNoController,
                            decoration: const InputDecoration(
                              labelText: 'Emergency Contact Number',
                              border: OutlineInputBorder(),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              prefixText: "+63 ",
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        CheckboxListTile(
                          enabled: false,
                          title: const Text("Government ID"),
                          value: governmentId,
                          onChanged: (bool? value) {
                            setState(() {
                              governmentId = value ?? false;
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, // Position the checkbox at the start of the ListTile
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 16.0), // Align with the checkbox title
                          child: Text(
                            "You're Governemnt ID is required as a means to protect cooperatives.",
                            style: TextStyle(
                              fontSize: 12, // Smaller font size for fine print
                              color: Colors
                                  .grey, // Optional: Grey color for fine print
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          DateTime startDate = currentDate.copyWith(
                              hour: availableTime.time.hour,
                              minute: availableTime.time.minute);
                          DateTime endDate = startDate.add(Duration(
                              hours: listing.duration!.hour,
                              minutes: listing.duration!.minute));
                          final currentTrip = ref.read(currentTripProvider);

                          ListingBookings booking = ListingBookings(
                            tripUid: currentTrip!.uid!,
                            tripName: currentTrip.name,
                            listingId: listing.uid!,
                            listingTitle: listing.title,
                            customerName: ref.read(userProvider)!.name,
                            bookingStatus: "Reserved",
                            price: listing.price!,
                            category: "Trip",
                            startDate: startDate,
                            endDate: endDate,
                            email: "",
                            governmentId:
                                "https://firebasestorage.googleapis.com/v0/b/lakbay-cd97e.appspot.com/o/users%2FTimothy%20Mendoza%2Fimages%20(3).jpg?alt=media&token=36ab03ef-0880-4487-822e-1eb512a73ea0",
                            guests: guests,
                            customerPhoneNo: phoneNoController.text,
                            customerId: ref.read(userProvider)!.uid,
                            emergencyContactName:
                                emergencyContactNameController.text,
                            emergencyContactNo:
                                emergencyContactNoController.text,
                            needsContributions: false,
                            tasks: listing.fixedTasks,
                            cooperativeId: listing.cooperative.cooperativeId,
                          );

                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog.fullscreen(
                                    child: CustomerTripCheckout(
                                        listing: listing,
                                        availableTime: availableTime,
                                        booking: booking));
                              }).then((value) {
                            context.pop();
                            context.pop();
                          });
                        },
                        child: const Text('Proceed'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }));
        });
  }
}
