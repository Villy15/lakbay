import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/core/providers/storage_repository_providers.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/coop_model.dart';

class AddTour extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  final String category;
  const AddTour({required this.coop, required this.category, super.key});

  @override
  ConsumerState<AddTour> createState() => _AddTourState();
}

class _AddTourState extends ConsumerState<AddTour> {
  // Global key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Stepper
  int activeStep = 0;
  int upperBound = 5;

  // Initial values
  String type = 'Day Trip';
  num guests = 0;
  List<bool> workingDays = List.filled(7, false);
  String selectedDurationUnit = 'Hours';
  TimeOfDay duration = const TimeOfDay(hour: 1, minute: 15);

  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController =
      TextEditingController(text: 'Eastwood City');
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _guestInfoController = TextEditingController();
  String mapAddress = "";
  List<File>? _images;

  TimeOfDay _selectedOpeningHours = TimeOfDay.now();

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

    final imagePath = 'listings/${widget.coop.name}';
    final ids = _images!.map((image) => image.path.split('/').last).toList();
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
                debugPrint("line 94");
                ListingCooperative cooperative = ListingCooperative(
                    cooperativeId: widget.coop.uid!,
                    cooperativeName: widget.coop.name);
                // Prepare data for ListingModel
                ListingModel listing = ListingModel(
                  address: _addressController.text,
                  category: widget.category,
                  description: _descriptionController.text,
                  title: _titleController.text,
                  workingDays: workingDays, 
                  type: type,
                  city: "",
                  province: "",
                  images: _images?.map((image) {
                    final imagePath =
                        'listings/${widget.coop.name}/${image.path.split('/').last}';
                    return ListingImages(path: imagePath);
                  }).toList(),
                  cooperative: cooperative,
                  publisherId: ref.read(userProvider)!.uid,
                  publisherName: ref.read(userProvider)!.name,
                  price: num.parse(_priceController.text),
                  pax: int.parse(_capacityController.text),
                  duration: duration,
                  openingHours: DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    _selectedOpeningHours.hour,
                    _selectedOpeningHours.minute,
                  ),
                  guestInfo: _guestInfoController.text,
                );
                debugPrint("Line 126");
                // Update image URLs in the listing model
                listing = listing.copyWith(
                  images: listing.images!.asMap().entries.map((entry) {
                    return entry.value.copyWith(url: imageUrls[entry.key]);
                  }).toList(),
                );

                debugPrint(listing.toString());
                if (mounted) {
                  ref
                      .read(listingControllerProvider.notifier)
                      .addListing(listing, context);
                }
              },
            ));
  }
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
            appBar: AppBar(title: const Text('Tour Listing')),
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

  Widget stepForm(BuildContext context) {
    switch (activeStep) {
      case 1:
        return addDetails(context);
      case 2:
        return addLocation(context);
      case 3:
        return addListingPhotos(context);
      case 4:
        return addGuestInfo(context);
      case 5:
        return reviewListing(context);
      default:
        return chooseType(context);
    }
  }

Widget addDetails(BuildContext context) {
  // List to hold the options for duration unit
  List<String> durationUnitOptions = ['Hours', 'Minutes'];

  // Variable to hold the selected duration unit
  String selectedDurationUnit = durationUnitOptions[0]; // Default: Hours

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 10),
      TextFormField(
        controller: _titleController,
        decoration: const InputDecoration(
          labelText: 'Listing Title*',
          border: OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: "Name of Listing",
        ),
      ),
      const SizedBox(height: 10),
      TextFormField(
        controller: _descriptionController,
        maxLines: null,
        decoration: const InputDecoration(
          labelText: 'Description*',
          border: OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: "Description of Listing",
        ),
      ),
      const SizedBox(height: 10),
      TextFormField(
        controller: _priceController,
        maxLines: null,
        decoration: const InputDecoration(
          labelText: 'Price*',
          border: OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: "Price per person",
        ),
      ),
      const SizedBox(height: 10),
      // Conditionally render the TextFormField based on the selected type
      const SizedBox(height: 10),
      TextFormField(
        controller: _capacityController,
        maxLines: null,
        decoration: const InputDecoration(
          labelText: 'Capacity*',
          border: OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: "Capacity",
        ),
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: _durationController,
              maxLines: 1,
              decoration: const InputDecoration(
                labelText: 'Duration*',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior
                    .always, // Keep the label always visible
                hintText: "1:15",
                suffix: Text(
                  'hr:mins',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                ),
              ),
              readOnly: true,
              onTap: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: duration,
                  initialEntryMode: TimePickerEntryMode.inputOnly,
                  builder: (BuildContext context, Widget? child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: true),
                      child: child!,
                    );
                  },
                );

                if (pickedTime != null) {
                  setState(() {
                    _durationController.text =
                        "${pickedTime.hour}:${pickedTime.minute}";
                    duration = pickedTime;
                  });
                }
              },
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      const SizedBox(height: 10),
      ListTile(
        title: const Text('Start Time*'),
        subtitle: Text(
          'Selected Time: ${_selectedOpeningHours.format(context)}',
        ),
        onTap: () async {
          TimeOfDay? picked = await showTimePicker(
            context: context,
            initialTime: _selectedOpeningHours,
          );
          if (picked != _selectedOpeningHours) {
            setState(() {
              _selectedOpeningHours = picked!;
            });
          }
        },
      ),
      const SizedBox(height: 10),
      const SizedBox(height: 10),
      const Text('Working Days', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const Text('Please select your working days...', style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
      Column(
        children: List<Widget>.generate(7, (int index) {
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
        }),
      ),
      const SizedBox(height: 10),
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



  Widget addLocation(BuildContext context) {
    return Column(children: [
      TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Address*',
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

  Widget addListingPhotos(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Row(
            children: [
              Icon(
                Icons.image_outlined,
                color: Theme.of(context).iconTheme.color
              ),
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
            ]
          )
        )
      ]
    );
  }

  Widget addGuestInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        TextFormField(
          controller:
              _guestInfoController, // Create a new TextEditingController for guest info
          maxLines: null,
          decoration: const InputDecoration(
            labelText: 'Guest Information',
            helperText: 'Enter additional information for guests (optional)',
            border: OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ],
    );
  }

  Widget reviewListing(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (_images?.isNotEmpty == true) ...[
            const Padding(
              padding: EdgeInsets.only(top: 8.0, left: 12.0),
              child: DisplayText(
                  text: "Images:",
                  lines: 1,
                  style:
                      TextStyle(fontSize: 20.0)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ImageSlider(
                  images: _images,
                  height: MediaQuery.sizeOf(context).height / 2.5,
                  width: double.infinity,
                  radius: BorderRadius.circular(10)),
            ),
          ],
          const Padding(
            padding: EdgeInsets.only(top: 8.0, left: 12.0),
            child: DisplayText(
                text: "Title:",
                lines: 1,
                  style:
                      TextStyle(fontSize: 20.0)),
          ),
          ListTile(
            title: DisplayText(
                text: _titleController.text,
                lines: 1,
                  style:
                      const TextStyle(fontSize: 20.0)),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0, left: 12.0),
            child: DisplayText(
                text: "Description:",
                lines: 1,
                  style:
                      TextStyle(fontSize: 20.0)),
          ),
          ListTile(
            title: DisplayText(
                text: _descriptionController.text,
                lines: 1,
                  style:
                      const TextStyle(fontSize: 20.0)),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0, left: 12.0),
            child: DisplayText(
                text: "Address:",
                lines: 1,
                  style:
                      TextStyle(fontSize: 20.0)),
          ),
          ListTile(
            title: DisplayText(
                text: _addressController.text,
                lines: 1,
                  style:
                      const TextStyle(fontSize: 20.0)),
          ),
          // add working days
          ListTile(
            title: const Text('Working Days',
                style: TextStyle(fontSize: 20)),
            subtitle: Text(workingDays
                .asMap()
                .entries
                .where((element) => element.value)
                .map((e) => getDay(e.key))
                .toList()
                .join(', ')),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0, left: 12.0),
            child: DisplayText(
                text: "Price:",
                lines: 1,
                  style:
                      TextStyle(fontSize: 20.0)),
          ),
          ListTile(
            title: DisplayText(
                text: _priceController.text,
                lines: 1,
                  style:
                      const TextStyle(fontSize: 20.0)),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0, left: 12.0),
            child: DisplayText(
              text: "Duration:",
              lines: 1,
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          ListTile(
            title: DisplayText(
              text: "${_durationController.text} $selectedDurationUnit",
              lines: 1,
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0, left: 12.0),
            child: DisplayText(
                text: "Capacity:",
                lines: 1,
                  style:
                      TextStyle(fontSize: 20.0)),
          ),
          ListTile(
            title: DisplayText(
                text: _capacityController.text,
                lines: 1,
                  style:
                      const TextStyle(fontSize: 20.0)),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0, left: 12.0),
            child: DisplayText(
                text: "Guest Information:",
                lines: 1,
                  style:
                      TextStyle(fontSize: 20.0)),
          ),
          ListTile(
            title: DisplayText(
                text: _guestInfoController.text.isEmpty
                    ? "No additional information provided."
                    : _guestInfoController.text,
                lines: 1,
                  style:
                      const TextStyle(fontSize: 20.0)),
          ),
          const SizedBox(height: 20.0),
        ]);
  }

  Widget chooseType(BuildContext context) {
    List<Map<String, dynamic>> types = [
      {'name': 'Day Trip', 'icon': Icons.directions_car},
      {'name': 'Multi-Day Tour', 'icon': Icons.airplanemode_active},
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

  Row header() {
    return Row(
      children: [
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Add ${widget.category}',
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
              onPressed: () {
                submitAddListing();
              },
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
