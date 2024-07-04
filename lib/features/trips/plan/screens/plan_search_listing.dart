import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/providers/days_provider.dart';
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/trips/plan/components/entertainment_card.dart';
import 'package:lakbay/features/trips/plan/components/food_card.dart';
import 'package:lakbay/features/trips/plan/components/room_card.dart';
import 'package:lakbay/features/trips/plan/components/transport_card.dart';
import 'package:lakbay/features/trips/plan/components/trip_card.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/plan_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class PlanSearchListing extends ConsumerStatefulWidget {
  final String category;
  final List<ListingBookings>? bookings;
  final List<ListingModel>? listings;
  const PlanSearchListing(
      {super.key, required this.category, this.bookings, this.listings});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PlanSearchListingState();
}

// Enum for sorting
enum SortBy {
  highestPrice,
  lowestPrice,
  rating,
  distance,
}

class _PlanSearchListingState extends ConsumerState<PlanSearchListing> {
  late String selectedCategory;
  SortBy sortBy = SortBy.lowestPrice;
  Map<String, dynamic> filters = {
    'Transport': false,
    'Accommodation': false,
    'Food': false,
    'Tours': false,
    'Entertainment': false,
  };
  dynamic listingResults = [];

  @override
  void initState() {
    super.initState();
    selectedCategory = capitalize(widget.category);
    // String capitalizedCategory = capitalize(widget.category);
    // if (filters.containsKey(selectedCate)) {
    //   filters[capitalizedCategory] = true;
    // } else {
    //   // Make all true
    //   filters.updateAll((key, value) => true);
    // }
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  void onTapLocation() {
    context.push('/select_location', extra: 'search_plan');
  }

  void updateSortOrder(SortBy newSortBy) {
    setState(() {
      sortBy = newSortBy;
    });
  }

  void updateFilterOptions(String category, bool isSelected) {
    setState(() {
      filters[category] = isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final planLocation = ref.watch(planLocationProvider);
    // final planStartDate = ref.watch(planStartDateProvider);
    final planEndDate = ref.watch(planEndDateProvider);
    final daysPlan = ref.read(daysPlanProvider);
    final formattedCurrentDate =
        DateFormat('EEE, MMM dd').format(daysPlan.currentDay!);
    final planSearch = ref.watch(planSearchLocationProvider);
    Future.delayed(Duration.zero, () {
      if (ref.watch(parentStateProvider) == true) {
        context.pop();
        context.pop();
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            ref.read(planSearchLocationProvider.notifier).reset();
            context.pop();
            context.pop();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    planLocation ?? 'Location',
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.category == 'Accommodation')
                  Text(
                    daysPlan.currentDay == null || planEndDate == null
                        ? 'Select a date'
                        : '${DateFormat('EEE, MMM dd').format(daysPlan.currentDay!)} - ${DateFormat('EEE, MMM dd').format(planEndDate)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                if (widget.category == "Transport" ||
                    widget.category == "Food" ||
                    widget.category == "Entertainment")
                  Text(
                    formattedCurrentDate,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
            InkWell(
              child: const Icon(Icons.search_rounded),
              onTap: () {
                onTapLocation();
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
          child: widget.listings!.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'lib/core/images/SleepingCatFromGlitch.svg',
                                height: 100, // Adjust height as desired
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'No listings found',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Create a wiki at the button below',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const Text(
                                'to share your knowledge',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                              spacing: 8.0,
                              children: [
                                // if the planSearch is not null, show the ActionChip. Otherwise, show the Text widget
                                if (planSearch != null)
                                  ActionChip(
                                    onPressed: () {
                                      // Filter
                                      showLocationAlertDialog(
                                          context, planSearch);
                                    },
                                    label: SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          7.5,
                                      child: Text(
                                        planSearch,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    avatar:
                                        const Icon(Icons.location_on_outlined),
                                  ),
                                ActionChip(
                                  onPressed: () {
                                    // Filter
                                    showFilterBottomSheet(context);
                                  },
                                  label: Text(selectedCategory),
                                  avatar: const Icon(Icons.filter_alt_outlined),
                                ),
                                ActionChip(
                                  onPressed: () {
                                    // Sort
                                    showSortBottomSheet(context);
                                  },
                                  label: const Text('Sort'),
                                  avatar: const Icon(Icons.sort),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          listingCardController(selectedCategory, planSearch),
                    ),
                  ],
                )),
    );
  }

  Future<dynamic> showSortBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Close button
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sort',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // Transparent Divider
                      // const Divider(
                      //   color: Colors.transparent,
                      // ),

                      // List of radio tiles of each category

                      RadioListTile(
                        value: SortBy.lowestPrice,
                        groupValue: sortBy,
                        onChanged: (value) {
                          setState(() {
                            updateSortOrder(value as SortBy);
                            context.pop();
                          });
                        },
                        title: const Text('Lowest Price'),
                      ),

                      RadioListTile(
                        value: SortBy.highestPrice,
                        groupValue: sortBy,
                        onChanged: (value) {
                          setState(() {
                            updateSortOrder(value as SortBy);
                            context.pop();
                          });
                        },
                        title: const Text('Highest Price'),
                      ),

                      RadioListTile(
                        value: SortBy.rating,
                        groupValue: sortBy,
                        onChanged: (value) {
                          setState(() {
                            sortBy = value as SortBy;
                          });
                        },
                        title: const Text('Rating'),
                      ),

                      RadioListTile(
                        value: SortBy.distance,
                        groupValue: sortBy,
                        onChanged: (value) {
                          setState(() {
                            sortBy = value as SortBy;
                          });
                        },
                        title: const Text('Distance'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  // show the location along with a map widget
  Future<dynamic> showLocationAlertDialog(
      BuildContext context, String planSearch) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          //adjust the height and width of the dialog
          title: Text(
            'Location: $planSearch',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width * 0.8,
            child: MapWidget(address: planSearch),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final bool confirm = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Confirm',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            content: Text(
                              'Are you sure you want to remove the location?',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  context.pop(false);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.pop(true);
                                },
                                child: const Text('Confirm'),
                              ),
                            ],
                          );
                        }) ??
                    false;

                if (confirm) {
                  ref.read(planSearchLocationProvider.notifier).reset();
                  // ignore: use_build_context_synchronously
                  context.pop();
                }
              },
              child: const Text('Remove Filter'),
            ),
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showFilterBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) => SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Close button
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Select Category',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            // Transparent Divider
                            const Divider(
                              color: Colors.transparent,
                            ),

                            // Filter by category
                            const Text(
                              'Category',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(),

                            // List of checkbox tiles of each category
                            // List of checkbox tiles of each category
                            ...filters.keys.map((category) {
                              return InkWell(
                                onTap: () {
                                  this.setState(() {
                                    selectedCategory = category;
                                    context.pop();
                                  });
                                },
                                child: SizedBox(
                                    height:
                                        MediaQuery.sizeOf(context).height / 10,
                                    child: Text(
                                      category,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400),
                                    )),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ));
        });
  }

  Widget listingCardController(String category, String? planSearch) {
    if (planSearch != null) {
      // Filter the listings based on the search
      listingResults = widget.listings!
          .where((listing) => listing.address.contains(planSearch))
          .toList();
    } else {
      listingResults = widget.listings;
    }

    switch (category) {
      // if planSearch is not null, show the listings based on the search

      case "Accommodation":
        return RoomCard(
          category: category,
          bookings: widget.bookings!,
          accommodationListings: planSearch != null ? listingResults : null,
          allListings: widget.listings,
        );

      case "Transport":
        return TransportCard(
            category: category, transportListings: listingResults);

      case "Food":
        return FoodCard(category: category, foodListings: listingResults);

      case "Tour":
        return TripCard(category: category, tripListings: widget.listings!);

      case "Entertainment":
        return EntertainmentCard(
            category: category, entertainmentListings: widget.listings!);

      default:
        return const Text("An Error Occurred!");
    }
  }
}
