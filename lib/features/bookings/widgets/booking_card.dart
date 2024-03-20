// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class BookingCard extends ConsumerStatefulWidget {
  final ListingBookings booking;
  final ListingModel listing;
  const BookingCard({super.key, required this.booking, required this.listing});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookingCardState();
}

class _BookingCardState extends ConsumerState<BookingCard> {
  void onTap(BuildContext context, WidgetRef ref) {
    context.push(
      '/bookings/booking_details',
      extra: {'booking': widget.booking, 'listing': widget.listing},
    ).then(
      (value) {
        ref.read(navBarVisibilityProvider.notifier).hide();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String?> imageUrls =
        widget.listing.images!.map((listingImage) => listingImage.url).toList();
    return Center(
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 1,
        surfaceTintColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: InkWell(
          splashColor: Colors.orange.withAlpha(30),
          onTap: () => onTap(context, ref),
          child: SizedBox(
              width: double.infinity,
              // height: 290,
              child: Column(
                children: [
                  // Random Image
                  DisplayImage(
                      imageUrl: widget.listing.images!.first.url,
                      height: MediaQuery.sizeOf(context).height / 3,
                      width: double.infinity,
                      radius: BorderRadius.circular(0)),

                  // Card Title
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                            child: Text(
                              widget.listing.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Description
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.listing.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),

                  // // Card Location
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Padding(
                  //     padding: const EdgeInsets.fromLTRB(4.0, 4.0, 8.0, 8.0),
                  //     child: Row(
                  //       children: [
                  //         const Icon(
                  //           Icons.location_on_outlined,
                  //           color: Colors.grey,
                  //         ),
                  //         Text(
                  //           '${listing.city}, ${listing.province}',
                  //           style: const TextStyle(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.normal,
                  //             color: Colors.grey,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  const Divider(),

                  // Price, Rating, and Distance
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                    child: Row(
                      children: [
                        // Price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat.MMM().format(
                                widget.booking.startDate!,
                              ),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${DateFormat.d().format(widget.booking.startDate!)} - ${DateFormat.d().format(widget.booking.endDate!)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat.y().format(
                                widget.booking.startDate!,
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        // Vertical divider
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32.0, 12, 32, 12),
                          child: Container(
                            height: 80,
                            width: 1,
                            color: Colors.orange.withOpacity(0.5),
                          ),
                        ),

                        // Distance
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Location
                            Text(
                              'Mariveles, Bataan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // Address
                            Text(
                              'Camaya Coast Beach',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
