import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/common/widgets/text_in_bottomsheet.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class CustomerAccomodation extends ConsumerStatefulWidget {
  final ListingModel listing;
  const CustomerAccomodation({super.key, required this.listing});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerAccomodationState();
}

class _CustomerAccomodationState extends ConsumerState<CustomerAccomodation> {
  List<SizedBox> tabs = [
    const SizedBox(
      width: 100.0,
      child: Tab(
        // icon: Icon(Icons.location_pin),
        child: Text('Destination'),
      ),
    ),
    const SizedBox(
      width: 100.0,
      child: Tab(
        // icon: Icon(Icons.meeting_room_outlined),
        child: Text('Rooms'),
      ),
    ),
    const SizedBox(
      width: 100.0,
      child: Tab(
        // icon: Icon(Icons.meeting_room_outlined),
        child: Text('Bookings'),
      ),
    ),
  ];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
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

  @override
  Widget build(BuildContext context) {
    // final user = ref.watch(userProvider);
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          context.pop();
          ref.read(navBarVisibilityProvider.notifier).show();
        },
        child: DefaultTabController(
          initialIndex: 0,
          length: tabs.length,
          child: Scaffold(
            // Add appbar with back button
            appBar: _appBar(widget.listing.title, context),
            body: TabBarView(
              children: [
                destination(),
                rooms(),
                bookings(),
              ],
            ),

            // Bottom Nav Bar with price on the left and Book Now on the right
            // bottomNavigationBar: BottomAppBar(
            //   surfaceTintColor: Colors.white,
            //   height: 90,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       const Flexible(
            //         child: Padding(
            //           padding: EdgeInsets.all(8.0),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     'Price',
            //                     style: TextStyle(
            //                       fontSize: 16,
            //                       fontWeight: FontWeight.w400,
            //                     ),
            //                   ),
            //                   Row(
            //                     children: [
            //                       Text('₱12000.00',
            //                           style: TextStyle(
            //                               fontSize: 18,
            //                               fontWeight: FontWeight.bold)),
            //                       Text('/night',
            //                           style: TextStyle(
            //                               fontSize: 14,
            //                               fontWeight: FontWeight.w400)),
            //                     ],
            //                   ),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //       Flexible(
            //         child: Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: FilledButton(
            //             // Make it wider
            //             style: ButtonStyle(
            //               minimumSize: MaterialStateProperty.all<Size>(
            //                   const Size(180, 45)),
            //             ),
            //             onPressed: () {},
            //             child: const Text('Book Now'),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ),
        ));
  }

  AppBar _appBar(String title, BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          // fontFamily: 'Satisfy',
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottom: TabBar(
        tabAlignment: TabAlignment.center,
        labelPadding: EdgeInsets.zero,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: tabs,
      ),
    );
  }

  SingleChildScrollView destination() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Slider
          CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 1.0,
              height: 250.0,
              enlargeFactor: 0,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {},
            ),
            items: [
              Image(
                image: NetworkImage(
                  widget.listing.images!.first.url!,
                ),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: DisplayText(
                    text: widget.listing.title,
                    lines: 2,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Location
                DisplayText(
                  text:
                      "Location: ${widget.listing.province}, ${widget.listing.city}",
                  lines: 4,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
                  ),
                ),

                DisplayText(
                  text: "${widget.listing.category} · ${widget.listing.type}",
                  lines: 1,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
                  ),
                ),

                const Divider(),
                DisplayText(
                  text: 'Description',
                  lines: 1,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                  ),
                ),
                TextInBottomSheet(
                    "About this space", widget.listing.description, context),

                const Divider(),
                // DisplayText(
                //   text: 'Where you\'ll sleep',
                //   lines: 1,
                //   style: TextStyle(
                //     fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                //   ),
                // ),
              ],
            ),
          ),
          const Divider(),

          ref
              .watch(getCooperativeProvider(
                  widget.listing.cooperative.cooperativeId))
              .maybeWhen(
                data: (coop) {
                  return ListTile(
                    leading: SizedBox(
                      height: 40,
                      width: 40,
                      child: DisplayImage(
                          imageUrl: coop.imageUrl,
                          height: 40,
                          width: 40,
                          radius: BorderRadius.circular(20)),
                    ),
                    // Contact owner
                    trailing: IconButton(
                      onPressed: () {
                        // Show snackbar with reviews
                        showSnackBar(context, 'Contact owner');
                      },
                      icon: const Icon(Icons.message_rounded),
                    ),
                    title: Text('Hosted by ${coop.name}',
                        style: Theme.of(context).textTheme.labelLarge),
                  );
                },
                orElse: () => const ListTile(
                  leading: Icon(Icons.error),
                  title: Text('Error'),
                  subtitle: Text('Something went wrong'),
                ),
              ),

          const Divider(),
        ],
      ),
    );
  }

  ListView rooms() {
    return ListView.builder(
        // physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.listing.availableRooms!.length,
        itemBuilder: ((context, index) {
          List<String?> imageUrls = widget
              .listing.availableRooms![index].images!
              .map((listingImage) => listingImage.url)
              .toList();
          return Card(
            elevation: 1.0, // Slight shadow for depth
            margin: const EdgeInsets.all(8.0), // Space around the card
            child: Column(
              children: [
                ImageSlider(
                  images: imageUrls,
                  height: MediaQuery.of(context).size.height /
                      3.5, // Reduced height
                  width: double.infinity,
                ),
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
                                "${widget.listing.availableRooms![index].bedrooms} Bedroom",
                                style: const TextStyle(
                                  fontSize:
                                      18, // Increased font size, larger than the previous one
                                  fontWeight: FontWeight.bold, // Bold text
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "₱${widget.listing.availableRooms![index].price}",
                                      style: TextStyle(
                                          fontSize: 16, // Size for the price
                                          fontWeight: FontWeight
                                              .bold, // Bold for the price
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
                          Center(
                              child: ElevatedButton(
                            onPressed: () async {
                              final bookings = await ref.watch(
                                  getAllBookingsByIdProvider((
                                widget.listing.uid!,
                                widget.listing.availableRooms![index].roomId
                              )).future);

                              // Show the date range picker dialog
                              if (context.mounted) {
                                DateTime? endDate;
                                DateTime? startDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2025),
                                    selectableDayPredicate: (DateTime day) {
                                      // Check if the day is in the list of booked dates
                                      final bookedDates =
                                          getAllDatesFromBookings(bookings);
                                      for (DateTime bookedDate in bookedDates) {
                                        if (day.year == bookedDate.year &&
                                            day.month == bookedDate.month &&
                                            day.day == bookedDate.day) {
                                          return false; // Disable this booked date
                                        }
                                      }
                                      return true; // Enable all other dates
                                    });
                                if (startDate != null && context.mounted) {
                                  endDate = await showDatePicker(
                                      context: context,
                                      initialDate: startDate
                                          .add(const Duration(days: 1)),
                                      firstDate: startDate,
                                      lastDate: DateTime(2025),
                                      selectableDayPredicate: (DateTime day) {
                                        // Check if the day is in the list of booked dates
                                        final bookedDates =
                                            getAllDatesFromBookings(bookings);
                                        for (DateTime bookedDate
                                            in bookedDates) {
                                          if (day.year == bookedDate.year &&
                                              day.month == bookedDate.month &&
                                              day.day == bookedDate.day) {
                                            return false; // Disable this booked date
                                          }
                                        }
                                        return true; // Enable all other dates
                                      });
                                }

                                if (startDate != null &&
                                    endDate != null &&
                                    context.mounted) {
                                  // Handle the picked date range
                                  showConfirmBooking(
                                      widget.listing.availableRooms![index],
                                      startDate,
                                      endDate,
                                      context);
                                  // ListingBookings(id: id, guests: guests, userId: userId)
                                  // ref
                                  //     .read(listingControllerProvider.notifier)
                                  //     .addBooking(
                                  //         booking, widget.listing.uid!, context);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                            ),
                            child: const Text(
                              'Book Now',
                              style: TextStyle(fontSize: 16),
                            ),
                          )),
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
                                        height:
                                            MediaQuery.sizeOf(context).height /
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
                                                  "Guests: ${widget.listing.availableRooms![index].guests}",
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
                                                  "Beds: ${widget.listing.availableRooms![index].beds}",
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
                                                  "Bathrooms: ${widget.listing.availableRooms![index].bathrooms}",
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
                ),
              ],
            ),
          );
        }));
  }

  Widget bookings() {
    return ref.watch(getAllBookingsProvider(widget.listing.uid!)).when(
          data: (List<ListingBookings> bookings) {
            // Get all listings by the cooperative
            return ListView.builder(
                // physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: bookings.length,
                itemBuilder: ((context, index) {
                  String formattedStartDate =
                      DateFormat('MMMM dd').format(bookings[index].startDate!);
                  String formattedEndDate =
                      DateFormat('MMMM dd').format(bookings[index].endDate!);
                  return Card(
                    elevation: 1.0, // Slight shadow for depth
                    margin: const EdgeInsets.all(8.0), // Space around the card
                    child: Column(
                      children: [
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "$formattedStartDate - ",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            formattedEndDate,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "Room ID: ${bookings[index].roomId}",
                                        style: const TextStyle(
                                          fontSize:
                                              18, // Increased font size, larger than the previous one
                                          fontWeight:
                                              FontWeight.bold, // Bold text
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  "Guests: ${bookings[index].guests}",
                                              style: TextStyle(
                                                  fontSize:
                                                      16, // Size for the price
                                                  fontWeight: FontWeight
                                                      .bold, // Bold for the price
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
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Spacer(), // Pushes the button to the right
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  var Expense = showAddExpenseDialog(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape:
                                      const CircleBorder(), // Makes the button round
                                  padding: const EdgeInsets.all(
                                      10), // Padding to increase the size of the circle
                                ),
                                child: const Icon(Icons.attach_money_rounded),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }));
          },
          error: (error, stackTrace) => Scaffold(
            body: ErrorText(
              error: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          ),
          loading: () => const Scaffold(
            body: Loader(),
          ),
        );
  }

  void showConfirmBooking(AvailableRoom room, DateTime startDate,
      DateTime endDate, BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        num guests = 0;
        TextEditingController phoneNoController = TextEditingController();
        TextEditingController emergencyContactNameController =
            TextEditingController();
        TextEditingController emergencyContactNoController =
            TextEditingController();
        bool governmentId = true;
        String formattedStartDate = DateFormat('MMMM dd').format(startDate);
        String formattedEndDate = DateFormat('MMMM dd').format(endDate);
        return DraggableScrollableSheet(
          initialChildSize: 0.75, // 75% of screen height
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(builder: (context, setState) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$formattedStartDate - ",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formattedEndDate,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.sizeOf(context).height / 20),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Number of Guests',
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior
                                .always, // Keep the label always visible
                            hintText: "2",
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
                            hintText: "+63",
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
                            hintText: "+63",
                          ),
                          keyboardType: TextInputType.phone,
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
                                  fontSize:
                                      12, // Smaller font size for fine print
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
                              ListingBookings booking = ListingBookings(
                                roomId: room.roomId,
                                startDate: startDate,
                                endDate: endDate,
                                email: "",
                                governmentId:
                                    "https://firebasestorage.googleapis.com/v0/b/lakbay-cd97e.appspot.com/o/users%2FTimothy%20Mendoza%2Fimages%20(3).jpg?alt=media&token=36ab03ef-0880-4487-822e-1eb512a73ea0",
                                guests: guests,
                                phoneNo: phoneNoController.text,
                                userId: ref.read(userProvider)!.uid,
                                emergencyContactName:
                                    emergencyContactNameController.text,
                                emergencyContactNo:
                                    emergencyContactNoController.text,
                              );
                              ref
                                  .read(listingControllerProvider.notifier)
                                  .addBooking(
                                      booking, widget.listing.uid!, context);
                            },
                            child: const Text('Proceed'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
          },
        );
      },
    );
  }

  Future<void> showAddExpenseDialog(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController costController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add an Expense'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                TextFormField(
                  controller: costController,
                  decoration: const InputDecoration(
                    labelText: 'Cost',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                // Add logic to handle the input data
                String name = titleController.text;
                num cost = num.parse(costController.text);
                Expense(cost: cost, name: name);
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }
}
