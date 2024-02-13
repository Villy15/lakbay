import 'package:flutter/material.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/models/listing_model.dart';

class RoomCard extends StatelessWidget {
  final ListingModel listing;
  const RoomCard({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    List<String?> imageUrls = listing.availableRooms!
        .expand((room) => room.images!.map((image) => image.url))
        .toList();

    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 2.5,
      width: MediaQuery.sizeOf(context).width / 2,
      child: Card(
          child: Column(
        children: [
          ImageSlider(
              images: imageUrls,
              height: MediaQuery.sizeOf(context).height / 5,
              width: MediaQuery.sizeOf(context).width / 2),
          // Text("$")
        ],
      )),
    );
  }
}
