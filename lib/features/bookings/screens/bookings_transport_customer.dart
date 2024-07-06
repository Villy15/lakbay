// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/listings/crud/customer_transport_receipt.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/notifications/notifications_controller.dart';
import 'package:lakbay/features/sales/sales_controller.dart';
import 'package:lakbay/features/trips/plan/plan_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/notifications_model.dart';
import 'package:lakbay/models/plan_model.dart';
import 'package:lakbay/models/sale_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/user_model.dart';

class BookingsTransportCustomer extends ConsumerStatefulWidget {
  final ListingModel listing;
  final ListingBookings booking;

  const BookingsTransportCustomer(
      {super.key, required this.listing, required this.booking});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookingsTransportCustomerState();
}

class _BookingsTransportCustomerState
    extends ConsumerState<BookingsTransportCustomer> {
  late String departureTime;
  late String departed;
  late String departureDate;
  late String departureLocation;
  late String arrived;
  late String arrivalTime;
  late String arrivalDate;
  late String arrivalLocation;
  late String vehicleNo;
  late String driverName;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  void createRoom(BuildContext context, String senderId, UserModel user) async {
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

  @override
  Widget build(BuildContext context) {
    debugPrint('File Name: booking_transport_customer.dart');
    departureTime = widget.booking.startTime!.format(context);
    departed = widget.booking.serviceStart != null
        ? DateFormat('h:mm a').format(widget.booking.serviceStart!)
        : "";
    departureDate = DateFormat('E, MMM d').format(widget.booking.startDate!);
    departureLocation = widget.listing.pickUp!;
    arrivalTime = (widget.booking.endTime!).format(context);
    arrived = widget.booking.serviceComplete != null
        ? DateFormat('h:mm a').format(widget.booking.serviceComplete!)
        : "";
    arrivalDate = DateFormat('E, MMM d').format(widget.booking.endDate!);
    arrivalLocation = widget.listing.destination!;
    vehicleNo = widget.booking.vehicleNo != null
        ? widget.booking.vehicleNo.toString()
        : "Not Set";
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          ref.read(navBarVisibilityProvider.notifier).show();
          context.pop();
        },
        child: ref
            .watch(getBookingByIdProvider(
                (widget.booking.listingId, widget.booking.id!)))
            .when(
                data: (ListingBookings booking) {
                  List<String?> imageUrls = widget.listing.images!
                      .map((listingImage) => listingImage.url)
                      .toList();
                  Map<String, Map<String, dynamic>> generalActions = {
                    "listing": {
                      "icon": Icons.location_on_outlined,
                      "title": "View Listing",
                      "action": () {
                        context.push(
                            "/market/${widget.listing.category.toLowerCase()}",
                            extra: widget.listing);
                      }
                    },
                    "message": {
                      "icon": Icons.chat_outlined,
                      "title": "Message Host",
                      "action": () {
                        createRoom(context, widget.listing.publisherId,
                            ref.watch(userProvider)!);
                      }
                    },
                  };

                  Map<String, Map<String, dynamic>> reservationActions = {
                    "receipt": {
                      "icon": Icons.receipt_long_outlined,
                      "title": "View receipt",
                      "action": () => showDialog(
                          context: context,
                          builder: ((context) {
                            return Dialog.fullscreen(
                              child: CustomerTransportReceipt(
                                  listing: widget.listing,
                                  booking: widget.booking),
                            );
                          }))
                    },
                    "booking": {
                      "icon": Icons.cancel_outlined,
                      "title": "Cancel Booking",
                      "action": () {
                        cancelBookingProcess(context, booking);
                      }
                    },
                  };
                  return Scaffold(
                      extendBodyBehindAppBar: true,
                      appBar: AppBar(
                          backgroundColor: Colors.transparent,
                          leading: IconButton(
                              iconSize: 20,
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                context.pop();
                              })),
                      body: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Stack(children: [
                              Container(
                                  foregroundDecoration: BoxDecoration(
                                      color: Colors.black.withOpacity(
                                          booking.bookingStatus == "Cancelled"
                                              ? 0.5
                                              : 0.0)),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    width: MediaQuery.of(context).size.width,
                                    child: TwoMarkerMapWidget(
                                      pickup: widget.listing.pickUp!,
                                      destination: widget.listing.destination!,
                                    ),
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 70.0, left: 30),
                                child: Row(
                                  children: [
                                    Flexible(
                                        child: Text(
                                            booking.bookingStatus == 'Cancelled'
                                                ? "Your Booking Has Been Cancelled"
                                                : '',
                                            style: const TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white))),
                                  ],
                                ),
                              )
                            ]),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Departure',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(departureDate,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500)),
                                          // Checkin time
                                          Text(
                                            departureTime,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          Text(
                                            departureLocation,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w200),
                                          ),
                                          Text(
                                            ('Vehicle No: $vehicleNo'),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300),
                                          ),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Arrival',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(arrivalDate,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500)),
                                          // Checkout time
                                          Text(
                                            arrivalTime,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          Text(
                                            arrivalLocation,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w200),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        ('Departed: $departed'),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300),
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
                                      child: Text(
                                        ('Arrived: $arrived'),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ...generalActions.entries.map((entry) {
                              final generalAction = entry.value;
                              return Column(children: [
                                Container(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 15.0, right: 15.0),
                                    child: const Divider(
                                        color: Colors.grey, height: 1.0)),
                                ListTile(
                                    leading:
                                        Icon(generalAction["icon"], size: 24),
                                    title: Text(generalAction["title"],
                                        style: const TextStyle(
                                          fontSize: 16,
                                        )),
                                    onTap: generalAction["action"],
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded))
                              ]);
                            }),
                            Container(
                                margin: const EdgeInsets.only(top: 15),
                                height: 10,
                                width: double.infinity,
                                color: Colors.grey[200]),

                            // reservation details
                            const Padding(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, top: 20),
                                child: Text('Reservation Details',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))),

                            if (booking.bookingStatus != 'Cancelled' &&
                                booking.bookingStatus != 'Completed')
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 10, bottom: 15),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Cancellation Policy: ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                        if (booking.bookingStatus !=
                                                'Cancelled' &&
                                            booking.bookingStatus !=
                                                'Completed')
                                          Text(
                                              'Cancellation before ${DateFormat('MMM d, HH:mm a').format(booking.endDate!.subtract(const Duration(days: 5)))}'
                                              ' entitles you to a refund amount of ₱${(booking.amountPaid!).toStringAsFixed(2)}\n'
                                              'Cancellation after stated date entitles you to a refund amount of ₱${(booking.amountPaid! - (widget.listing.cancellationRate! > 1 ? widget.listing.cancellationRate! : booking.amountPaid! * (widget.listing.cancellationRate!))).toStringAsFixed(2)}')
                                      ])),

                            ...reservationActions.entries.map((entry) {
                              final reservationAction = entry.value;
                              if (booking.bookingStatus == 'Cancelled' &&
                                      entry.key == 'booking' ||
                                  booking.bookingStatus == 'Completed' &&
                                      entry.key == 'booking') {
                                return Container();
                              } else {
                                return Column(children: [
                                  Container(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, left: 15.0, right: 15.0),
                                      child: const Divider(
                                          color: Colors.grey, height: 1.0)),
                                  ListTile(
                                      leading: Icon(reservationAction["icon"],
                                          size: 24),
                                      title: Text(reservationAction["title"],
                                          style: const TextStyle(
                                            fontSize: 16,
                                          )),
                                      onTap: reservationAction["action"],
                                      trailing: const Icon(
                                          Icons.arrow_forward_ios_rounded))
                                ]);
                              }
                            }),

                            const Padding(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, top: 20),
                                child: Text("Hosted By",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))),

                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: [
                                  const Icon(Icons.people_alt_outlined),
                                  const SizedBox(width: 8),
                                  Text(
                                      widget
                                          .listing.cooperative.cooperativeName,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal))
                                ])),
                          ])));
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString(), stackTrace: ''),
                loading: () => const CircularProgressIndicator()));
  }

  Future<dynamic> cancelBookingProcess(
      BuildContext context, ListingBookings booking) {
    return showDialog(
      context: context,
      builder: (context) {
        Map<String, bool> reasons = {
          'I don\'t want to go anymore': false,
          'My travel plans changed': false,
          'I have an emergency': false,
          'Other': false,
        };

        Map<String, num> paymentDetails = {
          'Original Booking': (booking.amountPaid!),
          'Your total refund': (booking.amountPaid! -
              (booking.amountPaid! * widget.listing.cancellationRate!)),
        };

        String? selectedReason;
        return StatefulBuilder(builder: (context, setDialogState) {
          return Dialog.fullscreen(
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              bottomNavigationBar: PreferredSize(
                preferredSize: Size.fromHeight(
                    MediaQuery.sizeOf(context).height /
                        30), // Adjust the height as needed
                child: BottomAppBar(
                  surfaceTintColor: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: FilledButton(
                          onPressed: selectedReason != null
                              ? () {
                                  cancellationPaymentDetails(
                                      context, booking, paymentDetails);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Adjust the value as needed
                            ),
                          ),
                          child: const Text(
                            'Confirm Cancellation',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      "Why do you need to cancel?",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height / 20,
                  ),
                  Column(
                    children: reasons.entries.map((entry) {
                      final reasonKey = entry.key;
                      return Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(reasonKey),
                              trailing: Radio(
                                value: reasonKey,
                                groupValue: selectedReason,
                                onChanged: (newValue) {
                                  setDialogState(() {
                                    reasons.forEach((key, value) {
                                      reasons[key] = key == newValue;
                                    });
                                    selectedReason = newValue;
                                  });
                                },
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

  Future<dynamic> cancellationPaymentDetails(BuildContext context,
      ListingBookings booking, Map<String, num> paymentDetails) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog.fullscreen(
              child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              surfaceTintColor: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: FilledButton(
                      onPressed: () {
                        onTapCancel(context, booking).then((value) {
                          context.pop();
                          context.pop();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Adjust the value as needed
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your Cancellation",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                    const Text(
                      "Cancellation is effective immediately. The payment method you used to reserve this accommodation will be refunded in 5 - 7 business days.",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: MediaQuery.sizeOf(context).height / 20),
                    const Text(
                      "Payment Details",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    ...paymentDetails.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key.toString(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "₱${entry.value.toStringAsFixed(2)} PHP",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              height: 1,
                              width: double.infinity,
                              color: Colors.grey[200],
                            ),
                          ],
                        ),
                      );
                    }),
                  ]),
            ),
          ));
        });
  }

  Future<dynamic> onTapCancel(
      BuildContext context, ListingBookings booking) async {
    final updatedBooking = booking.copyWith(
        amountPaid: booking.amountPaid! * widget.listing.cancellationRate!,
        bookingStatus: "Cancelled",
        paymentStatus: "Cancelled");
    final transportUserCancelNotif = NotificationsModel(
      title: "Booking Reservation Cancelled!",
      message:
          "Your booking for ${widget.listing.title} has been cancelled. You will receive a refund of ₱${booking.amountPaid! * widget.listing.cancellationRate!}",
      type: 'listing',
      bookingId: booking.id,
      listingId: booking.listingId,
      ownerId: booking.customerId,
      createdAt: DateTime.now(),
      isRead: false,
    );
    final sale = await ref.read(getSaleByBookingIdProvider(booking.id!).future);
    SaleModel updatedSale = sale.copyWith(
        transactionType: "Cancellation",
        saleAmount: booking.amountPaid! * widget.listing.cancellationRate!);
    final trip = await ref.read(getPlanByUidProvider(booking.tripUid).future);
    PlanModel updatedTrip = trip.copyWith(
      activities: trip.activities
          ?.where((activity) => activity.bookingId != booking.id)
          .toList(),
    );

    if (context.mounted) {
      ref.read(salesControllerProvider.notifier).updateSale(
          context, updatedSale,
          booking: updatedBooking, trip: updatedTrip);
      ref
          .read(notificationControllerProvider.notifier)
          .addNotification(transportUserCancelNotif, context);
    }
  }
}
