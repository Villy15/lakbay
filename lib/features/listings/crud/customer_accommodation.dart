import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
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
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/common/widgets/text_in_bottomsheet.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/listings/crud/customer_accommodation_checkout.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/trips/plan/plan_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/plan_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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
  ];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
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
                          "Your Governemnt ID is required as a means to protect cooperatives.",
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
                    child: FilledButton(
                      onPressed: () {
                        startDate = startDate.copyWith(
                            hour: widget.listing.checkIn!.hour,
                            minute: widget.listing.checkIn!.minute);
                        endDate = endDate.copyWith(
                            hour: widget.listing.checkOut!.hour,
                            minute: widget.listing.checkOut!.minute);
                        final currentTrip = ref.read(currentTripProvider);

                        ListingBookings booking = ListingBookings(
                          tripUid: currentTrip!.uid!,
                          tripName: currentTrip.name,
                          listingId: widget.listing.uid!,
                          listingTitle: widget.listing.title,
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
                          tasks: widget.listing.fixedTasks,
                          cooperativeId:
                              widget.listing.cooperative.cooperativeId,
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
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Adjust the value as needed
                        ),
                      ),
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

  void createRoom(BuildContext context, String senderId) async {
    // Create a room
    final room = await FirebaseChatCore.instance.createRoom(
      types.User(id: senderId),
    );

    // ignore: use_build_context_synchronously
    context.push(
      '/inbox/id/$senderId',
      extra: room,
    );
  }

  SingleChildScrollView destination(String? planUid) {
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
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Check In',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 10),
                              Text(widget.listing.checkIn!.format(context),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        color: Colors.grey,
                        thickness: 5,
                        width: 10,
                        indent: 0,
                        endIndent: 0,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _displaySubHeader('Check Out'),
                              const SizedBox(height: 10),
                              Text(widget.listing.checkOut!.format(context),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _displaySubHeader("Description"),
                TextInBottomSheet(
                    widget.listing.title, widget.listing.description, context),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Find Us Here',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),

                // Getting There Address
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height / 5,
                    child: MapWidget(address: widget.listing.address),
                  ),
                ),
              ],
            ),
          ),
          // const Divider(),

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
                        createRoom(context, widget.listing.publisherId);
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

          // Add this to current trip
          // Padding(
          //   padding:
          //       const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          //   child: FilledButton(
          //     onPressed: () {
          //       addCurrentTrip(context, planUid);
          //     },
          //     style: ButtonStyle(
          //       minimumSize: MaterialStateProperty.all<Size>(
          //           const Size(double.infinity, 45)),
          //     ),
          //     child: const Text('Add this to current trip'),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget rooms() {
    return ref.watch(getAllRoomsByListingIdProvider(widget.listing.uid!)).when(
        data: (List<AvailableRoom> rooms) {
          return ListView.builder(
              // physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: rooms.length,
              itemBuilder: ((context, index) {
                List<String?> imageUrls = rooms[index]
                    .images!
                    .map((listingImage) => listingImage.url)
                    .toList();
                var room = rooms[index];
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
                                      "${rooms[index].bedrooms} Bedroom",
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
                                            text: "₱${rooms[index].price}",
                                            style: TextStyle(
                                                fontSize:
                                                    16, // Size for the price
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
                                    child: FilledButton(
                                  onPressed: () async {
                                    final bookings = await ref.watch(
                                        getAllBookingsByIdProvider((
                                      widget.listing.uid!,
                                      widget
                                          .listing.availableRooms![index].roomId
                                    )).future);
                                    if (context.mounted) {
                                      showSelectDate(context, bookings, index);
                                    }
                                  },
                                  style: FilledButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          8.0), // Adjust the value as needed
                                    ),
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
                                            title: Text("Room Details",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary, // Set the text color to black or your desired color
                                                )),
                                            content: SizedBox(
                                              height: MediaQuery.sizeOf(context)
                                                      .height /
                                                  4,
                                              width: MediaQuery.sizeOf(context)
                                                      .width /
                                                  1.5,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .people_alt_outlined,
                                                        size: 20,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    "Can accommodate up to \n",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onBackground, // Set the text color to black or your desired color
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: room.guests >
                                                                        1
                                                                    ? "${room.guests} guests"
                                                                    : "${room.guests} guest",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary, // Set the text color to black or your desired color
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.bed_rounded,
                                                        size: 20,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    "The room has ",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onBackground, // Set the text color to black or your desired color
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: room.beds >
                                                                        1
                                                                    ? "${room.beds} beds"
                                                                    : "${room.beds} bed",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary, // Set the text color to black or your desired color
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.bathtub_outlined,
                                                        size: 20,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    "The room has ",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onBackground, // Set the text color to black or your desired color
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: room.bathrooms >
                                                                        1
                                                                    ? "${room.bathrooms} bathrooms"
                                                                    : "${room.bathrooms} bathroom",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary, // Set the text color to black or your desired color
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
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
        },
        error: ((error, stackTrace) => Scaffold(
            body: ErrorText(
                error: error.toString(), stackTrace: stackTrace.toString()))),
        loading: () => const Scaffold(body: Loader()));
  }

  void addCurrentTrip(BuildContext context, String? planUid) {
    final selectedDate = ref.read(selectedDateProvider);

    // Edit the current plan
    PlanActivity activity = PlanActivity(
      // Create a random key for the activity
      key: DateTime.now().millisecondsSinceEpoch.toString(),
      listingId: widget.listing.uid,
      category: 'Accommodation',
      dateTime: selectedDate,
      title: widget.listing.title,
      imageUrl: widget.listing.images!.first.url,
      description: widget.listing.description,
    );

    ref
        .read(plansControllerProvider.notifier)
        .addActivityToPlan(planUid!, activity, context);
  }

  @override
  Widget build(BuildContext context) {
    final planUid = ref.read(currentPlanIdProvider);
    final isLoading = ref.watch(plansControllerProvider);
    debugPrintJson("File Name: customer_accommodation.dart");
    // final user = ref.watch(userProvider);
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          context.pop();
          // ref.read(navBarVisibilityProvider.notifier).show();
        },
        child: DefaultTabController(
          initialIndex: 0,
          length: tabs.length,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            // Add appbar with back button
            appBar: _appBar(widget.listing.title, context),
            body: TabBarView(
              children: [
                isLoading ? const Loader() : destination(planUid),
                rooms(),
              ],
            ),
          ),
        ));
  }

  Widget _displaySubtitleText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
    );
  }

  Text _displaySubHeader(String subHeader) {
    return Text(
      subHeader,
      style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.primary
          // Add other styling as needed
          ),
    );
  }
}
