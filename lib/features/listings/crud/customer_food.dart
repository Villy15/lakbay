import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
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
  List<SizedBox> tabs = [
    const SizedBox(width: 100, child: Tab(child: Text('Details'))),
    const SizedBox(width: 100, child: Tab(child: Text('Tables'))),
    const SizedBox(width: 100, child: Tab(child: Text('Bookings'))),
  ];
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
        child: DefaultTabController(
            initialIndex: 0,
            length: tabs.length,
            child: Scaffold(
                appBar: AppBar(
                  title: widget.listing.title.length > 20
                      ? Text('${widget.listing.title.substring(0, 20)}...',
                          style: const TextStyle(
                              fontSize: 32.0, fontWeight: FontWeight.bold))
                      : Text(widget.listing.title,
                          style: const TextStyle(
                              fontSize: 32.0, fontWeight: FontWeight.bold)),
                  bottom: TabBar(
                      tabAlignment: TabAlignment.center,
                      labelPadding: EdgeInsets.zero,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: tabs),
                ),
                body: TabBarView(children: [
                  details()
                ]))));
  }

  SingleChildScrollView details() {
    return SingleChildScrollView(
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
                fit: BoxFit.cover
              )
            ]
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
                      fontWeight: FontWeight.bold
                    )
                  )
                ),
                DisplayText(
                  text: 'Location: ${widget.listing.province}, ${widget.listing.city}',
                  lines: 4,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelLarge?.fontSize
                  ) 
                ),
                DisplayText(
                  text: '${widget.listing.category} · ${widget.listing.type}',
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
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize
                  )
                ),
                if (widget.listing.description.length > 40) ... [
                  TextInBottomSheet(
                    "About this space", widget.listing.description, context)
                ] 
                else ... [
                  DisplayText(
                    text: widget.listing.description,
                    lines: 5,
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.labelLarge?.fontSize
                    )
                  )
                ],
              ],
            )
          ),
          const SizedBox(height: 10),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: DisplayText(
              text: 'Menu',
              lines: 1,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleLarge?.fontSize
              )
            ),
          ),
          const SizedBox(height: 10),
          CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 0.3,
              height: 100.0,
              enlargeFactor: 0,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {}
            ),
            items: (widget.listing.menuImgs ?? []).map((img) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage('${img.url}'),
                        fit: BoxFit.cover
                      )
                    )
                  );
                }
              );
            }).toList()
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Working Hours',
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.titleLarge?.fontSize
                        )
                      )
                    ),
                    Text(
                      '${widget.listing.availableTables!.first.startTime.format(context)} - ${widget.listing.availableTables!.first.endTime.format(context)}',
                      style: const TextStyle(fontSize: 12)
                    )
                  ]
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        'Available Days',
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.titleLarge?.fontSize
                        )
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        getWorkingDays(widget.listing.availableTables!.first.workingDays),
                        style: const TextStyle(
                          fontSize: 12
                        )
                      )
                    )
                  ]
                )
              ]
            )
          ),
          const SizedBox(height: 30),
          const Divider(),

          ListTile(
            leading: SizedBox(
              height: 40,
              width: 40,
              child: DisplayImage(
                imageUrl: 'cooperatives/${widget.listing.cooperative.cooperativeName}/download.jpg',
                height: 40,
                width: 40,
                radius: BorderRadius.circular(20)
              )
            ),
            trailing: IconButton(
              onPressed: () {
                showSnackBar(context, 'Contact owner');
              },
              icon: const Icon(Icons.message_rounded)
            ),
            title: Text(
              'Hosted by ${widget.listing.cooperative.cooperativeName}',
              style: Theme.of(context).textTheme.labelLarge
              )
          ),
          const Divider(),

          const SizedBox(height: 5)
        ]
      )
    );
  }

  String getWorkingDays(List<bool> workingDays) {
    const daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    List<String> result = [];
    for (int i = 0; i < workingDays.length; i++) {
      if (workingDays[i]) {
        int start = i;
        // Find the end of this sequence of days
        while (i + 1 < workingDays.length && workingDays[i + 1]) {
          i++;
        }
        // If start and i are the same, it means only one day is available
        if (start == i) {
          result.add(daysOfWeek[start]);
        } else {
          // Else, we have a range of days
          result.add('${daysOfWeek[start]}-${daysOfWeek[i]}');
        }
      }
    }
    return result.join(', ');
  }
}
