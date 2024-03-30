import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/providers/storage_repository_providers.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/listings/crud/customer_accommodation_checkout.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/features/user/user_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/user_model.dart';
import 'package:lakbay/models/wrappers/rooms_params.dart';
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
  const RoomCard(
      {super.key,
      required this.category,
      required this.bookings,
      this.customerBooking,
      this.reason,
      this.guests,
      this.startDate,
      this.endDate});

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
    final guests = ref.read(currentPlanGuestsProvider) ?? widget.guests;
    final startDate = ref.read(planStartDateProvider) ?? widget.startDate;
    final endDate = ref.read(planEndDateProvider) ?? widget.endDate;
    final currentUser = ref.read(userProvider);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
                                                                  'To book a room, you need to complete your profile first.'),
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
                                                      debugPrint(
                                                          "This is the current user's phone number: ${currentUser!.phoneNo}");
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

  List<String> getUnavailableRoomUids(
      List<ListingBookings> bookings, DateTime startDate, DateTime endDate) {
    List<String> unavailableRoomUids = [];
    Map<String, List<DateTime>> rooms = {};

// Put all the dates booked under a certain room uid in map with its corresponding value being a list of all the dates
    for (ListingBookings booking in bookings) {
      DateTime currentDate = booking.startDate!;
      if (_isDateInRange(currentDate, startDate, booking.endDate!) == true) {
        while ((currentDate.isBefore(booking.endDate!))) {
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
    for (DateTime date in dateList) {
      // debugPrint('dateList: $dateList');
      // debugPrint('startDate: $startDate');
      // debugPrint('endDate: $endDate');
      // Check if the current date falls within the range
      if (_isDateInRange(date, startDate, endDate) == false) {
        return false;
      }
    }
    if (dateList.first.difference(startDate).inDays >= 1 ||
        endDate.difference(dateList.last).inDays >= 1) {
      return false;
    } else {
      return true;
    }
  }

  bool _isDateInRange(DateTime date, DateTime planStart, DateTime planEnd) {
    return date.isAfter(planStart.subtract(const Duration(days: 1))) &&
        date.isBefore(planEnd.add(const Duration(days: 1)));
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
      final result = await ref
        .read(storageRepositoryProvider)
        .storeFile(
          path: 'users/${updatedUser.name}',
          id: profilePicture.path.split('/').last,
          file: profilePicture,
        );

      result.fold(
        (failure) => debugPrint('Failed to upload image: $failure'),
        (imageUrl) {
          // update user with the new profile picture
          updatedUser = updatedUser.copyWith(profilePic: imageUrl);
        }
      );
    }

    if (governmentId != null) {
      final result = await ref
        .read(storageRepositoryProvider)
        .storeFile(
          path: 'users/${updatedUser.name}',
          id: governmentId.path.split('/').last,
          file: governmentId,
        );

      result.fold(
        (failure) => debugPrint('Failed to upload image: $failure'),
        (imageUrl) {
          // update user with the new government id picture
          updatedUser = updatedUser.copyWith(governmentId: imageUrl);
        }
      );
    }

    // transfer updatedUser to user
    ref.read(usersControllerProvider.notifier).editProfile(context, user.uid, updatedUser);
  }

  return updatedUser;
}

  Future<UserModel> processGovernmentId(
      UserModel user, File? governmentId) async {
    if (governmentId != null) {
      final result = await ref.read(storageRepositoryProvider).storeFile(
            path: 'users/${user.name}',
            id: governmentId.path.split('/').last,
            file: governmentId,
          );

      result.fold((failure) => debugPrint('Failed to upload image: $failure'),
          (imageUrl) {
        // update user with the new government id picture
        user = user.copyWith(governmentId: imageUrl);
        ref
            .read(usersControllerProvider.notifier)
            .editProfile(context, user.uid, user);
      });
    }

    return user;
  }

  // a dialog for the user to update their profile
  void showUpdateProfile(BuildContext context, UserModel user) async {
    File? profilePicture;
    File? governmentId;
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
                                      child: Row(children: [
                                    Icon(Icons.image,
                                        color:
                                            Theme.of(context).iconTheme.color),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: ImagePickerFormField(
                                        initialValue: profilePicture,
                                        onSaved: (value) {
                                          
                                          this.setState(() {
                                            profilePicture = value;
                                            debugPrint('this is the value: $profilePicture');
                                          });
                                        },
                                      ),
                                    )
                                  ])),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                          labelText: 'Email*',
                                          border: OutlineInputBorder(),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          hintText: "username@gmail.com",
                                          helperText: "*required"),
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
                                        labelText: 'First Name*',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        hintText: "First Name",
                                        helperText: "*required"),
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
                                        labelText: 'Last Name*',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        hintText: "Last Name",
                                        helperText: "*required"),
                                    // initialValue: user.lastName ?? '',
                                    onChanged: (value) {
                                      user = user.copyWith(lastName: value);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: addressController,
                                    decoration: const InputDecoration(
                                        labelText: 'Address*',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        hintText: "Street, City, Province",
                                        helperText: "*required"),
                                    // initialValue: user.address ?? '',
                                    onChanged: (value) {
                                      user = user.copyWith(address: value);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: phoneNoController,
                                    decoration: const InputDecoration(
                                        labelText: 'Phone Number*',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        prefixText: "+63 ",
                                        helperText: "*required",
                                        hintText: '91234567891'),
                                    keyboardType: TextInputType.phone,
                                    // initialValue: user.phoneNo ?? '',
                                    onChanged: (value) {
                                      user = user.copyWith(phoneNo: value);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  // text for government id
                                  const Text('Government ID'),
                                  GestureDetector(
                                      child: Row(
                                    children: [
                                      Icon(Icons.card_travel,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: ImagePickerFormField(
                                          initialValue: governmentId,
                                          onSaved: (value) {
                                            this.setState(() {
                                              governmentId = value;
                                              debugPrint('this is the value: $governmentId');
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  )),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: emergencyContactNameController,
                                    decoration: const InputDecoration(
                                        labelText: 'Emergency Contact Name',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        hintText: "Lastname Firstname",
                                        helperText: "*required"),
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
                                        helperText: "*required"),
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

                                      debugPrint('this is user: $user');

                                      // close dialog
                                      Navigator.of(context).pop();
                                      this.setState(() {
                                        user = user;
                                      });

                                      ref.read(userProvider.notifier).setUser(user);
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        num guests = 0;
        TextEditingController guestController = TextEditingController(text: room.guests.toString() ?? '');
        TextEditingController phoneNoController =
            TextEditingController(text: user?.phoneNo ?? '');
        TextEditingController emergencyContactNameController =
            TextEditingController(text: user?.emergencyContactName ?? '');
        TextEditingController emergencyContactNoController =
            TextEditingController(text: user?.emergencyContactName ?? '');
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
                          decoration: const InputDecoration(
                            labelText: 'Number of Guests',
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
                              labelText: 'Emergency Contact Name*',
                              border: OutlineInputBorder(),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintText: "Lastname Firstname",
                              helperText: "*required"),
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
                              helperText: "*required"),
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
                    child: FilledButton(
                      onPressed: () {
                        startDate = startDate.copyWith(
                            hour: listing.checkIn!.hour,
                            minute: listing.checkIn!.minute);
                        endDate = endDate.copyWith(
                            hour: listing.checkOut!.hour,
                            minute: listing.checkOut!.minute);
                        final currentTrip = ref.read(currentTripProvider);

                        ListingBookings booking = ListingBookings(
                          tripUid: currentTrip!.uid!,
                          tripName: currentTrip.name,
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
                            }).then((value) {
                          context.pop();
                          context.pop();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              4.0), // Adjust the radius as needed
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
