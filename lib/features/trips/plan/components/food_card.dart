import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/models/listing_model.dart';

class FoodCard extends ConsumerStatefulWidget {
  final String category;
  final List<ListingModel>? foodListings;
  const FoodCard(
    {
      super.key,
      required this.category,
      required this.foodListings
    }
  );

  @override
  _FoodCardState createState() => _FoodCardState();
}

class _FoodCardState extends ConsumerState<FoodCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(widget.category),
          ListView.builder(
            itemCount: widget.foodListings!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(widget.foodListings![index].title),
                subtitle: Text(widget.foodListings![index].description),
              );
            }
          )
        ],
      ),
    );
  }
}