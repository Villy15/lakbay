import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/listing_model.dart';

class TransportCard extends ConsumerStatefulWidget {
  final String category;
  final List<ListingModel>? transportListings;
  const TransportCard(
      {super.key, required this.category, required this.transportListings});

  @override
  ConsumerState<TransportCard> createState() => _TransportCardState();
}

class _TransportCardState extends ConsumerState<TransportCard> {
  @override
  Widget build(BuildContext context) {
    final guests = ref.read(currentPlanGuestsProvider);
    final startDate = ref.read(planStartDateProvider);
    final endDate = ref.read(planEndDateProvider);

    if (widget.transportListings != null) {
      return SizedBox(
          width: double.infinity,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.transportListings!.length,
              itemBuilder: ((context, index) {
                final List<String?> imageUrls = widget
                    .transportListings![index].images!
                    .map((listingImage) => listingImage.url)
                    .toList();
                final transport = widget.transportListings![index];
                return SizedBox(
                  // height: MediaQuery.sizeOf(context).height / 2,
                  width: MediaQuery.sizeOf(context).width / 2,
                  child: Card(
                      child: Column(
                    children: [
                      ImageSlider(
                          images: imageUrls,
                          height: MediaQuery.sizeOf(context).height / 4,
                          width: MediaQuery.sizeOf(context).width / 2),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 10,
                            top: 10,
                            bottom: 10), // Reduced overall padding
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      transport.title,
                                      style: const TextStyle(
                                        fontSize:
                                            18, // Increased font size, larger than the previous one
                                        fontWeight:
                                            FontWeight.bold, // Bold text
                                      ),
                                    ),
                                    Text(
                                      transport.title,
                                      style: const TextStyle(
                                        fontSize:
                                            14, // Increased font size, larger than the previous one
                                        fontWeight:
                                            FontWeight.w500, // Bold text
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                "₱${transport.availableTransport!.price}",
                                            style: TextStyle(
                                                fontSize:
                                                    14, // Size for the price
                                                fontWeight: FontWeight
                                                    .w500, // Bold for the price
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface),
                                          ),
                                          TextSpan(
                                            text: " per trip",
                                            style: TextStyle(
                                                fontSize:
                                                    14, // Smaller size for 'per night'
                                                fontStyle: FontStyle
                                                    .italic, // Italicized 'per night'
                                                fontWeight: FontWeight
                                                    .normal, // Normal weight for 'per night'
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height / 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    context.push('/market/${widget.category}',
                                        extra: transport);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 5),
                                  ),
                                  child: const Text(
                                    'View Listing',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 5),
                                  ),
                                  child: const Text(
                                    'Book Now',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Row(
                                  children: [
                                    const Icon(Icons.bed_outlined),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      widget.category,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  )),
                );
              })));
    } else {
      return Center(
        child: Column(
          children: [
            const Text("No Transportation Available"),
            Text(
                "(${DateFormat('MMMM dd').format(startDate!)} - ${DateFormat('MMMM dd').format(endDate!)})")
          ],
        ),
      );
    }
  }
}
