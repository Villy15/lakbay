import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/text_in_bottomsheet.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/models/listing_model.dart';

class CustomerEntertainment extends ConsumerStatefulWidget {
  final ListingModel listing;
  const CustomerEntertainment({super.key, required this.listing});

  @override
  ConsumerState<CustomerEntertainment> createState() =>
      _CustomerEntertainmentState();
}

class _CustomerEntertainmentState extends ConsumerState<CustomerEntertainment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          iconSize: 20,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
            ref.read(navBarVisibilityProvider.notifier).show();
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
                    widget.listing.images!.first.url!,
                  ),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      fontSize:
                          Theme.of(context).textTheme.labelLarge?.fontSize,
                    ),
                  ),

                  DisplayText(
                    text: "${widget.listing.category} · ${widget.listing.type}",
                    lines: 1,
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.labelLarge?.fontSize,
                    ),
                  ),

                  const Divider(),
                  DisplayText(
                    text: 'Description',
                    lines: 1,
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleLarge?.fontSize,
                    ),
                  ),
                  TextInBottomSheet(
                      "About this space", widget.listing.description, context),

                  const Divider(),
                  // DisplayText(
                  //   text: 'Where you\'ll sleep',
                  //   lines: 1,
                  //   style: TextStyle(
                  //     fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                  //   ),
                  // ),
                ],
              ),
            ),
            // const Divider(),

            ref
                .watch(getCooperativeProvider(
                    widget.listing.cooperative.cooperativeId))
                .maybeWhen(
                  data: (coop) {
                    return ListTile(
                      leading: SizedBox(
                        height: 40,
                        width: 40,
                        child: DisplayImage(
                            imageUrl: coop.imageUrl,
                            height: 40,
                            width: 40,
                            radius: BorderRadius.circular(20)),
                      ),
                      // Contact owner
                      trailing: IconButton(
                        onPressed: () {
                          // Show snackbar with reviews
                          showSnackBar(context, 'Contact owner');
                        },
                        icon: const Icon(Icons.message_rounded),
                      ),
                      title: Text('Hosted by ${coop.name}',
                          style: Theme.of(context).textTheme.labelLarge),
                    );
                  },
                  orElse: () => const ListTile(
                    leading: Icon(Icons.error),
                    title: Text('Error'),
                    subtitle: Text('Something went wrong'),
                  ),
                ),

            const Divider(),

            // Add this to current trip
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: FilledButton(
                onPressed: () {
                  // addCurrentTrip(context, planUid);
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                      const Size(double.infinity, 45)),
                ),
                child: const Text('Add this to current trip'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
