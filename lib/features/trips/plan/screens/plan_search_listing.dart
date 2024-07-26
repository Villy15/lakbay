import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/providers/days_provider.dart';
import 'package:lakbay/core/util/accommodation_utils.dart';
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/trips/plan/components/entertainment_card.dart';
import 'package:lakbay/features/trips/plan/components/food_card.dart';
import 'package:lakbay/features/trips/plan/components/room_card.dart';
import 'package:lakbay/features/trips/plan/components/transport_card.dart';
import 'package:lakbay/features/trips/plan/components/trip_card.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:collection/collection.dart';

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
    'Entertainment': false,
  };
  dynamic listingResults = [];
  late List<ListingBookings> filterCategoryBookings;
  late List<ListingModel> filterCategoryListings;


  bool showLocationField = false;
  final filterSearch = TextEditingController();
  final filterSearchCategory = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNodeCategory = FocusNode();
  List<ListingModel> searchFilterResult = [];
  String finalFilteredSearch = '';
  String finalFilteredSearchCategory = '';
  bool isCategorySearch = false;

  @override
  void initState() {
    super.initState();
    selectedCategory = capitalize(widget.category);
    filterSearch.addListener(() {
      debugPrint('filter search text: ${filterSearch.text}');
      finalFilteredSearch = filterSearch.text;
      debugPrint("final search: $finalFilteredSearch");
      debugPrint('calling listing controller!');
      debugPrint('this is the selected category at the moment: $selectedCategory');

      if (selectedCategory == widget.category) {
        listingCardController(selectedCategory, finalFilteredSearch);
      }
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {});
      });
    });

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        FocusScope.of(context).unfocus();
        debugPrint('unfocused!');

        if (filterSearch.text.isNotEmpty) {
          // debugPrint('this is the selected category at the moment: $selectedCategory');
          finalFilteredSearch = filterSearch.text;
          // debugPrint('this is the final filtered search: $finalFilteredSearch');
          if (selectedCategory == widget.category) {
            listingCardController(selectedCategory, finalFilteredSearch);
          }
        }
      }
    });

    // add a listener to filterSearchCategory
    filterSearchCategory.addListener(() {
      debugPrint('filter search text category: ${filterSearchCategory.text}');
      finalFilteredSearchCategory = filterSearchCategory.text;
      debugPrint("final search: $finalFilteredSearchCategory");
      debugPrint('calling listing controller!');
      debugPrint('this is the selected category at the moment: $selectedCategory');

      if (selectedCategory != widget.category) {
        debugPrint('awts');
        listingCardFilterByCategory(selectedCategory, filterCategoryBookings, filterCategoryListings, finalFilteredSearchCategory);
      }
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {});
      });
    });

    // add a listener to _focusNodeCategory
    _focusNodeCategory.addListener(() {
      if (!_focusNodeCategory.hasFocus) {
        FocusScope.of(context).unfocus();
        debugPrint('unfocused!');

        if (filterSearchCategory.text.isNotEmpty) {
          // debugPrint('this is the selected category at the moment: $selectedCategory');
          finalFilteredSearchCategory = filterSearchCategory.text;
          // debugPrint('this is the final filtered search: $finalFilteredSearch');
          if (selectedCategory != widget.category) {
            listingCardFilterByCategory(selectedCategory, filterCategoryBookings, filterCategoryListings, finalFilteredSearchCategory);
          }
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
                        child: 
                        // if the selected category is not the same as the widget category, show the filterSearchCategory
                        // else, show the filterSearch
                        selectedCategory != widget.category
                        ? TextField(
                            focusNode: _focusNodeCategory,
                            controller: filterSearchCategory,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) {
                              listingCardFilterByCategory(selectedCategory, filterCategoryBookings, filterCategoryListings, value);
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
                                    filterSearchCategory.clear();
                                    showLocationField = false;
                                    finalFilteredSearchCategory = '';
                                  });

                                  listingCardFilterByCategory(
                                      selectedCategory, filterCategoryBookings, filterCategoryListings, finalFilteredSearchCategory);
                                },
                              ),
                            ))
                            :
                        TextField(
                            focusNode: _focusNode,
                            controller: filterSearch,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) {
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
                          finalFilteredSearchCategory,
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
        // if isCategorySearch is true, focus on the filterSearchCategory
        // else, focus on the filterSearch
        isCategorySearch ? FocusScope.of(context).requestFocus(_focusNodeCategory) : FocusScope.of(context).requestFocus(_focusNode);
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
                                  final filterCategoryFuture = await ref.read(getAllListingsProvider.future);
                                  final filterCategory = filterCategoryFuture;
                                  // print the data of the filterCategoryListings
                                  final query = FirebaseFirestore.instance
                                    .collectionGroup(
                                        'bookings'); // Perform collection group query for 'bookings'
                                    final bookings = await ref
                                        .watch(getBookingsByPropertiesProvider((query)).future);

                                   
                                    
                                    filterCategoryBookings = bookings;
                                  
                                  // final filterBookings = await ref.watch(getAllBookingsProvider);
                                  this.setState(()  {
                                    selectedCategory = category;
                                    // use the filterCategory then assign it to filterCategoryListings. use the selectedCategory to filter the listings
                                    filterCategoryListings = filterCategory.where((element) => element.category == selectedCategory).toList();
                                    
                                    isCategorySearch = true;
                                    debugPrint('this is filterCategoryListings: $filterCategoryListings');
                                    // listingCardFilterByCategory(selectedCategory, filterCategoryBookings, filterCategoryListings, finalFilteredSearchCategory);
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
    final daysPlan = ref.read(daysPlanProvider);
    int dayIndex = daysPlan.currentDay!.weekday - 1;

    debugPrint('this is working at the moment!');
    debugPrint('this is the category: $category');
    List<ListingModel> listingResults = [];
    if (searchFilter != null) {
      // Filter the listings based on the search
      final removeSpaceFilterSearch = cleanAndNormalizeSearchFilter(searchFilter);
      listingResults = listingModel.where((element) => element.address.contains(removeSpaceFilterSearch.toLowerCase())).toList();
      debugPrint('I am working!');
    } else {
      listingResults = listingModel;
      debugPrint('I did not work');
    }

    if (searchFilter != null && category == 'Transport') {
      debugPrint('im there');
      final removeSpaceFilterSearch = cleanAndNormalizeSearchFilter(searchFilter);
      listingResults = listingModel
          .where((listing) {
            debugPrint('checking listing! this is the day index: $dayIndex');
            // check all transport listing's available days
            if (listing.availableTransport?.workingDays?[dayIndex] == true) {
              debugPrint('current transport: ${listing.availableTransport?.workingDays?[dayIndex]}');
              return listing.pickUp!.toLowerCase().contains(removeSpaceFilterSearch.toLowerCase()) ||
              listing.destination!.toLowerCase().contains(removeSpaceFilterSearch.toLowerCase());
            }
            // listing.pickUp!.toLowerCase().contains(removeSpaceFilterSearch.toLowerCase()) ||
            // listing.destination!.toLowerCase().contains(removeSpaceFilterSearch.toLowerCase())

            return false;
          }
              
          ).toList();
    }

    if (searchFilter != null && category == 'Entertainment') {
      debugPrint('i am in entertainment');
      final removeSpaceFilterSearch = cleanAndNormalizeSearchFilter(searchFilter);
      debugPrint('this is the remove space filter search: $removeSpaceFilterSearch');

      listingResults = listingModel
        .where((listing) {
          debugPrint('this is listing for entertainment: $listing');
          // listing.entertainmentScheduling
          // for fixed dates, check the current date and its corresponding fixed date if it is available
          bool fixedEntDate = listing.entertainmentScheduling?.fixedDates?.any((fixedDate) {
            debugPrint('this is the fixed date: $fixedDate');
            return fixedDate.date == daysPlan.currentDay && fixedDate.available == true && listing.address.toLowerCase().contains(removeSpaceFilterSearch.toLowerCase());
          }) ?? false;

          // check through listing.entertainmentScheduling.availability[dayindex] to see what's available (if value is true)
          bool availableEntDate = listing.entertainmentScheduling?.availability?[dayIndex].available == true && listing.address.toLowerCase().contains(removeSpaceFilterSearch.toLowerCase());

          return fixedEntDate || availableEntDate;
        }).toList(); // Assuming you want to collect the results into a List// Assuming you want to collect the results into a List
    }

    if (searchFilter != null && category == 'Food') {
      final removeSpaceFilterSearch = cleanAndNormalizeSearchFilter(searchFilter);
      // Use daysPlan.currentDay since the current day is found on FoodService
      listingResults = listingModel
          .where((listing) {
            debugPrint('this is listing: $listing');
            // Get the first availableDeal where workingDays[dayIndex] is true, if any
            var firstMatchingDeal = listing.availableDeals?.firstWhereOrNull((foodListing) {
              return foodListing.workingDays[dayIndex] == true;
            });
            debugPrint('this is the first matching deal: $firstMatchingDeal');
            // If a matching deal is found, print its workingDays for debugging
            if (firstMatchingDeal != null) {
              debugPrint('this is proof that im available today: ${firstMatchingDeal.workingDays}');
              return listing.address.toLowerCase().contains(removeSpaceFilterSearch.toLowerCase());
            }
            return false;
          }).toList();
    }

    switch(category) {
      case "Accommodation":
        return RoomCard(
          category: category,
          bookings: listingBookings,
          accommodationListings: searchFilter != null ? listingResults.where((element) => element.address.contains(searchFilter.toLowerCase())).toList() : null,
          allListings: listingResults,
        );

      case "Transport":
        return TransportCard(
            category: category, transportListings: listingResults);

      case "Food":
        return FoodCard(category: category, foodListings: listingResults);

      case "Entertainment":
        return EntertainmentCard(
            category: category, entertainmentListings: listingResults);

      default:
        return const Text("An Error Occurred!");
    }
  }
  // remove excess spaces from the search filter
  String cleanAndNormalizeSearchFilter(String searchFilter) {
    // Remove excess spaces
    String cleanedFilter = searchFilter.trim().replaceAll(RegExp(r'\s+'), ' ');
    // 
    return cleanedFilter;
  }

  Widget listingCardController(String category, String? searchFilter) {
    final daysPlan = ref.read(daysPlanProvider);
    List<String> unavailableRoomUids  = [];

    isCategorySearch = false;
    debugPrint('this is isCategorySearch: $isCategorySearch');

    // Assuming daysPlan.currentDay is a DateTime object
    int dayIndex = daysPlan.currentDay!.weekday - 1;
    final startDate = ref.read(planStartDateProvider);
    final endDate = ref.read(planEndDateProvider);


    if (searchFilter != null && category == 'Accommodation') {
      // Filter the listings based on the search
      final removeSpaceFilterSearch = cleanAndNormalizeSearchFilter(searchFilter);

      listingResults = widget.listings!
          .where((listing) => listing.address.toLowerCase().contains(removeSpaceFilterSearch.toLowerCase()))
          .toList();
      // debugPrint('this is the new listing results with search filter on: $listingResults, search filter: $searchFilter');

      unavailableRoomUids = getUnavailableRoomUids(
          widget.bookings!, startDate!, endDate!, listingResults);

        debugPrint('plan search listing. this is the unavailable room uids: $listingResults');

    } 

    if (searchFilter != null && category == 'Transport') {
      final removeSpaceFilterSearch = cleanAndNormalizeSearchFilter(searchFilter);
      listingResults = widget.listings!
          .where((listing) {
            // check all transport listing's available days
            if (listing.availableTransport?.workingDays?[dayIndex] == true) {
              return listing.pickUp!.toLowerCase().contains(removeSpaceFilterSearch.toLowerCase()) ||
              listing.destination!.toLowerCase().contains(removeSpaceFilterSearch.toLowerCase());
            }
            // listing.pickUp!.toLowerCase().contains(removeSpaceFilterSearch.toLowerCase()) ||
            // listing.destination!.toLowerCase().contains(removeSpaceFilterSearch.toLowerCase())

            return false;
          }
              
          ).toList();
    }

    if (searchFilter != null && category == 'Food') {
      final removeSpaceFilterSearch = cleanAndNormalizeSearchFilter(searchFilter);
      // Use daysPlan.currentDay since the current day is found on FoodService
      listingResults = widget.listings!
          .where((listing) {
            // Get the first availableDeal where workingDays[dayIndex] is true, if any
            var firstMatchingDeal = listing.availableDeals?.firstWhereOrNull((foodListing) {
              return foodListing.workingDays[dayIndex] == true;
            });
            // If a matching deal is found, print its workingDays for debugging
            if (firstMatchingDeal != null) {
              debugPrint('this is proof that im available today: ${firstMatchingDeal.workingDays}');
              return listing.address.toLowerCase().contains(removeSpaceFilterSearch.toLowerCase());
            }
            return false;
          }).toList();
    }

    if (searchFilter != null && category == 'Entertainment') {
      final removeSpaceFilterSearch = cleanAndNormalizeSearchFilter(searchFilter);

      listingResults = widget.listings!
        .where((listing) {
          // listing.entertainmentScheduling
          // for fixed dates, check the current date and its corresponding fixed date if it is available
          bool fixedEntDate = listing.entertainmentScheduling?.fixedDates?.any((fixedDate) {
            return fixedDate.date == daysPlan.currentDay && fixedDate.available == true && listing.address.toLowerCase().contains(removeSpaceFilterSearch.toLowerCase());
          }) ?? false;

          // check through listing.entertainmentScheduling.availability[dayindex] to see what's available (if value is true)
          bool availableEntDate = listing.entertainmentScheduling?.availability?[dayIndex].available == true && listing.address.toLowerCase().contains(removeSpaceFilterSearch.toLowerCase());

          return fixedEntDate || availableEntDate;
        }).toList(); // Assuming you want to collect the results into a List// Assuming you want to collect the results into a List
    }

    switch (category) {
      case"Accommodation":
        return RoomCard(
          category: category,
          bookings: widget.bookings!,
          accommodationListings: searchFilter != null ? listingResults : null,
          allListings: widget.listings,
          // if availableRooms is empty, set it to null
          unavailableRoomUids: unavailableRoomUids
        );

      case "Transport":
        return TransportCard(
            category: category, transportListings: listingResults);

      case "Food":
        return FoodCard(category: category, foodListings: listingResults);


      case "Entertainment":
        return EntertainmentCard(
            category: category, entertainmentListings: listingResults);

      default:
        return const Text("An Error Occurred!");
    }
  }

}
