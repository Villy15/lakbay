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
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/wrappers/committee_params.dart';

enum DownpaymentPolicy { fixedDownRate, percentageDownRate }

enum CancelPolicy { fixedCancelRate, percentageCancelRate }

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
  int upperBound = 3;

  // controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController checkInController =
      TextEditingController(text: ('11:30 AM'));
  final TextEditingController checkOutController =
      TextEditingController(text: ('2:30 PM'));

  String mapAddress = "";
  List<File>? _images;

  List<List<File>> roomImages = [];
  List<AvailableRoom> availableRooms = [];

  TimeOfDay checkIn = const TimeOfDay(hour: 11, minute: 30);
  TimeOfDay checkOut = const TimeOfDay(hour: 14, minute: 30);

  List<BookingTask>? fixedTasks = [];

  final TextEditingController _downpaymentRateController =
      TextEditingController();
  final TextEditingController _cancellationRateController =
      TextEditingController();
  final TextEditingController _cancellationPeriodController =
      TextEditingController();
  final TextEditingController _downpaymentPeriodController =
      TextEditingController();

  DownpaymentPolicy _selectedDownpayment =
      DownpaymentPolicy.fixedDownRate; // Default value
  CancelPolicy _selectedCancel = CancelPolicy.fixedCancelRate; // Default value

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
                    checkIn:
                        TimeOfDay(hour: checkIn.hour, minute: checkIn.minute),
                    checkOut:
                        TimeOfDay(hour: checkOut.hour, minute: checkOut.minute),
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
                    downpaymentRate: _selectedDownpayment ==
                            DownpaymentPolicy.fixedDownRate
                        ? num.parse((_downpaymentRateController.text))
                        : num.parse((_downpaymentRateController.text)) / 100,
                    cancellationRate: _selectedCancel ==
                            CancelPolicy.fixedCancelRate
                        ? num.parse((_cancellationRateController.text))
                        : num.parse((_cancellationRateController.text)) / 100,
                    cancellationPeriod:
                        num.parse((_cancellationPeriodController.text)),
                    downpaymentPeriod:
                        num.parse((_downpaymentPeriodController.text)),
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
                    ref.read(listingLocationProvider.notifier).reset();
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
              Icons.meeting_room_outlined,
              color: Theme.of(context).colorScheme.background,
            ),
            Icon(
              Icons.map_outlined,
              color: Theme.of(context).colorScheme.background,
            ),
            Icon(
              Icons.policy,
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
        FilledButton(
            style: FilledButton.styleFrom(
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
              // show an alert dialog to ask if the user is ready to submit his listing
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: const Text('Submit Listing'),
                        content: const Text(
                            'Are you sure you want to submit this listing?'),
                        actions: [
                          FilledButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0))),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () {
                              submitAddListing();
                            },
                            style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0))),
                            child: const Text('Submit'),
                          ),
                        ]);
                  });
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
        return 'Add Rooms';

      case 2:
        return 'Set Location';

      case 3:
        return 'Add Policies';

      default:
        return 'Add Details';
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
            border: OutlineInputBorder(),
            floatingLabelBehavior:
                FloatingLabelBehavior.always, // Keep the label always visible
            hintText: "Hotel near the beach....",
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: checkInController,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: 'Check In*',
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior
                      .always, // Keep the label always visible
                  hintText: "11:30",
                ),
                readOnly: true,
                onTap: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: checkIn,
                    initialEntryMode: TimePickerEntryMode.inputOnly,
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: false),
                        child: child!,
                      );
                    },
                  );

                  if (pickedTime != null) {
                    setState(() {
                      checkInController.text = pickedTime.format(context);
                      checkIn = pickedTime;
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: checkOutController,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: 'Check Out*',
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior
                      .always, // Keep the label always visible
                  hintText: "2:30",
                ),
                readOnly: true,
                onTap: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: checkOut,
                    initialEntryMode: TimePickerEntryMode.inputOnly,
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: false),
                        child: child!,
                      );
                    },
                  );
                  if (pickedTime != null) {
                    setState(() {
                      checkOutController.text = pickedTime.format(context);
                      checkOut = pickedTime;
                    });
                  }
                },
              ),
            ),
          ],
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
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width / 1.2,
          child: FilledButton(
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
            style: FilledButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    8.0), // Adjust the border radius as needed
              ),
            ),
            child: const Text('Add Room'),
          ),
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
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * .8,
                          child: FilledButton(
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
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 24.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Adjust the border radius as needed
                                ),
                              ),
                              child: const Text("Confirm")),
                        )
                      ])),
            ),
          ),
        ],
      );
    });
  }

  Widget addLocation(BuildContext context) {
    final location = ref.read(listingLocationProvider);
    if (location != null) {
      _addressController.text = location;
      mapAddress = location;
    }
    return Column(children: [
      TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Address*',
            border: OutlineInputBorder(),
          ),
          readOnly: true,
          onTap: () async {
            await context.push('/select_location', extra: 'listing');
          }),

      const SizedBox(height: 10),

      // Google Map
      SizedBox(
        height: 400,
        child: MapWidget(address: mapAddress, radius: true),
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
        SizedBox(
          width: MediaQuery.sizeOf(context).width / 1.2,
          child: FilledButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      child: Dialog.fullscreen(child: showFixedTaskForm()),
                    );
                  });
            },
            style: FilledButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    8.0), // Adjust the border radius as needed
              ),
            ),
            child: const Text("Add Task"),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: fixedTasks?.length,
            itemBuilder: ((context, taskIndex) {
              return ListTile(
                dense: true,
                leading: Text("[${taskIndex + 1}]."),
                title: DisplayText(
                  text: fixedTasks![taskIndex].name,
                  lines: 3,
                  style: const TextStyle(
                    fontSize: 14, // Adjust text style
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      fixedTasks?.remove(fixedTasks?[taskIndex]);
                    });
                  },
                ),
              );
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
    List<String> assignedIds = [];
    List<String> assignedNames = [];
    List<CooperativeMembers>? members;

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
                // Column(
                //   children: [
                //     TextFormField(
                //       maxLines: 1,
                //       decoration: const InputDecoration(
                //           labelText: 'Members Assigned*',
                //           border: OutlineInputBorder(),
                //           floatingLabelBehavior: FloatingLabelBehavior
                //               .always, // Keep the label always visible
                //           suffixIcon: Icon(Icons.arrow_drop_down),
                //           hintText:
                //               "Press to select member" // Dropdown arrow icon
                //           ),
                //       readOnly: true,
                //       canRequestFocus: false,
                //       onTap: () async {
                //         members = await ref.read(
                //             getAllMembersInCommitteeProvider(CommitteeParams(
                //           committeeName: committeeController.text,
                //           coopUid: ref.watch(userProvider)!.currentCoop!,
                //         )).future);

                //         members = members!
                //             .where((member) =>
                //                 !assignedNames.contains(member.name))
                //             .toList();
                //         if (context.mounted) {
                //           return showModalBottomSheet(
                //             context: context,
                //             builder: (builder) {
                //               return Container(
                //                 padding: const EdgeInsets.all(
                //                     10.0), // Padding for overall container
                //                 child: Column(
                //                   children: [
                //                     // Optional: Add a title or header for the modal
                //                     Padding(
                //                       padding: const EdgeInsets.symmetric(
                //                           vertical: 10.0),
                //                       child: Text(
                //                         "Members (${committeeController.text})",
                //                         style: const TextStyle(
                //                           fontSize: 18.0,
                //                           fontWeight: FontWeight.bold,
                //                         ),
                //                       ),
                //                     ),
                //                     Expanded(
                //                       child: ListView.builder(
                //                         itemCount: members!.length,
                //                         itemBuilder: (context, index) {
                //                           return ListTile(
                //                             title: Text(
                //                               members![index].name,
                //                               style: const TextStyle(
                //                                   fontSize:
                //                                       16.0), // Adjust font size
                //                             ),
                //                             onTap: () {
                //                               setState(
                //                                 () {
                //                                   assignedIds.add(
                //                                       members![index].uid!);
                //                                   assignedNames.add(
                //                                       members![index].name);
                //                                 },
                //                               );
                //                               context.pop();
                //                             },
                //                             // Optional: Add trailing icons or actions
                //                           );
                //                         },
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               );
                //             },
                //           );
                //         }
                //       },
                //     ),
                //     const SizedBox(
                //       height: 5,
                //     ),
                //     GridView.builder(
                //       physics: const NeverScrollableScrollPhysics(),
                //       shrinkWrap: true,
                //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //         crossAxisCount: 2, // 2 items per row
                //         crossAxisSpacing:
                //             0, // No space between cards horizontally
                //         mainAxisSpacing: 0, // No space between cards vertically
                //         mainAxisExtent: MediaQuery.sizeOf(context).height /
                //             16, // Height of each card
                //       ),
                //       itemCount: assignedNames
                //           .length, // Replace with the length of your data
                //       itemBuilder: (context, index) {
                //         return Container(
                //           decoration: BoxDecoration(
                //             border: Border.all(
                //                 color: Colors
                //                     .transparent), // Optional: to add a border or change the color
                //           ),
                //           child: ListTile(
                //             horizontalTitleGap: 0,
                //             contentPadding:
                //                 EdgeInsets.zero, // Remove default padding
                //             title: Text(
                //               assignedNames[
                //                   index], // Replace with the name from your data
                //               style: const TextStyle(
                //                 fontSize: 14, // Adjust text style
                //                 overflow:
                //                     TextOverflow.ellipsis, // Handle long text
                //               ),
                //             ),
                //             leading: IconButton(
                //               padding:
                //                   EdgeInsets.zero, // Remove default padding
                //               icon: const Icon(
                //                 Icons.close,
                //                 color: Colors.black,
                //                 size: 16,
                //               ), // 'X' icon
                //               onPressed: () {
                //                 setState(() {
                //                   assignedIds.remove(members![members!
                //                           .indexWhere((element) =>
                //                               element.name ==
                //                               assignedNames[index])]
                //                       .uid!);
                //                   assignedNames.removeAt(index);
                //                 });
                //               },
                //             ),
                //           ),
                //         );
                //       },
                //     )
                //   ],
                // ),
              ]),
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            width: MediaQuery.sizeOf(context).width * .8,
            child: FilledButton(
                onPressed: () {
                  this.setState(() {
                    fixedTasks?.add(BookingTask(
                        listingName: _titleController.text,
                        status: 'Incomplete',
                        assignedIds: assignedIds,
                        assignedNames: assignedNames,
                        committee: committeeController.text,
                        complete: false,
                        openContribution: false,
                        name: taskNameController.text));
                  });
                  context.pop();
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Adjust the border radius as needed
                  ),
                ),
                child: const Text("Add Task")),
          ),
        ],
      );
    });
  }

  Widget addPolicies(BuildContext context) {
    List<String> notes = [
      "Downpayment Rate: The necessary amount to be paid by a customer in order to book and reserve the service.",
      "Cancellation Rate: The amount that would not be refunded in the situation that a customer cancels their booking.",
      "Downpayment Period: This refers to the number of days before the scheduled booking, that a customer must pay their balance on the situation that they aren't yet fully paid. Otherwise their booking will be cancelled.",
      "Cancellation Period: This refers to the number of days before the scheduled booking, that a customer can cancel or pay the full amount in the case for a downpayment and still receive a return. Otherwise their booking will be cancelled",
      "Customers booking passed the downpayment and/or cancellation period would be required to pay the full amount upon checkout."
    ];
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Downpayment',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Radio buttons for payment options
            Row(
              children: [
                Expanded(
                  child: RadioListTile<DownpaymentPolicy>(
                    title: const Text('Fixed Rate'),
                    value: DownpaymentPolicy.fixedDownRate,
                    groupValue: _selectedDownpayment,
                    onChanged: (DownpaymentPolicy? value) {
                      setState(() {
                        _selectedDownpayment = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<DownpaymentPolicy>(
                    title: const Text('Percent Rate'),
                    value: DownpaymentPolicy.percentageDownRate,
                    groupValue: _selectedDownpayment,
                    onChanged: (DownpaymentPolicy? value) {
                      setState(() {
                        _selectedDownpayment = value!;
                      });
                    },
                  ),
                )
              ],
            ),
            if (_selectedDownpayment == DownpaymentPolicy.fixedDownRate) ...[
              rendFixedDownRate(),
            ],

            if (_selectedDownpayment ==
                DownpaymentPolicy.percentageDownRate) ...[
              rendPercentageDownRate(),
            ],
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cancellation',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Radio buttons for payment options
            Row(
              children: [
                Expanded(
                  child: RadioListTile<CancelPolicy>(
                    title: const Text('Fixed Rate'),
                    value: CancelPolicy.fixedCancelRate,
                    groupValue: _selectedCancel,
                    onChanged: (CancelPolicy? value) {
                      setState(() {
                        _selectedCancel = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<CancelPolicy>(
                    title: const Text('Percent Rate'),
                    value: CancelPolicy.percentageCancelRate,
                    groupValue: _selectedCancel,
                    onChanged: (CancelPolicy? value) {
                      setState(() {
                        _selectedCancel = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            if (_selectedCancel == CancelPolicy.fixedCancelRate) ...[
              rendFixedCancelRate(),
            ],

            if (_selectedCancel == CancelPolicy.percentageCancelRate) ...[
              rendPercentageCancelRate(),
            ],
          ],
        ),
        addNotes(notes),
      ],
    );
  }

  Row rendPercentageCancelRate() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _cancellationRateController,
            maxLines: 1,
            decoration: const InputDecoration(
                labelText: 'Fixed Rate',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior
                    .always, // Keep the label always visible
                hintText: "e.g., 5",
                suffixText: "%"),
            onTap: () {},
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextFormField(
            controller: _cancellationPeriodController,
            maxLines: 1,
            keyboardType: TextInputType.number, // For numeric input
            decoration: const InputDecoration(
                labelText: 'Cancellation Period', // Indicate it's a percentage
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior
                    .always, // Keep the label always visible
                hintText: "e.g., 5 Days before the booked date",
                suffixText: "Day/s"),
            onTap: () {
              // Handle tap if needed, e.g., showing a dialog to select a percentage
            },
          ),
        ),
      ],
    );
  }

  Row rendFixedCancelRate() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _cancellationRateController,
            maxLines: 1,
            decoration: const InputDecoration(
                labelText: 'Fixed Rate',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior
                    .always, // Keep the label always visible
                hintText: "e.g., 5",
                suffixText: "₱"),
            onTap: () {},
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextFormField(
            controller: _cancellationPeriodController,
            maxLines: 1,
            keyboardType: TextInputType.number, // For numeric input
            decoration: const InputDecoration(
                labelText: 'Cancellation Period', // Indicate it's a percentage
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior
                    .always, // Keep the label always visible
                hintText: "e.g., 5 Days before the booked date",
                suffixText: "Day/s"),
            onTap: () {
              // Handle tap if needed, e.g., showing a dialog to select a percentage
            },
          ),
        ),
      ],
    );
  }

  Row rendPercentageDownRate() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _downpaymentRateController,
            maxLines: 1,
            keyboardType: TextInputType.number, // For numeric input
            decoration: const InputDecoration(
                labelText: 'Percentage Rate', // Indicate it's a percentage
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
            controller: _downpaymentPeriodController,
            maxLines: 1,
            keyboardType: TextInputType.number, // For numeric input
            decoration: const InputDecoration(
                labelText: 'Downpayment Period', // Indicate it's a percentage
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior
                    .always, // Keep the label always visible
                hintText: "e.g., 5 Days before the booked date",
                suffixText: "Day/s"),
            onTap: () {
              // Handle tap if needed, e.g., showing a dialog to select a percentage
            },
          ),
        ),
      ],
    );
  }

  Row rendFixedDownRate() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _downpaymentRateController,
            maxLines: 1,
            keyboardType: TextInputType.number, // For numeric input
            decoration: const InputDecoration(
                labelText: 'Fixed Rate', // Indicate it's a percentage
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior
                    .always, // Keep the label always visible
                hintText: "e.g., 20",
                suffixText: "₱"),
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
            controller: _downpaymentPeriodController,
            maxLines: 1,
            keyboardType: TextInputType.number, // For numeric input
            decoration: const InputDecoration(
                labelText: 'Downpayment Period', // Indicate it's a percentage
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior
                    .always, // Keep the label always visible
                hintText: "e.g., 5 Days before the booked date",
                suffixText: "Day/s"),
            onTap: () {
              // Handle tap if needed, e.g., showing a dialog to select a percentage
            },
          ),
        ),
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
        return addRoomDetails(context);
      case 2:
        return addLocation(context);
      case 3:
        return addPolicies(context);

      default:
        return addDetails(context);
    }
  }
}
