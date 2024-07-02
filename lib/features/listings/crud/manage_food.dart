import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/common/widgets/text_in_bottomsheet.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class ManageFood extends ConsumerStatefulWidget {
  final ListingModel listing;
  const ManageFood({super.key, required this.listing});

  @override
  ConsumerState<ManageFood> createState() => _ManageFoodState();
}

class _ManageFoodState extends ConsumerState<ManageFood> {
  List<SizedBox> tabs = [
    const SizedBox(width: 100, child: Tab(child: Text('Bookings'))),
    const SizedBox(width: 100, child: Tab(child: Text('Details')))
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
    // final planUid = ref.read(currentPlanIdProvider);
    // final isLoading = ref.watch(plansControllerProvider);
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          ref.read(navBarVisibilityProvider.notifier).show();
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
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ))
                        : Text(widget.listing.title,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                    bottom: TabBar(
                      tabAlignment: TabAlignment.center,
                      labelPadding: EdgeInsets.zero,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: tabs,
                    )),
                body: TabBarView(children: [bookings(), details()]))));
  }

  SingleChildScrollView details() {
    List<String?> imageUrls =
        widget.listing.images!.map((listingImage) => listingImage.url).toList();

    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ImageSlider(
          images: imageUrls,
          height: MediaQuery.sizeOf(context).height * .4,
          width: MediaQuery.sizeOf(context).width,
          radius: BorderRadius.zero),

      Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 14.0),
            child: DisplayText(
                text: widget.listing.title,
                lines: 2,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          DisplayText(
              text: 'Location: ${widget.listing.address}',
              lines: 4,
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelLarge?.fontSize)),
          DisplayText(
            text: "${widget.listing.category} · ${widget.listing.type}",
            lines: 1,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
            ),
          ),
          const Divider(),
          DisplayText(
            text: 'Description',
            lines: 1,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
            ),
          ),
          if (widget.listing.description.length > 40) ...[
            TextInBottomSheet(
                "About this space", widget.listing.description, context)
          ] else ...[
            DisplayText(
              text: widget.listing.description,
              lines: 5,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
              ),
            )
          ],
        ]),
      ),
      const SizedBox(height: 10),
      const Divider(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Working Hours',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                  ),
                ),
              ),
              Text(
                '${widget.listing.availableDeals?.first.startTime} - ${widget.listing.availableDeals?.first.endTime}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  'Available Days',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(right: 8.0),
              //   child: Text(
              //     getWorkingDays(
              //         widget.listing.availableTransport!.workingDays!),
              //     style: const TextStyle(fontSize: 12),
              //   ),
              // ),
            ],
          ),
        ]),
      ),
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

      // this box is so that the edit listing doesn't cover any content
      SizedBox(
        height: MediaQuery.sizeOf(context).height / 35,
      ),
      const Divider(),
      Container(
        margin: const EdgeInsets.only(bottom: 0, right: 0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: FilledButton(
              onPressed: () {
                // Handle button tap here
                // Perform action when 'Edit Listing' button is tapped
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(4.0), // Adjust the radius as needed
                ),
              ),
              child: const Text('Edit Listing'),
            ),
          ),
        ),
      ),
    ]));
  }

  Widget bookings() {
    return ref.watch(getAllBookingsProvider(widget.listing.uid!)).when(
        data: (List<ListingBookings> bookings) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: bookings.length,
              itemBuilder: ((context, index) {
                final booking = bookings[index];
                num needsContribution = 0;
                // String formattedStartDate =
                //     DateFormat('MMMM dd').format(bookings[index].startDate!);

                ref
                    .watch(getBookingTasksByBookingId(
                        (booking.listingId, booking.id!)))
                    .when(
                        data: (List<BookingTask> bookingTasks) {
                          // ignore: unused_local_variable
                          for (var bookingTask in bookingTasks) {
                            needsContribution = needsContribution + 1;
                          }
                        },
                        error: (error, stackTrace) => ErrorText(
                              error: error.toString(),
                              stackTrace: stackTrace.toString(),
                            ),
                        loading: () => const Loader());
                return null;
              }));
        },
        error: (error, stackTrace) => Scaffold(
              body: ErrorText(
                error: error.toString(),
                stackTrace: stackTrace.toString(),
              ),
            ),
        loading: () => const Scaffold(body: Loader()));
  }
}
