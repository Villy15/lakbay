import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/providers/days_provider.dart';
import 'package:lakbay/core/providers/storage_repository_providers.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/listings/crud/customer_entertainment_checkout.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/features/user/user_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/user_model.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

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
    final daysPlan = ref.read(daysPlanProvider);
    if (widget.entertainmentListings!.isNotEmpty) {
      debugPrint('this is the entertainment list ${widget.entertainmentListings}');
      return SizedBox(
          width: double.infinity,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.entertainmentListings!.length,
              itemBuilder: ((context, index) {
                final entertainment = widget.entertainmentListings![index];

                return entertainmentTypeController(
                    entertainment, entertainment.type, daysPlan.currentDay!);
              })));
    } else {
      return Center(
        child: Column(
          children: [
            const Text("No Entertainment Available"),
            Text("(${DateFormat('MMMM dd').format(daysPlan.currentDay!)})")
          ],
        ),
      );
    }
  }

  Widget? entertainmentTypeController(
      ListingModel listing, String? type, DateTime currentDate) {
    final List<String?> imageUrls =
        listing.images!.map((listingImage) => listingImage.url).toList();
    switch (type) {
      case 'Rental':
        return rentalCard(listing, imageUrls, currentDate);
      case "Watching/Performances":
        return activityToursCard(listing, imageUrls, currentDate);
      case 'Activities/Tours':
        return activityToursCard(listing, imageUrls, currentDate);
      default:
        return rentalCard(listing, imageUrls, currentDate);
    }
  }

  Widget rentalCard(
      ListingModel listing, List<String?> imageUrls, DateTime currentDate) {
    final currentUser = ref.read(userProvider);
    debugPrint('This is the rental card: $listing');

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
                                    ? '/ ${listing.duration!.minute} mins'
                                    : '/ ${listing.duration!.hour} hrs ${listing.duration!.minute.remainder(60)} mins',
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
                      FilledButton(
                          onPressed: () {
                            context.push('/market/${widget.category}',
                                extra: listing);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  4.0), // Adjust the radius as needed
                            ),
                          ),
                          child: const Text('View Listing',
                              style: TextStyle(fontSize: 14))),
                      FilledButton(
                          onPressed: () async {
                            if (currentUser?.name == 'Lakbay User' ||
                                currentUser?.phoneNo == null ||
                                currentUser?.emergencyContact == null ||
                                currentUser?.emergencyContactName == null ||
                                currentUser?.governmentId == null) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: const Text('Profile Incomplete'),
                                        content: const Text(
                                            'To book an entertainment, you need to complete your profile first.'),
                                        actions: [
                                          FilledButton(
                                              onPressed: () async {
                                                showUpdateProfile(
                                                    context, currentUser!);
                                              },
                                              style: FilledButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0))),
                                              child: const Text(
                                                  'Update Profile',
                                                  style:
                                                      TextStyle(fontSize: 14)))
                                        ]);
                                  });
                            } else {
                              if (context.mounted) {
                                final bookings = await ref.watch(
                                    getAllBookingsProvider(listing.uid!)
                                        .future);
                                // String formattedCurrentDate =
                                //     DateFormat('MMMM dd, yyyy')
                                //         .format(currentDate);
                                showDialog(
                                    // ignore: use_build_context_synchronously
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Select a Rental Time Slot',
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
                                                          availableTime
                                                              .time.hour,
                                                          availableTime
                                                              .time.minute);
                                                  List<ListingBookings>
                                                      bookingsCopy = bookings;
                                                  Map<DateTime?, num>
                                                      availableTimeAndCapacity =
                                                      {
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
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                    title: const Text(
                                                                        'No units available'),
                                                                    content: Text(
                                                                        'The time ${availableTime.time.format(context)} has reached its capacity of ${availableTimeAndCapacity[dateTimeSlot]}.  Please select another time.'),
                                                                    actions: [
                                                                      TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              const Text('Close'))
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
                            }

                            // showConfirmBooking(transport, listing, DateTime.now(), DateTime.now(), , endTime, typeOfTrip);
                          },
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  4.0), // Adjust the radius as needed
                            ),
                          ),
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
                                  title: const Text("Entertainment Details"),
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
                                  text: "Entertainment Details",
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

  Widget? activityToursCard(
      ListingModel listing, List<String?> imageUrls, DateTime currentDate) {
        debugPrint('This is the activity tours card: $listing');
    final currentUser = ref.read(userProvider);
    final dayIndex = ref.read(daysPlanProvider).currentDay!.weekday - 1;
    switch (listing.entertainmentScheduling!.type) {
      case "dayScheduling":
        {
          var day = listing.entertainmentScheduling!.availability![dayIndex];
          AvailableDay? availableDay;
          var daysOfWeek = 0;
          var startIndex = dayIndex + 1;
          while (daysOfWeek < 7) {
            if (startIndex >= 7) {
              startIndex = 0; // Wrap around to the beginning of the week
            }

            var tempDay =
                listing.entertainmentScheduling!.availability![startIndex];
            if (tempDay.available == true && startIndex != dayIndex) {
              availableDay = tempDay;
              break; // Found the available day, exit the loop
            }

            startIndex++;
            daysOfWeek++;
          }
          var timeSlots = day.availableTimes;

          return daySchedulingCard(imageUrls, listing, currentUser, timeSlots,
              currentDate, day, availableDay);
        }
      case "dateScheduling":
        {
          var date = listing.entertainmentScheduling!.fixedDates!.where((date) {
            return date.date.eqvYearMonthDay(currentDate);
          }).firstOrNull; // Changed from .first to .firstOrNull

          // if (date == null) {
          //   debugPrint('i am null. no date found');
          //   // Handle the case when no matching date is found
          //   return null;
          // }
          var availableDate = listing.entertainmentScheduling!.fixedDates!
              .where((availableDate) {
            return availableDate.available == true &&
                availableDate.date.isAfter(currentDate);
          }).firstOrNull;
          var timeSlots = date?.availableTimes;
          return dateSchedulingCard(imageUrls, listing, currentUser, timeSlots,
              currentDate, date, availableDate);
        }
    }
    return null;
  }

  SizedBox dateSchedulingCard(
      List<String?> imageUrls,
      ListingModel listing,
      UserModel? currentUser,
      List<AvailableTime>? timeSlots,
      DateTime currentDate,
      AvailableDate? date,
      AvailableDate? availableDate) {
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
                                    ? '/ ${listing.duration!.minute} mins'
                                    : '/ ${listing.duration!.hour} hrs ${listing.duration!.minute.remainder(60)} mins',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.normal,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              )
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
                      FilledButton(
                          onPressed: () {
                            context.push('/market/${widget.category}',
                                extra: listing);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  4.0), // Adjust the radius as needed
                            ),
                          ),
                          child: const Text('View Listing',
                              style: TextStyle(fontSize: 14))),
                      date != null && date.available == true
                          ? dateSchedulingBookNow(
                              currentUser, listing, timeSlots!, currentDate)
                          : FilledButton(
                              onPressed: null,
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      4.0), // Adjust the radius as needed
                                ),
                              ),
                              child: Text(
                                  'Next Available \n ${availableDate != null ? formatDateMMDDYYYY(availableDate.date) : "Not Scheduled"}',
                                  style: const TextStyle(fontSize: 14)))
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Row(children: [
                        Icon(listing.type! == "Activities/Tours"
                            ? Icons.hiking_outlined
                            : Icons.movie_outlined),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(listing.type!,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        )
                      ])),
                      TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Entertainment Details"),
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
                                  text: "Entertainment Details",
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

  FilledButton dateSchedulingBookNow(
      UserModel? currentUser,
      ListingModel listing,
      List<AvailableTime> timeSlots,
      DateTime currentDate) {
    return FilledButton(
        onPressed: () async {
          if (currentUser?.name == 'Lakbay User' ||
              currentUser?.phoneNo == null ||
              currentUser?.emergencyContact == null ||
              currentUser?.emergencyContactName == null ||
              currentUser?.governmentId == null) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: const Text('Profile Incomplete'),
                      content: const Text(
                          'To book an entertainment, you need to complete your profile first.'),
                      actions: [
                        FilledButton(
                            onPressed: () async {
                              showUpdateProfile(context, currentUser!);
                            },
                            style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0))),
                            child: const Text('Update Profile',
                                style: TextStyle(fontSize: 14)))
                      ]);
                });
          } else {
            if (context.mounted) {
              final bookings =
                  await ref.watch(getAllBookingsProvider(listing.uid!).future);
              // String formattedCurrentDate =
              //     DateFormat('MMMM dd, yyyy')
              //         .format(currentDate);

              showDialog(
                  // ignore: use_build_context_synchronously
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      scrollable: true,
                      title: const Text('Select a time',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      content: Column(
                          children: timeSlots.map((availableTime) {
                        {
                          DateTime dateTimeSlot = DateTime(
                              currentDate.year,
                              currentDate.month,
                              currentDate.day,
                              availableTime.time.hour,
                              availableTime.time.minute);
                          List<ListingBookings> bookingsCopy = bookings;
                          Map<DateTime?, num> availableTimeAndCapacity = {
                            dateTimeSlot: availableTime.maxPax
                          };
                          // format the currentDate
                          String formattedCurrentDate =
                              DateFormat('yyyy-MM-dd').format(currentDate);

                          for (ListingBookings booking in bookingsCopy) {
                            // only get the date and not the time from booking.startDate. trim it to only get the date
                            if (booking.bookingStatus != "Cancelled") {
                              DateTime bookingStartDate = booking.startDate!;
                              String formattedDate = DateFormat('yyyy-MM-dd')
                                  .format(bookingStartDate);

                              // check the formattedCurrentDate and the formattedDate if they are the same
                              if (formattedCurrentDate == formattedDate) {
                                // remove duplicates of departure time, and get the total number of guests for each departure time

                                if (availableTimeAndCapacity
                                    .containsKey(bookingStartDate)) {
                                  availableTimeAndCapacity[bookingStartDate] =
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
                          }
                          return ListTile(
                              title: Text(availableTime.time.format(context)),
                              trailing: Text(
                                  'Slots Left: ${availableTimeAndCapacity[dateTimeSlot]}'),
                              onTap: () async {
                                num capacity =
                                    availableTimeAndCapacity[dateTimeSlot] ?? 0;

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
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Close'))
                                            ]);
                                      });
                                } else {
                                  showConfirmBooking(
                                      availableTime, listing, currentDate);
                                }
                              });
                        }
                      }).toList()),
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
          }
        },
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(4.0), // Adjust the radius as needed
          ),
        ),
        child: const Text('Book Now', style: TextStyle(fontSize: 14)));
  }

  SizedBox daySchedulingCard(
      List<String?> imageUrls,
      ListingModel listing,
      UserModel? currentUser,
      List<AvailableTime> timeSlots,
      DateTime currentDate,
      AvailableDay? day,
      AvailableDay? availableDay) {
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
                                    ? '/ ${listing.duration!.minute} mins'
                                    : '/ ${listing.duration!.hour} hrs ${listing.duration!.minute.remainder(60)} mins',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.normal,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              )
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
                      FilledButton(
                          onPressed: () {
                            context.push('/market/${widget.category}',
                                extra: listing);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  4.0), // Adjust the radius as needed
                            ),
                          ),
                          child: const Text('View Listing',
                              style: TextStyle(fontSize: 14))),
                      day?.available == true
                          ? daySchedulingBookNow(
                              currentUser, listing, timeSlots, currentDate)
                          : FilledButton(
                              onPressed: null,
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      4.0), // Adjust the radius as needed
                                ),
                              ),
                              child: Text(
                                  'Next Available \n ${availableDay?.day}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 14)))
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Row(children: [
                        Icon(listing.type! == "Activities/Tours"
                            ? Icons.hiking_outlined
                            : Icons.movie_outlined),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(listing.type!,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        )
                      ])),
                      TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Entertainment Details"),
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
                                  text: "Entertainment Details",
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

  FilledButton daySchedulingBookNow(
      UserModel? currentUser,
      ListingModel listing,
      List<AvailableTime> timeSlots,
      DateTime currentDate) {
    return FilledButton(
        onPressed: () async {
          if (currentUser?.name == 'Lakbay User' ||
              currentUser?.phoneNo == null ||
              currentUser?.emergencyContact == null ||
              currentUser?.emergencyContactName == null ||
              currentUser?.governmentId == null) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: const Text('Profile Incomplete'),
                      content: const Text(
                          'To book an entertainment, you need to complete your profile first.'),
                      actions: [
                        FilledButton(
                            onPressed: () async {
                              showUpdateProfile(context, currentUser!);
                            },
                            style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0))),
                            child: const Text('Update Profile',
                                style: TextStyle(fontSize: 14)))
                      ]);
                });
          } else {
            if (context.mounted) {
              final bookings =
                  await ref.watch(getAllBookingsProvider(listing.uid!).future);
              // String formattedCurrentDate =
              //     DateFormat('MMMM dd, yyyy')
              //         .format(currentDate);

              showDialog(
                  // ignore: use_build_context_synchronously
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      scrollable: true,
                      title: const Text('Select a time',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      content: Column(
                          children: timeSlots.map((availableTime) {
                        {
                          DateTime dateTimeSlot = DateTime(
                              currentDate.year,
                              currentDate.month,
                              currentDate.day,
                              availableTime.time.hour,
                              availableTime.time.minute);
                          List<ListingBookings> bookingsCopy = bookings;
                          Map<DateTime?, num> availableTimeAndCapacity = {
                            dateTimeSlot: availableTime.maxPax
                          };
                          // format the currentDate
                          String formattedCurrentDate =
                              DateFormat('yyyy-MM-dd').format(currentDate);

                          for (ListingBookings booking in bookingsCopy) {
                            // only get the date and not the time from booking.startDate. trim it to only get the date
                            if (booking.bookingStatus != "Cancelled") {
                              DateTime bookingStartDate = booking.startDate!;
                              String formattedDate = DateFormat('yyyy-MM-dd')
                                  .format(bookingStartDate);

                              // check the formattedCurrentDate and the formattedDate if they are the same
                              if (formattedCurrentDate == formattedDate) {
                                // remove duplicates of departure time, and get the total number of guests for each departure time

                                if (availableTimeAndCapacity
                                    .containsKey(bookingStartDate)) {
                                  availableTimeAndCapacity[bookingStartDate] =
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
                          }
                          return ListTile(
                              title: Text(availableTime.time.format(context)),
                              trailing: Text(
                                  'Slots Left: ${availableTimeAndCapacity[dateTimeSlot]}'),
                              onTap: () async {
                                num capacity =
                                    availableTimeAndCapacity[dateTimeSlot] ?? 0;

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
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Close'))
                                            ]);
                                      });
                                } else {
                                  showConfirmBooking(
                                      availableTime, listing, currentDate);
                                }
                              });
                        }
                      }).toList()),
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
          }
        },
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(4.0), // Adjust the radius as needed
          ),
        ),
        child: const Text('Book Now', style: TextStyle(fontSize: 14)));
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
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                      this.setState(() {
                                        user = user;
                                      });

                                      ref
                                          .read(userProvider.notifier)
                                          .setUser(user);
                                    },
                                    style: FilledButton.styleFrom(
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

  Future<dynamic> showConfirmBooking(
      AvailableTime availableTime, ListingModel listing, DateTime currentDate) {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) {
          num guests = 0;
          final user = ref.read(userProvider);
          final currentPlanGuests = ref.read(currentPlanGuestsProvider);
          guests = currentPlanGuests!;
          TextEditingController guestController =
              TextEditingController(text: guests.toString());
          TextEditingController phoneNoController =
              TextEditingController(text: user?.phoneNo ?? '');
          TextEditingController emergencyContactNameController =
              TextEditingController(text: user?.emergencyContactName ?? '');
          TextEditingController emergencyContactNoController =
              TextEditingController(text: user?.emergencyContact ?? '');
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
                            formattedStartDate, // Replace with your subtitle text
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
                      iconTheme: IconThemeData(
                        color: Theme.of(context)
                            .colorScheme
                            .primary, // Change this color to your desired color
                      ),
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
                                fontSize:
                                    12, // Smaller font size for fine print
                                color: Colors
                                    .grey, // Optional: Grey color for fine print
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () {
                                DateTime startDate = currentDate.copyWith(
                                    hour: availableTime.time.hour,
                                    minute: availableTime.time.minute);
                                DateTime endDate = startDate.add(Duration(
                                    hours: listing.duration!.hour,
                                    minutes: listing.duration!.minute));
                                final currentTrip =
                                    ref.read(currentTripProvider);

                                ListingBookings booking = ListingBookings(
                                  tripUid: currentTrip!.uid!,
                                  tripName: currentTrip.name,
                                  listingId: listing.uid!,
                                  listingTitle: listing.title,
                                  customerName: ref.read(userProvider)!.name,
                                  bookingStatus: "Reserved",
                                  price: listing.price!,
                                  category: "Entertainment",
                                  startDate: startDate,
                                  endDate: endDate,
                                  email: user!.email ?? '',
                                  governmentId: user.governmentId ??
                                      '', // add the government id
                                  guests: guests,
                                  customerPhoneNo: phoneNoController.text,
                                  customerId: ref.read(userProvider)!.uid,
                                  emergencyContactName:
                                      emergencyContactNameController.text,
                                  emergencyContactNo:
                                      emergencyContactNoController.text,
                                  needsContributions: false,
                                  cooperativeId:
                                      listing.cooperative.cooperativeId,
                                );

                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog.fullscreen(
                                          child: CustomerEntertainmentCheckout(
                                              listing: listing,
                                              availableTime: availableTime,
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
        });
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
