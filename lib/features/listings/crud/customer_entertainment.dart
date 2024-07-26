// ignore_for_file: unused_local_variable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/providers/days_provider.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/common/widgets/text_in_bottomsheet.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/listings/crud/customer_transport_checkout.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/user_model.dart';

class CustomerEntertainment extends ConsumerStatefulWidget {
  final ListingModel listing;
  const CustomerEntertainment({super.key, required this.listing});

  @override
  ConsumerState<CustomerEntertainment> createState() =>
      _CustomerEntertainmentState();
}

class _CustomerEntertainmentState extends ConsumerState<CustomerEntertainment> {
  List<SizedBox> tabs = [
    const SizedBox(width: 100, child: Tab(child: Text('Details'))),
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
    final daysPlan = ref.read(daysPlanProvider);
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
              appBar: AppBar(
                title: widget.listing.title.length > 20
                    ? Text('${widget.listing.title.substring(0, 20)}...',
                        style: const TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold))
                    : Text(widget.listing.title,
                        style: const TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold)),
                bottom: TabBar(
                  tabAlignment: TabAlignment.center,
                  labelPadding: EdgeInsets.zero,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: tabs,
                ),
              ),
              body: TabBarView(children: [
                details(),
              ]),
              // create a bottom navigation bar for the customer
              // so that they may be able to book the transport
            )));
  }

  SingleChildScrollView details() {
    final List<String?> imageUrls =
        widget.listing.images!.map((listingImage) => listingImage.url).toList();
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ImageSlider(
          images: imageUrls,
          height: MediaQuery.sizeOf(context).height / 2,
          width: double.infinity,
          radius: BorderRadius.circular(0)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Align elements to the top by default
                children: [],
              ),
            ),
            _displaySubHeader("Description"),
            TextInBottomSheet(
                widget.listing.title, widget.listing.description, context),
            _displaySubHeader('Getting There'),
            // Getting There Address
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height / 5,
                child: MapWidget(
                  address: widget.listing.address,
                  radius: true,
                ),
              ),
            ),
            if (widget.listing.entertainmentScheduling!.type == "dayScheduling")
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _displaySubHeader("Operating Days"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: getWorkingDays(widget
                          .listing.entertainmentScheduling!.availability!),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
      ref
          .watch(
              getCooperativeProvider(widget.listing.cooperative.cooperativeId))
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
                    // createRoom(context, widget.listing.publisherId);
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
      const SizedBox(height: 5),
    ]));
  }

  Widget getWorkingDays(List<AvailableDay> workingDays) {
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
      if (workingDays[i].available == true) {
        result.add(daysOfWeek[i]);
      }
    }
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: result.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 120,
      ),
      itemBuilder: (context, index) {
        String day = result[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 3,
                    ),
                    itemCount: widget.listing.entertainmentScheduling!
                        .availability![index].availableTimes.length,
                    itemBuilder: (context, timeIndex) {
                      var time = widget.listing.entertainmentScheduling!
                          .availability![index].availableTimes[timeIndex];
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          time.time.format(context),
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
