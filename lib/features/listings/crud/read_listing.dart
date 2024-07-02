import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/listing_model.dart';

class ReadListingPage extends ConsumerStatefulWidget {
  final String listingId;
  const ReadListingPage({super.key, required this.listingId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReadListingPageState();
}

class _ReadListingPageState extends ConsumerState<ReadListingPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  void pop() {
    context.pop();
    ref.read(navBarVisibilityProvider.notifier).show();
  }

  @override
  Widget build(BuildContext context) {
    // final user = ref.watch(userProvider);

    return ref.watch(getListingProvider(widget.listingId)).when(
          data: (ListingModel listing) {
            return PopScope(
              canPop: false,
              onPopInvoked: (bool didPop) {
                ref.read(navBarVisibilityProvider.notifier).show();
                context.pop();
              },
              child: Scaffold(
                // Add appbar with back button
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    iconSize: 20,
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      pop();
                    },
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Slider
                      CarouselSlider(
                        options: CarouselOptions(
                          viewportFraction: 1.0,
                          height: 250.0,
                          enlargeFactor: 0,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          onPageChanged: (index, reason) {},
                        ),
                        items: [
                          Image(
                            image: NetworkImage(
                              listing.images!.first.url!,
                            ),
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),

                      // Title
                      Padding(
                        padding: const EdgeInsets.only(top: 14.0),
                        child: DisplayText(
                          text: listing.title,
                          lines: 2,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Location
                      DisplayText(
                        text: "Location: ${listing.province}, ${listing.city}",
                        lines: 4,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelLarge?.fontSize,
                        ),
                      ),

                      DisplayText(
                        text:
                            "${listing.pax ?? 1} guests · ${listing.category}",
                        lines: 1,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelLarge?.fontSize,
                        ),
                      ),

                      const Divider(),
                    ],
                  ),
                ),
                // Bottom Nav Bar with price on the left and Book Now on the right
                bottomNavigationBar: BottomAppBar(
                  surfaceTintColor: Colors.white,
                  height: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Price',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text('₱12000.00',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    Text('/night',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FilledButton(
                          // Make it wider
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(180, 45)),
                          ),
                          onPressed: () {},
                          child: const Text('Book Now'),
                        ),
                      ),
                    ],
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
  }
}
