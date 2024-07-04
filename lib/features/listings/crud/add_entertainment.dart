import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
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
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

enum CancelPolicy { fixedCancelRate, percentageCancelRate }

enum IntervalOptions { paddedIntervals, fixedIntervals }

enum SchedulingOptions { dayAvaiabilityScheduling, dateScheduling }

class AddEntertainment extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  final String category;
  const AddEntertainment(
      {required this.coop, required this.category, super.key});

  @override
  ConsumerState<AddEntertainment> createState() => _AddEntertainmentState();
}

class _AddEntertainmentState extends ConsumerState<AddEntertainment> {
  // global key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // stepper
  int activeStep = 0;
  int upperBound = 5;

  // initial values
  String type = 'Rentals';
  num guests = 0;
  List<bool> workingDays = List.filled(7, false);

  List<AvailableDay> availableDays = [];
  List<AvailableTime> availableTimes = [];
  TimeOfDay duration = const TimeOfDay(hour: 1, minute: 15);
  IntervalOptions? _selectedIntervalOption; // Default value
  SchedulingOptions? _selectedSchedulingOption; // Default value
  String mapAddress = "";
  List<File>? _images;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedOpeningHours = const TimeOfDay(hour: 8, minute: 30);
  TimeOfDay _selectedClosingHours = const TimeOfDay(hour: 17, minute: 0);
  // controllers

  final TextEditingController durationController =
      TextEditingController(text: '1:15');
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _unitsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _guestInfoController = TextEditingController();
  final TextEditingController _selectedOpeningHoursController =
      TextEditingController(text: '8:30 AM');
  final TextEditingController _selectedClosingHoursController =
      TextEditingController(text: '5:30 PM  ');
  final TextEditingController _cancellationRateController =
      TextEditingController();
  final TextEditingController _cancellationPeriodController =
      TextEditingController();
  CancelPolicy _selectedCancel = CancelPolicy.fixedCancelRate; // Default value
  EntertainmentScheduling entertainmentScheduling = EntertainmentScheduling();
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

  void onTapDate(BuildContext context, DateTime startDate, DateTime endDate,
      StateSetter setSchedule) {
    DateTime localStartDate = startDate;
    DateTime localEndDate = endDate;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setDate) {
          return Dialog.fullscreen(
              child: Column(children: [
            AppBar(
              iconTheme: IconThemeData(
                color: Theme.of(context)
                    .colorScheme
                    .primary, // Change this color to your desired color
              ),
              title: Text(
                "Date Scheduling",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SfDateRangePicker(
                      selectionMode: DateRangePickerSelectionMode.range,
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        setDate(() {
                          localStartDate = args.value.startDate;
                          localEndDate = args.value.endDate;
                        });
                      },
                      minDate: DateTime.now(),
                    ),
                    FilledButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(120, 45)),
                      ),
                      onPressed: () {
                        setSchedule(() {
                          startDate = localStartDate;
                          endDate = localEndDate;
                          setState(() {
                            this.startDate = localStartDate;
                            this.endDate = localEndDate;
                          });
                        });
                        context.pop();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ]));
        });
      },
    );
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
                  ListingCooperative cooperative = ListingCooperative(
                      cooperativeId: widget.coop.uid!,
                      cooperativeName: widget.coop.name);
                  debugPrint(cooperative.toString());
                  // Prepare data for ListingModel
                  ListingModel listing = ListingModel(
                    availableTimes: availableTimes,
                    address: _addressController.text,
                    category: widget.category,
                    description: _descriptionController.text,
                    title: _titleController.text,
                    availableDays: availableDays,
                    type: type,
                    entertainmentScheduling: entertainmentScheduling,
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
                    numberOfUnits: int.parse(_unitsController.text),
                    duration: duration,
                    openingHours: TimeOfDay(
                        hour: _selectedOpeningHours.hour,
                        minute: _selectedOpeningHours.minute),
                    closingHours: TimeOfDay(
                        hour: _selectedClosingHours.hour,
                        minute: _selectedClosingHours.minute),
                    guestInfo: _guestInfoController.text,
                    cancellationPeriod:
                        num.parse(_cancellationPeriodController.text),
                    cancellationRate: _selectedCancel ==
                            CancelPolicy.fixedCancelRate
                        ? num.parse((_cancellationRateController.text))
                        : num.parse((_cancellationRateController.text)) / 100,
                  );
                  debugPrint(listing.toString());
                  //Update image URLs in the listing model
                  listing = listing.copyWith(
                    images: listing.images!.asMap().entries.map((entry) {
                      return entry.value.copyWith(url: imageUrls[entry.key]);
                    }).toList(),
                  );

                  debugPrint(listing.toString());
                  if (mounted) {
                    ref.read(listingLocationProvider.notifier).clearLocation();
                    ref
                        .read(listingControllerProvider.notifier)
                        .addListing(listing, context);
                    ref.read(listingLocationProvider.notifier).reset();
                  }
                },
              ));
    }
  }

  void submitAddTour() {
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
                  ListingCooperative cooperative = ListingCooperative(
                      cooperativeId: widget.coop.uid!,
                      cooperativeName: widget.coop.name);
                  debugPrint(cooperative.toString());
                  // Prepare data for ListingModel
                  ListingModel listing = ListingModel(
                    availableTimes: availableTimes,
                    address: _addressController.text,
                    category: widget.category,
                    description: _descriptionController.text,
                    title: _titleController.text,
                    type: type,
                    entertainmentScheduling: entertainmentScheduling,
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
                    duration: duration,
                    cancellationPeriod:
                        num.parse(_cancellationPeriodController.text),
                    cancellationRate: _selectedCancel ==
                            CancelPolicy.fixedCancelRate
                        ? num.parse((_cancellationRateController.text))
                        : num.parse((_cancellationRateController.text)) / 100,
                  );
                  //Update image URLs in the listing model
                  listing = listing.copyWith(
                    images: listing.images!.asMap().entries.map((entry) {
                      return entry.value.copyWith(url: imageUrls[entry.key]);
                    }).toList(),
                  );

                  debugPrint(listing.toString());
                  if (mounted) {
                    ref.read(listingLocationProvider.notifier).clearLocation();
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
            appBar: AppBar(title: const Text('Entertainment Listing')),
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

  Widget datePicker(BuildContext context, DateTime startDate, DateTime endDate,
      StateSetter setSchedule) {
    return Column(
      children: [
        ListTile(
          title: const Text('Available Dates'),
          leading: const Icon(Icons.calendar_today_outlined),
          subtitle: Text(
              '${DateFormat.MMMMd().format(startDate)} - ${DateFormat.yMMMMd().format(endDate)}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            onTapDate(context, startDate, endDate, setSchedule);
          },
        ),
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
              Icons.policy,
              color: Theme.of(context).colorScheme.background,
            ),
            // Icon(
            //   Icons.summarize_outlined,
            //   color: Theme.of(context).colorScheme.background,
            // ),
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

  Widget stepForm(BuildContext context) {
    switch (activeStep) {
      case 1:
        switch (type) {
          case 'Rentals':
            return addRentalDetails(context);
          case 'Watching/Performances':
            return addWatchingPerformancesDetails(context);
          case 'Activities/Tours':
            return addActivitiesDetails(context);
          default:
            return addRentalDetails(context);
        }
      case 2:
        return addLocation(context);
      case 3:
        return addListingPhotos(context);
      case 4:
        switch (type) {
          case 'Rentals':
            return calculateIntervals(context);
          case 'Watching/Performances':
            return createScheduling(context);
          case 'Activities/Tours':
            return createScheduling(context);
          default:
            return calculateIntervals(context);
        }
      case 5:
        return addPolicies(context);
      // case 6:
      //   return reviewListing(context);
      default:
        return chooseType(context);
    }
  }

  Widget addRentalDetails(BuildContext context) {
    List<String> notes = [
      "Duration is the rental duration for every booking.",
      "Number of units refers to the total amount of units available for rent.",
      "Capacity refers to the maximum number of persons that can be accommodated per unit.",
      "Start Time and End Time is similar to your working hours. This information can later be used to calculate availability of units in intervals using your provided duration",
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Listing Title',
            border: OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: "Banana Boating",
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _descriptionController,
          maxLines: null,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: "Go on a banana boat ride...",
          ),
        ),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
            child: TextFormField(
              controller: _priceController,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: "250",
                prefix: Text('₱'),
                suffix: Text(
                  'per person',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: durationController,
              maxLines: 1,
              decoration: const InputDecoration(
                labelText: 'Duration',
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
                    durationController.text =
                        "${pickedTime.hour}:${pickedTime.minute}";
                    duration = pickedTime;
                  });
                }
              },
            ),
          ),
        ]),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _unitsController,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Number of Units',
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: "2",
                  suffix: Text(
                    'units',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: TextFormField(
                controller: _capacityController,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Capacity',
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: "10",
                  suffix: Text(
                    'person/s',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
            child: TextFormField(
              controller: _selectedOpeningHoursController,
              maxLines: 1,
              decoration: const InputDecoration(
                labelText: 'Start Time',
                border: OutlineInputBorder(),

                floatingLabelBehavior: FloatingLabelBehavior
                    .always, // Keep the label always visible
                hintText: "8:30 AM",
              ),
              readOnly: true,
              onTap: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _selectedOpeningHours,
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
                    _selectedOpeningHoursController.text =
                        pickedTime.format(context);
                    _selectedOpeningHours = pickedTime;
                  });
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: _selectedClosingHoursController,
              maxLines: 1,
              decoration: const InputDecoration(
                labelText: 'End Time',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior
                    .always, // Keep the label always visible
                hintText: "5:30 PM",
              ),
              readOnly: true,
              onTap: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _selectedClosingHours,
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
                    _selectedClosingHoursController.text =
                        pickedTime.format(context);
                    _selectedClosingHours = pickedTime;
                  });
                }
              },
            ),
          ),
        ]),
        const SizedBox(height: 10),
        addNotes(
          notes,
        ),
      ],
    );
  }

  Widget addWatchingPerformancesDetails(BuildContext context) {
    List<String> notes = [
      "Duration refers to how long the Showing/Performance will take to completion.",
      "Capacity refers to the maximum number of persons allowed for a single Showing/Performance.",
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Listing Title',
            border: OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: "Traditional Fire Dance",
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _descriptionController,
          maxLines: null,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText:
                "Experience the primal energy and ancient artistry of fire dancing...",
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _priceController,
          maxLines: null,
          decoration: const InputDecoration(
            labelText: 'Price',
            prefix: Text('₱'),
            suffix: Text(
              'per person',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
            ),
            border: OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: "400",
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _capacityController,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Capacity',
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffix: Text(
                    'person/s',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                  hintText: "10",
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: durationController,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: 'Duration',
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior
                      .always, // Keep the label always visible
                  hintText: "1:15",
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
                      durationController.text =
                          "${pickedTime.hour}:${pickedTime.minute}";
                      duration = pickedTime;
                    });
                  }
                },
              ),
            )
          ],
        ),
        addNotes(
          notes,
        ),
      ],
    );
  }

  Widget addActivitiesDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Listing Title',
            border: OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: "Pottery Making Class",
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _descriptionController,
          maxLines: null,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText:
                "Unleash your inner artist and discover the joy of pottery...",
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _priceController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    prefix: Text('₱'),
                    suffix: Text(
                      'per person',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "50",
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: durationController,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    labelText: 'Duration',
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior
                        .always, // Keep the label always visible
                    hintText: "1:15",
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
                        durationController.text =
                            "${pickedTime.hour}:${pickedTime.minute}";
                        duration = pickedTime;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
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
    final location = ref.read(listingLocationProvider);
    if (location != null) {
      _addressController.text = location;
      mapAddress = location;
    }
    return Column(children: [
      TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Address',
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
        child: MapWidget(address: mapAddress),
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

  Widget calculateIntervals(BuildContext context) {
    TimeOfDay timePadding = const TimeOfDay(hour: 0, minute: 15);
    TextEditingController timePaddingController = TextEditingController(
        text: '${timePadding.hour}:${timePadding.minute}');
    List<String> notes = [
      'Intervals will determine the availability of your units to be rented at a given day.',
      'Time Paddding refers to an added time you might want to add inbetween bookings, incase you might need time inbetween rentals of a unit (Duration: 30mins, Time Padding: 15mins, your rentals will have 45 minute intervals).',
    ];
    return StatefulBuilder(builder: (context, setOption) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Radio buttons for payment options
                        Flexible(
                          child: SizedBox(
                            child: RadioListTile<IntervalOptions>(
                              contentPadding: const EdgeInsets.all(0),
                              title: const Text('Padded\nIntervals'),
                              value: IntervalOptions.paddedIntervals,
                              groupValue: _selectedIntervalOption,
                              onChanged: (IntervalOptions? value) {
                                setState(() {
                                  _selectedIntervalOption = value!;
                                  availableTimes = [];
                                });
                              },
                            ),
                          ),
                        ),
                        Flexible(
                          child: RadioListTile<IntervalOptions>(
                            contentPadding: const EdgeInsets.all(0),
                            title: const Text('Fixed\nIntervals'),
                            value: IntervalOptions.fixedIntervals,
                            groupValue: _selectedIntervalOption,
                            onChanged: (IntervalOptions? value) {
                              setState(() {
                                _selectedIntervalOption = value!;
                                availableTimes = [];
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    if (_selectedIntervalOption ==
                        IntervalOptions.paddedIntervals) ...[
                      timePaddingFormField(
                          timePaddingController, timePadding, setOption),
                      showIntervalInfo(),
                      intervalOptionsDetails(timePadding: timePadding),
                    ],
                    if (_selectedIntervalOption ==
                        IntervalOptions.fixedIntervals) ...[
                      addIntervalButton(context),
                      showIntervalInfo(),
                      intervalOptionsDetails(timePadding: timePadding),
                    ]
                  ],
                ),
              ),
            ),
            addNotes(notes),
          ],
        ),
      );
    });
  }

  Widget addIntervalButton(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        width: MediaQuery.sizeOf(context).width / 2,
        child: FilledButton(
          onPressed: () async {
            final TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: availableTimes.isEmpty
                  ? _selectedOpeningHours
                  : availableTimes.last.time,
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
                availableTimes.add(AvailableTime(
                    available: true,
                    maxPax: num.parse(_capacityController.text),
                    time: pickedTime));
              });
            }
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  8), // Adjust the border radius as needed
            ),
          ),
          child: const Text('Add Interval'),
        ));
  }

  Widget showIntervalInfo() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Rental Intervals:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            Row(
              children: [
                Text(
                  '${availableTimes.length}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w400),
                ),
                const SizedBox(width: 2.5),
                const Text(
                  'per day',
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Available Rentals:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
              Row(
                children: [
                  Text(
                    '${availableTimes.length * int.parse(_unitsController.text)}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(width: 2.5),
                  const Text(
                    'per day',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ],
          )),
    ]);
  }

  Widget timePaddingFormField(TextEditingController timePaddingController,
      TimeOfDay timePadding, StateSetter setOption) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.sizeOf(context).width / 2,
      child: TextFormField(
        controller: timePaddingController,
        maxLines: 1,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
          labelText: 'Time Padding',
          border: const OutlineInputBorder(),
          floatingLabelBehavior:
              FloatingLabelBehavior.always, // Keep the label always visible
          hintText: timePaddingController.text,
          suffix: const Text(
            'hr:mins',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
          ),
        ),
        readOnly: true,
        onTap: () async {
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: timePadding,
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
            setOption(() {
              timePaddingController.text =
                  "${pickedTime.hour}:${pickedTime.minute}";
              timePadding = pickedTime;
            });

            TimeOfDay intervalDuration = TimeOfDay(
                hour: duration.hour + timePadding.hour,
                minute: duration.minute + timePadding.minute);
            if (intervalDuration.minute >= 60) {
              intervalDuration = TimeOfDay(
                  hour: intervalDuration.hour + 1,
                  minute: intervalDuration.minute - 60);
            }
            availableTimes = calculatePaddedIntervals(intervalDuration);
          }
        },
      ),
    );
  }

  List<AvailableTime> calculatePaddedIntervals(TimeOfDay intervalDuration) {
    List<AvailableTime> intervals = [];
    num maxPax = num.parse(_capacityController.text);
    AvailableTime currentTime = AvailableTime(
        available: true, maxPax: maxPax, time: _selectedOpeningHours);
    while (currentTime.time.hour < _selectedClosingHours.hour ||
        (currentTime.time.hour == _selectedClosingHours.hour &&
            currentTime.time.minute < _selectedClosingHours.minute)) {
      intervals.add(currentTime);
      currentTime = AvailableTime(
        available: true,
        maxPax: maxPax,
        time: TimeOfDay(
            hour: currentTime.time.hour + intervalDuration.hour,
            minute: currentTime.time.minute + intervalDuration.minute),
      );

      if (currentTime.time.minute >= 60) {
        currentTime = AvailableTime(
          available: true,
          maxPax: maxPax,
          time: TimeOfDay(
              hour: currentTime.time.hour + 1,
              minute: currentTime.time.minute - 60),
        );
      }
    }

    return intervals;
  }

  Widget addPolicies(BuildContext context) {
    List<String> notes = [
      "Cancellation Rate: The amount that would not be refunded in the situation that a customer cancels their booking.",
      "Cancellation Period: This refers to the number of days before the scheduled booking, that a customer can cancel and pay the full amount in the case for a downpayment. Otherwise their booking will be cancelled",
      "Customers booking passed the cancellation period would be required to pay the downpayment or full amount upon checkout."
    ];
    return Column(
      children: [
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
                labelText: 'Percentage Rate',
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

  Widget chooseType(BuildContext context) {
    List<Map<String, dynamic>> types = [
      {'name': 'Rentals', 'icon': Icons.sailing},
      {'name': 'Watching/Performances', 'icon': Icons.theater_comedy},
      {'name': 'Activities/Tours', 'icon': Icons.directions_walk},
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
        switch (type) {
          case 'Rentals':
            return 'Intervals and Availability';
          case 'Watching/Performances':
            return "Scheduling";
          case 'Activities/Tours':
            return 'Scheduling';
          default:
            return 'Intervals and Availability';
        }
      case 5:
        return 'Add Policies';
      // case 6:
      //   return 'Review Listing';
      default:
        return 'Choose Type';
    }
  }

  Widget bottomAppBar() {
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
              switch (type) {
                case "Rentals":
                  return submitAddListing();
                case "Watching/Performances":
                  return submitAddTour();
                case "Activities/Tours":
                  return submitAddTour();
                default:
                  return submitAddTour();
              }
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

  Widget intervalOptionsDetails({TimeOfDay? timePadding}) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 10.0, // Spacing between columns
            mainAxisSpacing: 0.0, // Spacing between rows
            mainAxisExtent: MediaQuery.sizeOf(context).height / 15),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: availableTimes.length,
        itemBuilder: (context, timeIndex) {
          final availableTime = availableTimes[timeIndex];
          return ListTile(
            horizontalTitleGap: 5,
            leading: Text('${timeIndex + 1}'),
            title: Text(
                '${availableTime.time.hourOfPeriod}:${availableTime.time.minute == 0 ? '00' : availableTime.time.minute} ${availableTime.time.period.name.toUpperCase()}'),
            titleTextStyle: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          );
        });
  }

  Widget createScheduling(BuildContext context) {
    List<String> notes = [
      "Availability Scheduling will allow you to adjust your listings availability by certain days of the week.",
      "Date Scheduling will allow you to make your listing available during the dates you specify.",
    ];

    return StatefulBuilder(builder: (context, setOption) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 50,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Radio buttons for payment options
                        Flexible(
                          child: SizedBox(
                            child: RadioListTile<SchedulingOptions>(
                              contentPadding: const EdgeInsets.all(0),
                              title: const Text('Availability\nScheduling'),
                              value: SchedulingOptions.dayAvaiabilityScheduling,
                              groupValue: _selectedSchedulingOption,
                              onChanged: (SchedulingOptions? value) {
                                setState(() {
                                  _selectedSchedulingOption = value!;
                                  availableTimes = [];

                                  entertainmentScheduling =
                                      entertainmentScheduling.copyWith(
                                          type: "dayScheduling");
                                });
                              },
                            ),
                          ),
                        ),
                        Flexible(
                          child: RadioListTile<SchedulingOptions>(
                            contentPadding: const EdgeInsets.all(0),
                            title: const Text('Date\nScheduling'),
                            value: SchedulingOptions.dateScheduling,
                            groupValue: _selectedSchedulingOption,
                            onChanged: (SchedulingOptions? value) {
                              setState(() {
                                _selectedSchedulingOption = value!;
                                availableTimes = [];
                                entertainmentScheduling =
                                    entertainmentScheduling.copyWith(
                                        type: "dateScheduling");
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    if (_selectedSchedulingOption ==
                        SchedulingOptions.dayAvaiabilityScheduling) ...[
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        width: MediaQuery.sizeOf(context).width / 1.2,
                        child: FilledButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog.fullscreen(
                                    child: showSchedulingForm(),
                                  );
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 24.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Adjust the border radius as needed
                            ),
                          ),
                          child: const Text('Add Schedule'),
                        ),
                      ),
                      if (entertainmentScheduling.type == "dayScheduling")
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                entertainmentScheduling.availability?.length,
                            itemBuilder: (context, dayIndex) {
                              AvailableDay day = entertainmentScheduling
                                  .availability![dayIndex];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    day.day,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  day.availableTimes.isNotEmpty
                                      ? GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: day.availableTimes.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                                2, // Number of columns
                                            mainAxisSpacing:
                                                0, // Spacing between rows
                                            crossAxisSpacing:
                                                0.0, // Spacing between columns
                                            childAspectRatio:
                                                2.0, // Adjust this value to change the item aspect ratio
                                          ),
                                          itemBuilder: (context, timeIndex) {
                                            AvailableTime time =
                                                day.availableTimes[timeIndex];
                                            return GridTile(
                                              header: Text(
                                                time.time.format(context),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                                textAlign: TextAlign.center,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Capacity: ${time.maxPax}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : const Center(
                                          child: Text("No Schedule")),
                                ],
                              );
                            }),
                    ],
                    if (_selectedSchedulingOption ==
                        SchedulingOptions.dateScheduling) ...[
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        width: MediaQuery.sizeOf(context).width / 1.2,
                        child: FilledButton(
                          onPressed: () {
                            debugPrint(entertainmentScheduling.toString());
                            // showDateScheduling(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 24.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Adjust the border radius as needed
                            ),
                          ),
                          child: const Text('Add Schedule'),
                        ),
                      ),
                      if (entertainmentScheduling.type == "dateScheduling")
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                entertainmentScheduling.fixedDates?.length,
                            itemBuilder: (context, dateIndex) {
                              AvailableDate date = entertainmentScheduling
                                  .fixedDates![dateIndex];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formatDateMMDDYYYY(date.date),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  date.availableTimes.isNotEmpty
                                      ? GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: date.availableTimes.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                                2, // Number of columns
                                            mainAxisSpacing:
                                                0, // Spacing between rows
                                            crossAxisSpacing:
                                                0.0, // Spacing between columns
                                            childAspectRatio:
                                                2.0, // Adjust this value to change the item aspect ratio
                                          ),
                                          itemBuilder: (context, timeIndex) {
                                            AvailableTime time =
                                                date.availableTimes[timeIndex];
                                            return GridTile(
                                              header: Text(
                                                time.time.format(context),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                                textAlign: TextAlign.center,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Capacity: ${time.maxPax}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : const Center(
                                          child: Text("No Schedule")),
                                ],
                              );
                            })
                    ],
                  ],
                ),
              ),
            ),
            addNotes(notes),
          ],
        ),
      );
    });
  }

  Future<dynamic> showDateScheduling(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          TimeOfDay timeSlot = const TimeOfDay(hour: 8, minute: 30);
          List<AvailableTime> timeSlots = [];
          TextEditingController timeSlotCapacityController =
              TextEditingController();
          TextEditingController timeSlotController = TextEditingController();
          return StatefulBuilder(builder: (context, setSchedule) {
            return Dialog.fullscreen(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  iconTheme: IconThemeData(
                    color: Theme.of(context)
                        .colorScheme
                        .primary, // Change this color to your desired color
                  ),
                  title: Text(
                    "Date Scheduling",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Date Selector",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          datePicker(
                            context,
                            startDate,
                            endDate,
                            setSchedule,
                          ),
                          const SizedBox(height: 20),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Time Slot & Capacity',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary)),
                                    const SizedBox(width: 10),
                                    FilledButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    "Time Slot & Capacity"),
                                                content: SizedBox(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                          .width,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: TextFormField(
                                                          controller:
                                                              timeSlotController,
                                                          maxLines: 1,
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                'Time Slot',
                                                            border:
                                                                OutlineInputBorder(),
                                                            floatingLabelBehavior:
                                                                FloatingLabelBehavior
                                                                    .always, // Keep the label always visible
                                                            hintText: "8:30 AM",
                                                          ),
                                                          readOnly: true,
                                                          onTap: () async {
                                                            final TimeOfDay?
                                                                pickedTime =
                                                                await showTimePicker(
                                                              context: context,
                                                              initialTime:
                                                                  timeSlot,
                                                              initialEntryMode:
                                                                  TimePickerEntryMode
                                                                      .inputOnly,
                                                              builder: (BuildContext
                                                                      context,
                                                                  Widget?
                                                                      child) {
                                                                return MediaQuery(
                                                                  data: MediaQuery.of(
                                                                          context)
                                                                      .copyWith(
                                                                          alwaysUse24HourFormat:
                                                                              false),
                                                                  child: child!,
                                                                );
                                                              },
                                                            );

                                                            if (pickedTime !=
                                                                null) {
                                                              setSchedule(() {
                                                                timeSlotController
                                                                        .text =
                                                                    pickedTime
                                                                        .format(
                                                                            context);
                                                                timeSlot =
                                                                    pickedTime;
                                                              });
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          controller:
                                                              timeSlotCapacityController,
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                'Capacity',
                                                            border:
                                                                OutlineInputBorder(),
                                                            floatingLabelBehavior:
                                                                FloatingLabelBehavior
                                                                    .always,
                                                            hintText: "10",
                                                            suffix: Text(
                                                              'person/s',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  FilledButton(
                                                      onPressed: () {
                                                        context.pop();
                                                      },
                                                      style: FilledButton
                                                          .styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 12.0),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  8.0), // Adjust the value as needed
                                                        ),
                                                      ),
                                                      child:
                                                          const Text('Cancel')),
                                                  FilledButton(
                                                      onPressed: () {
                                                        setSchedule(() {
                                                          AvailableTime
                                                              availableTime =
                                                              AvailableTime(
                                                                  available:
                                                                      true,
                                                                  maxPax: num.parse(
                                                                      timeSlotCapacityController
                                                                          .text),
                                                                  time:
                                                                      timeSlot);
                                                          timeSlots.add(
                                                              availableTime);
                                                        });
                                                        context.pop();
                                                      },
                                                      style: FilledButton
                                                          .styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 12.0),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  8.0), // Adjust the value as needed
                                                        ),
                                                      ),
                                                      child: const Text('Add')),
                                                ],
                                              );
                                            });
                                      },
                                      style: FilledButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              8.0), // Adjust the value as needed
                                        ),
                                      ),
                                      child: const Text(
                                        "Add",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                                const Text(
                                    'Please indicate the time slot and capacity for selected dates.',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic)),
                                const SizedBox(
                                  height: 10,
                                ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: timeSlots.length,
                                    itemBuilder: (context, timeSlotIndex) {
                                      var timeSlot = timeSlots[timeSlotIndex];
                                      return ListTile(
                                        title:
                                            Text(timeSlot.time.format(context)),
                                        subtitle: Text(
                                            "Capacity: ${timeSlot.maxPax}"),
                                        trailing: const Icon(Icons.close),
                                      );
                                    }),
                              ]),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 10, left: 10, right: 10),
                            width: double.infinity,
                            child: FilledButton(
                                onPressed: () {
                                  List<AvailableDate> dates = [];
                                  DateTime currentDate = startDate;
                                  while (currentDate.isBefore(endDate) ||
                                      currentDate.isAtSameMomentAs(endDate)) {
                                    dates.add(AvailableDate(
                                        available: true,
                                        date: currentDate,
                                        availableTimes: timeSlots));
                                    currentDate = currentDate
                                        .add(const Duration(days: 1));
                                  }
                                  setState(() {
                                    entertainmentScheduling =
                                        entertainmentScheduling.copyWith(
                                            type: "dateScheduling",
                                            fixedDates: dates);
                                    debugPrint(
                                        entertainmentScheduling.toString());
                                  });
                                  context.pop();
                                },
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Adjust the value as needed
                                  ),
                                ),
                                child: const Text('Save')),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ));
          });
        });
  }

  Widget showSchedulingForm() {
    TimeOfDay timeSlot = const TimeOfDay(hour: 8, minute: 30);
    TextEditingController timeSlotController =
        TextEditingController(text: '8:30 AM');
    TextEditingController timeSlotCapacityController = TextEditingController();
    var localWorkingDays = [...workingDays];
    List<AvailableTime> timeSlots = [];
    return StatefulBuilder(builder: (context, setVars) {
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
              "Availability Scheduling",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Working Days',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          const Text(
                              'Please indicate the days of booking availability.',
                              style: TextStyle(
                                  fontSize: 15, fontStyle: FontStyle.italic)),
                        ]),
                  ),
                  Column(
                    children: List<Widget>.generate(7, (int index) {
                      return CheckboxListTile(
                        visualDensity: VisualDensity.compact,
                        title: Text(
                          getDay(index),
                          style: const TextStyle(fontSize: 16),
                        ),
                        value: localWorkingDays[index],
                        onChanged: (bool? value) {
                          setVars(() {
                            localWorkingDays[index] = value!;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Time Slot & Capacity',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                              const SizedBox(width: 10),
                              FilledButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                              "Time Slot & Capacity"),
                                          content: SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    controller:
                                                        timeSlotController,
                                                    maxLines: 1,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Time Slot',
                                                      border:
                                                          OutlineInputBorder(),
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .always, // Keep the label always visible
                                                      hintText: "8:30 AM",
                                                    ),
                                                    readOnly: true,
                                                    onTap: () async {
                                                      final TimeOfDay?
                                                          pickedTime =
                                                          await showTimePicker(
                                                        context: context,
                                                        initialTime: timeSlot,
                                                        initialEntryMode:
                                                            TimePickerEntryMode
                                                                .inputOnly,
                                                        builder: (BuildContext
                                                                context,
                                                            Widget? child) {
                                                          return MediaQuery(
                                                            data: MediaQuery.of(
                                                                    context)
                                                                .copyWith(
                                                                    alwaysUse24HourFormat:
                                                                        false),
                                                            child: child!,
                                                          );
                                                        },
                                                      );

                                                      if (pickedTime != null) {
                                                        setVars(() {
                                                          timeSlotController
                                                                  .text =
                                                              pickedTime.format(
                                                                  context);
                                                          timeSlot = pickedTime;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller:
                                                        timeSlotCapacityController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Capacity',
                                                      border:
                                                          OutlineInputBorder(),
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .always,
                                                      hintText: "10",
                                                      suffix: Text(
                                                        'person/s',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            FilledButton(
                                                onPressed: () {
                                                  context.pop();
                                                },
                                                style: FilledButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 12.0),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0), // Adjust the value as needed
                                                  ),
                                                ),
                                                child: const Text('Cancel')),
                                            FilledButton(
                                                onPressed: () {
                                                  setVars(() {
                                                    AvailableTime
                                                        availableTime =
                                                        AvailableTime(
                                                            available: true,
                                                            maxPax: num.parse(
                                                                timeSlotCapacityController
                                                                    .text),
                                                            time: timeSlot);
                                                    timeSlots
                                                        .add(availableTime);
                                                  });
                                                  context.pop();
                                                },
                                                style: FilledButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 12.0),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0), // Adjust the value as needed
                                                  ),
                                                ),
                                                child: const Text('Add')),
                                          ],
                                        );
                                      });
                                },
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Adjust the value as needed
                                  ),
                                ),
                                child: const Text(
                                  "Add",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          const Text(
                              'Please indicate the time slot and capacity for selected days.',
                              style: TextStyle(
                                  fontSize: 15, fontStyle: FontStyle.italic)),
                          const SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: timeSlots.length,
                              itemBuilder: (context, timeSlotIndex) {
                                var timeSlot = timeSlots[timeSlotIndex];
                                return ListTile(
                                  title: Text(timeSlot.time.format(context)),
                                  subtitle:
                                      Text("Capacity: ${timeSlot.maxPax}"),
                                  trailing: const Icon(Icons.close),
                                );
                              }),
                        ]),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    width: double.infinity,
                    child: FilledButton(
                        onPressed: () {
                          List<AvailableDay> updatedDays = [];
                          for (int i = 0; i < localWorkingDays.length; i++) {
                            var day = localWorkingDays[i];
                            AvailableDay updatedDay = AvailableDay(
                                available: day,
                                day: getDay(i),
                                availableTimes: day == true ? timeSlots : []);
                            updatedDays.add(updatedDay);
                          }
                          setState(() {
                            entertainmentScheduling =
                                entertainmentScheduling.copyWith(
                                    type: "dayScheduling",
                                    availability: updatedDays);
                          });
                          context.pop();
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Adjust the value as needed
                          ),
                        ),
                        child: const Text('Save')),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  // void onTapAddTime(BuildContext context, TimeOfDay timeSlot,
  //     TextEditingController timeSlotCapacityController) {
  //   availableTimes = [];
  //   return setState(() {
  //     workingDays.forEach((key, value) {
  //       if (value == true) {
  //         if (availableDays
  //             .asMap()
  //             .entries
  //             .any((element) => element.value.day == key)) {
  //           availableTimes = availableDays[
  //                   availableDays.indexWhere((element) => element.day == key)]
  //               .availableTimes
  //               .toList(growable: true);
  //           if (!availableTimes
  //               .asMap()
  //               .entries
  //               .any((element) => element.value.time == timeSlot)) {
  //             availableTimes.add(AvailableTime(
  //                 available: true,
  //                 currentPax: 0,
  //                 maxPax: num.parse(timeSlotCapacityController.text),
  //                 time: timeSlot));
  //             availableTimes.sort((timeOne, timeTwo) {
  //               return int.parse('${timeOne.time.hour}${timeOne.time.minute}')
  //                   .compareTo(int.parse(
  //                       '${timeTwo.time.hour}${timeTwo.time.minute}'));
  //             });
  //           }
  //           availableDays[
  //                   availableDays.indexWhere((element) => element.day == key)] =
  //               AvailableDay(
  //                   available: true, day: key, availableTimes: availableTimes);
  //         } else {
  //           availableTimes
  //                   .asMap()
  //                   .entries
  //                   .any((element) => element.value.time != timeSlot)
  //               ? availableTimes.add(AvailableTime(
  //                   available: true,
  //                   currentPax: 0,
  //                   maxPax: num.parse(timeSlotCapacityController.text),
  //                   time: timeSlot))
  //               : null;
  //           availableDays.add(AvailableDay(
  //               available: true, day: key, availableTimes: availableTimes));
  //         }
  //       }
  //       workingDays[key] = false;
  //     });
  //   });
  // }
}

final listingStartDate =
    StateNotifierProvider<ListingStartDateNotifier, DateTime?>(
  (ref) => ListingStartDateNotifier(),
);

class ListingStartDateNotifier extends StateNotifier<DateTime?> {
  ListingStartDateNotifier() : super(null);

  void setStartDate(DateTime startDate) {
    state = startDate;
  }

  void clearStartDate() {
    state = null;
  }
}

final listingEndDate = StateNotifierProvider<ListingEndDateNotifier, DateTime?>(
  (ref) => ListingEndDateNotifier(),
);

class ListingEndDateNotifier extends StateNotifier<DateTime?> {
  ListingEndDateNotifier() : super(null);

  void setEndDate(DateTime endDate) {
    state = endDate;
  }

  void clearEndDate() {
    state = null;
  }
}
