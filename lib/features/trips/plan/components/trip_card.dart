import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/models/listing_model.dart';

class TripCard extends ConsumerWidget {
  final ListingModel listing;
  const TripCard({super.key, required this.listing});

  void onTap(BuildContext context, WidgetRef ref) {
    // context.push('/market/${listing.category}', extra: listing);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        20), // round the corners of the image
                    child: Image(
                      image: NetworkImage(listing.images!.first.url!),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),

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
                              listing.title,
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
                        listing.description,
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
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Febuary',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '1 - 3',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '2024',
                              style: TextStyle(
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

  String getCardPricing() {
    switch (listing.category) {
      case "Accommodation":
        AvailableRoom? lowestPricedRoom = findRoomWithLowestPrice(listing);
        if (lowestPricedRoom != null) {
          return "₱${lowestPricedRoom.price} per night";
        } else {
          return "";
        }
      case "Food":
        return "";
      case "Transport":
        return "";
      case "Tours":
        return "";
      case "Entertainment":
        return "";
    }
    return "";
  }

  AvailableRoom? findRoomWithLowestPrice(ListingModel listing) {
    // Check if the list is not empty
    if (listing.availableRooms == null || listing.availableRooms!.isEmpty) {
      return null;
    }

    // Use reduce to find the room with the lowest price
    return listing.availableRooms!.reduce((currentLowest, room) {
      return (room.price < currentLowest.price) ? room : currentLowest;
    });
  }
}
