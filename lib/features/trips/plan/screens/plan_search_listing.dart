import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/trips/plan/components/room_card.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class PlanSearchListing extends ConsumerStatefulWidget {
  final String category;
  final List<ListingBookings> bookings;
  const PlanSearchListing(
      {super.key, required this.category, required this.bookings});

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
    context.push('/plan/location');
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
    final planStartDate = ref.watch(planStartDateProvider);
    final planEndDate = ref.watch(planEndDateProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
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
                Text(planLocation ?? 'Location',
                    style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  planStartDate == null || planEndDate == null
                      ? 'Select a date'
                      : '${DateFormat.yMMMMd().format(planStartDate)} - ${DateFormat.yMMMMd().format(planEndDate)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            InkWell(
              child: const Icon(Icons.map_outlined),
              onTap: () {
                onTapLocation();
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
            listingCardController(selectedCategory),
            // ref.watch(getAllListingsProvider).when(
            //       data: (listings) {
            //         // Sort
            //         switch (sortBy) {
            //           case SortBy.lowestPrice:
            //             listings.sort((a, b) => a.price!.compareTo(b.price!));
            //             break;
            //           case SortBy.highestPrice:
            //             listings.sort((a, b) => b.price!.compareTo(a.price!));
            //             break;
            //           case SortBy.rating:
            //             break;
            //           case SortBy.distance:
            //             break;
            //         }

            //         // Filter
            //         final filteredListings = listings.where((listing) {
            //           return filters[listing.category] == true;
            //         }).toList();

            //         return Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: ListView.separated(
            //             separatorBuilder: (context, index) => const SizedBox(
            //               height: 12.0,
            //             ),
            //             physics: const NeverScrollableScrollPhysics(),
            //             shrinkWrap: true,
            //             itemCount: filteredListings.length,
            //             itemBuilder: (context, index) {
            //               final listing = filteredListings[index];
            //               return listingCardController(listing);
            //             },
            //           ),
            //         );
            //       },
            //       error: (error, stackTrace) => ErrorText(
            //           error: error.toString(),
            //           stackTrace: stackTrace.toString()),
            //       loading: () => const Loader(),
            //     ),
          ],
        ),
      ),
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
                                  'Filter',
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
                              return CheckboxListTile(
                                value: filters[category],
                                onChanged: (value) {
                                  setState(() {
                                    filters[category] = value!;
                                    updateFilterOptions(category, value);
                                  });
                                },
                                title: Text(category),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ));
        });
  }

  Widget listingCardController(String category) {
    switch (category) {
      case "Accommodation":
        return RoomCard(category: category, bookings: widget.bookings);

      case "Transport":
        return const Text("works");

      case "Food":
        return const Text("works");

      case "Tour":
        return const Text("works");

      case "Entertainment":
        return const Text("works");

      default:
        return const Text("An Error Occurred!");
    }
  }
}
