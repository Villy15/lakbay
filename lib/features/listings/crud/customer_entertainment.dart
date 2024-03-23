import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/models/listing_model.dart';

class CustomerEntertainment extends ConsumerStatefulWidget {
  final ListingModel listing;
  const CustomerEntertainment({super.key, required this.listing});

  @override
  ConsumerState<CustomerEntertainment> createState() =>
      _CustomerEntertainmentState();
}

class _CustomerEntertainmentState extends ConsumerState<CustomerEntertainment> {
  int numberOfPersons = 1;

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
        Navigator.of(context).pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(navBarVisibilityProvider.notifier).show();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              // Title
              Padding(
                padding: const EdgeInsets.only(top: 14.0, left: 12.0),
                child: DisplayText(
                  text: widget.listing.title,
                  lines: 2,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              // Location
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 12.0),
                child: DisplayText(
                  text:
                      "Location: ${widget.listing.province}, ${widget.listing.city}",
                  lines: 4,
                  style: const TextStyle(
                      fontSize: 16),
                ),
              ),

              // No. of guests
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 12.0),
                child: DisplayText(
                  text:
                      "Number of guests per booking: ${widget.listing.pax ?? 1}",
                  lines: 1,
                  style: const TextStyle(
                      fontSize: 16),
                ),
              ),

              const Divider(),

              Padding(
                padding: const EdgeInsets.only(top: 5, left: 12.0),
                child: DisplayText(
                  text: 'Description',
                  lines: 1,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 5, left: 12.0),
                child: DisplayText(
                  text: widget.listing.description,
                  lines: 4,
                  style: const TextStyle(
                       fontSize: 16),
                ),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          surfaceTintColor: Colors.white,
          height: 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rental Fee',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: [
                            Text("₱${widget.listing.price.toString()}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton(
                  style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all<Size>(const Size(180, 45)),
                  ),
                  onPressed: () {
                    // Define opening and closing hours
                    final int openingHour = widget.listing.openingHours!.hour;
                    final int closingHour = widget.listing.closingHours!.hour;
                    final int intervalDurationInMinutes =
                        widget.listing.duration!.hour.toInt();

List<Widget> availableTimes = [];
for (int hour = openingHour; hour < closingHour; hour++) {
  for (int minute = 0; minute < 60; minute += intervalDurationInMinutes) {
    String time = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    availableTimes.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // Center the buttons horizontally
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // Calculate total price
                  num totalPrice = numberOfPersons * widget.listing.price!.toInt();

                  return AlertDialog(
                    title: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.arrow_back),
                            ),
                            const SizedBox(width: 8), // Add space between back button and title
                            const Text(
                              "Number of Persons",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          "Selected Time: $time",
                          style: const TextStyle(fontSize: 14),
                        ), // Display the selected time
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (numberOfPersons > 1) {
                                    numberOfPersons--;
                                  }
                                });
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            Text(
                              numberOfPersons.toString(),
                              style: const TextStyle(fontSize: 20),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  numberOfPersons++;
                                });
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                        const SizedBox(width: 550, height: 127,),
                        const Divider(),
                        Text(
                          'Total Price: ₱$totalPrice', // Display total price
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    actions: [
  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 250,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white, // Border color
            width: 5.0, // Border width
            
          ),
          borderRadius: BorderRadius.circular(30.0), // Border radius
        ),
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: const Text(
            "Confirm",
            style: TextStyle(color: Colors.green), // Text color
          ),
        ),
      ),
    ],
  ),
],

                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(100, 36), // Adjust the width and height as needed
            ),
            child: Text(time),
          ),
          const SizedBox(width: 50), // Add space between button and text
          Text(
            'Slots : ${widget.listing.numberOfUnits}',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}



                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Available times"),
                          content: SizedBox(
                            width: 550, // Adjust the width as needed
                            height: 200, // Adjust the height as needed
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: availableTimes,
                              ),
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(
                              25.0), // Adjust the padding as needed
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Close"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Add to trip'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
