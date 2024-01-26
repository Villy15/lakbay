// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cooptourism/data/models/listing.dart';
// import 'package:cooptourism/data/models/today.dart/sales.dart';
// import 'package:cooptourism/data/models/review.dart';
// import 'package:cooptourism/data/models/task.dart';
// import 'package:cooptourism/data/repositories/cooperative_repository.dart';
// import 'package:cooptourism/data/repositories/today/sales_repository.dart';
// import 'package:cooptourism/data/repositories/review_repository.dart';
// import 'package:cooptourism/data/repositories/task_repository.dart';
// import 'package:cooptourism/pages/market/listing_edit.dart';
// import 'package:cooptourism/pages/market/listing_messages_inbox.dart';
// import 'package:cooptourism/pages/market/listing_tasks.dart';
// import 'package:cooptourism/pages/market/map_page.dart';
// import 'package:cooptourism/pages/market/reviews_page.dart';
// import 'package:cooptourism/providers/home_page_provider.dart';
// import 'package:cooptourism/providers/user_provider.dart';
// import 'package:cooptourism/widgets/display_image.dart';
// import 'package:cooptourism/widgets/display_text.dart';
// import 'package:cooptourism/widgets/leading_back_button.dart';
// import 'package:cooptourism/widgets/listing_display_description.dart';
// import 'package:cooptourism/widgets/listing_image_slider.dart';
// import 'package:cooptourism/widgets/listing_manager_rail_menu.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
// import 'package:lakbay/models/listing_model.dart';
// import 'package:uuid/uuid.dart';

// class SelectedTouringPage extends ConsumerStatefulWidget {
//   final ListingModel listing;
//   const SelectedTouringPage({super.key, required this.listing});

//   @override
//   ConsumerState<SelectedTouringPage> createState() =>
//       _SelectedTouringPageState();
// }

// class _SelectedTouringPageState extends ConsumerState<SelectedTouringPage> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       ref.read(navBarVisibilityProvider.notifier).state = false;
//     });
//   }

//   void showSnackBar(BuildContext context, String text) {
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           content: Text(text),
//           action: SnackBarAction(
//             label: 'Close',
//             onPressed: () {
//               ScaffoldMessenger.of(context).hideCurrentSnackBar();
//             },
//           ),
//         ),
//       );
//   }

//   int railIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     CooperativesRepository cooperativesRepository = CooperativesRepository();
//     Future<List<String>> cooperativeNames = cooperativesRepository
//         .getCooperativeNames(ref.watch(userModelProvider)!.cooperativesJoined!);
//     return WillPopScope(
//       onWillPop: () async {
//         ref.read(navBarVisibilityProvider.notifier).state = true;
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//             backgroundColor: Colors.transparent,
//             leadingWidth: 45,
//             toolbarHeight: 35,
//             leading: LeadingBackButton(ref: ref)),
//         extendBodyBehindAppBar: true,
//         body: FutureBuilder(
//             future: cooperativeNames,
//             builder: (context, snapshot) {
//               if (snapshot.hasError) {
//                 return Text("Error: ${snapshot.error}");
//               }
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               final names = snapshot.data!;
//               final ReviewRepository reviewRepository = ReviewRepository();

//               final Stream<List<ReviewModel>> reviews =
//                   reviewRepository.getAllListingReviews(widget.listing.id!);
//               return Stack(
//                 children: [
//                   if (railIndex == 0)
//                     ListView(
//                       padding: const EdgeInsets.only(top: 0),
//                       children: [
//                         ListingImageSlider(listing: widget.listing),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 14),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 14.0),
//                                 child: DisplayText(
//                                     text: widget.listing.title,
//                                     lines: 2,
//                                     style: const TextStyle(
//                                       fontSize: 22,
//                                       fontWeight: FontWeight.bold,
//                                     )),
//                               ),
//                               // Padding(
//                               //   padding: const EdgeInsets.only(bottom: 10.0),
//                               //   child: DisplayText(
//                               //       text: "₱${listing.price!.toStringAsFixed(2)}",
//                               //       lines: 1,
//                               //       style: const TextStyle(
//                               //         fontSize: 18,
//                               //         fontWeight: FontWeight.w500,
//                               //       )),
//                               // ),
//                               DisplayText(
//                                 text:
//                                     "Location: ${widget.listing.province ?? ''}, ${widget.listing.city ?? ''}",
//                                 lines: 4,
//                                 style: TextStyle(
//                                     fontSize: Theme.of(context)
//                                         .textTheme
//                                         .labelLarge
//                                         ?.fontSize),
//                               ),
//                               DisplayText(
//                                 text:
//                                     "${widget.listing.pax ?? 1} guests · ${widget.listing.type ?? ''} · ${widget.listing.category ?? ''}",
//                                 lines: 1,
//                                 style: TextStyle(
//                                     fontSize: Theme.of(context)
//                                         .textTheme
//                                         .labelLarge
//                                         ?.fontSize),
//                               ),

//                               StreamBuilder(
//                                   stream: reviews,
//                                   builder: (context, snapshot) {
//                                     if (snapshot.hasError) {
//                                       return Text('Error: ${snapshot.error}');
//                                     }

//                                     if (snapshot.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return const SizedBox.shrink();
//                                     }

//                                     final reviews = snapshot.data!;
//                                     return Row(
//                                       children: [
//                                         Icon(Icons.star_rounded,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .primary),
//                                         const SizedBox(width: 5),
//                                         DisplayText(
//                                           text:
//                                               "${widget.listing.rating ?? 0.00}",
//                                           lines: 1,
//                                           style: TextStyle(
//                                               fontSize: Theme.of(context)
//                                                   .textTheme
//                                                   .labelLarge
//                                                   ?.fontSize),
//                                         ),
//                                         const SizedBox(width: 5),
//                                         TextButton(
//                                           onPressed: () {
//                                             if (reviews.isEmpty) {
//                                               ScaffoldMessenger.of(context)
//                                                   .showSnackBar(
//                                                 SnackBar(
//                                                   content:
//                                                       const Text('No reviews'),
//                                                   action: SnackBarAction(
//                                                     label: 'Close',
//                                                     onPressed: () {
//                                                       ScaffoldMessenger.of(
//                                                               context)
//                                                           .hideCurrentSnackBar();
//                                                     },
//                                                   ),
//                                                 ),
//                                               );
//                                             } else {
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         ReviewsPage(
//                                                             review: reviews,
//                                                             listing: widget
//                                                                 .listing)),
//                                               );
//                                             }
//                                           },
//                                           child: Text(
//                                             '${reviews.length} reviews',
//                                             style: const TextStyle(
//                                                 fontSize: 12,
//                                                 decoration:
//                                                     TextDecoration.underline),
//                                           ),
//                                         )
//                                       ],
//                                     );
//                                   }),

//                               const Divider(),

//                               DisplayText(
//                                 text: 'Description',
//                                 lines: 1,
//                                 style: TextStyle(
//                                   fontSize: Theme.of(context)
//                                       .textTheme
//                                       .titleLarge
//                                       ?.fontSize,
//                                 ),
//                               ),

//                               const SizedBox(
//                                 height: 10,
//                               ),

//                               listingDisplayDescription(
//                                   widget.listing, context),

//                               const Divider(),

//                               DisplayText(
//                                 text: 'Where you\'ll go',
//                                 lines: 1,
//                                 style: TextStyle(
//                                   fontSize: Theme.of(context)
//                                       .textTheme
//                                       .titleLarge
//                                       ?.fontSize,
//                                 ),
//                               ),

//                               Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 16.0, right: 16.0),
//                                   child: Column(
//                                     children: [
//                                       const SizedBox(height: 16.0),
//                                       SizedBox(
//                                         width: 350,
//                                         height: 200,
//                                         child: MapSample(
//                                           address:
//                                               '${widget.listing.province ?? ''}, ${widget.listing.city ?? 'Philippines'}',
//                                         ),
//                                       ),
//                                       const SizedBox(height: 16.0),
//                                     ],
//                                   )),

//                               const Divider(),

//                               // Hosted by owner
//                               ListTile(
//                                 leading: DisplayImage(
//                                     path:
//                                         '${widget.listing.owner}/images/pfp.jpg',
//                                     height: 40,
//                                     width: 40,
//                                     radius: BorderRadius.circular(20)),
//                                 // Contact owner
//                                 trailing: IconButton(
//                                   onPressed: () {
//                                     // Show snackbar with reviews
//                                     showSnackBar(context, 'Contact owner');
//                                   },
//                                   icon: const Icon(Icons.message_rounded),
//                                 ),
//                                 title: Text(
//                                     'Hosted by ${widget.listing.ownerMember ?? 'Timothy Mendoza'}',
//                                     style:
//                                         Theme.of(context).textTheme.labelLarge),
//                                 subtitle: Text(
//                                     widget.listing.cooperativeOwned ??
//                                         'Iwahori Multi-Purpose Cooperative',
//                                     style:
//                                         Theme.of(context).textTheme.bodySmall),
//                               ),

//                               const Divider(),

//                               const SizedBox(
//                                 height: 100,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   if (railIndex == 1)
//                     ListingMessagesInbox(
//                       listingId: widget.listing.id!,
//                     ),
//                   if (railIndex == 2)
//                     ListingEdit(
//                       listing: widget.listing,
//                     ),
//                   if (railIndex == 3)
//                     ListingTasks(
//                       listing: widget.listing,
//                     ),
//                   if (ref.watch(userModelProvider)!.role == "Manager" &&
//                       names.contains(widget.listing.cooperativeOwned) == true)
//                     ListingManagerRailMenu(
//                       railIndex: railIndex,
//                       onDestinationSelected: (index) {
//                         setState(() {
//                           railIndex = index;
//                         });
//                       },
//                       listingId: widget.listing.id!,
//                     ),
//                 ],
//               );
//             }),
//         bottomNavigationBar: railIndex == 0
//             ? BottomAppBar(
//                 surfaceTintColor: Colors.white,
//                 height: 90,
//                 child: customerRow(widget.listing))
//             : null,
//       ),
//     );
//   }

//   Row customerRow(ListingModel listing) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: FilledButton(
//               // Make it wider
//               style: ButtonStyle(
//                 minimumSize:
//                     MaterialStateProperty.all<Size>(const Size(180, 45)),
//               ),
//               onPressed: () {
//                 showModalBottomSheet(
//                   backgroundColor: Colors.white,
//                   isScrollControlled: true,
//                   barrierLabel: "Booking Options",
//                   context: context,
//                   builder: (BuildContext context) {
//                     return _TouringBookingOptions(listing: widget.listing);
//                   },
//                 );
//               },
//               child: const Text('Book Now'),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _TouringBookingOptions extends ConsumerStatefulWidget {
//   final ListingModel listing;
//   const _TouringBookingOptions({required this.listing});

//   @override
//   ConsumerState<_TouringBookingOptions> createState() =>
//       __TouringBookingOptionsState();
// }

// class __TouringBookingOptionsState
//     extends ConsumerState<_TouringBookingOptions> {
//   // GlobalKey<__PaxCounterState> paxCounterState = GlobalKey();
//   int? selectedDate;
//   int? selectedTime;
//   int? paxCount;

//   setPax(newValue) {
//     setState(() {
//       paxCount = newValue;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(10),
//       height: MediaQuery.of(context).size.height / 1.5,
//       child: ListView(
//         children: [
//           Container(
//             alignment: Alignment.centerLeft,
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Theme.of(context).colorScheme.outline,
//                 width: 1.5,
//               ),
//               borderRadius: const BorderRadius.all(Radius.circular(15)),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 10.0, top: 10, right: 10),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Row(
//                     children: [
//                       Icon(Icons.info_outline_rounded, size: 15),
//                       SizedBox(width: 5),
//                       Text("Please select a tour date and time"),
//                     ],
//                   ),
//                   Divider(
//                     color: Theme.of(context).colorScheme.outline,
//                   ),
//                   const Text("Date"),
//                   const SizedBox(height: 10),
//                   Container(
//                     margin: const EdgeInsets.only(bottom: 10),
//                     height: MediaQuery.sizeOf(context).height /
//                         12.5, // Set a fixed height for horizontal ListView
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       scrollDirection: Axis.horizontal,
//                       itemCount: widget.listing.availableDates?.length ?? 0,
//                       itemBuilder: (context, dateIndex) {
//                         return Container(
//                           margin: const EdgeInsets.only(right: 10),
//                           child: ChoiceChip(
//                             label: Text(
//                               "${widget.listing.availableDates![dateIndex].date!.toDate().day} ${getMonthCode(widget.listing.availableDates![dateIndex].date!.toDate().month)}",
//                             ),
//                             selected: selectedDate == dateIndex,
//                             onSelected: (bool selected) {
//                               setState(() {
//                                 selectedDate = selected ? dateIndex : null;
//                               });
//                             },
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   if (selectedDate != null &&
//                       widget.listing.availableDates![selectedDate!]
//                               .availableTimes !=
//                           null)
//                     Column(
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text("Time"),
//                             const SizedBox(height: 10),
//                             Container(
//                               margin: const EdgeInsets.only(bottom: 20),
//                               height: MediaQuery.sizeOf(context).height / 15,
//                               child: ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: widget
//                                         .listing
//                                         .availableDates![selectedDate!]
//                                         .availableTimes
//                                         ?.length ??
//                                     0,
//                                 itemBuilder: (context, timeIndex) {
//                                   return Container(
//                                     margin: const EdgeInsets.only(right: 10),
//                                     child: ChoiceChip(
//                                       label: Text(
//                                         widget
//                                             .listing
//                                             .availableDates![selectedDate!]
//                                             .availableTimes![timeIndex]
//                                             .time!,
//                                       ),
//                                       selected: selectedTime == timeIndex,
//                                       onSelected: widget
//                                                   .listing
//                                                   .availableDates![
//                                                       selectedDate!]
//                                                   .availableTimes![timeIndex]
//                                                   .maxPax !=
//                                               widget
//                                                   .listing
//                                                   .availableDates![
//                                                       selectedDate!]
//                                                   .availableTimes![timeIndex]
//                                                   .currentPax
//                                           ? (bool selected) {
//                                               setState(() {
//                                                 selectedTime =
//                                                     selected ? timeIndex : null;
//                                                 paxCount = 0;
//                                               });
//                                             }
//                                           : null,
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                         if (selectedTime != null)
//                           _PaxCounter(
//                             // key: paxCounterState,
//                             listing: widget.listing,
//                             dateIndex: selectedDate!,
//                             timeIndex: selectedTime!,
//                             paxCount: paxCount!,
//                             setPax: setPax,
//                           ),
//                       ],
//                     )
//                   else if (selectedDate != null)
//                     Container(
//                         margin: const EdgeInsets.symmetric(vertical: 20),
//                         child: Center(
//                             child: Text(
//                           "Day is Fully Booked",
//                           style: Theme.of(context).textTheme.bodyLarge!,
//                         ))),
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     width: double.infinity,
//                     child: FilledButton(
//                       onPressed: (selectedTime == null || paxCount == 0)
//                           ? null
//                           : () {
//                               final Timestamp date = widget
//                                   .listing.availableDates![selectedDate!].date!;
//                               final String time = widget
//                                   .listing
//                                   .availableDates![selectedDate!]
//                                   .availableTimes![selectedTime!]
//                                   .time!;
//                               SalesRepository salesRepository =
//                                   SalesRepository();
//                               TaskRepository taskRepository = TaskRepository();
//                               String id = const Uuid().v4();
//                               salesRepository
//                                   .addSale(
//                                       id,
//                                       SalesData(
//                                           uid: id,
//                                           customerid:
//                                               ref.watch(userModelProvider)!.uid,
//                                           cooperativeId:
//                                               widget.listing.cooperativeOwned,
//                                           dateSelected: date,
//                                           timeSelected: time,
//                                           numberOfGuests: paxCount,
//                                           date: Timestamp.now(),
//                                           sales: (widget.listing.price *
//                                               num.parse(paxCount.toString())),
//                                           category: widget.listing.category))
//                                   .whenComplete(() => taskRepository.addTask(
//                                       TaskModel(
//                                           referenceId: widget.listing.id,
//                                           isManagerApproved: false,
//                                           title:
//                                               "${date.toDate().day} ${getMonthCode(date.toDate().month)} $time",
//                                           description: "",
//                                           progress: 0,
//                                           toDoList: [])));
//                             },
//                       child: const Text("Book Now"),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }

//   String getMonthCode(int monthNumber) {
//     Map<int, String> monthCodes = {
//       1: 'Jan',
//       2: 'Feb',
//       3: 'Mar',
//       4: 'Apr',
//       5: 'May',
//       6: 'Jun',
//       7: 'Jul',
//       8: 'Aug',
//       9: 'Sep',
//       10: 'Oct',
//       11: 'Nov',
//       12: 'Dec',
//     };

//     return monthCodes[monthNumber] ??
//         'Invalid'; // Return 'Invalid' if the month number is not valid
//   }
// }

// class _PaxCounter extends StatefulWidget {
//   final ListingModel listing;
//   final int dateIndex;
//   final int timeIndex;
//   final int paxCount;
//   final Function setPax;
//   const _PaxCounter({
//     // super.key,
//     required this.listing,
//     required this.dateIndex,
//     required this.timeIndex,
//     required this.paxCount,
//     required this.setPax,
//   });

//   @override
//   State<_PaxCounter> createState() => __PaxCounterState();
// }

// class __PaxCounterState extends State<_PaxCounter> {
//   @override
//   Widget build(BuildContext context) {
//     final num maxPax = widget.listing.availableDates![widget.dateIndex]
//         .availableTimes![widget.timeIndex].maxPax!;
//     final num currentPax = widget.listing.availableDates![widget.dateIndex]
//         .availableTimes![widget.timeIndex].currentPax!;
//     return Container(
//       alignment: Alignment.centerLeft,
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Theme.of(context).colorScheme.outline,
//           width: 1.5,
//         ),
//         borderRadius: const BorderRadius.all(Radius.circular(15)),
//       ),
//       child: Padding(
//         padding:
//             const EdgeInsets.only(left: 10.0, top: 10, right: 10, bottom: 10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const Icon(Icons.info_outline_rounded, size: 15),
//                 const SizedBox(width: 5),
//                 Text("Slots remaining ${maxPax - currentPax}"),
//               ],
//             ),
//             Divider(
//               color: Theme.of(context).colorScheme.outline,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text("Person"),
//                 Text("₱${widget.listing.price * widget.paxCount}"),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SizedBox(
//                       height: 25,
//                       width: 25,
//                       child: IconButton(
//                           padding: EdgeInsets.zero,
//                           iconSize: 15,
//                           onPressed: () {
//                             widget.paxCount == 0
//                                 ? null
//                                 : setState(
//                                     () {
//                                       // paxCount = paxCount - 1;
//                                       widget.setPax(widget.paxCount - 1);
//                                     },
//                                   );
//                           },
//                           icon: const Icon(Icons.remove)),
//                     ),
//                     const SizedBox(width: 20),
//                     Text("${widget.paxCount}"),
//                     const SizedBox(width: 20),
//                     SizedBox(
//                       height: 25,
//                       width: 25,
//                       child: IconButton(
//                         padding: EdgeInsets.zero,
//                         iconSize: 15,
//                         onPressed: () {
//                           widget.paxCount == (maxPax - currentPax)
//                               ? null
//                               : setState(() {
//                                   // paxCount = paxCount + 1;
//                                   widget.setPax(widget.paxCount + 1);
//                                 });
//                         },
//                         icon: const Icon(Icons.add),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
