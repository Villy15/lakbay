import 'package:flutter/material.dart';
import 'package:lakbay/models/listing_model.dart';

class CommunityHubListingCard extends StatelessWidget {
  const CommunityHubListingCard({
    super.key,
    required this.listing,
  });

  final ListingModel listing;

  @override
  Widget build(BuildContext context) {
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
        onTap: () {},
        title: Text(
          listing.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // subtitle Start Date - End Date, format it to Feb 26, 2024
        subtitle: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Customer Name
            // Text(
            //   "Customer: ${booking.customerName}",
            // ),

            // // Guests
            // Text(
            //   "Guests: ${booking.guests}",
            // ),
          ],
        ),

        // display Image in leading
        leading: Image.network(
          listing.images!.first.url!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
