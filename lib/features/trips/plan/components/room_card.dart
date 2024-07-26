import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/providers/storage_repository_providers.dart';
import 'package:lakbay/core/util/accommodation_utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/listings/crud/customer_accommodation_checkout.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/notifications/notifications_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/features/user/user_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/notifications_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/user_model.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class RoomCard extends ConsumerStatefulWidget {
  final String category;
  final List<ListingBookings> bookings;
  final ListingBookings?
      customerBooking; //use this for when you need to pass a booking here to streamline the process of booking, [1] Case: emergencybooking
  final String? reason; //['emergency']
  final num? guests;
  final DateTime? startDate;
  final DateTime? endDate;
  final Query? query;
  final List<ListingModel>? accommodationListings;
  final List<ListingModel>? allListings;
  final List<String>? unavailableRoomUids;
  const RoomCard({
    super.key,
    required this.category,
    required this.bookings,
    this.customerBooking,
    this.reason,
    this.guests,
    this.startDate,
    this.endDate,
    this.query,
    this.accommodationListings,
    this.allListings,
    this.unavailableRoomUids,
  });

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
    final startDate = ref.read(planStartDateProvider) ?? widget.startDate;
    final endDate = ref.read(planEndDateProvider) ?? widget.endDate;
    // final daysPlan = ref.read(daysPlanProvider);

    final currentUser = ref.read(userProvider);
    // final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    List<String> unavailableRoomUids = getUnavailableRoomUids(
        widget.bookings, startDate!, endDate!, widget.accommodationListings);
    debugPrint('the unavailable rooms: $unavailableRoomUids');
    Query query = widget.query ??
        FirebaseFirestore.instance.collectionGroup('availableRooms');
    
    // if (unavailableRoomUids.isNotEmpty && widget.accommodationListings != null) {
    //   query = query.where('uid', whereNotIn: unavailableRoomUids);
    // }

    if (unavailableRoomUids.isNotEmpty) {
      debugPrint('yes yes ye !');
      query = query.where('uid', whereNotIn: unavailableRoomUids);
      
    }

    else if (widget.accommodationListings!.isNotEmpty && unavailableRoomUids.isNotEmpty) {
      // use query to get the rooms
      debugPrint('i am not empty');
      List<ListingModel> filteredListings = widget.accommodationListings!
        .where((listing) => listing.availableRooms != null && listing.availableRooms!.any((room) => !unavailableRoomUids.contains(room.roomId)))
        .toList();
      debugPrint('these are the filteredListings: $filteredListings');

      List<String> filteredListingIds =
          filteredListings.map((listing) => listing.uid!).toList();
      
      debugPrint('these are the listingIds: $filteredListingIds');

      query = query.where('listingId', whereIn: filteredListingIds);
        
    }

    else if (widget.accommodationListings!.isNotEmpty && unavailableRoomUids.isEmpty) {
      // use query to get the rooms
      debugPrint('im empty');
      List<ListingModel> filteredListings = widget.accommodationListings!
        .where((listing) => listing.availableRooms != null)
        .toList();
      List<String> filteredListingIds =
          filteredListings.map((listing) => listing.uid!).toList();
        
      debugPrint('these are the listingIds: $filteredListingIds');
      

      query = query.where('listingId', whereIn: filteredListingIds);
    }
    
    
    
    return ref.watch(getRoomByPropertiesProvider(query)).when(
          data: (List<AvailableRoom> rooms) {
            if (rooms .isNotEmpty) {
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
                                      SizedBox(
                                        width: MediaQuery.sizeOf(context).width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              flex: 1,
                                              child: Text(
                                                "${room.bedrooms} Bedroom",
                                                style: const TextStyle(
                                                  fontSize:
                                                      14, // Increased font size, larger than the previous one
                                                  fontWeight: FontWeight
                                                      .w500, // Bold text
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: widget.allListings != null
                                                  ? Text(
                                                      "Check In: ${widget.allListings?.firstWhere((element) {
                                                            if (element.uid! ==
                                                                room.listingId) {
                                                              return true;
                                                            } else {
                                                              return false;
                                                            }
                                                          }).checkIn!.format(context)}",
                                                      style: const TextStyle(
                                                        fontSize:
                                                            14, // Increased font size, larger than the previous one
                                                        fontWeight: FontWeight
                                                            .w500, // Bold text
                                                      ),
                                                    )
                                                  : const Text(""),
                                            ),
                                          ],
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
                                                FilledButton(
                                                  onPressed: () {
                                                    context.push(
                                                        '/market/${widget.category}',
                                                        extra: listing);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0), // Adjust the radius as needed
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'View Listing',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                                FilledButton(
                                                  onPressed: () async {
                                                    debugPrint(
                                                        'this is the current user name : ${currentUser?.name}');
                                                    if (currentUser?.name ==
                                                            'Lakbay User' ||
                                                        currentUser?.phoneNo ==
                                                            null ||
                                                        currentUser
                                                                ?.emergencyContactName ==
                                                            null ||
                                                        currentUser
                                                                ?.emergencyContact ==
                                                            null ||
                                                        currentUser
                                                                ?.governmentId ==
                                                            null) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Profile Incomplete'),
                                                              content: const Text(
                                                                  'To book a service, you need to complete your profile first.'),
                                                              actions: [
                                                                FilledButton(
                                                                  onPressed:
                                                                      () async {
                                                                    showUpdateProfile(
                                                                        context,
                                                                        currentUser!);
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4.0), // Adjust the radius as needed
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    'Update Profile',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                      return;
                                                    }

                                                    if (widget.reason !=
                                                        'emergency') {
                                                      showSelectDate(
                                                          context,
                                                          startDate,
                                                          endDate,
                                                          widget.bookings,
                                                          listing,
                                                          room);
                                                    } else {
                                                      emergencyBooking(context,
                                                          room, listing);
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0), // Adjust the radius as needed
                                                    ),
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
                                                  title: Text("Room Details",
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary, // Set the text color to black or your desired color
                                                      )),
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
                                                            Icon(
                                                              Icons
                                                                  .people_alt_outlined,
                                                              size: 20,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary,
                                                            ),
                                                            const SizedBox(
                                                                width: 10),
                                                            Expanded(
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text:
                                                                          "Can accommodate up to \n",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
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
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
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
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary,
                                                            ),
                                                            const SizedBox(
                                                                width: 10),
                                                            Expanded(
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text:
                                                                          "The room has ",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
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
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
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
                                                              Icons
                                                                  .bathtub_outlined,
                                                              size: 20,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary,
                                                            ),
                                                            const SizedBox(
                                                                width: 10),
                                                            Expanded(
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text:
                                                                          "The room has ",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
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
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
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

  void showSelectDate(
      BuildContext context,
      DateTime startDate,
      DateTime endDate,
      List<ListingBookings> bookings,
      ListingModel listing,
      AvailableRoom room) {
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
                          final bookedDates =
                              getAllDatesFromBookings(bookings, room);
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
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        4.0), // Adjust the radius as needed
                  ),
                ),
                child: const Text('Save'),
              ),
            ),
          );
        });
  }

  List<DateTime> getAllDatesFromBookings(
      List<ListingBookings> bookings, AvailableRoom room) {
    List<DateTime> allDates = [];

    for (ListingBookings booking in bookings) {
      if (booking.roomUid! == room.uid) {
        // Add start date
        DateTime currentDate = booking.startDate!.add(const Duration(days: 0));

        // Keep adding dates until you reach the end date
        while (currentDate
            .isBefore(booking.endDate!.subtract(const Duration(days: 1)))) {
          allDates.add(currentDate);
          // Move to next day
          currentDate = currentDate.add(const Duration(days: 1));
        }
      }
    }

    return allDates;
  }

  Future<UserModel> submitUpdateProfile(
      BuildContext context,
      UserModel user,
      UserModel updatedUser,
      GlobalKey<FormState> formKey,
      File? profilePicture,
      File? governmentId) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (profilePicture != null) {
        final result = await ref.read(storageRepositoryProvider).storeFile(
              path: 'users/${updatedUser.name}',
              id: profilePicture.path.split('/').last,
              file: profilePicture,
            );

        result.fold((failure) => debugPrint('Failed to upload image: $failure'),
            (imageUrl) {
          // update user with the new profile picture
          updatedUser = updatedUser.copyWith(profilePic: imageUrl);
        });
      }

      if (governmentId != null) {
        final result = await ref.read(storageRepositoryProvider).storeFile(
              path: 'users/${updatedUser.name}',
              id: governmentId.path.split('/').last,
              file: governmentId,
            );

        result.fold((failure) => debugPrint('Failed to upload image: $failure'),
            (imageUrl) {
          // update user with the new government id picture
          updatedUser = updatedUser.copyWith(governmentId: imageUrl);
        });
      }

      // transfer updatedUser to user
      ref
          .read(usersControllerProvider.notifier)
          // ignore: use_build_context_synchronously
          .editProfile(context, user.uid, updatedUser);
    }

    return updatedUser;
  }

  // a dialog for the user to update their profile
  void showUpdateProfile(BuildContext context, UserModel user) async {
    File? profilePicture;
    String? profilePicLink = user.profilePic;
    File? governmentId;
    // String? governmentIdLink = user.governmentId;
    ValueNotifier<File?> governmentIdNotifier = ValueNotifier<File?>(null);
    final TextEditingController firstNameController =
        TextEditingController(text: user.firstName ?? '');
    final TextEditingController lastNameController =
        TextEditingController(text: user.lastName ?? '');
    final TextEditingController phoneNoController =
        TextEditingController(text: user.phoneNo ?? '');
    final TextEditingController emailController =
        TextEditingController(text: user.email);
    final TextEditingController emergencyContactNameController =
        TextEditingController(text: user.emergencyContactName ?? '');
    final TextEditingController emergencyContactNoController =
        TextEditingController(text: user.emergencyContact ?? '');
    final TextEditingController addressController =
        TextEditingController(text: user.address ?? '');
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) {
          return Dialog.fullscreen(
              child: StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Form(
                      key: formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppBar(
                                leading: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () =>
                                        Navigator.of(context).pop()),
                                title: const Text('Edit Profile',
                                    style: TextStyle(fontSize: 18)),
                                elevation: 0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                children: [
                                  GestureDetector(
                                      child: Row(
                                    children: [
                                      Icon(Icons.image,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: ImagePickerFormField(
                                          imageUrl: profilePicLink,
                                          initialValue: profilePicture,
                                          onSaved: (value) {
                                            this.setState(() {
                                              profilePicture = value;
                                              debugPrint(
                                                  'this is the value: $profilePicture');
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  )),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                        labelText: 'Email',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        hintText: "username@gmail.com",
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      // if email is not null, put the initial value
                                      onChanged: (value) {
                                        user = user.copyWith(email: value);
                                      },
                                      readOnly: true,
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: firstNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'First Name',
                                      border: OutlineInputBorder(),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "First Name",
                                    ),
                                    // put initial value if the user's first name is not null
                                    // initialValue: user.firstName ?? '',
                                    onChanged: (value) {
                                      user = user.copyWith(firstName: value);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: lastNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Last Name',
                                      border: OutlineInputBorder(),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Last Name",
                                    ),
                                    // initialValue: user.lastName ?? '',
                                    onChanged: (value) {
                                      user = user.copyWith(lastName: value);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: addressController,
                                    decoration: const InputDecoration(
                                      labelText: 'Address',
                                      border: OutlineInputBorder(),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Street, City, Province",
                                    ),
                                    // initialValue: user.address ?? '',
                                    onChanged: (value) {
                                      user = user.copyWith(address: value);
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
                                        hintText: '91234567891'),
                                    keyboardType: TextInputType.phone,
                                    // initialValue: user.phoneNo ?? '',
                                    onChanged: (value) {
                                      user = user.copyWith(phoneNo: value);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  // text for government id
                                  ListTile(
                                    title: const Text('Government ID*'),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    ),
                                    subtitle: ValueListenableBuilder<File?>(
                                      valueListenable: governmentIdNotifier,
                                      builder: (context, governmentId, child) {
                                        return governmentId == null
                                            ? const Text(
                                                'Upload a valid Government ID ')
                                            : Text(
                                                'Government ID selected: ${path.basename(governmentId.path)}');
                                      },
                                    ),
                                    onTap: () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: [
                                          'jpg',
                                          'jpeg',
                                          'png',
                                          'pdf',
                                          'doc'
                                        ],
                                      );

                                      if (result != null) {
                                        this.setState(() {
                                          governmentId =
                                              File(result.files.single.path!);
                                          governmentIdNotifier.value =
                                              governmentId;
                                        });
                                      }
                                    },
                                  ),

                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: emergencyContactNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Emergency Contact Name',
                                      border: OutlineInputBorder(),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Lastname Firstname",
                                    ),
                                    // initialValue: user.emergencyContactName ?? '',
                                    onChanged: (value) {
                                      user = user.copyWith(
                                          emergencyContactName: value);
                                    },
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
                                      hintText: '91234567891',
                                    ),
                                    keyboardType: TextInputType.phone,
                                    // initialValue: user.emergencyContactNo ?? '',
                                    onChanged: (value) {
                                      user = user.copyWith(
                                          emergencyContact: value);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  FilledButton(
                                    onPressed: () async {
                                      formKey.currentState!.save();
                                      UserModel updatedUser = user.copyWith(
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                        name:
                                            "${firstNameController.text} ${lastNameController.text}",
                                        address: addressController.text,
                                        phoneNo: phoneNoController.text,
                                        emergencyContactName:
                                            emergencyContactNameController.text,
                                        emergencyContact:
                                            emergencyContactNoController.text,
                                      );
                                      debugPrint(
                                          'this is the government id and the profile picture: $governmentId, $profilePicture');
                                      user = await submitUpdateProfile(
                                          context,
                                          user,
                                          updatedUser,
                                          formKey,
                                          profilePicture,
                                          governmentId);

                                      // close dialog
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                      this.setState(() {
                                        user = user;
                                      });

                                      ref
                                          .read(userProvider.notifier)
                                          .setUser(user);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            4.0), // Adjust the radius as needed
                                      ),
                                    ),
                                    child: const Text(
                                        'Update Profile Information'),
                                  )
                                ],
                              ),
                            ),
                          ]),
                    )));
          }));
        });
  }

  void showConfirmBooking(AvailableRoom room, ListingModel listing,
      DateTime startDate, DateTime endDate, BuildContext context) {
    final user = ref.read(userProvider);
    var guests = ref.read(currentPlanGuestsProvider);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // ignore: unused_local_variable
        String? guestNum = guests.toString();
        debugPrint('this is the room number of guests: $guestNum');
        TextEditingController guestController =
            TextEditingController(text: guestNum);
        TextEditingController phoneNoController =
            TextEditingController(text: user?.phoneNo ?? '');
        TextEditingController emergencyContactNameController =
            TextEditingController(text: user?.emergencyContactName ?? '');
        TextEditingController emergencyContactNoController =
            TextEditingController(text: user?.emergencyContact ?? '');
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
                    iconTheme: IconThemeData(
                      color: Theme.of(context)
                          .colorScheme
                          .primary, // Change this color to your desired color
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Customer Details",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          "$formattedStartDate - $formattedEndDate", // Replace with your subtitle text
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground, // Adjust subtitle color as needed
                          ),
                        ),
                      ],
                    ),
                    elevation: 0, // Optional: Remove shadow
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: guestController,
                          decoration: const InputDecoration(
                            labelText: 'Guests',
                            border: OutlineInputBorder(),
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
                            hintText: '91234567891',
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 10),
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
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              startDate = startDate.copyWith(
                                  hour: listing.checkIn!.hour,
                                  minute: listing.checkIn!.minute);
                              endDate = endDate.copyWith(
                                  hour: listing.checkOut!.hour,
                                  minute: listing.checkOut!.minute);
                              final currentTrip = ref.read(currentTripProvider);
                              final user = ref.read(userProvider);

                              ListingBookings booking = ListingBookings(
                                tripUid: currentTrip!.uid!,
                                tripName: currentTrip.name,
                                listingId: listing.uid!,
                                listingTitle: listing.title,
                                customerName: user!.name,
                                bookingStatus: "Reserved",
                                price: room.price,
                                category: "Accommodation",
                                roomId: room.roomId,
                                roomUid: room.uid,
                                startDate: startDate,
                                endDate: endDate,
                                email: user.email ?? '',
                                governmentId: user.governmentId ?? '',
                                guests: num.parse(guestNum),
                                customerPhoneNo: phoneNoController.text,
                                customerId: user.uid,
                                emergencyContactName:
                                    emergencyContactNameController.text,
                                emergencyContactNo:
                                    emergencyContactNoController.text,
                                needsContributions: false,
                                tasks: listing.fixedTasks,
                                cooperativeId:
                                    listing.cooperative.cooperativeId,
                              );

                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog.fullscreen(
                                        child: CustomerAccommodationCheckout(
                                            listing: listing,
                                            room: room,
                                            booking: booking));
                                  }).then((value) {
                                context.pop();
                                context.pop();
                              });
                            },
                            style: FilledButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
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
                ],
              ),
            ),
          );
        }));
      },
    );
  }

  Future<dynamic> emergencyBooking(
    BuildContext context,
    AvailableRoom room,
    ListingModel listing,
  ) async {
    ListingBookings updatedBooking =
        widget.customerBooking!.copyWith(roomId: room.roomId);
    List<BookingTask> updatedBookingTasks = await ref.read(
        getBookingTasksByBookingId((listing.uid!, updatedBooking.id!)).future);
    if (context.mounted) {
      ref
          .read(listingControllerProvider.notifier)
          .updateBooking(context, listing.uid!, updatedBooking, '');

      for (var updatedBookingTask in updatedBookingTasks) {
        updatedBookingTask =
            updatedBookingTask.copyWith(roomId: updatedBooking.roomId);
        ref
            .read(listingControllerProvider.notifier)
            .updateBookingTask(context, listing.uid!, updatedBookingTask, '');
      }
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Room Transfer'),
              content: SizedBox(
                height: MediaQuery.sizeOf(context).height * .2,
                child: FutureBuilder<bool>(
                  future:
                      Future.delayed(const Duration(seconds: 2), () => true),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text('Transferring Customer'),
                          ],
                        ),
                      ); // Show a loading indicator while waiting
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // send a notification to the user once the room transfer is successful
                      final roomTransferNotif = NotificationsModel(
                          title: 'Room Transfer',
                          message:
                              'You have been transferred to Room No.: ${room.roomId}. Please check your new room details.',
                          listingId: updatedBooking.listingId,
                          ownerId: updatedBooking.customerId,
                          bookingId: updatedBooking.id,
                          type: 'listing',
                          isToAllMembers: false,
                          createdAt: DateTime.now(),
                          isRead: false);

                      try {
                        ref
                            .read(notificationControllerProvider.notifier)
                            .addNotification(roomTransferNotif, context);
                        debugPrint(
                            'Success! A notification has been sent to the user.');
                      } catch (e) {
                        debugPrint(
                            'Error while trying to send a notification: $e');
                      }
                      return const Text(
                          'Customer has been transferred to another room. Tasks accomplished prior have been invalidated due to the room transfer.'); // Show the text after delay
                    }
                  },
                ),
              ),
              actions: [
                FilledButton(
                    onPressed: () {
                      context.pop();
                      context.pop();
                    },
                    child: const Text('Close'))
              ],
            );
          });
    }
  }
}

Future<void> sendRoomTransferNotification(WidgetRef ref,
    NotificationsModel notification, BuildContext context) async {
  try {
    await ref
        .read(notificationControllerProvider.notifier)
        .addNotification(notification, context);
    // Handle success, possibly updating the state to show a success message
    debugPrint('Notification sent successfully!');
  } catch (e) {
    // Handle error, possibly updating the state to show an error message
    debugPrint('Error while trying to send a notification: $e');
  }
}

class ImagePickerFormField extends FormField<File> {
  ImagePickerFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    String? imageUrl,
  }) : super(
          builder: (FormFieldState<File> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (pickedFile != null) {
                      state.didChange(File(pickedFile.path));
                    }
                  },
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: state.value != null
                        ? Image.file(state.value!, fit: BoxFit.cover)
                        : (imageUrl != null && imageUrl.isNotEmpty)
                            ? Image.network(imageUrl, fit: BoxFit.cover)
                            : const Center(child: Text('Select an image')),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 12),
                    child: Text(
                      state.errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        );
}
