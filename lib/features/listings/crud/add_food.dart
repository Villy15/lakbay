import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/providers/storage_repository_providers.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class AddFood extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  final String category;
  const AddFood({required this.coop, required this.category, super.key});

  @override
  ConsumerState<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends ConsumerState<AddFood> {
  // global key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // stepper
  int activeStep = 0;
  int upperBound = 5;

  // initial values
  String type = 'Nature-Based';
  final List<File> _menuImgs = [];
  List<File>? _images = [];
  List<List<File>> _dealImgs = [];
  List<List<File>> tempDealImgs = [];
  List<List<File>> two = [];
  List<File> dealImgs = [];
  late DateTime startDate = DateTime.now();
  late DateTime endDate = DateTime.now();
  List<bool> workingDays = List.filled(7, false);
  num guests = 0;
  List<FoodService> availableDeals = [];
  List<Task>? fixedTasks = [];

  // controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _dealNameController = TextEditingController();
  final TextEditingController _dealDescriptionController =
      TextEditingController();
  final TextEditingController _addressController =
      TextEditingController(text: 'Eastwood City');

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
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
                    availableDeals: availableDeals,
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
                    type: type,
                    fixedTasks: fixedTasks,
                  );
                  listing = await processMenuImages(listing);
                  listing = await processDealImages(listing);
                  listing = listing.copyWith(
                    images: listing.images!.asMap().entries.map((entry) {
                      return entry.value.copyWith(url: imageUrls[entry.key]);
                    }).toList(),
                  );
                  debugPrint("$listing");
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

  Future<ListingModel> processMenuImages(ListingModel listing) async {
    final images = _menuImgs;
    final imagePath = 'listings/${widget.coop.name}';
    final ids = images.map((image) => image.path.split('/').last).toList();
    await ref
        .read(storageRepositoryProvider)
        .storeFiles(path: imagePath, ids: ids, files: images)
        .then(
          (value) => value.fold(
            (failure) => debugPrint('Failed to store files'),
            (urls) {
              debugPrint('these are the urls: $urls');
              listing = listing.copyWith(
                menuImgs: images
                    .asMap()
                    .map((index, image) {
                      return MapEntry(
                          index,
                          ListingImages(
                              path: image.path, url: urls[index].toString()));
                    })
                    .values
                    .toList(),
              );
            },
          ),
        );
    return listing;
  }

  Future<ListingModel> processDealImages(ListingModel listing) async {
    debugPrint("this is working!");
    final images = _dealImgs;
    debugPrint('these are the images: $images');
    final imagePath = 'listings/${widget.coop.name}';
    final ids = images
        .expand((fileList) => fileList.map((file) => file.path.split('/').last))
        .toList();
    debugPrint('these are the deals ids: $ids');
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
              debugPrint('image urls: $imageUrls');
              debugPrint("faggot!: $listing");

              // add the urls to corresponding img
              listing = listing.copyWith(
                availableDeals: listing.availableDeals!
                    .asMap()
                    .map((dealIndex, deal) {
                      List<String> dealImageUrls = imageUrls[dealIndex];

                      List<ListingImages> updatedImages = deal.dealImgs
                          .asMap()
                          .map((imageIndex, image) {
                            String imageUrl = dealImageUrls.length > imageIndex
                                ? dealImageUrls[imageIndex]
                                : ''; // Default empty URL
                            return MapEntry(
                                imageIndex, image.copyWith(url: imageUrl));
                          })
                          .values
                          .toList();

                      return MapEntry(
                          dealIndex, deal.copyWith(dealImgs: updatedImages));
                    })
                    .values
                    .toList(),
              );

              debugPrint("$listing");
            },
          ),
        );
    return listing;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(listingControllerProvider);
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          context.pop();
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Add Food Listing'),
            ),
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
              Icons.details_outlined,
              color: Theme.of(context).colorScheme.background,
            ),
            Icon(
              Icons.info_outline_rounded,
              color: Theme.of(context).colorScheme.background,
            ),
            Icon(
              Icons.map_outlined,
              color: Theme.of(context).colorScheme.background,
            ),
            Icon(
              Icons.image_outlined,
              color: Theme.of(context).colorScheme.background,
            ),
            Icon(
              Icons.question_mark_outlined,
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
              debugPrint('the current step is $activeStep');
            });
          },
        ),
        header(),
      ],
    );
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
        return 'Add supporting details';

      case 2:
        return 'Where are you located?';

      case 3:
        return 'Add some photos';

      case 4:
        return 'What do you want the guests to know?';

      case 5:
        return 'Review Listing';

      default:
        return 'Add details';
    }
  }

  Widget chooseType(BuildContext context) {
    List<Map<String, dynamic>> types = [
      {'name': 'Nature-Based', 'icon': Icons.forest_outlined},
      {'name': 'Cultural', 'icon': Icons.diversity_2_outlined},
      {'name': 'Sun and Beach', 'icon': Icons.beach_access_outlined},
      {
        'name': 'Health, Wellness, and Retirement',
        'icon': Icons.local_hospital_outlined
      },
      {'name': 'Diving and Marine Sports', 'icon': Icons.scuba_diving_outlined},
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
        const Text('Please add the details of your listing...',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic)),
        const SizedBox(height: 10),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Listing Title*',
            helperText: '*required',
            border: OutlineInputBorder(),
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
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _feeController,
          decoration: const InputDecoration(
            labelText: 'Reservation Fee',
            prefix: Text('₱'),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Food Information',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        const Text('Add your menu here...',
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic)),
        const SizedBox(height: 10),
        if (_menuImgs.isNotEmpty) ...[
          ImageSlider(
              images: _menuImgs,
              height: MediaQuery.sizeOf(context).height / 1.7,
              width: double.infinity)
        ] else ...[
          GestureDetector(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.image_outlined,
                color: Theme.of(context).iconTheme.color),
            const SizedBox(width: 15),
            Expanded(
                child: ImagePickerFormField(
              context: context,
              initialValue: _menuImgs,
              height: MediaQuery.sizeOf(context).height / 4.5,
              width: MediaQuery.sizeOf(context).height / 2,
              onImagesSelected: (images) {
                setState(() {
                  _menuImgs.addAll(images);
                  debugPrint('menu images added: $_menuImgs');
                });
              },
            ))
          ])),
          const SizedBox(height: 25)
        ],
      ],
    );
  }

  String getDay(int index) {
    switch (index) {
      case 0:
        return 'Monday';
      case 1:
        return 'Tuesday';
      case 2:
        return 'Wednesday';
      case 3:
        return 'Thursday';
      case 4:
        return 'Friday';
      case 5:
        return 'Saturday';
      default:
        return 'Sunday';
    }
  }

  Widget addSuppDetails(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Add more details to your listing...',
          style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic)),
      const SizedBox(height: 20),
      const Text(
        'Working Hours',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      const Text(
        'Indicate your working hours...',
        style: TextStyle(
          fontSize: 15.0,
          fontStyle: FontStyle.italic,
        ),
      ),
      const SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(children: [
          const Text('Start Time'),
          ElevatedButton(
              onPressed: () async {
                final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    initialEntryMode: TimePickerEntryMode.inputOnly);
                if (time != null) {
                  setState(() {
                    startDate = DateTime(
                      startDate.year,
                      startDate.month,
                      startDate.day,
                      time.hour,
                      time.minute,
                    );
                  });
                }
              },
              // ignore: unnecessary_null_comparison
              child: Text(startDate == null
                  ? 'Select Time'
                  : DateFormat.jm().format(startDate)))
        ]),

        // end time
        Column(children: [
          const Text('End Time'),
          const SizedBox(height: 5),
          ElevatedButton(
              onPressed: () async {
                final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    initialEntryMode: TimePickerEntryMode.inputOnly);
                if (time != null) {
                  setState(() {
                    endDate = DateTime(
                      endDate.year,
                      endDate.month,
                      endDate.day,
                      time.hour,
                      time.minute,
                    );
                  });
                }
              },
              // ignore: unnecessary_null_comparison
              child: Text(endDate == null
                  ? 'Select Time'
                  : DateFormat.jm().format(endDate)))
        ])
      ]),
      const SizedBox(height: 15),
      const Text(
        'Add Working Days',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      const Text(
        'Indicate the days you are open...',
        style: TextStyle(
          fontSize: 15.0,
          fontStyle: FontStyle.italic,
        ),
      ),
      Column(
          children: List<Widget>.generate(7, (index) {
        return CheckboxListTile(
          title: Text(
            getDay(index),
            style: const TextStyle(fontSize: 16),
          ),
          value: workingDays[index],
          onChanged: (bool? value) {
            setState(() {
              workingDays[index] = value!;
            });
          },
        );
      })),
      const SizedBox(height: 15),
      const Text(
        'Deals Available',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      const Text(
        'Add some deals for your guests to enjoy...',
        style: TextStyle(
          fontSize: 15.0,
          fontStyle: FontStyle.italic,
        ),
      ),
      const SizedBox(height: 15),
      ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: availableDeals.length,
          itemBuilder: ((context, index) {
            return Card(
                elevation: 4.0,
                margin: const EdgeInsets.all(8.0),
                child: Column(children: [
                  ImageSlider(
                    images: availableDeals[index]
                        .dealImgs
                        .map((image) => File(image.path))
                        .toList(),
                    height: MediaQuery.sizeOf(context).height / 3,
                    width: double.infinity,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(availableDeals[index].dealName,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text("₱${availableDeals[index].price.toString()}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold))
                          ],
                        ),
                        const SizedBox(height: 4)
                      ]))
                ]));
          })),
      Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return addDealBottomSheet(
                      dealImgs, _dealNameController, guests);
                });
          },
          child: const Text('Add Deal'),
        ),
      ),
    ]);
  }

  DraggableScrollableSheet addDealBottomSheet(
      List<File> images, TextEditingController tableIdController, num guests) {
    return DraggableScrollableSheet(
      initialChildSize: 0.80,
      expand: false,
      builder: (context, scrollController) {
        return StatefulBuilder(builder: (context, setState) {
          return SingleChildScrollView(
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
                      Expanded(
                        child: ImagePickerFormField(
                          height: MediaQuery.sizeOf(context).height / 5,
                          width: MediaQuery.sizeOf(context).width / 1.3,
                          context: context,
                          initialValue: images,
                          onSaved: (List<File>? files) {
                            images.clear();
                            images.addAll(files!);

                            tempDealImgs.add(images);
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

                            tempDealImgs.add(List.from(images));
                            // once testing is added, add it to the dealImgs
                          },
                        ),
                      )
                    ]))),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                      controller: tableIdController,
                      decoration: const InputDecoration(
                          labelText: 'Deal Name*',
                          helperText: '*required',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: "Bundle Meal No. 1",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12)),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      }),
                ),
                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                      controller: _dealDescriptionController,
                      maxLines: null,
                      decoration: const InputDecoration(
                          labelText: 'Description*',
                          helperText: '*required',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: "This meal includes...",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12)),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      }),
                ),
                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                      controller: _priceController,
                      maxLines: null,
                      decoration: const InputDecoration(
                          labelText: 'Price*',
                          helperText: '*required',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: "₱",
                          prefix: Text('₱'),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12)),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      }),
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height / 60),
                ListTile(
                    title: const Row(children: [
                      Icon(Icons.people_alt_outlined),
                      SizedBox(width: 10),
                      Text('Guests')
                    ]),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (guests >= 1) {
                              setState(() {
                                guests--;
                              });
                            }
                          }),
                      const SizedBox(width: 10),
                      Text('$guests', style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              guests++;
                            });
                          })
                    ])),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    debugPrint(
                        'this is the testing, i think it will work: $tempDealImgs');
                    // move testing to dealImgs
                    _dealImgs = List.from(tempDealImgs);
                    FoodService deal = FoodService(
                        available: true,
                        dealName: _dealNameController.text,
                        dealDescription: _dealDescriptionController.text,
                        price: num.parse(_priceController.text),
                        guests: guests,
                        startTime: TimeOfDay.fromDateTime(startDate),
                        endTime: TimeOfDay.fromDateTime(endDate),
                        workingDays: workingDays,
                        dealImgs: images
                            .map((image) => ListingImages(path: image.path))
                            .toList());
                    this.setState(() {
                      int index = availableDeals.indexWhere((element) =>
                          element.dealName == _dealNameController.text);
                      if (index == -1) {
                        debugPrint('this is the new testing: $tempDealImgs');
                        availableDeals.add(deal);
                      } else {
                        debugPrint('this is the new testing: $tempDealImgs');
                        availableDeals[index] = deal;
                      }

                      // clear all field
                      _dealNameController.clear();
                      _dealDescriptionController.clear();
                      _priceController.clear();
                      _dealImgs.add(images);
                      images.clear();

                      debugPrint('this is the testing: $_dealImgs');
                      guests = 0;
                    });
                    context.pop();
                  },
                  child: const Text('Confirm'),
                )
              ]));
        });
      },
    );
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
        onPressed: () {},
        child: const Text('Update Map'),
      ),

      const SizedBox(height: 10),

      // Google Map
      SizedBox(
        height: 400,
        child: MapWidget(address: _addressController.text),
      )
    ]);
  }

  Widget addListingPhotos(BuildContext context) {
    return Column(children: [
      GestureDetector(
          child: Row(children: [
        Icon(Icons.image_outlined, color: Theme.of(context).iconTheme.color),
        const SizedBox(width: 15),
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
        )
      ]))
    ]);
  }

  Widget addGuestInfo(BuildContext context) {
    return const Column();
  }

  Widget reviewListing(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (_images?.isNotEmpty == true) ...[
            const Padding(
              padding: EdgeInsets.only(top: 8.0, left: 12.0),
              child: DisplayText(
                  text: "Listing Photo/s",
                  lines: 1,
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ImageSlider(
                  images: _images,
                  height: MediaQuery.sizeOf(context).height / 2.5,
                  width: double.infinity),
            ),
          ],

          ListTile(
              title: const Text('Category',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Text(widget.category)),
          const Divider(),
          // Step 1
          ListTile(
              title: const Text(
                'Title',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(_titleController.text)),
          ListTile(
            title: const Text('Description',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Text(_descriptionController.text),
          ),
          ListTile(
            title: const Text('Reservation Fee',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Text("₱${_feeController.text}"),
          ),
          const Divider(),
          if (availableDeals.isNotEmpty == true) ...[
            const Padding(
              padding: EdgeInsets.only(top: 8.0, left: 16.0),
              child: DisplayText(
                  text: "Table/s Available",
                  lines: 1,
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 15),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: availableDeals.length,
                itemBuilder: ((context, index) {
                  return Card(
                      elevation: 4.0,
                      margin: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        ImageSlider(
                          images: availableDeals[index]
                              .dealImgs
                              .map((image) => File(image.path))
                              .toList(),
                          height: MediaQuery.sizeOf(context).height / 3,
                          width: double.infinity,
                        ),
                        Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.card_giftcard_outlined,
                                      size: 16),
                                  const SizedBox(width: 4),
                                  Text(availableDeals[index].dealName,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 4)
                            ]))
                      ]));
                })),
          ],

          if (_menuImgs.isNotEmpty == true) ...[
            const Padding(
              padding: EdgeInsets.only(top: 8.0, left: 16.0),
              child: DisplayText(
                  text: "Menu/s",
                  lines: 1,
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ImageSlider(
                  images: _menuImgs,
                  height: MediaQuery.sizeOf(context).height / 1.5,
                  width: double.infinity),
            ),
          ],

          const Divider(),
        ]);
  }

  Widget stepForm(BuildContext context) {
    switch (activeStep) {
      case 1:
        return addSuppDetails(context);
      case 2:
        return addLocation(context);
      case 3:
        return addListingPhotos(context);
      case 4:
        return addGuestInfo(context);
      case 5:
        return reviewListing(context);

      default:
        return addDetails(context);
    }
  }
}

class ImagePickerFormField extends FormField<List<File>> {
  final Function(List<File>) onImagesSelected;

  ImagePickerFormField({
    super.key,
    super.onSaved,
    super.validator,
    required BuildContext context,
    required double height,
    required double width,
    List<File>? initialValue,
    required this.onImagesSelected,
  }) : super(
          initialValue: initialValue ?? [],
          builder: (FormFieldState<List<File>> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final pickedFiles = await picker.pickMultiImage();

                    if (pickedFiles.isNotEmpty) {
                      List<File> files = pickedFiles
                          .map((pickedFile) => File(pickedFile.path))
                          .toList();
                      state.didChange(files);
                      onImagesSelected(files); // Use the callback here
                    }
                  },
                  child: Column(
                    children: [
                      // If its empty
                      if (state.value!.isEmpty)
                        Container(
                          height: height,
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add_photo_alternate_outlined,
                                  color: Colors.grey,
                                  size: 50,
                                ),
                                DisplayText(
                                  text: "Add Images",
                                  lines: 1,
                                  style: Theme.of(context).textTheme.bodySmall!,
                                ),
                              ]),
                        ),
                      if (state.value!.isNotEmpty)
                        Container(
                          height: height,
                          width: width,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child:
                              Image.file(state.value!.first, fit: BoxFit.cover),
                        ),
                      if (state.value!.length > 1)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                          ),
                          itemCount: state.value!.length - 1,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.file(state.value![index + 1],
                                  fit: BoxFit.cover),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 12),
                    child: Text(
                      state.errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        );
}
