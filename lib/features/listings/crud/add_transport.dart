import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/listings/listing_provider.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/listing_model.dart';

class AddTransport extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  final String category;
  const AddTransport({required this.coop, required this.category, super.key});

  @override
  ConsumerState<AddTransport> createState() => _AddTransportState();
}

class _AddTransportState extends ConsumerState<AddTransport> {
  // global key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  // stepper
  int activeStep = 0;
  int upperBound = 5;

  // initial values
  String type = 'Nature-Based';
  num guests = 0;
  num luggage = 0;
  
  List<File>? _images = [];

  // controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController(text: 'Eastwood City');
  
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(listingControllerProvider);
    return PopScope(
      canPop: false,
      onPopInvoked:(didPop) {
        context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Listing'),
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
                print(widget.coop.uid);
                List<AvailableTransport> transport = ref.watch(addTransportProvider) ?? [];
                ListingModel updatedListing = 
                  ref.watch(saveListingProvider)!.copyWith(
                    address: _addressController.text,
                    category: widget.category,
                    city: widget.coop.city,
                    cooperative: ListingCooperative(
                      cooperativeId: widget.coop.uid!,
                      cooperativeName: widget.coop.name,
                    ),
                    description: _descriptionController.text,
                    images: _images?.map((e) => ListingImages(path: e.path)).toList(),
                    availableTransport: transport
                  );
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
        return 'Add details';

      case 2:
        return 'Where are you located?';

      case 3:
        return 'Add listing photo/s';

      case 4:
        return 'What do you want the guest/s to know?';
        
      case 5:
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
            floatingLabelBehavior: 
              FloatingLabelBehavior.always,
            hintText: "Name of Listing"
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
              FloatingLabelBehavior.always,
            hintText: "Description of Listing"
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _feeController,
          decoration: const InputDecoration(
            labelText: 'Price*',
            prefix: Text('₱'),
            helperText: '*required',
            border: OutlineInputBorder(),
            floatingLabelBehavior: 
              FloatingLabelBehavior.always,
            hintText: ""
          ),
        ),
        const SizedBox(height: 10),
        ListTile(
          title: const Row(
            children: [
              Icon(Icons.people_alt_outlined),
              SizedBox(width: 10),
              Text('Guests')
            ]
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
                }
              ),
              const SizedBox(width: 10),
              Text(
                "$guests",
                style: const TextStyle(fontSize: 16) 
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    guests++;
                  });
                }
              )
            ]
          )
        ),
        const SizedBox(height: 10),
        ListTile(
          title: const Row(
            children: [
              Icon(Icons.luggage),
              SizedBox(width: 10),
              Text('Luggages')
            ]
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (luggage >= 1) {
                    setState(() {
                      luggage--;
                    });
                  }
                }
              ),
              const SizedBox(width: 10),
              Text(
                "$luggage",
                style: const TextStyle(fontSize: 16) 
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    luggage++;
                  });
                }
              )
            ]
          )
        )
      ],
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
    return const Column();
  }

  Widget reviewListing(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [

        if (_images?.isNotEmpty == true)... [
          const Padding(
            padding: EdgeInsets.only(top: 8.0, left: 12.0),
            child: DisplayText(
              text: "Listing Photo/s",
              lines: 1,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ImageSlider(
              images: _images,
              height: MediaQuery.sizeOf(context).height / 2.5, 
              width: double.infinity
            ),
          ),
        ],
        
        ListTile(
          title: const Text(
            'Category',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
          ),
          subtitle: Text(widget.category)
        ),
        ListTile(
          title: const Text(
            'Type',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            
          ),
          subtitle: Text(type)
        ),
        const Divider(),
        // Step 1
        ListTile(
          title: const Text(
            'Title',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(_titleController.text)
        ),
        ListTile(
          title: const Text('Description',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          subtitle: Text(_descriptionController.text),
        ),
        ListTile(
          title: const Text('Price',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          subtitle: Text("₱${_feeController.text} / per day"),
        ),
        
        const Divider(),
        ListTile(
          title: const Text('Guest Capacity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          subtitle: Text("$guests"),
        ),
        ListTile(
          title: const Text('Luggage Capacity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          subtitle: Text("$luggage"),
        )
        
        
        
      ]
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

      default: return chooseType(context);
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