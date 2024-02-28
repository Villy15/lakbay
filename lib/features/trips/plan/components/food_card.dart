// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/listing_model.dart';

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
                                            if (food.price != null) ...[
                                              RichText(
                                                  text: TextSpan(children: [
                                                TextSpan(
                                                    text: "₱${food.price}",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface)),
                                              ]))
                                            ] else ...[
                                              const Text(
                                                  'No reservation fee indicated.',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontStyle:
                                                          FontStyle.italic))
                                            ]
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
                                            if (food.price != null) ...[
                                              ElevatedButton(
                                                  onPressed: () {},
                                                  child: const Text('Book Now'))
                                            ] else ...[
                                              ElevatedButton(
                                                  onPressed: () {},
                                                  child: const Text(
                                                      'Add Activity'))
                                            ]
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
}
