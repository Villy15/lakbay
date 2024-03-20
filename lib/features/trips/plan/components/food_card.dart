// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/providers/days_provider.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/listings/crud/customer_food_checkout.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class FoodCard extends ConsumerStatefulWidget {
  final String category;
  final List<ListingModel>? foodListings;
  const FoodCard(
      {super.key, required this.category, required this.foodListings});

  @override
  FoodCardState createState() => FoodCardState();
}

class FoodCardState extends ConsumerState<FoodCard> {
  @override
  Widget build(BuildContext context) {
    final guests = ref.read(currentPlanGuestsProvider);
    final startDate = ref.read(planStartDateProvider);
    final endDate = ref.read(planEndDateProvider);
    final daysPlan = ref.read(daysPlanProvider);

    if (widget.foodListings != null) {
      return SizedBox(
          width: double.infinity,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.foodListings!.length,
              itemBuilder: ((context, index) {
                final List<String?> imageUrls = widget
                    .foodListings![index].images!
                    .map((listingImage) => listingImage.url)
                    .toList();
                final food = widget.foodListings![index];
                return SizedBox(
                    width: MediaQuery.sizeOf(context).width / 2,
                    child: Card(
                        child: Column(children: [
                      ImageSlider(
                          images: imageUrls,
                          height: MediaQuery.sizeOf(context).height / 4,
                          width: MediaQuery.sizeOf(context).width / 2,
                          radius: BorderRadius.circular(10)),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 10, top: 10, bottom: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(food.title,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(food.title,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            const SizedBox(height: 10),
                                            const Text(
                                                'No reservation fee indicated.',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontStyle:
                                                        FontStyle.italic))
                                          ])
                                    ]),
                                SizedBox(
                                    height:
                                        MediaQuery.sizeOf(context).height / 30),
                                ref.watch(getListingProvider(food.uid!)).when(
                                    data: (ListingModel listing) {
                                      return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  context.push(
                                                      '/market/${widget.category}',
                                                      extra: listing);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 25,
                                                        vertical: 5)),
                                                child: const Text(
                                                    'View Listing',
                                                    style: TextStyle(
                                                        fontSize: 14))),
                                            ElevatedButton(
                                                onPressed: () {
                                                  showConfirmBooking(
                                                      food.availableDeals!
                                                          .first,
                                                      listing,
                                                      daysPlan.currentDay!);
                                                },
                                                child: const Text('Book Now'))
                                          ]);
                                    },
                                    error: (((error, stackTrace) => ErrorText(
                                        error: error.toString(),
                                        stackTrace: stackTrace.toString()))),
                                    loading: () => const Loader())
                              ])),
                    ])));
              })));
    } else {
      return Center(
          child: Column(children: [
        const Text('No Food Listings Available'),
        Text(
            "(${DateFormat('MMMM dd').format(startDate!)} - ${DateFormat('MMMM dd').format(endDate!)})")
      ]));
    }
  }

  void showConfirmBooking(
      FoodService food, ListingModel listing, DateTime bookedDate) {
    showDialog(
        context: context,
        builder: (context) {
          num guests = 0;
          final user = ref.read(userProvider);

          TextEditingController phoneNoController =
              TextEditingController(text: user?.phoneNo);
          TextEditingController emergencyContactNameController =
              TextEditingController();
          TextEditingController emergencyContactNoController =
              TextEditingController();
          bool governmentId = true;
          String formattedDate = DateFormat('MMMM dd, yyyy').format(bookedDate);

          return Dialog.fullscreen(
              child: StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppBar(
                              leading: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    context.pop();
                                  }),
                              title: Text(formattedDate,
                                  style: const TextStyle(fontSize: 18)),
                              elevation: 0),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(children: [
                                TextFormField(
                                    decoration: InputDecoration(
                                        labelText:
                                            'Number of Guests (Max: ${food.guests})',
                                        border: const OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        hintText: '1'),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      guests = int.tryParse(value) ?? 0;
                                    }),
                                const SizedBox(height: 10),
                                TextFormField(
                                    controller: phoneNoController,
                                    decoration: const InputDecoration(
                                        labelText: 'Phone Number',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always),
                                    keyboardType: TextInputType.phone),
                                const SizedBox(height: 10),
                                TextFormField(
                                    controller: emergencyContactNameController,
                                    decoration: const InputDecoration(
                                        labelText: 'Emergency Contact Name',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always),
                                    keyboardType: TextInputType.name),
                                const SizedBox(height: 10),
                                TextFormField(
                                    controller: emergencyContactNoController,
                                    decoration: const InputDecoration(
                                        labelText: 'Emergency Contact Number',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always),
                                    keyboardType: TextInputType.phone),
                                Column(children: [
                                  CheckboxListTile(
                                      enabled: false,
                                      value: governmentId,
                                      title: const Text('Government ID'),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          governmentId = value ?? false;
                                        });
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 16),
                                      child: Text(
                                          'Your government ID is required as a means to protect cooperatives.',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontStyle: FontStyle.italic)))
                                ]),
                                SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          final currentTrip =
                                              ref.read(currentTripProvider);

                                          ListingBookings booking =
                                              ListingBookings(
                                            tripUid: currentTrip!.uid!,
                                            tripName: currentTrip.name,
                                            listingId: listing.uid!,
                                            listingTitle: listing.title,
                                            customerName:
                                                ref.read(userProvider)!.name,
                                            bookingStatus: "Reserved",
                                            price: food.price,
                                            category: 'Food',
                                            startDate: bookedDate,
                                            endDate: bookedDate,
                                            email: "",
                                            governmentId:
                                                "https://firebasestorage.googleapis.com/v0/b/lakbay-cd97e.appspot.com/o/users%2FTimothy%20Mendoza%2Fimages%20(3).jpg?alt=media&token=36ab03ef-0880-4487-822e-1eb512a73ea0",
                                            guests: guests,
                                            customerPhoneNo:
                                                phoneNoController.text,
                                            customerId:
                                                ref.read(userProvider)!.uid,
                                            emergencyContactName:
                                                emergencyContactNameController
                                                    .text,
                                            emergencyContactNo:
                                                emergencyContactNoController
                                                    .text,
                                            needsContributions: false,
                                            tasks: listing.fixedTasks,
                                          );

                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog.fullscreen(
                                                    child: CustomerFoodCheckout(
                                                        listing: listing,
                                                        foodService: food,
                                                        booking: booking));
                                              });
                                        },
                                        child: const Text('Proceed')))
                              ]))
                        ])));
          }));
        });
  }
}
