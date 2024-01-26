import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_stepper/stepper.dart';
import 'package:lakbay/core/providers/storage_repository_providers.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/listings/widgets/image_picker_form_field.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/listing_model.dart';

class AddAccommodation extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  final String category;
  const AddAccommodation(
      {required this.coop, required this.category, super.key});

  @override
  ConsumerState<AddAccommodation> createState() => _AddAccommodationState();
}

class _AddAccommodationState extends ConsumerState<AddAccommodation> {
  // global key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // stepper -- change if needed for specific category
  // initial values
  String type = 'Nature-Based';
  int activeStep = 0;
  int upperBound = 6;

  // controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController =
      TextEditingController(text: 'Eastwood City');
  String mapAddress = "";
  List<File>? _images;

  List<List<File>> roomImages = [];
  List<AvailableRoom> availableRooms = [];

  TimeOfDay checkIn = TimeOfDay.now();
  TimeOfDay checkOut = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed.
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();

    super.dispose();
  }

  void submitAddListing() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Prepare data for storeFiles
      final imagePath = 'listings/${widget.coop.name}';
      final ids = _images!.map((image) => image.path.split('/').last).toList();

      // Upload images to firebase storage
      ref
          .read(storageRepositoryProvider)
          .storeFiles(
            path: imagePath,
            ids: ids,
            files: _images!,
          )
          .then((value) => value.fold(
                (failure) => debugPrint('Failed to upload images: $failure'),
                (imageUrls) async {
                  ListingCooperative cooperative = ListingCooperative(
                      cooperativeId: widget.coop.uid!,
                      cooperativeName: widget.coop.name);
                  ListingModel listing = ListingModel(
                      availableRooms: availableRooms,
                      address: _addressController.text,
                      category: widget.category,
                      city: "",
                      images: _images!.map((image) {
                        final imagePath =
                            'listings/${widget.coop.name}/${image.path.split('/').last}';
                        return ListingImages(
                          path: imagePath,
                        );
                      }).toList(),
                      cooperative: cooperative,
                      description: _descriptionController.text,
                      province: "",
                      publisherId: ref.read(userProvider)!.uid,
                      publisherName: ref.read(userProvider)!.name,
                      title: _titleController.text,
                      type: type);
                  listing = await processRoomImages(listing);
                  listing = listing.copyWith(
                    images: listing.images!.asMap().entries.map((entry) {
                      return entry.value.copyWith(url: imageUrls[entry.key]);
                    }).toList(),
                  );
                  debugPrintJson(listing);
                  if (mounted) {
                    ref
                        .read(listingControllerProvider.notifier)
                        .addListing(listing, context);
                  }
                },
              ));

      // Add Listing
      //
    }
  }

  Future<ListingModel> processRoomImages(ListingModel listing) async {
    final images = roomImages;
    final imagePath = 'listings/${widget.coop.name}';
    final ids = images
        .expand((fileList) => fileList.map((file) => file.path.split('/').last))
        .toList();
    await ref
        .read(storageRepositoryProvider)
        .storeListNestedFiles(
          path: imagePath,
          ids: ids,
          filesLists: images,
        )
        .then(
          (value) => value.fold(
            (failure) => debugPrint('Failed to upload images: $failure'),
            (imageUrls) {
              debugPrintJson(listing);
              listing = listing.copyWith(
                availableRooms: listing.availableRooms!
                    .asMap()
                    .map((roomIndex, room) {
                      // Get the corresponding list of image URLs for this room
                      List<String> roomImageUrls = imageUrls[roomIndex];

                      // Map each image in the room to its corresponding URL
                      List<ListingImages> updatedImages = room.images!
                          .asMap()
                          .map((imageIndex, image) {
                            // Ensure we have a URL for each image
                            if (imageIndex < roomImageUrls.length) {
                              return MapEntry(
                                  imageIndex,
                                  image.copyWith(
                                      url: roomImageUrls[imageIndex]));
                            }
                            return MapEntry(imageIndex, image);
                          })
                          .values
                          .toList();
                      return MapEntry(
                          roomIndex, room.copyWith(images: updatedImages));
                    })
                    .values
                    .toList(),
              );
              debugPrintJson(listing);
            },
          ),
        );
    return listing;
  }

  @override
  Widget build(BuildContext context) {
    debugPrintJson("File Name: add_accommodation.dart");
    final isLoading = ref.watch(listingControllerProvider);
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          context.pop();
        },
        child: Scaffold(
            appBar: AppBar(title: const Text('Add Accommodation')),
            bottomNavigationBar: bottomAppBar(),
            body: isLoading
                ? const Loader()
                : SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Column(children: [
                              steppers(context),
                              stepForm(context)
                            ]))))));
  }

  Column steppers(BuildContext context) {
    return Column(
      children: [
        IconStepper(
          lineColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          stepColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          activeStepColor: Theme.of(context).colorScheme.primary,
          enableNextPreviousButtons: false,
          icons: [
            Icon(
              Icons.type_specimen_outlined,
              color: Theme.of(context).colorScheme.background,
            ),
            Icon(
              Icons.details_outlined,
              color: Theme.of(context).colorScheme.background,
            ),
            Icon(
              Icons.meeting_room_outlined,
              color: Theme.of(context).colorScheme.background,
            ),
            Icon(
              Icons.map_outlined,
              color: Theme.of(context).colorScheme.background,
            ),
            Icon(
              Icons.task,
              color: Theme.of(context).colorScheme.background,
            ),
            Icon(
              Icons.policy,
              color: Theme.of(context).colorScheme.background,
            ),
            Icon(
              Icons.summarize_outlined,
              color: Theme.of(context).colorScheme.background,
            ),
          ],

          // activeStep property set to activeStep variable defined above.
          activeStep: activeStep,

          // This ensures step-tapping updates the activeStep.
          onStepReached: (index) {
            setState(() {
              activeStep = index;
            });
          },
        ),
        header(),
      ],
    );
  }

  BottomAppBar bottomAppBar() {
    return BottomAppBar(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      if (activeStep == 0) ...[
        TextButton(
            onPressed: () {
              context.pop();
              // ref.read(navBarVisibilityProvider.notifier).show();
            },
            child: const Text('Cancel'))
      ] else ...[
        TextButton(
            onPressed: () {
              setState(() {
                activeStep--;
              });
            },
            child: const Text('Back'))
      ],

      // Next
      if (activeStep != upperBound) ...[
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              if (activeStep < upperBound) {
                setState(() {
                  activeStep++;
                });
              }
            },
            child: Text(
              'Next',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ))
      ] else ...[
        TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              submitAddListing();
            },
            child: Text(
              'Submit',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ))
      ]
    ]));
  }

  Widget header() {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DisplayText(
          text: headerText(),
          lines: 2,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String headerText() {
    switch (activeStep) {
      case 1:
        return 'Add details';

      case 2:
        return 'Add Rooms';

      case 3:
        return 'Set Location';

      case 4:
        return 'Add Fixed Tasks';

      case 5:
        return 'Add Policies';

      case 6:
        return 'Review Listing';

      default:
        return 'Choose Type';
    }
  }

  Widget chooseType(BuildContext context) {
    List<Map<String, dynamic>> types = [
      {'name': 'Sun and Beach', 'icon': Icons.beach_access_outlined},
      {
        'name': 'Health, Wellness, and Retirement',
        'icon': Icons.local_hospital_outlined
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: types.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 120,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: type == types[index]['name']
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primary.withOpacity(0.0),
                  width: 1,
                ),
              ),
              surfaceTintColor: Theme.of(context).colorScheme.background,
              child: InkWell(
                onTap: () {
                  setState(() {
                    type = types[index]['name'];
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      Icon(
                        types[index]['icon'],
                        size: 35,
                        color: Theme.of(context).colorScheme.primary,
                      ),

                      // Title
                      Text(
                        types[index]['name'],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget addDetails(BuildContext context) {
    TextEditingController checkInController = TextEditingController();
    TextEditingController checkOutController = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Listing Title*',
            helperText: '*required',
            border: OutlineInputBorder(),
            floatingLabelBehavior:
                FloatingLabelBehavior.always, // Keep the label always visible
            hintText: "Hotel Lakbay",
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _descriptionController,
          maxLines: 1,
          decoration: const InputDecoration(
            labelText: 'Description*',
            helperText: '*required',
            border: OutlineInputBorder(),
            floatingLabelBehavior:
                FloatingLabelBehavior.always, // Keep the label always visible
            hintText: "Hotel near the beach....",
          ),
        ),
        SizedBox(height: MediaQuery.sizeOf(context).height / 25),
        TextFormField(
          controller: checkInController,
          maxLines: 1,
          decoration: const InputDecoration(
            labelText: 'Check In*',
            helperText: '*required',
            border: OutlineInputBorder(),
            floatingLabelBehavior:
                FloatingLabelBehavior.always, // Keep the label always visible
            hintText: "11:30",
          ),
          readOnly: true,
          onTap: () {
            setState(() async {
              checkIn = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    initialEntryMode: TimePickerEntryMode.inputOnly,
                  ) ??
                  TimeOfDay.now();
              if (context.mounted) {
                checkInController.text = checkIn.format(context);
              }
            });
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: checkOutController,
          maxLines: null,
          decoration: const InputDecoration(
            labelText: 'Check Out*',
            helperText: '*required',
            border: OutlineInputBorder(),
            floatingLabelBehavior:
                FloatingLabelBehavior.always, // Keep the label always visible
            hintText: "1:30",
          ),
          readOnly: true,
          onTap: () {
            setState(() async {
              checkIn = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    initialEntryMode: TimePickerEntryMode.inputOnly,
                  ) ??
                  TimeOfDay.now();
              if (context.mounted) {
                checkInController.text = checkIn.format(context);
              }
            });
          },
        ),
        const SizedBox(height: 10),
        GestureDetector(
          child: Row(
            children: [
              Expanded(
                child: ImagePickerFormField(
                  height: MediaQuery.sizeOf(context).height / 2.5,
                  width: MediaQuery.sizeOf(context).width,
                  context: context,
                  initialValue: _images,
                  onSaved: (List<File>? files) {
                    _images = files;
                  },
                  validator: (List<File>? files) {
                    if (files == null || files.isEmpty) {
                      return 'Please select some images';
                    }
                    return null;
                  },
                  onImagesSelected: (List<File> files) {
                    _images = files;
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget addRoomDetails(BuildContext context) {
    return Column(children: [
      Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  // String roomId = "";
                  TextEditingController roomIdController =
                      TextEditingController();
                  // num price = 0;
                  TextEditingController priceController =
                      TextEditingController();
                  num guests = 0;
                  num bedrooms = 0;
                  num beds = 0;
                  num bathrooms = 0;
                  List<File> images = [];
                  return addRoomBottomSheet(images, roomIdController,
                      priceController, guests, bedrooms, beds, bathrooms);
                });
          },
          child: const Text('Add Room'),
        ),
      ),
      ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: availableRooms.length,
          itemBuilder: ((context, index) {
            return Card(
              elevation: 4.0, // Slight shadow for depth
              margin: const EdgeInsets.all(8.0), // Space around the card
              child: Column(
                children: [
                  ImageSlider(
                    images: roomImages[index],
                    height: MediaQuery.of(context).size.height /
                        5, // Reduced height
                    width: double.infinity,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.all(12.0), // Reduced overall padding
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.vpn_key,
                                size: 16), // Icon representing a key or ID
                            const SizedBox(width: 4),
                            Text(
                              "Room ID: ${availableRooms[index].roomId}",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.money, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  "Price: ₱${availableRooms[index].price}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const Text(" • ",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight
                                        .bold)), // Bigger, bolder dot separator

                            Row(
                              children: [
                                const Icon(Icons.people_alt_outlined, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  "Guests: ${availableRooms[index].guests}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.meeting_room_outlined,
                                    size: 16), // Replace with appropriate icon
                                const SizedBox(width: 4),
                                Text(
                                  "Bedrooms: ${availableRooms[index].bedrooms}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const Text(" • ",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight
                                        .bold)), // Bigger, bolder dot separator

                            Row(
                              children: [
                                const Icon(Icons.bed_outlined,
                                    size: 16), // Replace with appropriate icon
                                const SizedBox(width: 4),
                                Text(
                                  "Beds: ${availableRooms[index].beds}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const Text(" • ",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight
                                        .bold)), // Bigger, bolder dot separator

                            Row(
                              children: [
                                const Icon(Icons.bathtub_outlined,
                                    size: 16), // Replace with appropriate icon
                                const SizedBox(width: 4),
                                Text(
                                  "Bathrooms: ${availableRooms[index].bathrooms}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(
                            height: 8), // Reduced spacing before the buttons
                      ],
                    ),
                  ),
                ],
              ),
            );
          })),
    ]);
  }

  DraggableScrollableSheet addRoomBottomSheet(
      List<File> images,
      TextEditingController roomIdController,
      TextEditingController priceController,
      num guests,
      num bedrooms,
      num beds,
      num bathrooms) {
    return DraggableScrollableSheet(
        initialChildSize: 0.80,
        expand: false,
        builder: (context, scrollController) {
          return StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: SizedBox(
                  height: MediaQuery.sizeOf(context).height / 1,
                  width: double.infinity,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
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
                                  // this.images.add(images);
                                  roomImages.add(images);
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
                                  // this.images.add(images);
                                  roomImages.add(images);
                                },
                              ),
                            ]))),
                        const SizedBox(height: 15),
                        Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20.0),
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
                        SizedBox(
                            height: MediaQuery.sizeOf(context).height / 50),
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
                              bottom: BorderSide(
                                  color: Theme.of(context).dividerColor),
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
                              bottom: BorderSide(
                                  color: Theme.of(context).dividerColor),
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
                              bottom: BorderSide(
                                  color: Theme.of(context).dividerColor),
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
                                Text('$beds',
                                    style: const TextStyle(fontSize: 16)),
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
                              bottom: BorderSide(
                                  color: Theme.of(context).dividerColor),
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
                        ElevatedButton(
                            onPressed: () {
                              AvailableRoom room = AvailableRoom(
                                  available: true,
                                  images: images.map((image) {
                                    final imagePath =
                                        'listings/${widget.coop.name}/${image.path.split('/').last}';
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
                              this.setState(() {
                                int index = availableRooms.indexWhere(
                                    (element) =>
                                        element.roomId ==
                                        roomIdController.text);
                                if (index == -1) {
                                  availableRooms.add(room);
                                } else {
                                  availableRooms[index] = room;
                                }
                              });
                              context.pop();
                            },
                            child: const Text("Confirm"))
                      ])),
            );
          });
        });
  }

  Widget addLocation(BuildContext context) {
    return Column(children: [
      TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Address*',
            helperText: '*required',
            border: OutlineInputBorder(),
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          }),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          setState(() {
            mapAddress = _addressController.text;
          });
        },
        child: const Text('Update Map'),
      ),

      const SizedBox(height: 10),

      // Google Map
      SizedBox(
        height: 400,
        child: MapWidget(address: mapAddress),
      )
    ]);
  }

  Widget addFixedTasks(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(children: []),
    );
  }

  Widget addPolicies(BuildContext context) {
    return const Column();
  }

  Widget reviewListing(BuildContext context) {
    return Column(
      children: <Widget>[
        // Step 0
        ListTile(
          title: const Text('Category',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          subtitle: Text(widget.category),
        ),
        ListTile(
          title: const Text('Type',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          subtitle: Text(type),
        ),
        const Divider(),
        // Step 1
        ListTile(
          title: const Text('Title',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          subtitle: Text(_titleController.text),
        ),
        ListTile(
          title: const Text('Description',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          subtitle: Text(_descriptionController.text),
        ),
        // Step 2

        const Divider(),
        // Step 3
        ListTile(
          title: const Text('Address',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          subtitle: Text(_addressController.text),
        ),
        const Divider(),
        // Step 4
        // ListTile(
        //   title: const Text('Image',
        //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        //   subtitle: _image != null ? Image.file(_image!) : const Text('None'),
        // ),
        const Divider(),

        // Step 5
      ],
    );
  }

  Widget stepForm(BuildContext context) {
    switch (activeStep) {
      case 1:
        return addDetails(context);
      case 2:
        return addRoomDetails(context);
      case 3:
        return addLocation(context);
      case 4:
        return addFixedTasks(context);
      case 5:
        return addPolicies(context);
      case 6:
        return reviewListing(context);

      default:
        return chooseType(context);
    }
  }
}
