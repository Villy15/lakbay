import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lakbay/core/providers/storage_repository_providers.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/listing_model.dart';

class AddListing extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  const AddListing({super.key, required this.coop});

  @override
  ConsumerState<AddListing> createState() => _AddListingState();
}

class _AddListingState extends ConsumerState<AddListing> {
  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int activeStep = 0;
  int upperBound = 6;

  // Form fields
  // Step 0
  String category = 'Accommodation';

  // Step 1
  final _titleController = TextEditingController(text: 'Cozy Condo');
  final _descriptionController =
      TextEditingController(text: 'A wonderful place to stay');
  final _priceController = TextEditingController(text: '1000');
  String type = 'Nature-Based';

  // Step 2
  //Accommodation

  // Step3
  final _addressController = TextEditingController(text: 'Eastwood City');
  final String address = 'Eastwood City';

  // Step 4
  List<File>? _images;

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
    _priceController.dispose();
    _addressController.dispose();

    super.dispose();
  }

  void submitAddListing(ListingModel listing) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // var listing = ListingModel(
      //   publisherId: userId,
      //   category: category,
      //   type: type,
      //   title: _titleController.text,
      //   description: _descriptionController.text,
      //   price: num.parse(_priceController.text),
      //   address: _addressController.text,
      //   city: widget.coop.city,
      //   province: widget.coop.province,
      //   cooperative: ListingCooperative(
      //     cooperativeId: widget.coop.uid!,
      //     cooperativeName: widget.coop.name,
      //   ),
      //   images: _images!.map((image) {
      //     final imagePath =
      //         'listings/${widget.coop.name}/${image.path.split('/').last}';
      //     return ListingImages(
      //       path: imagePath,
      //     );
      //   }).toList(),
      // );

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
                (imageUrls) {
                  listing = listing.copyWith(
                    images: listing.images!.asMap().entries.map((entry) {
                      return entry.value.copyWith(url: imageUrls[entry.key]);
                    }).toList(),
                  );
                  debugPrintJson(listing);

                  ref
                      .read(listingControllerProvider.notifier)
                      .addListing(listing, context);
                },
              ));

      // Add Listing
      //
    }
  }

  String headerText() {
    switch (activeStep) {
      case 1:
        return 'Add details';

      case 2:
        switch (category) {
          case "Accommodation":
            return "Room Availability";
          case "Transport":
            return "";
          case "Tours":
            return "";
          case "Food":
            return "";
          case "Entertainment":
            return "";
        }
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
        return 'Choose Category';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(listingControllerProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Listing')),
        bottomNavigationBar: bottomAppBar(context),
        body: isLoading
            ? const Loader()
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      children: [
                        steppers(context),
                        stepForm(context),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget stepForm(BuildContext context) {
    switch (activeStep) {
      case 1:
        return step1(context);
      case 2:
        switch (category) {
          case "Accommodation":
            return Step2Accommodation(coop: widget.coop);
        }
        return const Text("No Supporting Details");
      case 3:
        return step3(context);
      case 4:
        return step4(context);
      case 5:
        return step5(context);
      case 6:
        return step6(context);
      default:
        return step0(context);
    }
  }

  Widget step0(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {'name': 'Accommodation', 'icon': Icons.hotel_outlined},
      {'name': 'Transport', 'icon': Icons.directions_bus_outlined},
      {'name': 'Tours', 'icon': Icons.map_outlined},
      {'name': 'Food', 'icon': Icons.restaurant_outlined},
      {'name': 'Entertainment', 'icon': Icons.movie_creation_outlined},
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: categories.length,
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
              color: category == categories[index]['name']
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.primary.withOpacity(0.0),
              width: 1,
            ),
          ),
          surfaceTintColor: Theme.of(context).colorScheme.background,
          child: InkWell(
            onTap: () {
              setState(() {
                category = categories[index]['name'];
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
                    categories[index]['icon'],
                    size: 35,
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  // Title
                  Text(
                    categories[index]['name'],
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
    );
  }

  Widget step1(BuildContext context) {
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
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            icon: Icon(
              Icons.title_outlined,
            ),
            border: OutlineInputBorder(),
            labelText: 'Listing Title*',
            helperText: '*required',
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _descriptionController,
          maxLines: null,
          decoration: const InputDecoration(
            icon: Icon(
              Icons.description_outlined,
            ),
            border: OutlineInputBorder(),
            labelText: 'Description*',
            helperText: '*required',
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _priceController,
          maxLines: null,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            icon: Icon(
              Icons.money_outlined,
            ),
            border: OutlineInputBorder(),
            labelText: 'Price*',
            prefix: Text('₱'),
            helperText: '*required',
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
        ),
        const SizedBox(height: 30),
        Text(
          "Choose a type",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
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
                  color: category == types[index]['name']
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

  Widget step3(BuildContext context) {
    return Column(children: [
      TextFormField(
        controller: _addressController,
        decoration: const InputDecoration(
          icon: Icon(
            Icons.location_on_outlined,
          ),
          border: OutlineInputBorder(),
          labelText: 'Address*',
          helperText: '*required',
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {},
        child: const Text('Update Map'),
      ),
      const SizedBox(height: 10),

      // Google Map
      SizedBox(
        height: 400,
        child: MapWidget(
          address: _addressController.text,
        ),
      ),
    ]);
  }

  Widget step4(BuildContext context) {
    return Column(children: [
      GestureDetector(
        child: Row(
          children: [
            Icon(
              Icons.image_outlined,
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(
                width:
                    15), // Add some spacing between the icon and the container
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
    ]);
  }

  Widget step5(BuildContext context) {
    return Column(children: [
      GestureDetector(
        child: const Row(
          children: [],
        ),
      ),
      const SizedBox(height: 10),
    ]);
  }

  Widget step6(BuildContext context) {
    return Column(
      children: <Widget>[
        // Step 0
        ListTile(
          title: const Text('Category',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          subtitle: Text(category),
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
        ListTile(
          title: const Text('Price',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          subtitle: Text(_priceController.text),
        ),
        const Divider(),
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
              Icons.category_outlined,
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
            });
          },
        ),
        header(),
      ],
    );
  }

  BottomAppBar bottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Cancel Button

          if (activeStep == 0) ...[
            TextButton(
              onPressed: () {
                context.pop();
                ref.read(navBarVisibilityProvider.notifier).show();
              },
              child: const Text('Cancel'),
            ),
          ] else ...[
            TextButton(
              onPressed: () {
                if (activeStep > 0) {
                  setState(() {
                    activeStep--;
                  });
                }
              },
              child: const Text('Back'),
            ),
          ],

          // Next Button
          if (activeStep != upperBound) ...[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                if (activeStep < upperBound) {
                  if (activeStep == 0 && (category == '')) {
                    showSnackBar(context, 'Please select a category');
                    return;
                  }
                  setState(() {
                    activeStep++;
                  });
                }
              },
              child: Text('Next',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                  )),
            )
          ] else ...[
            TextButton(
              onPressed: () {
                // submitAddListing();
              },
              child: const Text('Submit'),
            ),
          ]
        ],
      ),
    );
  }

  Widget header() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              headerText(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
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

class Step2Accommodation extends StatefulWidget {
  final CooperativeModel coop;
  const Step2Accommodation({required this.coop, super.key});

  @override
  State<Step2Accommodation> createState() => _Step2AccommodationState();
}

class _Step2AccommodationState extends State<Step2Accommodation> {
  List<AvailableRoom> availableRooms = [];
  List<List<File>> images = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: GestureDetector(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.image_outlined,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ),
                                        const SizedBox(
                                            width:
                                                15), // Add some spacing between the icon and the container
                                        ImagePickerFormField(
                                          height: MediaQuery.sizeOf(context)
                                                  .height /
                                              5,
                                          width:
                                              MediaQuery.sizeOf(context).width /
                                                  1.3,
                                          context: context,
                                          initialValue: images,
                                          onSaved: (List<File>? files) {
                                            images.addAll(files!);
                                            this.images.add(images);
                                          },
                                          validator: (List<File>? files) {
                                            if (files == null ||
                                                files.isEmpty) {
                                              return 'Please select some images';
                                            }
                                            return null;
                                          },
                                          onImagesSelected: (List<File> files) {
                                            images = files;
                                            this.images.add(images);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: TextFormField(
                                    controller: roomIdController,
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.title_outlined),
                                      border: OutlineInputBorder(),
                                      labelText: "Room Id",
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal:
                                              12), // Adjust padding here
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        MediaQuery.sizeOf(context).height / 50),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: TextFormField(
                                    controller: priceController,
                                    maxLines: null,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration: const InputDecoration(
                                      icon: Icon(
                                        Icons.money_outlined,
                                      ),
                                      border: OutlineInputBorder(),
                                      labelText: 'Price',
                                      prefix: Text('₱'),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal:
                                              12), // Adjust padding here
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
                                          color:
                                              Theme.of(context).dividerColor),
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
                                            style:
                                                const TextStyle(fontSize: 16)),
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
                                          color:
                                              Theme.of(context).dividerColor),
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
                                            style:
                                                const TextStyle(fontSize: 16)),
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
                                          color:
                                              Theme.of(context).dividerColor),
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
                                            style:
                                                const TextStyle(fontSize: 16)),
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
                                          color:
                                              Theme.of(context).dividerColor),
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
                                            style:
                                                const TextStyle(fontSize: 16)),
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
                                  height:
                                      MediaQuery.sizeOf(context).height / 30,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      this.setState(() {
                                        availableRooms.add(AvailableRoom(
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
                                            price: num.parse(
                                                priceController.text)));
                                      });
                                      context.pop();
                                    },
                                    child: const Text("Confirm"))
                              ],
                            ));
                      },
                    );
                  });
            },
            child: const Text('Add Room'),
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: availableRooms.length,
            itemBuilder: ((context, index) {
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageSlider(
                        images: images[index],
                        height: MediaQuery.sizeOf(context).height / 5),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 20.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Room ID: ${availableRooms[index].roomId}",
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    availableRooms.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                          Text(
                            "Price: ₱${availableRooms[index].price}",
                          ),
                          Text(
                            "Guests: ${availableRooms[index].guests}",
                          ),
                          Text(
                            "Bedrooms: ${availableRooms[index].bedrooms}",
                          ),
                          Text(
                            "Beds: ${availableRooms[index].beds}",
                          ),
                          Text(
                            "Bathrooms: ${availableRooms[index].bathrooms}",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            })),
      ],
    );
  }
}
