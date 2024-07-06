import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/providers/days_provider.dart';
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
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
  late List<ListingBookings> filterCategoryBookings;
  late List<ListingModel> filterCategoryListings;


  bool showLocationField = false;
  final filterSearch = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<ListingModel> searchFilterResult = [];
  String finalFilteredSearch = '';

  @override
  void initState() {
    super.initState();
    selectedCategory = capitalize(widget.category);
    filterSearch.addListener(() {
      debugPrint('filter search text: ${filterSearch.text}');
      finalFilteredSearch = filterSearch.text;
      debugPrint("final search: $finalFilteredSearch");
      debugPrint('calling listing controller!');
      listingCardController(selectedCategory, finalFilteredSearch);
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {});
      });
    });

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        FocusScope.of(context).unfocus();
        debugPrint('unfocused!');

        if (filterSearch.text.isNotEmpty) {
          finalFilteredSearch = filterSearch.text;
          debugPrint('this is the final filtered search: $finalFilteredSearch');
          listingCardController(selectedCategory, finalFilteredSearch);
        }
      }
    });
    // String capitalizedCategory = capitalize(widget.category);
    // if (filters.containsKey(selectedCate)) {
    //   filters[capitalizedCategory] = true;
    // } else {
    //   // Make all true
    //   filters.updateAll((key, value) => true);
    // }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    filterSearch.dispose();
    super.dispose();
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
    final planEndDate = ref.watch(planEndDateProvider);
    final daysPlan = ref.read(daysPlanProvider);
    final formattedCurrentDate =
        DateFormat('EEE, MMM dd').format(daysPlan.currentDay!);
    // final planSearch = ref.watch(planSearchLocationProvider);
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
                toggleLocationFieldVisibility();
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
                    Visibility(
                      visible: showLocationField,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                            focusNode: _focusNode,
                            controller: filterSearch,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) {
                              debugPrint(
                                  'Enter pressed with search text: $value');
                              listingCardController(selectedCategory, value);
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              hintText: 'Search Location',
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(right: 20, top: 5.5),
                                child: Icon(
                                  Icons.search,
                                  size: 18,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: const Padding(
                                  padding: EdgeInsets.only(top: 5.5),
                                  child: Icon(Icons.close, size: 20),
                                ),
                                onPressed: () {
                                  setState(() {
                                    filterSearch.clear();
                                    showLocationField = false;
                                    finalFilteredSearch = '';
                                  });
                                  debugPrint(
                                      'I press to close the filter search!');
                                  listingCardController(
                                      selectedCategory, finalFilteredSearch);
                                },
                              ),
                            )),
                      ),
                    ),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      // if the actionchip is triggered, the listingCardFilterByCategory will be called
                      // else, the listingCardController will be called

                      child: selectedCategory != widget.category
                        ? listingCardFilterByCategory(
                          selectedCategory,
                          filterCategoryBookings,
                          filterCategoryListings,
                          finalFilteredSearch,
                          )
                        : listingCardController(selectedCategory, finalFilteredSearch)

                      // child: listingCardController(
                      //     selectedCategory, finalFilteredSearch),
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

  void toggleLocationFieldVisibility() {
    setState(() {
      showLocationField = !showLocationField;
    });
    if (showLocationField) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNode);
      });
    }
  }

  Future<dynamic> showFilterBottomSheet(BuildContext context) {
    final planStartDate = ref.watch(planStartDateProvider);
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
                                onTap: () async {
                                  final today = Timestamp.fromDate(planStartDate!);
                                  final filterCategoryFuture = await ref.read(getAllListingsProvider.future);
                                  final filterCategory = filterCategoryFuture;
                                  // print the data of the filterCategoryListings
                                  debugPrint('This is all the listings: $filterCategory');
                                  final query = FirebaseFirestore.instance
                                    .collectionGroup(
                                        'bookings'); // Perform collection group query for 'bookings'
                                    final bookings = await ref
                                        .watch(getBookingsByPropertiesProvider((query)).future);

                                    debugPrint('this is bookings: $bookings');
                                    
                                    filterCategoryBookings = bookings;
                                    debugPrint('this is the filterCategoryBookings: $filterCategoryBookings');
                                  
                                  // final filterBookings = await ref.watch(getAllBookingsProvider);
                                  this.setState(()  {
                                    selectedCategory = category;
                                    // use the filterCategory then assign it to filterCategoryListings. use the selectedCategory to filter the listings
                                    filterCategoryListings = filterCategory.where((element) => element.category == selectedCategory).toList();

                                    debugPrint('this is the filterCategoryListings: $filterCategoryListings');
                                    

                                    // selectedCategory = category;
                                    // // do a ref.read to get the filtered listings by category
                                    // ref.read(getAllListingsByCategoryProvider(category)).whenData((value) {
                                    //   filterCategoryListings = value;
                                    // });

                                    // final query = FirebaseFirestore.instance
                                    // .collectionGroup(
                                    //     'bookings') // Perform collection group query for 'bookings'
                                    // .where('category', isEqualTo: selectedCategory)
                                    // .where('bookingStatus', isEqualTo: "Reserved")
                                    // .where('startDate', isGreaterThan: today);
                                    // final bookings = await ref
                                    //     .watch(getBookingsByPropertiesProvider((query)).future);

                                    // filterCategoryBookings = bookings;


                                    // listingCardFilterByCategory(category, filterCategoryBookings, filterCategoryListings, null);
                                    // ignore: use_build_context_synchronously
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

  Widget listingCardFilterByCategory(String category, List<ListingBookings> listingBookings, List<ListingModel> listingModel, String? searchFilter) {
    switch(category) {
      case "Accommodation":
        return RoomCard(
          category: category,
          bookings: listingBookings,
          accommodationListings: searchFilter != null ? listingModel.where((element) => element.address.contains(searchFilter)).toList() : null,
          allListings: listingModel,
        );

      case "Transport":
        return TransportCard(
            category: category, transportListings: listingModel);

      case "Food":
        return FoodCard(category: category, foodListings: listingModel);

      case "Tour":
        debugPrint('ganorn talaga!');
        return TripCard(category: category, tripListings: listingModel);

      case "Entertainment":
        debugPrint('wowie!');
        return EntertainmentCard(
            category: category, entertainmentListings: listingModel);

      default:
        return const Text("An Error Occurred!");
    }
  }
  // remove excess spaces from the search filter
  String removeExcessSpaces(String searchFilter) {
    return searchFilter.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  Widget listingCardController(String category, String? searchFilter) {
    debugPrint('I am the category: $category');
    debugPrint('this is bookings: ${widget.bookings}');
    debugPrint('this is the search filter wawawawa: $searchFilter');
    debugPrint('this is the listings: ${widget.listings}');
    if (searchFilter != null) {
      // Filter the listings based on the search
      final removeSpaceFilterSearch = removeExcessSpaces(searchFilter);
      listingResults = widget.listings!
          .where((listing) => listing.address.toLowerCase().contains(removeSpaceFilterSearch.toLowerCase()))
          .toList();
    } else {
      listingResults = widget.listings;
    }

    if (searchFilter != null && category == 'Transport') {
      final removeSpaceFilterSearch = removeExcessSpaces(searchFilter);
      listingResults = widget.listings!
          .where((listing) =>
              listing.pickUp!.toLowerCase().contains(removeSpaceFilterSearch.toLowerCase()) ||
              listing.destination!.toLowerCase().contains(removeSpaceFilterSearch.toLowerCase()))
          .toList();
    }

    debugPrint(
        'this is the length of listingResults: ${listingResults.length}');

    switch (category) {
      case "Accommodation":
        return RoomCard(
          category: category,
          bookings: widget.bookings!,
          accommodationListings: searchFilter != null ? listingResults : null,
          allListings: widget.listings,
        );

      case "Transport":
        return TransportCard(
            category: category, transportListings: listingResults);

      case "Food":
        return FoodCard(category: category, foodListings: listingResults);

      case "Tour":
        debugPrint('ganorn talaga!');
        return TripCard(category: category, tripListings: widget.listings!);

      case "Entertainment":
        debugPrint('wowie!');
        return EntertainmentCard(
            category: category, entertainmentListings: widget.listings!);

      default:
        return const Text("An Error Occurred!");
    }
  }
}
