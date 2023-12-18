import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/leading_back_button.dart';
import 'package:lakbay/models/listing_model.dart';

class CustomerAccomodation extends ConsumerStatefulWidget {
  final ListingModel listing;
  const CustomerAccomodation({super.key, required this.listing});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerAccomodationState();
}

class _CustomerAccomodationState extends ConsumerState<CustomerAccomodation> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final user = ref.watch(userProvider);
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
        // Add appbar with back button
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: LeadingBackButton(ref: ref)),
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
                      widget.listing.images!.first.url!,
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
                  text: widget.listing.title,
                  lines: 2,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Location
              DisplayText(
                text:
                    "Location: ${widget.listing.province}, ${widget.listing.city}",
                lines: 4,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
                ),
              ),

              DisplayText(
                text:
                    "${widget.listing.pax ?? 1} guests · ${widget.listing.type} · ${widget.listing.category}",
                lines: 1,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
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
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('/night',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400)),
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
                    minimumSize:
                        MaterialStateProperty.all<Size>(const Size(180, 45)),
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
  }
}
