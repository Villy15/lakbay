import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/text_in_bottomsheet.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class CustomerTransportation extends ConsumerStatefulWidget {
  final ListingModel listing;
  const CustomerTransportation({super.key, required this.listing});

  @override
  ConsumerState<CustomerTransportation> createState() =>
      _CustomerTransportationState();
}

class _CustomerTransportationState
    extends ConsumerState<CustomerTransportation> {
  List<SizedBox> tabs = [
    const SizedBox(width: 100, child: Tab(child: Text('Details'))),
    const SizedBox(width: 100, child: Tab(child: Text('Bookings')))
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                appBar: AppBar(
                  title: widget.listing.title.length > 20
                      ? Text('${widget.listing.title.substring(0, 20)}...',
                          style: const TextStyle(
                              fontSize: 32.0, fontWeight: FontWeight.bold))
                      : Text(widget.listing.title,
                          style: const TextStyle(
                              fontSize: 32.0, fontWeight: FontWeight.bold)),
                  bottom: TabBar(
                    tabAlignment: TabAlignment.center,
                    labelPadding: EdgeInsets.zero,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: tabs,
                  ),
                ),
                body: TabBarView(children: [details(), bookings()]))));
  }

  SingleChildScrollView details() {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 14.0),
            child: DisplayText(
                text: widget.listing.title,
                lines: 2,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          DisplayText(
              text:
                  'Location: ${widget.listing.province}, ${widget.listing.city}',
              lines: 4,
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelLarge?.fontSize)),
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
          if (widget.listing.description.length > 40) ...[
            TextInBottomSheet(
                "About this space", widget.listing.description, context)
          ] else ...[
            Text('this is the length: ${widget.listing.description.length}'),
            DisplayText(
              text: widget.listing.description,
              lines: 5,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
              ),
            )
          ],
        ]),
      ),
      const SizedBox(height: 10),
      const Divider(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Working Hours',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                  ),
                ),
              ),
              Text(
                '${widget.listing.availableTransport!.startTime.format(context)} - ${widget.listing.availableTransport!.endTime.format(context)}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  'Available Days',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  getWorkingDays(
                      widget.listing.availableTransport!.workingDays),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ]),
      ),
      const SizedBox(height: 30),
      const Divider(),

      ListTile(
        leading: SizedBox(
          height: 40,
          width: 40,
          child: DisplayImage(
              imageUrl:
                  'cooperatives/${widget.listing.cooperative.cooperativeName}/download.jpg',
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
        title: Text('Hosted by ${widget.listing.cooperative.cooperativeName}',
            style: Theme.of(context).textTheme.labelLarge),
      ),
      const Divider(),

      const SizedBox(height: 5),

      // add a book now button
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Transport details
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: '₱${widget.listing.availableTransport?.price}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary)),
                if (widget.listing.type == 'Private') ...[
                  TextSpan(
                    text: " per night",
                    style: TextStyle(
                        fontSize: 16, // Smaller size for 'per night'
                        fontStyle: FontStyle.italic, // Italicized 'per night'
                        fontWeight:
                            FontWeight.normal, // Normal weight for 'per night'
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ] else ...[
                  TextSpan(
                    text: " per person",
                    style: TextStyle(
                        fontSize: 16, // Smaller size for 'per night'
                        fontStyle: FontStyle.italic, // Italicized 'per night'
                        fontWeight:
                            FontWeight.normal, // Normal weight for 'per night'
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ]
              ])),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16.0),
              child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text('Transport Details'),
                              content: SizedBox(
                                  height: MediaQuery.sizeOf(context).height / 4,
                                  width: MediaQuery.sizeOf(context).width / 1.5,
                                  child: Column(children: [
                                    Row(children: [
                                      const Icon(Icons.people_alt_outlined,
                                          size: 30),
                                      Text(
                                          "Guests: ${widget.listing.availableTransport!.guests}",
                                          style: const TextStyle(fontSize: 18))
                                    ]),
                                    const SizedBox(height: 10),
                                    Row(children: [
                                      const Icon(Icons.luggage_outlined,
                                          size: 30),
                                      Text(
                                          "Luggages: ${widget.listing.availableTransport!.luggage}",
                                          style: const TextStyle(fontSize: 18))
                                    ])
                                  ])));
                        });
                  },
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'Transport Details',
                          style: TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).colorScheme.secondary,
                              fontStyle: FontStyle.italic)),
                      WidgetSpan(
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 14,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )
                    ]),
                  )),
            )
          ]),

          // Book Now button
          Container(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 15,
                width: MediaQuery.of(context).size.width / 2.3,
                child: ElevatedButton(
                  onPressed: () async {
                    final bookings = await ref.watch(
                        getAllBookingsProvider(widget.listing.uid!).future);

                    debugPrint('this is the bookings: $bookings');
                    // ask the user if they would want to book a two-way trip
                    // if yes, show a date picker for the end date
                    // if no, show a date picker for the start date

                    if (context.mounted) {
                      DateTime? endDate;
                      DateTime initialDate = DateTime.now();

                      // ensure initalDate is a working day
                      while (!widget.listing.availableTransport!
                          .workingDays[initialDate.weekday - 1]) {
                        initialDate = initialDate.add(const Duration(days: 1));
                      }
                      DateTime? startDate = await showDatePicker(
                          context: context,
                          initialDate: initialDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2025),
                          selectableDayPredicate: (DateTime day) {
                            bool workingDays = widget
                                .listing
                                .availableTransport!
                                .workingDays[day.weekday - 1];
                            final bookedDates =
                                getAllDatesFromBookings(bookings);

                            // If the day is not a working day, disable it
                            if (!workingDays) {
                              return false;
                            }
                            for (DateTime bookedDate in bookedDates) {
                              if (day.year == bookedDate.year &&
                                  day.month == bookedDate.month &&
                                  day.day == bookedDate.day) {
                                return false;
                              }
                            }

                            // Enable all other days
                            return true;
                          });

                      if (startDate != null && context.mounted) {
                        endDate = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: startDate,
                          lastDate: DateTime(2025),
                          selectableDayPredicate: (DateTime day) {
                            bool workingDays = widget
                                .listing
                                .availableTransport!
                                .workingDays[day.weekday - 1];
                            final bookedDates =
                                getAllDatesFromBookings(bookings);

                            // If the day is not a working day, disable it
                            if (!workingDays) {
                              return false;
                            }
                            for (DateTime bookedDate in bookedDates) {
                              if (day.year == bookedDate.year &&
                                  day.month == bookedDate.month &&
                                  day.day == bookedDate.day) {
                                return false;
                              }
                            }

                            // Enable all other days
                            return true;
                          },
                        );
                      }
                      if (startDate != null && endDate != null) {
                        showConfirmBooking(widget.listing.availableTransport!,
                            startDate, endDate);
                      }
                    }
                  },
                  child: const Text(
                    'Book now',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ]));
  }

  Widget bookings() {
    return const Placeholder();
  }

  String getWorkingDays(List<bool> workingDays) {
    const daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    List<String> result = [];
    for (int i = 0; i < workingDays.length; i++) {
      if (workingDays[i]) {
        int start = i;
        // Find the end of this sequence of days
        while (i + 1 < workingDays.length && workingDays[i + 1]) {
          i++;
        }
        // If start and i are the same, it means only one day is available
        if (start == i) {
          result.add(daysOfWeek[start]);
        } else {
          // Else, we have a range of days
          result.add('${daysOfWeek[start]}-${daysOfWeek[i]}');
        }
      }
    }
    return result.join(', ');
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

  void showConfirmBooking(
      AvailableTransport transport, DateTime startDate, DateTime endDate) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        showDragHandle: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          num guests = 0;
          num luggage = 0;
          TextEditingController phoneNoController = TextEditingController();
          TextEditingController emergencyContactNameController =
              TextEditingController();
          TextEditingController emergencyContactNoController =
              TextEditingController();
          bool governmentId = true;
          String formattedStartDate =
              DateFormat('MMMM dd, yyyy').format(startDate);
          String formattedEndDate = DateFormat('MMMM dd, yyyy').format(endDate);

          return DraggableScrollableSheet(
              initialChildSize: 0.75,
              expand: false,
              builder: (context, scrollController) {
                return StatefulBuilder(builder: (context, setState) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('$formattedStartDate - ',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                )),
                                const SizedBox(height: 4),
                                Text('$formattedEndDate',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                )),
                              ]
                            ),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height / 20
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Number of Guests',
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                hintText: transport.guests.toString(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                guests = int.tryParse(value) ?? 0;
                              }
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Number of Luggages',
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                hintText: transport.luggage.toString(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                luggage = int.tryParse(value) ?? 0;
                              }
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: phoneNoController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                hintText: '+63',
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
                                hintText: 'Lastname Firstname',
                              )
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: emergencyContactNoController,
                              decoration: const InputDecoration(
                                labelText: 'Emergency Contact Number',
                                border: OutlineInputBorder(),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                hintText: '+63',
                              ),
                              keyboardType: TextInputType.phone
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                CheckboxListTile(
                                  enabled: false,
                                  title: const Text("Government ID"),
                                  value: governmentId,
                                  onChanged: (value) {
                                    setState(() {
                                      governmentId = value ?? false;
                                    });
                                  },
                                  controlAffinity: ListTileControlAffinity.leading
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Text(
                                    "Your Government ID is required as a means to protect cooperatives from fraud and to ensure the safety of all guests.",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey
                                    )
                                  )
                                )
                              ]
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text('Proceed'),
                              )
                            )
                          ],
                        )
                      )
                    )
                  );
                });
              });
        });
  }
}
