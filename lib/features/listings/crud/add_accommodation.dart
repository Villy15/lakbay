import 'dart:io';

import 'package:flutter/gestures.dart';
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
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/listings/widgets/image_picker_form_field.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/wrappers/committee_params.dart';

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
  final TextEditingController checkInController = TextEditingController();
  final TextEditingController checkOutController = TextEditingController();

  String mapAddress = "";
  List<File>? _images;

  List<List<File>> roomImages = [];
  List<AvailableRoom> availableRooms = [];

  TimeOfDay checkIn = TimeOfDay.now();
  TimeOfDay checkOut = TimeOfDay.now();

  List<Task>? fixedTasks = [];

  final TextEditingController _downpaymentRateController =
      TextEditingController();
  final TextEditingController _cancellationRateController =
      TextEditingController();
  final TextEditingController _cancellationPeriodController =
      TextEditingController();

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
                    checkIn: DateTime(DateTime.now().year)
                        .copyWith(hour: checkIn.hour, minute: checkIn.minute),
                    checkOut: DateTime(DateTime.now().year)
                        .copyWith(hour: checkOut.hour, minute: checkOut.minute),
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
                    type: type,
                    fixedTasks: fixedTasks,
                    downpaymentRate:
                        num.parse((_downpaymentRateController.text)) / 100,
                    cancellationRate:
                        num.parse((_cancellationRateController.text)) / 100,
                    cancellationPeriod:
                        num.parse((_cancellationPeriodController.text)),
                  );
                  listing = await processRoomImages(listing);
                  listing = listing.copyWith(
                    images: listing.images!.asMap().entries.map((entry) {
                      return entry.value.copyWith(url: imageUrls[entry.key]);
                    }).toList(),
                  );
                  // debugPrint("$listing");
                  if (mounted) {
                    ref.read(listingControllerProvider.notifier).addListing(
                        listing, context,
                        rooms: listing.availableRooms);
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
              // debugPrint("$listing");
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
              // debugPrint("$listing");
            },
          ),
        );
    return listing;
  }

  Column addNotes(
    List<String> notes,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        DisplayText(
          text: "Notes:",
          lines: 1,
          style: Theme.of(context).textTheme.headlineSmall!,
        ),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: notes.length,
            itemBuilder: ((context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    DisplayText(
                      text: notes[index],
                      lines: 10,
                      style: Theme.of(context).textTheme.bodySmall!,
                    ),
                  ],
                ),
              );
            }))
      ],
    );
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
          maxLines: null,
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
          onTap: () async {
            final TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: const TimeOfDay(hour: 11, minute: 30),
              initialEntryMode: TimePickerEntryMode.inputOnly,
            );

            if (pickedTime != null) {
              setState(() {
                checkInController.text = pickedTime.format(context);
                checkIn = pickedTime;
              });
            }
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: checkOutController,
          maxLines: 1,
          decoration: const InputDecoration(
            labelText: 'Check Out*',
            helperText: '*required',
            border: OutlineInputBorder(),
            floatingLabelBehavior:
                FloatingLabelBehavior.always, // Keep the label always visible
            hintText: "1:30",
          ),
          readOnly: true,
          onTap: () async {
            final TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: const TimeOfDay(hour: 1, minute: 30),
              initialEntryMode: TimePickerEntryMode.inputOnly,
            );
            if (pickedTime != null) {
              setState(() {
                checkOutController.text = pickedTime.format(context);
                checkOut = pickedTime;
              });
            }
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
            showDialog(
                context: context,
                builder: (context) {
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
                  return SizedBox(
                    child: Dialog.fullscreen(
                      child: showAddRoomForm(images, roomIdController,
                          priceController, guests, bedrooms, beds, bathrooms),
                    ),
                  );
                });
          },
          child: const Text('Add Room'),
        ),
      ),
      if (availableRooms.isEmpty)
        SizedBox(
            height: MediaQuery.sizeOf(context).height / 4,
            width: double.infinity,
            child: const Center(child: Text("No Rooms Created"))),
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
                      radius: BorderRadius.circular(10)),
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

  Widget showAddRoomForm(
      List<File> images,
      TextEditingController roomIdController,
      TextEditingController priceController,
      num guests,
      num bedrooms,
      num beds,
      num bathrooms) {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        children: [
          AppBar(
            leading: IconButton(
              iconSize: 30,
              onPressed: () {
                Navigator.of(context).pop(); // Corrected the navigation method
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
            title: const Text(
              "Create Room",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
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
            ),
          ),
        ],
      );
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
    List<String> notes = [
      "Fixed tasks will appear for every booking. They must always be accomplished when your service is purchased.",
      "Members that can be assigned to tasks are those belonging in the tourism committee."
    ];
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      child: Dialog.fullscreen(child: showFixedTaskForm()),
                    );
                  });
            },
            child: const Text("Add Task")),
        const SizedBox(
          height: 10,
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: fixedTasks?.length,
            itemBuilder: ((context, taskIndex) {
              return Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black, width: 1), // Border color
                    borderRadius: BorderRadius.circular(
                        6), // Border radius for rounded corners
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 5.0, right: 5, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black,
                                size: 25,
                              ), // 'X' icon
                              onPressed: () {},
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Aligns children at the start of the cross axis
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Task: ",
                                style: TextStyle(
                                  fontSize:
                                      16, // Ensure this matches the font size of the other text
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: DisplayText(
                                  text: fixedTasks![taskIndex].name,
                                  lines: 3,
                                  style: const TextStyle(
                                    fontSize: 16, // Adjust text style
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Assigned: ",
                                style: TextStyle(
                                  fontSize:
                                      16, // Ensure this matches the font size of the other text
                                ),
                              ),
                            ),
                            Expanded(
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, // 2 items per row
                                    crossAxisSpacing:
                                        1.5, // Space between cards horizontally
                                    mainAxisSpacing: 1.5,
                                    mainAxisExtent: MediaQuery.sizeOf(context)
                                            .height /
                                        20, // Space between cards vertically
                                  ),
                                  itemCount:
                                      fixedTasks![taskIndex].assigned.length,
                                  itemBuilder: (context, assignedIndex) {
                                    return Container(
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  Colors.grey), // Border color
                                          borderRadius: BorderRadius.circular(
                                              4), // Border radius for rounded corners
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            fixedTasks![taskIndex].assigned[
                                                assignedIndex], // Replace with the name from your data
                                            style: const TextStyle(
                                              fontSize: 14, // Adjust text style
                                              overflow: TextOverflow
                                                  .ellipsis, // Handle long text
                                            ),
                                          ),
                                        ));
                                  }),
                            ),
                          ],
                        )
                      ],
                    ),
                  ));
            })),
        if (fixedTasks!.isEmpty)
          SizedBox(
              height: MediaQuery.sizeOf(context).height / 5,
              width: double.infinity,
              child: const Center(child: Text("No Tasks Created"))),
        addNotes(
          notes,
        ),
      ],
    );
  }

  Widget showFixedTaskForm() {
    TextEditingController taskNameController = TextEditingController();
    TextEditingController committeeController =
        TextEditingController(text: "Tourism");
    List<String> assignedMembers = [];
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        children: [
          AppBar(
            leading: IconButton(
              iconSize: 30,
              onPressed: () {
                Navigator.of(context).pop(); // Corrected the navigation method
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
            title: const Text(
              "Create Task",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: [
                TextFormField(
                  controller: taskNameController,
                  decoration: const InputDecoration(
                    labelText: 'Task Name*',
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior
                        .always, // Keep the label always visible
                    hintText: "Prepare Room For Guests",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: committeeController,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    labelText: 'Committee Assigned*',
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior
                        .always, // Keep the label always visible
                    suffixIcon:
                        Icon(Icons.arrow_drop_down), // Dropdown arrow icon
                  ),
                  readOnly: true,
                  enabled: false,
                  onTap: () {},
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    TextFormField(
                      maxLines: 1,
                      decoration: const InputDecoration(
                          labelText: 'Members Assigned*',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior
                              .always, // Keep the label always visible
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          hintText:
                              "Press to select member" // Dropdown arrow icon
                          ),
                      readOnly: true,
                      canRequestFocus: false,
                      onTap: () async {
                        List<CooperativeMembers> members = await ref.read(
                            getAllMembersInCommitteeProvider(CommitteeParams(
                          committeeName: committeeController.text,
                          coopUid: ref.watch(userProvider)!.currentCoop!,
                        )).future);

                        members = members
                            .where((member) =>
                                !assignedMembers.contains(member.name))
                            .toList();
                        if (context.mounted) {
                          return showModalBottomSheet(
                            context: context,
                            builder: (builder) {
                              return Container(
                                padding: const EdgeInsets.all(
                                    10.0), // Padding for overall container
                                child: Column(
                                  children: [
                                    // Optional: Add a title or header for the modal
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: Text(
                                        "Members (${committeeController.text})",
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: members.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(
                                              members[index].name,
                                              style: const TextStyle(
                                                  fontSize:
                                                      16.0), // Adjust font size
                                            ),
                                            onTap: () {
                                              setState(
                                                () {
                                                  assignedMembers
                                                      .add(members[index].name);
                                                },
                                              );
                                              context.pop();
                                            },
                                            // Optional: Add trailing icons or actions
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 items per row
                        crossAxisSpacing:
                            1.5, // Space between cards horizontally
                        mainAxisSpacing: 1.5,
                        mainAxisExtent: MediaQuery.sizeOf(context).height /
                            8, // Space between cards vertically
                      ),
                      itemCount: assignedMembers
                          .length, // Replace with the length of your data
                      itemBuilder: (context, index) {
                        return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey), // Border color
                              borderRadius: BorderRadius.circular(
                                  4), // Border radius for rounded corners
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.black,
                                      size: 16,
                                    ), // 'X' icon
                                    onPressed: () {
                                      setState(
                                        () {
                                          assignedMembers.removeAt(index);
                                        },
                                      );
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      assignedMembers[
                                          index], // Replace with the name from your data
                                      style: const TextStyle(
                                        fontSize: 14, // Adjust text style
                                        overflow: TextOverflow
                                            .ellipsis, // Handle long text
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      },
                    )
                  ],
                ),
              ]),
            ),
          ),
          const Spacer(),
          ElevatedButton(
              onPressed: () {
                this.setState(() {
                  fixedTasks?.add(Task(
                      assigned: assignedMembers,
                      committee: committeeController.text,
                      complete: false,
                      openContribution: false,
                      name: taskNameController.text));
                });
                context.pop();
              },
              child: const Text("Add Task")),
        ],
      );
    });
  }

  Widget addPolicies(BuildContext context) {
    List<String> notes = [
      "Downpayment Rate: The necessary amount to be paid by a customer in order to book and reserve the service.",
      "Cancellation Rate: The amount that would not be refunded in the situation that a customer cancels their booking.",
      "Cancellation Period: This refers to the number of days before the scheduled booking, that a customer can cancel and pay the full amount in the case for a downpayment. Otherwise their booking will be cancelled",
      "Customers booking passed the cancellation period would be required to pay the downpayment or full amount upon checkout."
    ];
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _downpaymentRateController,
                maxLines: 1,
                keyboardType: TextInputType.number, // For numeric input
                decoration: const InputDecoration(
                    labelText:
                        'Downpayment Rate (%)*', // Indicate it's a percentage
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior
                        .always, // Keep the label always visible
                    hintText: "e.g., 20",
                    suffixText: "%"),
                onTap: () {
                  // Handle tap if needed, e.g., showing a dialog to select a percentage
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                controller: _cancellationRateController,
                maxLines: 1,
                decoration: const InputDecoration(
                    labelText: 'Cancellation Rate (%)*',
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior
                        .always, // Keep the label always visible
                    hintText: "e.g., 5",
                    suffixText: "%"),
                onTap: () {},
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: _cancellationPeriodController,
          maxLines: 1,
          keyboardType: TextInputType.number, // For numeric input
          decoration: const InputDecoration(
              labelText:
                  'Cancellation Period (Day/s)*', // Indicate it's a percentage
              border: OutlineInputBorder(),
              floatingLabelBehavior:
                  FloatingLabelBehavior.always, // Keep the label always visible
              hintText: "e.g., 5 Days before the booked date",
              suffixText: "Day/s"),
          onTap: () {
            // Handle tap if needed, e.g., showing a dialog to select a percentage
          },
        ),
        addNotes(notes),
      ],
    );
  }

  Widget reviewListing(BuildContext context) {
    int titleLines = 1;
    int descriptionLines = 2;
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        children: [
          ImageSlider(
              images: _images,
              height: MediaQuery.sizeOf(context).height / 4,
              width: double.infinity,
              radius: BorderRadius.circular(10)),
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  children: [
                    Text(
                      "Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 3,
                        height: 2,
                        indent: 15,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      RichText(
                        maxLines: titleLines,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Listing Title: ',
                              style: TextStyle(
                                fontSize: 16, // Adjust the font size as needed
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: _titleController.text,
                              style: const TextStyle(
                                fontSize: 16, // Adjust the font size as needed
                                color: Colors.black,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  setState(() {
                                    if (titleLines == 1) {
                                      titleLines = 99;
                                    } else {
                                      titleLines = 1;
                                    }
                                  });
                                },
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        maxLines: descriptionLines,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Description: ',
                              style: TextStyle(
                                fontSize: 16, // Adjust the font size as needed
                                fontWeight:
                                    FontWeight.bold, // Make the text bold
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: _descriptionController.text,
                              style: const TextStyle(
                                fontSize: 16, // Adjust the font size as needed
                                color: Colors.black,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  setState(() {
                                    if (descriptionLines == 2) {
                                      descriptionLines = 99;
                                    } else {
                                      descriptionLines = 2;
                                    }
                                  });
                                },
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            "Check In: ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            checkIn.format(context),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            "Check Out: ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            checkOut.format(context),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  children: [
                    Text(
                      "Rooms",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 3,
                        height: 2,
                        indent: 15,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    });
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
