import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/listings/listing_provider.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/listing_model.dart';

class AddAccommodation extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  final String category;
  const AddAccommodation({required this.coop, required this.category, super.key});

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
  final TextEditingController _addressController = TextEditingController(text: 'Eastwood City');

  final TextEditingController roomIdController = TextEditingController();
  final TextEditingController priceController = TextEditingController(); 
  @override
  Widget build(BuildContext context) {
    List<List<File>> images = ref.watch(addLocalImagesProvider) ?? [];
    List<AvailableRoom> availableRooms = ref.watch(addRoomProvider) ?? [];

    final isLoading = ref.watch(listingControllerProvider);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Listing')
        ),
        bottomNavigationBar: bottomAppBar(),
        body: isLoading 
              ? const Loader()
              : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      children: [
                        steppers(context),
                        stepForm(context)
                      ]
                    )
                  )
                )
              )
      )
    );
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

  BottomAppBar bottomAppBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (activeStep == 0) ... [
            TextButton(
              onPressed: () {
                context.pop();
                // ref.read(navBarVisibilityProvider.notifier).show();
              },
              child: const Text('Cancel')
            )
          ]
          else ... [
            TextButton(
              onPressed: () {
                setState(() {
                  activeStep--;
                });
              },
              child: const Text('Back')
            )
          ],
          
          // Next
          if (activeStep != upperBound) ... [
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
              )
            )
          ]
          else ... [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {},
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              )
            )
          ]
        ]
      )
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
        return 'Add details';

      case 2:
        return 'Add supporting details';

      case 3:
        return 'Where are you located?';

      case 4:
        return 'Add some photos';

      case 5:
        return 'What do you want the guest to know?';

      case 6:
        return 'Review Listing';

      default:
        return 'Choose Type';
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
      ],
    );
  }

  Widget addSuppDetails(BuildContext context) {
    return Column(
      children: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  TextEditingController roomIdController = TextEditingController();
                  TextEditingController priceController = TextEditingController();
                  num guests = 0;
                  num bedrooms = 0;
                  num beds = 0;
                  num bathrooms = 0;
                  List<File> images = [];

                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Container(
                        margin: const EdgeInsets.only(top: 20),
                        height: MediaQuery.sizeOf(context).height / 1,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: GestureDetector(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.image_outlined,
                                      color: Theme.of(context).iconTheme.color
                                    ),
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
                                        ref
                                            .read(addLocalImagesProvider.notifier)
                                            .addImages(images);
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
                                        ref
                                            .read(addLocalImagesProvider.notifier)
                                            .addImages(images);
                                      },
                                    ),
                                  ]
                                )
                              )
                            ),
                            const SizedBox(height: 15),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                controller: roomIdController,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.title_outlined),
                                  border: OutlineInputBorder(),
                                  labelText: "Room Id",
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 12.0
                                  )
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                }
                              )
                            ),
                            SizedBox(height: MediaQuery.sizeOf(context).height / 50),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                controller: priceController,
                                maxLines: null,
                                keyboardType:
                                    const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  icon: Icon(
                                    Icons.money_outlined,
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: 'Price',
                                  prefix: Text('₱'),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12), // Adjust padding here
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
                                  bottom: BorderSide(color: Theme.of(context).dividerColor),
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
                                    Text('$guests', style: const TextStyle(fontSize: 16)),
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
                                  bottom: BorderSide(color: Theme.of(context).dividerColor),
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
                                    Text('$bedrooms', style: const TextStyle(fontSize: 16)),
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
                                  bottom: BorderSide(color: Theme.of(context).dividerColor),
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
                                  bottom: BorderSide(color: Theme.of(context).dividerColor),
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
                                  List<AvailableRoom> rooms =
                                      ref.watch(addRoomProvider) ?? [];
                                  int index = rooms.indexWhere((element) =>
                                      element.roomId == roomIdController.text);
                                  if (index == -1) {
                                    ref.read(addRoomProvider.notifier).addRoom(room);
                                    ref
                                        .read(saveListingProvider.notifier)
                                        .saveListingProvider(ListingModel(
                                            address: "",
                                            category: "",
                                            city: "",
                                            cooperative: ListingCooperative(
                                                cooperativeId: "", cooperativeName: ""),
                                            description: "",
                                            province: "",
                                            publisherId: "",
                                            title: "",
                                            type: "",
                                            availableRooms: ref.watch(addRoomProvider)));
                                  } else {
                                    ref.read(addRoomProvider)?[index] = room;
                                  }
                                });
                                context.pop();
                              },
                              child: const Text("Confirm"))
                          ]
                        )
                      );
                    }
                  );
                }
              );
            },
            child: const Text('Add Room')
          )
        )
      ]
    );
  }

  Widget addLocation(BuildContext context) {
    return Column(
      children: [
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
          }
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {

          },
          child: const Text('Update Map'),
        ),

        const SizedBox(height: 10),
        
        // Google Map
        SizedBox(
          height: 400,
          child: MapWidget(
            address: _addressController.text
          ),
        )
      ]
    );
  }

  Widget addListingPhotos(BuildContext context) {
    return const Column();
  }

  Widget addGuestInfo(BuildContext context) {
    return const Column();
  }
  
  Widget reviewListing(BuildContext context) {
    return const Column();
  }

  Widget stepForm(BuildContext context) {
    switch (activeStep) {
      case 1: 
        return addDetails(context);
      case 2:
        return addSuppDetails(context);
      case 3:
        return addLocation(context);
      case 4: 
        return addListingPhotos(context);
      case 5:
        return addGuestInfo(context);
      case 6:
        return reviewListing(context);

      default: 
        return chooseType(context);
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