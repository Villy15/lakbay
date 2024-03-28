import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/providers/storage_repository_providers.dart';
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
import 'package:lakbay/features/listings/widgets/image_picker_form_field.dart';
import 'package:lakbay/features/trips/plan/plan_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class ManageAccommodation extends ConsumerStatefulWidget {
  final ListingModel listing;
  const ManageAccommodation({super.key, required this.listing});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManageAccommodationState();
}

class _ManageAccommodationState extends ConsumerState<ManageAccommodation> {
  List<SizedBox> tabs = [
    const SizedBox(
      width: 100.0,
      child: Tab(
        // icon: Icon(Icons.meeting_room_outlined),
        child: Text('Bookings'),
      ),
    ),
    const SizedBox(
      width: 100.0,
      child: Tab(
        // icon: Icon(Icons.location_pin),
        child: Text('Destination'),
      ),
    ),
    const SizedBox(
      width: 100.0,
      child: Tab(
        // icon: Icon(Icons.meeting_room_outlined),
        child: Text('Rooms'),
      ),
    ),
  ];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  AppBar _appBar(String title, BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          // fontFamily: 'Satisfy',
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottom: TabBar(
        tabAlignment: TabAlignment.center,
        labelPadding: EdgeInsets.zero,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: tabs,
      ),
    );
  }

  Future<AvailableRoom> processRoomImages(
      AvailableRoom room, List<File> roomImages) async {
    final images = roomImages;
    final imagePath = 'listings/${widget.listing.cooperative.cooperativeName}';
    final ids = images.map((file) => file.path.split('/').last).toList();
    await ref
        .read(storageRepositoryProvider)
        .storeFiles(
          path: imagePath,
          ids: ids,
          files: images,
        )
        .then(
          (value) => value.fold(
            (failure) => debugPrint('Failed to upload images: $failure'),
            (imageUrls) {
              room = room.copyWith(
                images: images.map((image) {
                  final imagePath =
                      'listings/${widget.listing.cooperative.cooperativeName}/${image.path.split('/').last}';
                  return ListingImages(
                    path: imagePath,
                  );
                }).toList(),
              );
              room = room.copyWith(
                images: room.images!.asMap().entries.map((entry) {
                  return entry.value.copyWith(url: imageUrls[entry.key]);
                }).toList(),
              );
            },
          ),
        );
    return room;
  }

  Widget addRoomDialog() {
    List<File> images = [];
    TextEditingController roomIdController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    num guests = 0;
    num bedrooms = 0;
    num beds = 0;
    num bathrooms = 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Room'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Dialog.fullscreen(
          child: StatefulBuilder(builder: (context, setState) {
        return SingleChildScrollView(
          child: SizedBox(
              height: MediaQuery.sizeOf(context).height / 1,
              width: double.infinity,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GestureDetector(
                            child: Row(children: [
                          Icon(Icons.image_outlined,
                              color: Theme.of(context).iconTheme.color),
                          const SizedBox(width: 15),
                          ImagePickerFormField(
                            height: MediaQuery.sizeOf(context).height / 5,
                            width: MediaQuery.sizeOf(context).width / 1.3,
                            context: context,
                            initialValue: images,
                            onSaved: (List<File>? files) {
                              images.clear();
                              images.addAll(files!);
                            },
                            validator: (List<File>? files) {
                              if (files == null || files.isEmpty) {
                                return 'Please select some images';
                              }
                              return null;
                            },
                            onImagesSelected: (List<File> files) {
                              images.clear();
                              images.addAll(files);
                            },
                          ),
                        ]))),
                    const SizedBox(height: 15),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                            controller: roomIdController,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.title_outlined),
                                border: OutlineInputBorder(),
                                labelText: "Room Id",
                                floatingLabelBehavior: FloatingLabelBehavior
                                    .always, // Keep the label always visible
                                hintText: "101",
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 12.0)),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            })),
                    SizedBox(height: MediaQuery.sizeOf(context).height / 50),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: priceController,
                        maxLines: null,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.money_outlined,
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Price',
                          floatingLabelBehavior: FloatingLabelBehavior
                              .always, // Keep the label always visible
                          hintText: "4500",
                          prefix: Text('₱'),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12), // Adjust padding here
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Theme.of(context).dividerColor),
                        ),
                      ),
                      child: ListTile(
                        title: const Row(
                          children: [
                            Icon(Icons.people_alt_outlined),
                            SizedBox(width: 10),
                            Text('Guests'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (guests >= 1) {
                                  setState(() {
                                    guests--;
                                  });
                                }
                              },
                            ),
                            const SizedBox(width: 10),
                            Text('$guests',
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  guests++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Theme.of(context).dividerColor),
                        ),
                      ),
                      child: ListTile(
                        title: const Row(
                          children: [
                            Icon(Icons.king_bed_outlined),
                            SizedBox(width: 10),
                            Text('Bedrooms'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (bedrooms >= 1) {
                                  setState(() {
                                    bedrooms--;
                                  });
                                }
                              },
                            ),
                            const SizedBox(width: 10),
                            Text('$bedrooms',
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  bedrooms++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Theme.of(context).dividerColor),
                        ),
                      ),
                      child: ListTile(
                        title: const Row(
                          children: [
                            Icon(Icons.single_bed_outlined),
                            SizedBox(width: 10),
                            Text('Beds'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (beds >= 1) {
                                  setState(() {
                                    beds--;
                                  });
                                }
                              },
                            ),
                            const SizedBox(width: 10),
                            Text('$beds', style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  beds++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Theme.of(context).dividerColor),
                        ),
                      ),
                      child: ListTile(
                        title: const Row(
                          children: [
                            Icon(Icons.bathtub_outlined),
                            SizedBox(width: 10),
                            Text('Bathrooms'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (bathrooms >= 1) {
                                  setState(() {
                                    bathrooms--;
                                  });
                                }
                              },
                            ),
                            const SizedBox(width: 10),
                            Text('$bathrooms',
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  bathrooms++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 30,
                    ),
                    FilledButton(
                        onPressed: () async {
                          AvailableRoom room = AvailableRoom(
                              available: true,
                              images: images.map((image) {
                                final imagePath =
                                    'listings/${widget.listing.cooperative.cooperativeName}/${image.path.split('/').last}';
                                return ListingImages(
                                  path: imagePath,
                                );
                              }).toList(),
                              roomId: roomIdController.text,
                              bathrooms: bathrooms,
                              bedrooms: bedrooms,
                              beds: beds,
                              guests: guests,
                              price: num.parse(priceController.text));
                          room = await processRoomImages(room, images);
                          if (context.mounted) {
                            ref
                                .read(listingControllerProvider.notifier)
                                .addRoom(context, widget.listing, room);
                          }

                          // context.pop();
                        },
                        child: const Text("Confirm"))
                  ])),
        );
      })),
    );
  }

  Widget bookings() {
    return ref.watch(getAllBookingsProvider(widget.listing.uid!)).when(
          data: (List<ListingBookings> bookings) {
            // Get all listings by the cooperative
            return ListView.builder(
                // physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: bookings.length,
                itemBuilder: ((context, index) {
                  String formattedStartDate =
                      DateFormat('MMMM dd').format(bookings[index].startDate!);
                  String formattedEndDate =
                      DateFormat('MMMM dd').format(bookings[index].endDate!);
                  return Card(
                    elevation: 1.0,
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: Row(
                            children: [
                              Text(
                                "$formattedStartDate - ",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                formattedEndDate,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                "Room: ${bookings[index].roomId} | ",
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Guests: ${bookings[index].guests}",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width * .5,
                              child: FilledButton(
                                onPressed: () {
                                  context.push(
                                    '/market/${bookings[index].category}/booking_details',
                                    extra: {
                                      'booking': bookings[index],
                                      'listing': widget.listing
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        4.0), // Adjust the radius as needed
                                  ),
                                ),
                                child: const Text("Booking Details"),
                              ),
                            ))
                      ],
                    ),
                  );
                }));
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

  Widget destination(String? planUid) {
    return Stack(
      children: [
        SingleChildScrollView(
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
                      text:
                          "${widget.listing.category} · ${widget.listing.type}",
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
                    TextInBottomSheet("About this space",
                        widget.listing.description, context),

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

              // this box is so that the edit listing doesn't cover any content
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 10,
              )
            ],
          ),
        ),
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
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(double.infinity, 45),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius
                          .zero, // Zero out the border radius to make it flat at the bottom
                    ),
                  ),
                ),
                child: const Text('Edit Listing'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget rooms() {
    return ref.watch(getAllRoomsByListingIdProvider(widget.listing.uid!)).when(
        data: (List<AvailableRoom> rooms) {
          return Stack(
            children: [
              ListView.builder(
                  // physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: rooms.length,
                  itemBuilder: ((context, index) {
                    List<String?> imageUrls = rooms[index]
                        .images!
                        .map((listingImage) => listingImage.url)
                        .toList();
                    return Card(
                      elevation: 1.0, // Slight shadow for depth
                      margin:
                          const EdgeInsets.all(8.0), // Space around the card
                      child: Column(
                        children: [
                          ImageSlider(
                              images: imageUrls,
                              height: MediaQuery.of(context).size.height /
                                  3.5, // Reduced height
                              width: double.infinity,
                              radius: BorderRadius.circular(10)),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 10,
                                top: 10,
                                bottom: 10), // Reduced overall padding
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${rooms[index].bedrooms} Bedroom",
                                          style: const TextStyle(
                                            fontSize:
                                                18, // Increased font size, larger than the previous one
                                            fontWeight:
                                                FontWeight.bold, // Bold text
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "₱${rooms[index].price}",
                                                style: TextStyle(
                                                    fontSize:
                                                        16, // Size for the price
                                                    fontWeight: FontWeight
                                                        .bold, // Bold for the price
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface),
                                              ),
                                              TextSpan(
                                                text: " per night",
                                                style: TextStyle(
                                                    fontSize:
                                                        14, // Smaller size for 'per night'
                                                    fontStyle: FontStyle
                                                        .italic, // Italicized 'per night'
                                                    fontWeight: FontWeight
                                                        .normal, // Normal weight for 'per night'
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Center(
                                        child: FilledButton(
                                      onPressed: () {},
                                      style: FilledButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              4.0), // Adjust the radius as needed
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50, vertical: 15),
                                      ),
                                      child: const Text(
                                        'Edit Room',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    )),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          // Action to perform on tap, e.g., show a dialog or navigate
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    const Text("Room Details"),
                                                content: SizedBox(
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height /
                                                          4,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width /
                                                          1.5,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                              Icons
                                                                  .people_alt_outlined,
                                                              size: 30),
                                                          Text(
                                                            "Guests: ${rooms[index].guests}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        18),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                              Icons.bed_rounded,
                                                              size: 30),
                                                          Text(
                                                            "Beds: ${rooms[index].beds}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        18),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                              Icons
                                                                  .bathtub_outlined,
                                                              size: 30),
                                                          Text(
                                                            "Bathrooms: ${rooms[index].bathrooms}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        18),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: const Text("Close"),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Room Details",
                                                style: TextStyle(
                                                    // color: Colors.grey,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface
                                                        .withOpacity(0.5),
                                                    fontStyle: FontStyle
                                                        .italic // Underline for emphasis
                                                    ),
                                              ),
                                              const WidgetSpan(
                                                child: Icon(
                                                  Icons
                                                      .keyboard_arrow_down, // Arrow pointing down icon
                                                  size:
                                                      16.0, // Adjust the size to fit your design
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  })),
              Container(
                margin: const EdgeInsets.only(bottom: 25, right: 25),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: FilledButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return addRoomDialog();
                            });
                      },
                      style: FilledButton.styleFrom(
                        shape: const CircleBorder(), // Circular shape
                        padding: const EdgeInsets.all(
                            15), // Padding to make the button larger
                      ),
                      child: const Icon(Icons.add), // Plus icon
                    )),
              )
            ],
          );
        },
        error: ((error, stackTrace) => Scaffold(
            body: ErrorText(
                error: error.toString(), stackTrace: stackTrace.toString()))),
        loading: () => const Scaffold(body: Loader()));
  }

  @override
  Widget build(BuildContext context) {
    final planUid = ref.read(currentPlanIdProvider);
    final isLoading = ref.watch(plansControllerProvider);
    debugPrintJson("File Name: manage_accommodation.dart");
    // final user = ref.watch(userProvider);
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
            resizeToAvoidBottomInset: true,
            // Add appbar with back button
            appBar: _appBar(widget.listing.title, context),
            body: TabBarView(
              children: [
                bookings(),
                isLoading ? const Loader() : destination(planUid),
                rooms(),
              ],
            ),
          ),
        ));
  }
}
