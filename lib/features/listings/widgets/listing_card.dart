import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/models/listing_model.dart';

class ListingCard extends ConsumerWidget {
  final ListingModel listing;
  const ListingCard({super.key, required this.listing});

  void onTap(BuildContext context, WidgetRef ref) {
    context
        .push(
      '/market/${listing.category.toLowerCase()}',
      extra: listing,
    )
        .then(
      (value) {
        debugPrint("Popped");
        ref.read(navBarVisibilityProvider.notifier).show();
      },
    );
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
                                const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                            child: Text(
                              listing.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Rating
                        Row(
                          children: [
                            Icon(
                              Icons.star_purple500_outlined,
                              color: Colors.yellow[600],
                            ),
                            const Text(
                              '4.8',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Card Location
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4.0, 4.0, 8.0, 8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey,
                          ),
                          Text(
                            '${listing.city}, ${listing.province}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Price, Rating, and Distance
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Row(
                          children: [
                            Text(
                              getCardPricing(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        // Distance
                        Row(
                          children: [
                            Icon(
                              listing.category == 'Accommodation'
                                  ? Icons.hotel_outlined
                                  : Icons.shopping_bag_outlined,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              listing.category,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
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
