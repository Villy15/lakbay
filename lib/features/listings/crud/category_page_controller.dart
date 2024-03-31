import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/listings/crud/customer_accommodation.dart';
import 'package:lakbay/features/listings/crud/customer_entertainment.dart';
import 'package:lakbay/features/listings/crud/customer_food.dart';
import 'package:lakbay/features/listings/crud/customer_touring.dart';
import 'package:lakbay/features/listings/crud/customer_transportation.dart';
import 'package:lakbay/features/listings/crud/manage_accommodation.dart';
import 'package:lakbay/features/listings/crud/manage_food.dart';
import 'package:lakbay/features/listings/crud/manage_transport.dart';
import 'package:lakbay/models/listing_model.dart';

class CategoryPageController extends ConsumerWidget {
  final ListingModel listing;
  const CategoryPageController({super.key, required this.listing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    if (user!.isCoopView != true) {
      return customerView(listing);
    } else {
      return manageViews(listing);
    }
  }

  Widget customerView(ListingModel listing) {
    switch (listing.category) {
      case 'Accommodation':
        return CustomerAccomodation(
          listing: listing,
        );
      case 'Transport':
        return CustomerTransportation(
          listing: listing,
        );
      case 'Food':
        return CustomerFood(
          listing: listing,
        );
      case 'Entertainment':
        return CustomerEntertainment(
          listing: listing,
        );
      case 'Tour':
        return CustomerTouring(
          listing: listing,
        );
      default:
        return CustomerAccomodation(
          listing: listing,
        );
    }
  }

  Widget manageViews(ListingModel listing) {
    switch (listing.category) {
      case 'Accommodation':
        return ManageAccommodation(
          listing: listing,
        );

      case 'Transport':
        return ManageTransportation(listing: listing);

      case 'Food':
        return ManageFood(
          listing: listing
        );

      default:
        return ManageAccommodation(
          listing: listing,
        );
    }
  }
}
