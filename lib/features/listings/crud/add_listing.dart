import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lakbay/core/providers/storage_repository_providers.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
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
  String? category = 'Accommodation';

  // Step 1
  final _titleController = TextEditingController(text: 'Cozy Condo');
  final _descriptionController =
      TextEditingController(text: 'A wonderful place to stay');
  final _priceController = TextEditingController(text: '1000');

  // Step 2
  int _guests = 1;
  int _bedrooms = 1;
  int _beds = 1;
  int _bathrooms = 1;

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

  void submitAddListing() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var listing = ListingModel(
        category: category!,
        title: _titleController.text,
        description: _descriptionController.text,
        price: num.parse(_priceController.text),
        pax: _guests,
        bedrooms: _bedrooms,
        beds: _beds,
        bathrooms: _bathrooms,
        address: _addressController.text,
        city: widget.coop.city,
        province: widget.coop.province,
        cooperative: ListingCooperative(
          cooperativeId: widget.coop.uid!,
          cooperativeName: widget.coop.name,
        ),
        images: _images!.map((image) {
          final imagePath =
              'listings/${widget.coop.name}/${image.path.split('/').last}';
          return ListingImages(
            path: imagePath,
          );
        }).toList(),
      );

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
        return step2(context);
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
    ];

    return GridView.builder(
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
    return Column(
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
        const SizedBox(height: 10),
      ],
    );
  }

  Widget step2(BuildContext context) {
    return Column(
      children: [
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
                    if (_guests > 1) {
                      setState(() {
                        _guests--;
                      });
                    }
                  },
                ),
                const SizedBox(width: 10),
                Text('$_guests', style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _guests++;
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
                    if (_bedrooms > 1) {
                      setState(() {
                        _bedrooms--;
                      });
                    }
                  },
                ),
                const SizedBox(width: 10),
                Text('$_bedrooms', style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _bedrooms++;
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
                    if (_beds > 1) {
                      setState(() {
                        _beds--;
                      });
                    }
                  },
                ),
                const SizedBox(width: 10),
                Text('$_beds', style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _beds++;
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
                    if (_bathrooms > 1) {
                      setState(() {
                        _bathrooms--;
                      });
                    }
                  },
                ),
                const SizedBox(width: 10),
                Text('$_bathrooms', style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _bathrooms++;
                    });
                  },
                ),
              ],
            ),
          ),
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
          subtitle: Text(category!),
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
        ListTile(
          title: const Text('Guests',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          subtitle: Text('$_guests'),
        ),
        ListTile(
          title: const Text('Bedrooms',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          subtitle: Text('$_bedrooms'),
        ),
        ListTile(
          title: const Text('Beds',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          subtitle: Text('$_beds'),
        ),
        ListTile(
          title: const Text('Bathrooms',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          subtitle: Text('$_bathrooms'),
        ),
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
                  if (activeStep == 0 &&
                      (category == '' || category!.isEmpty)) {
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
                submitAddListing();
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
    Key? key,
    FormFieldSetter<List<File>>? onSaved,
    FormFieldValidator<List<File>>? validator,
    List<File>? initialValue,
    required this.onImagesSelected,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
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
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: const Center(child: Text('Select Images')),
                        ),
                      if (state.value!.isNotEmpty)
                        Container(
                          height: 200,
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
