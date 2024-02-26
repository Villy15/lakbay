import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/listings/crud/customer_accommodation_checkout.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/wrappers/rooms_params.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class RoomCard extends ConsumerStatefulWidget {
  final String category;
  final List<ListingBookings> bookings;
  const RoomCard({super.key, required this.category, required this.bookings});

  @override
  ConsumerState<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends ConsumerState<RoomCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final guests = ref.read(currentPlanGuestsProvider);
    final startDate = ref.read(planStartDateProvider);
    final endDate = ref.read(planEndDateProvider);
    List<String> unavailableRoomUids =
        getUnavailableRoomUids(widget.bookings, startDate!, endDate!);

    return ref
        .watch(getRoomByPropertiesProvider(RoomsParams(
            unavailableRoomUids: unavailableRoomUids, guests: guests!)))
        .when(
          data: (List<AvailableRoom> rooms) {
            if (rooms.isNotEmpty) {
              return SizedBox(
                width: double.infinity,
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: rooms.length,
                    itemBuilder: ((context, index) {
                      final List<String?> imageUrls = rooms[index]
                          .images!
                          .map((listingImage) => listingImage.url)
                          .toList();
                      final room = rooms[index];
                      return SizedBox(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            room.listingName!,
                                            style: const TextStyle(
                                              fontSize:
                                                  18, // Increased font size, larger than the previous one
                                              fontWeight:
                                                  FontWeight.bold, // Bold text
                                            ),
                                          ),
                                          Text(
                                            "${room.bedrooms} Bedroom",
                                            style: const TextStyle(
                                              fontSize:
                                                  14, // Increased font size, larger than the previous one
                                              fontWeight:
                                                  FontWeight.w500, // Bold text
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "₱${room.price}",
                                                  style: TextStyle(
                                                      fontSize:
                                                          14, // Size for the price
                                                      fontWeight: FontWeight
                                                          .w500, // Bold for the price
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface),
                                                ),
                                                TextSpan(
                                                  text: " per night",
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
                                    height:
                                        MediaQuery.sizeOf(context).height / 30,
                                  ),
                                  ref
                                      .watch(
                                          getListingProvider(room.listingId!))
                                      .when(
                                          data: (ListingModel listing) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    context.push(
                                                        '/market/${widget.category}',
                                                        extra: listing);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 25,
                                                        vertical: 5),
                                                  ),
                                                  child: const Text(
                                                    'View Listing',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    showSelectDate(
                                                        context,
                                                        widget.bookings,
                                                        listing,
                                                        room);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 25,
                                                        vertical: 5),
                                                  ),
                                                  child: const Text(
                                                    'Book Now',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                          error: ((error, stackTrace) =>
                                              ErrorText(
                                                  error: error.toString(),
                                                  stackTrace:
                                                      stackTrace.toString())),
                                          loading: () => const Loader()),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Row(
                                        children: [
                                          const Icon(Icons.bed_outlined),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            widget.category,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )),
                                      TextButton(
                                          onPressed: () {
                                            // Action to perform on tap, e.g., show a dialog or navigate
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      "Room Details"),
                                                  content: SizedBox(
                                                    height: MediaQuery.sizeOf(
                                                                context)
                                                            .height /
                                                        4,
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width /
                                                        1.5,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                                Icons
                                                                    .people_alt_outlined,
                                                                size: 30),
                                                            Text(
                                                              "Guests: ${room.guests}",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          18),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                                Icons
                                                                    .bed_rounded,
                                                                size: 30),
                                                            Text(
                                                              "Beds: ${room.beds}",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          18),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                                Icons
                                                                    .bathtub_outlined,
                                                                size: 30),
                                                            Text(
                                                              "Bathrooms: ${room.bathrooms}",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          18),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child:
                                                          const Text("Close"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
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
                                                  text: "Room Details",
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
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        )),
                      );
                    })),
              );
            } else {
              return Center(
                child: Column(
                  children: [
                    const Text("No Rooms Available"),
                    Text(
                        "(${DateFormat('MMMM dd').format(startDate)} - ${DateFormat('MMMM dd').format(endDate)})")
                  ],
                ),
              );
            }
          },
          error: ((error, stackTrace) => ErrorText(
              error: error.toString(), stackTrace: stackTrace.toString())),
          loading: () => const Loader(),
        );
  }

  void showSelectDate(BuildContext context, List<ListingBookings> bookings,
      ListingModel listing, AvailableRoom room) {
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now();
    showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Select Date'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  context.pop();
                },
              ),
            ),
            body: Dialog.fullscreen(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Adjust the column size to wrap content
                children: [
                  Expanded(
                    // Remove Expanded if it causes layout issues
                    child: SfDateRangePicker(
                        selectionMode: DateRangePickerSelectionMode.range,
                        onSelectionChanged:
                            (DateRangePickerSelectionChangedArgs args) {
                          startDate = args.value.startDate;
                          endDate = args.value.endDate;
                        },
                        minDate: DateTime.now(),
                        selectableDayPredicate: (DateTime day) {
                          //       // Check if the day is in the list of booked dates
                          final bookedDates = getAllDatesFromBookings(bookings);
                          for (DateTime bookedDate in bookedDates) {
                            if (day.year == bookedDate.year &&
                                day.month == bookedDate.month &&
                                day.day == bookedDate.day) {
                              return false; // Disable this booked date
                            }
                          }
                          return true; // Enable all other dates
                        }),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              child: FilledButton(
                onPressed: () {
                  showConfirmBooking(
                      room, listing, startDate, endDate, context);
                },
                child: const Text('Save'),
              ),
            ),
          );
        });
  }

  List<DateTime> getAllDatesFromBookings(List<ListingBookings> bookings) {
    List<DateTime> allDates = [];

    for (ListingBookings booking in bookings) {
      // Add start date
      DateTime currentDate = booking.startDate!;

      // Keep adding dates until you reach the end date
      while (currentDate.isBefore(booking.endDate!) ||
          currentDate.isAtSameMomentAs(booking.endDate!)) {
        allDates.add(currentDate);
        // Move to next day
        currentDate = currentDate.add(const Duration(days: 1));
      }
    }

    return allDates;
  }

  List<String> getUnavailableRoomUids(
      List<ListingBookings> bookings, DateTime startDate, DateTime endDate) {
    List<String> unavailableRoomUids = [];
    Map<String, List<DateTime>> rooms = {};

// Put all the dates booked under a certain room uid in map with its corresponding value being a list of all the dates
    for (ListingBookings booking in bookings) {
      DateTime currentDate = booking.startDate!;

      if (_isDateInRange(currentDate, startDate, endDate)) {
        while ((currentDate.isBefore(booking.endDate!) ||
            currentDate.isAtSameMomentAs(booking.endDate!))) {
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

  bool isDateOverlap(
      DateTime startDate, DateTime endDate, List<DateTime> dateList) {
    // Loop through each date in the list

    int remainingDays = 0;

// for every date in the datelist of the room, you will compare it to your plan date range, if its within range, it means that date isn't allowed
    for (DateTime element in dateList) {
      DateTime date = startDate;
      while (date.isBefore(endDate) || date.isAtSameMomentAs(endDate)) {
        // Check if the current date is present in the date list
        // Check if the current date is within the range
        if (_isDateInRange(element, startDate, endDate) == false) {
          return false; // Return false if date not in range
        }

        date = date.add(const Duration(days: 1));
      }
      //this counts the amount of days compared against your plan, meaning that if remaining days is larger than the difference between now and your enddate, there is an available room for you
      remainingDays = remainingDays + 1;
    }

    if (remainingDays <= endDate.difference(DateTime.now()).inDays) {
      return false;
    } else {
      return true;
    }
  }

  bool _isDateInRange(DateTime date, DateTime rangeStart, DateTime rangeEnd) {
    if ((date.isAtSameMomentAs(rangeStart) || date.isAfter(rangeStart)) &&
            (date.isAtSameMomentAs(rangeEnd)) ||
        date.isBefore(rangeEnd.add(const Duration(days: 1)))) {
      return true;
    } else {
      return false;
    }
  }

  void showConfirmBooking(AvailableRoom room, ListingModel listing,
      DateTime startDate, DateTime endDate, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        num guests = 0;
        TextEditingController phoneNoController =
            TextEditingController(text: "${ref.read(userProvider)?.phoneNo}");
        TextEditingController emergencyContactNameController =
            TextEditingController();
        TextEditingController emergencyContactNoController =
            TextEditingController();
        bool governmentId = true;
        String formattedStartDate = DateFormat('MMMM dd').format(startDate);
        String formattedEndDate = DateFormat('MMMM dd').format(endDate);
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
                      "$formattedStartDate - $formattedEndDate",
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
                            labelText: 'Number of Guests (Max: ${room.guests})',
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
                            floatingLabelBehavior: FloatingLabelBehavior.always,
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
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: "Lastname Firstname",
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: emergencyContactNoController,
                          decoration: const InputDecoration(
                            labelText: 'Emergency Contact Number',
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
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
                        startDate = startDate.copyWith(
                            hour: listing.checkIn!.hour,
                            minute: listing.checkIn!.minute);
                        endDate = endDate.copyWith(
                            hour: listing.checkOut!.hour,
                            minute: listing.checkOut!.minute);
                        ListingBookings booking = ListingBookings(
                          listingId: listing.uid!,
                          listingTitle: listing.title,
                          customerName: ref.read(userProvider)!.name,
                          bookingStatus: "Reserved",
                          price: room.price,
                          category: "Accommodation",
                          roomId: room.roomId,
                          roomUid: room.uid,
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
                          emergencyContactNo: emergencyContactNoController.text,
                          needsContributions: false,
                          tasks: listing.fixedTasks,
                          cooperativeId: listing.cooperative.cooperativeId,
                        );

                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog.fullscreen(
                                  child: CustomerAccommodationCheckout(
                                      listing: listing,
                                      room: room,
                                      booking: booking));
                            });

                        // ref
                        //     .read(listingControllerProvider.notifier)
                        //     .addBooking(booking, widget.listing, context);
                      },
                      child: const Text('Proceed'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }));
      },
    );
  }
}
