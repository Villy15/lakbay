import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/leading_back_button.dart';
import 'package:lakbay/features/common/widgets/text_in_bottomsheet.dart';
import 'package:lakbay/models/listing_model.dart';

class CustomerFood extends ConsumerStatefulWidget {
  final ListingModel listing;
  const CustomerFood({super.key, required this.listing});

  @override
  ConsumerState<CustomerFood> createState() => _CustomerFoodState();
}

class _CustomerFoodState extends ConsumerState<CustomerFood> {
   @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: LeadingBackButton(ref: ref)
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  viewportFraction: 1.0,
                  height: 250.0,
                  enlargeFactor: 0,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {}
                ),
                items: [
                  Image(
                    image: NetworkImage(
                      widget.listing.images!.first.url!,
                    ),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                ]
              ),

              // Title
              Padding(
                padding: const EdgeInsets.only(top: 14.0),
                child: DisplayText(
                  text: widget.listing.title,
                  lines: 2,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  )
                ) 
              ),

              // Location
              DisplayText(
                text:
                  "Location: ${widget.listing.province}, ${widget.listing.city}",
                lines: 4,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelLarge?.fontSize
                )
              ),

              // No. of guests · Type · Category
              DisplayText(
                text:
                  "${widget.listing.pax ?? 1} guests · ${widget.listing.type} · ${widget.listing.category}",
                lines: 1,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelLarge?.fontSize
                )
              ),

              const Divider(),
              DisplayText(
                      text: 'Description',
                      lines: 1,
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleLarge?.fontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextInBottomSheet("About this space",
                        widget.listing.description, context),

              const SizedBox(height: 15), 
              const Divider(),


              // display menuImgs from listing
              // if listing.menuImgs is not null

              // if (widget.listing.menuImgs?.isNotEmpty == true) ... [
              //   DisplayText(
              //     text: "Menu",
              //     lines: 1,
              //     style: TextStyle(
              //       fontSize: Theme.of(context).textTheme.labelLarge?.fontSize
              //     )
              //   ),
              //   const SizedBox(height: 10),
              //   CarouselSlider(
              //     options: CarouselOptions(
              //       viewportFraction: 1.0,
              //       height: 500.0,
              //       enlargeFactor: 0,
              //       enlargeCenterPage: true,
              //       enableInfiniteScroll: false,
              //       onPageChanged: (index, reason) {}
              //     ),
              //     items: widget.listing.menuImgs!.map((e) {
              //       return Builder(
              //         builder: (BuildContext context) {
              //           return Image(
              //             image: NetworkImage(
              //               e.url!,
              //             ),
              //             width: double.infinity,
              //             height: 200,
              //             fit: BoxFit.cover,
              //           );
              //         },
              //       );
              //     }).toList(),
              //   ),
              //   const SizedBox(height: 15),
              //   const Divider(),

              // ]
            ]
          )
        ),
        // Bottom Nav Bar with price on left and book reservation
        bottomNavigationBar: BottomAppBar(
          surfaceTintColor: Colors.white,
          height: 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reservation Fee',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: [
                            Text("₱${widget.listing.price.toString()}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
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
      )
    );
  }
}
