import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class CommunityHubListingCard extends ConsumerWidget {
  const CommunityHubListingCard({
    super.key,
    required this.listing,
    required this.bookings,
  });

  final ListingModel listing;
  final List<ListingBookings> bookings;

  void onTap(BuildContext context, WidgetRef ref) {
    context.push('/market/${listing.category.toLowerCase()}', extra: listing);
  }

  int getNumberOfTasksThatNeedContributions() {
    int totalTasksNeedContributions = 0;

    for (var booking in bookings) {
      totalTasksNeedContributions += booking.tasksNeedContributions;
    }

    debugPrint('Total Tasks Need Contributions: $totalTasksNeedContributions');

    return totalTasksNeedContributions;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 1,
      borderOnForeground: true,
      // Add a border to the card
      surfaceTintColor: Theme.of(context).colorScheme.background,
      // margin: const EdgeInsets.symmetric(
      //   horizontal: 12.0,
      //   vertical: 4.0,
      // ),
      child: ListTile(
        onTap: () {
          onTap(context, ref);
        },
        title: Text(
          listing.title,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        // subtitle Start Date - End Date, format it to Feb 26, 2024
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Category
            Row(
              children: [
                const Icon(
                  Icons.category_outlined,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  listing.category,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            // Number of bookings
            Wrap(
              children: [
                ActionChip(
                  onPressed: () {},
                  label: Text(
                    '${bookings.length} Bookings',
                  ),
                  // Icon to show the number of bookings
                  avatar: const Icon(
                    Icons.book_outlined,
                  ),
                ),

                // Number of tasks that need contributions
                ActionChip(
                  onPressed: () {},
                  label: Text(
                    '${getNumberOfTasksThatNeedContributions()} Tasks Need Contributions',
                  ),
                  // Icon to show the number of tasks
                  avatar: const Icon(
                    Icons.task_alt,
                  ),
                ),
              ],
            ),
          ],
        ),

        // display Image in leading
        // Make the image have border radius
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(
            listing.images!.first.url!,
            width: 50,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),

        // leading: Image.network(
        //   listing.images!.first.url!,
        //   width: 50,
        //   height: 50,
        //   fit: BoxFit.cover,
        // ),
      ),
    );
  }
}
