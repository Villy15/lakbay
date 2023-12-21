import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/listings/widgets/listing_card.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/listing_model.dart';

class ListingsPage extends ConsumerStatefulWidget {
  final String coopId;
  const ListingsPage({super.key, required this.coopId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListingsPageState();
}

class _ListingsPageState extends ConsumerState<ListingsPage> {
  void addListing(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'add_listing',
      extra: coop,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return ref.watch(getCooperativeProvider(widget.coopId)).when(
          data: (CooperativeModel coop) {
            // Get all listings by the cooperative
            return ref.watch(getListingsByCoopProvider(widget.coopId)).when(
                  data: (List<ListingModel> listings) {
                    return Scaffold(
                      appBar: CustomAppBar(title: 'Listings', user: user),
                      body: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              // Display all listings by the cooperative list view
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: listings.length,
                                itemBuilder: (context, index) {
                                  final listing = listings[index];
                                  return ListingCard(
                                    listing: listing,
                                  );
                                },
                              ),

                              ElevatedButton(
                                onPressed: () {
                                  addListing(context, coop);
                                },
                                child: const Text('Add Listing'),
                              ),
                            ],

                            // Add Listing Button
                          ),
                        ),
                      ),
                    );
                  },
                  error: (error, stackTrace) => Scaffold(
                    body: ErrorText(
                      error: error.toString(),
                      stackTrace: stackTrace.toString(),
                    ),
                  ),
                  loading: () => const Scaffold(
                    body: Loader(),
                  ),
                );
          },
          error: (error, stackTrace) => Scaffold(
            body: ErrorText(
              error: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          ),
          loading: () => const Scaffold(
            body: Loader(),
          ),
        );
  }
}
