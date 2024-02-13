import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/listings/crud/customer_accommodation_checkout.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class RoomCard extends ConsumerStatefulWidget {
  final ListingModel listing;
  const RoomCard({super.key, required this.listing});

  @override
  ConsumerState<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends ConsumerState<RoomCard> {
  @override
  Widget build(BuildContext context) {
    final guests = ref.read(currentPlanGuestsProvider);

    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.listing.availableRooms!.length,
        itemBuilder: (context, index) {
          final AvailableRoom room = widget.listing.availableRooms![index];
          final List<String?> imageUrls = widget
              .listing.availableRooms![index].images!
              .map((listingImage) => listingImage.url)
              .toList();
          if (room.guests <= guests!) {
            return SizedBox(
              // height: MediaQuery.sizeOf(context).height / 2.5,
              width: MediaQuery.sizeOf(context).width / 2,
              child: Card(
                  child: Column(
                children: [
                  ImageSlider(
                      images: imageUrls,
                      height: MediaQuery.sizeOf(context).height / 4,
                      width: MediaQuery.sizeOf(context).width / 2),
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
                                  widget.listing.title,
                                  style: const TextStyle(
                                    fontSize:
                                        18, // Increased font size, larger than the previous one
                                    fontWeight: FontWeight.bold, // Bold text
                                  ),
                                ),
                                Text(
                                  "${room.bedrooms} Bedroom",
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
                                        text: "₱${room.price}",
                                        style: TextStyle(
                                            fontSize: 14, // Size for the price
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
                          height: MediaQuery.sizeOf(context).height / 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 5),
                              ),
                              child: const Text(
                                'View Listing',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final bookings = await ref.watch(
                                    getAllBookingsByIdProvider(
                                            (widget.listing.uid!, room.roomId))
                                        .future);
                                if (context.mounted) {
                                  showSelectDate(context, bookings, index);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 5),
                              ),
                              child: const Text(
                                'Book Now',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  // Action to perform on tap, e.g., show a dialog or navigate
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Room Details"),
                                        content: SizedBox(
                                          height: MediaQuery.sizeOf(context)
                                                  .height /
                                              4,
                                          width:
                                              MediaQuery.sizeOf(context).width /
                                                  1.5,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                      Icons.people_alt_outlined,
                                                      size: 30),
                                                  Text(
                                                    "Guests: ${room.guests}",
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(Icons.bed_rounded,
                                                      size: 30),
                                                  Text(
                                                    "Beds: ${room.beds}",
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                      Icons.bathtub_outlined,
                                                      size: 30),
                                                  Text(
                                                    "Bathrooms: ${room.bathrooms}",
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
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
          } else {
            return null;
          }
        });
  }

  void showSelectDate(
      BuildContext context, List<ListingBookings> bookings, int index) {
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
                  Navigator.of(context).pop();
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
                  showConfirmBooking(widget.listing.availableRooms![index],
                      startDate, endDate, context);
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

  void showConfirmBooking(AvailableRoom room, DateTime startDate,
      DateTime endDate, BuildContext context) {
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
                            hour: widget.listing.checkIn!.hour,
                            minute: widget.listing.checkIn!.minute);
                        endDate = endDate.copyWith(
                            hour: widget.listing.checkOut!.hour,
                            minute: widget.listing.checkOut!.minute);
                        ListingBookings booking = ListingBookings(
                          listingId: widget.listing.uid!,
                          listingTitle: widget.listing.title,
                          customerName: ref.read(userProvider)!.name,
                          bookingStatus: "Reserved",
                          price: room.price,
                          category: "Accommodation",
                          roomId: room.roomId,
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
                          tasks: widget.listing.fixedTasks,
                        );

                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog.fullscreen(
                                  child: CustomerAccommodationCheckout(
                                      listing: widget.listing,
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
