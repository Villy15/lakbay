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
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/wrappers/committee_params.dart';

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
  int upperBound = 6;

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
                    hintText: "e.g., Clean the tables",
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
              Icons.task,
              color: Theme.of(context).colorScheme.background,
            ),
            Icon(Icons.policy, color: Theme.of(context).colorScheme.background),
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
        return 'Add Fixed Tasks';

      case 5:
        return 'Add Policies';

      case 6:
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
              width: double.infinity,
              radius: BorderRadius.circular(10))
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
                      radius: BorderRadius.circular(10)),
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
                  width: double.infinity,
                  radius: BorderRadius.circular(10)),
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
                            radius: BorderRadius.circular(10)),
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
                  width: double.infinity,
                  radius: BorderRadius.circular(10)),
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
        return addFixedTasks(context);
      case 5:
        return addPolicies(context);
      case 6:
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
