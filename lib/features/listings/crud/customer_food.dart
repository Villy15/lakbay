import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/common/widgets/text_in_bottomsheet.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/inbox/inbox_page.dart';
import 'package:lakbay/features/trips/plan/plan_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/plan_model.dart';

class CustomerFood extends ConsumerStatefulWidget {
  final ListingModel listing;
  const CustomerFood({super.key, required this.listing});

  @override
  ConsumerState<CustomerFood> createState() => _CustomerFoodState();
}

class _CustomerFoodState extends ConsumerState<CustomerFood> {
  List<SizedBox> tabs = [
    const SizedBox(width: 100, child: Tab(child: Text('Details'))),
    const SizedBox(width: 100, child: Tab(child: Text('Deals'))),
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
    final planUid = ref.read(currentPlanIdProvider);
    final isLoading = ref.watch(plansControllerProvider);
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          context.pop();
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
                  isLoading ? const Loader() : foodDetails(planUid),
                  menu(),
                ]))));
  }

  SingleChildScrollView foodDetails(String? planUid) {
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
              onPageChanged: (index, reason) => {},
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
            ]),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Container(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Start Time',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500)),
                                        const SizedBox(height: 10),
                                        Text(
                                            widget.listing.availableDeals!.first
                                                .startTime
                                                .format(context),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold))
                                      ]))),
                          const VerticalDivider(
                            color: Colors.grey,
                            thickness: 5,
                            width: 10,
                            indent: 0,
                          ),
                          Expanded(
                              child: Container(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('End Time',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500)),
                                        const SizedBox(height: 10),
                                        Text(
                                            widget.listing.availableDeals!.first
                                                .endTime
                                                .format(context),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold))
                                      ])))
                        ])),
                const SizedBox(height: 10),
                const Text("Description",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                TextInBottomSheet(
                    widget.listing.title, widget.listing.description, context),
                const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Find Us Here',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: MediaQuery.sizeOf(context).height / 5,
                        child: MapWidget(
                          address: widget.listing.address,
                        )))
              ],
            )),
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
                              radius: BorderRadius.circular(20))),
                      trailing: IconButton(
                          onPressed: () {
                            // Show snackbar with reviews
                            createRoom(context, widget.listing.publisherId);
                          },
                          icon: const Icon(Icons.message_rounded)),
                      title: Text('Hosted by: ${coop.name}',
                          style: Theme.of(context).textTheme.labelLarge));
                },
                orElse: () => const ListTile(
                    leading: Icon(Icons.error),
                    title: Text('Error'),
                    subtitle: Text('Something went wrong'))),
        const Divider()
      ],
    ));
  }

  void createRoom(BuildContext context, String senderId) async {
    // Create a room
    final room = await FirebaseChatCore.instance.createRoom(
      types.User(id: senderId),
    );

    // ignore: use_build_context_synchronously
    context.push(
      '/inbox/id/$senderId',
      extra: room,
    );
  }

  SingleChildScrollView details(String? planUid) {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CarouselSlider(
          options: CarouselOptions(
              viewportFraction: 1.0,
              height: 250.0,
              enlargeFactor: 0,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {}),
          items: [
            Image(
                image: NetworkImage(
                  widget.listing.images!.first.url!,
                ),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover)
          ]),
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
                          fontSize: 22, fontWeight: FontWeight.bold))),
              DisplayText(
                  text:
                      'Location: ${widget.listing.province}, ${widget.listing.city}',
                  lines: 4,
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.labelLarge?.fontSize)),
              DisplayText(
                  text: widget.listing.category,
                  lines: 1,
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.labelLarge?.fontSize)),
              const Divider(),
              DisplayText(
                  text: 'Description',
                  lines: 1,
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleLarge?.fontSize)),
              if (widget.listing.description.length > 40) ...[
                TextInBottomSheet(
                    "About this space", widget.listing.description, context)
              ] else ...[
                DisplayText(
                    text: widget.listing.description,
                    lines: 5,
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelLarge?.fontSize))
              ],
            ],
          )),
      const Divider(),

      Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(children: [
              Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('Working Hours',
                      style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.fontSize))),
              Text(
                  '${widget.listing.availableDeals!.first.startTime.format(context)} - ${widget.listing.availableDeals!.first.endTime.format(context)}',
                  style: const TextStyle(fontSize: 12))
            ]),
            Column(children: [
              Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text('Available Days',
                      style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.fontSize))),
              Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                      getWorkingDays(
                          widget.listing.availableDeals!.first.workingDays),
                      style: const TextStyle(fontSize: 12)))
            ])
          ])),
      const SizedBox(height: 12),
      const Divider(),
      ref
          .watch(
              getCooperativeProvider(widget.listing.cooperative.cooperativeId))
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
                    // createRoom(context, widget.listing.publisherId);
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: FilledButton(
              onPressed: () {
                addCurrentTrip(context, planUid);
              },
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                      const Size(double.infinity, 45))),
              child: const Text('Add this to current trip'))),
    ]));
  }

  SingleChildScrollView menuAndDeals() {
    return SingleChildScrollView(
      // show the deals first
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: DisplayText(
                text: 'Deals that you may like',
                lines: 1,
                style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.titleLarge?.fontSize)),
          ),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.listing.availableDeals!.length,
              itemBuilder: ((context, index) {
                return Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      ImageSlider(
                          images: widget.listing.availableDeals![index].dealImgs
                              .map((img) => img.url!)
                              .toList(),
                          height: MediaQuery.sizeOf(context).height / 5.5,
                          width: double.infinity,
                          radius: BorderRadius.circular(10)),
                      Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          widget.listing.availableDeals![index]
                                              .dealName,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          "₱${widget.listing.availableDeals![index].price.toString()}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold))
                                    ]),
                                const SizedBox(height: 10),
                                Text(
                                    widget.listing.availableDeals![index]
                                        .dealDescription,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal))
                              ]))
                    ]));
              })),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: DisplayText(
                text: 'Menu',
                lines: 1,
                style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.titleLarge?.fontSize)),
          ),
          // Menu Images
          // replace with ImageSlider instead of Carousel Slider
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: ImageSlider(
                images:
                    (widget.listing.menuImgs)?.map((img) => img.url!).toList(),
                height: 100,
                width: double.infinity,
                radius: BorderRadius.circular(10)),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView menu() {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 10),
      // Padding(
      //   padding: const EdgeInsets.only(left: 10.0),
      //   child: DisplayText(
      //       text: 'Menu',
      //       lines: 1,
      //       style: TextStyle(
      //           fontSize: Theme.of(context).textTheme.titleLarge?.fontSize)),
      // ),
      // const SizedBox(height: 10),
      // Menu Images
      // replace with ImageSlider instead of Carousel Slider
      // Padding(
      //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      //   child: ImageSlider(
      //       images:
      //           (widget.listing.menuImgs ?? []).map((img) => img.url!).toList(),
      //       height: MediaQuery.sizeOf(context).height / 1.3,
      //       width: double.infinity,
      //       radius: BorderRadius.circular(10)),
      // ),
      // const SizedBox(height: 10),
      // const Divider(),
      // Padding(
      //   padding: const EdgeInsets.only(left: 10.0),
      //   child: DisplayText(
      //       text: 'Deals that you may like',
      //       lines: 1,
      //       style: TextStyle(
      //           fontSize: Theme.of(context).textTheme.titleLarge?.fontSize)),
      // ),
      ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.listing.availableDeals!.length,
          itemBuilder: ((context, index) {
            return Card(
                elevation: 4.0,
                margin: const EdgeInsets.all(8.0),
                child: Column(children: [
                  ImageSlider(
                      images: widget.listing.availableDeals![index].dealImgs
                          .map((img) => img.url!)
                          .toList(),
                      height: MediaQuery.sizeOf(context).height / 5.5,
                      width: double.infinity,
                      radius: BorderRadius.circular(10)),
                  Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      widget.listing.availableDeals![index]
                                          .dealName,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      "₱${widget.listing.availableDeals![index].price.toString()}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold))
                                ]),
                            const SizedBox(height: 10),
                            Text(
                                widget.listing.availableDeals![index]
                                    .dealDescription,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal))
                          ]))
                ]));
          })),
    ]));
  }

  void addCurrentTrip(BuildContext context, String? planUid) {
    final selectedDate = ref.read(selectedDateProvider);

    // edit the current plan
    PlanActivity activity = PlanActivity(
        // create a random key for the activity
        key: DateTime.now().millisecondsSinceEpoch.toString(),
        listingId: widget.listing.uid,
        category: widget.listing.category,
        dateTime: selectedDate,
        title: widget.listing.title,
        imageUrl: widget.listing.images!.first.url!,
        description: widget.listing.description);

    ref
        .read(plansControllerProvider.notifier)
        .addActivityToPlan(planUid!, activity, context);
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
