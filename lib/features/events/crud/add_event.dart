import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/providers/storage_repository_providers.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/events/events_controller.dart';
import 'package:lakbay/features/events/events_providers.dart';
import 'package:lakbay/models/coop_model.dart';
//import 'package:lakbay/features/events/events_repository.dart';
import 'package:lakbay/models/event_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddEventPage extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  const AddEventPage({super.key, required this.coop});

  @override
  ConsumerState<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends ConsumerState<AddEventPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _image;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));

  String? _selectedType;
  final List<String> _eventTypes = [
    'General Assembly',
    'Community Engagement',
    'Seminar',
    'Training and Education'
  ]; // replace with your actual types

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _cityController.dispose();
    _provinceController.dispose();

    // Dispose start and end date
    debugPrint('Disposing start and end date');
    ref.read(eventStartDateProvider.notifier).clearStartDate();
    ref.read(eventEndDateProvider.notifier).clearEndDate();

    super.dispose();
  }

  void addEvent(EventModel event) {
    ref.read(eventsControllerProvider.notifier).addEvent(event, context);
  }

  void onTapDate() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.95,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Select Date'),
            ),
            bottomNavigationBar: BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(120, 45)),
                    ),
                    onPressed: () {
                      ref
                          .read(eventStartDateProvider.notifier)
                          .setStartDate(startDate);

                      ref
                          .read(eventEndDateProvider.notifier)
                          .setEndDate(endDate);

                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: SfDateRangePicker(
                      selectionMode: DateRangePickerSelectionMode.range,
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        startDate = args.value.startDate;

                        endDate = args.value.endDate;
                      },
                      minDate: DateTime.now(),
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

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(eventsControllerProvider);
    final startDate = ref.watch(eventStartDateProvider);
    final endDate = ref.watch(eventEndDateProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Event')),
        body: isLoading
            ? const Loader()
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Row(
                            children: [
                              Icon(Icons.image,
                                  color: Theme.of(context).iconTheme.color),
                              const SizedBox(
                                  width:
                                      15), // Add some spacing between the icon and the container
                              Expanded(
                                child: ImagePickerFormField(
                                  initialValue: _image,
                                  onSaved: (File? file) {
                                    _image = file;
                                  },
                                  validator: (File? file) {
                                    if (file == null) {
                                      return 'Please select an image';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.event),
                            border: OutlineInputBorder(),
                            labelText: 'Event Name*',
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
                              icon: Icon(Icons.description),
                              border: OutlineInputBorder(),
                              labelText: 'Description',
                              helperText: 'optional'),
                        ),
                        const SizedBox(height: 10),
                        // Type of event
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.event_note),
                            border: OutlineInputBorder(),
                            labelText: 'Type of Event*',
                            helperText: '*required',
                          ),
                          value: _selectedType,
                          items: _eventTypes.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedType = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.location_on),
                            border: OutlineInputBorder(),
                            labelText: 'Location',
                            helperText: 'optional',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            // City
                            Flexible(
                              flex: 1,
                              child: TextFormField(
                                controller: _cityController,
                                decoration: const InputDecoration(
                                  // Empty icon to align with other text fields
                                  icon: Icon(Icons.location_on,
                                      color: Colors.transparent),
                                  // Drop down icon
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                  border: OutlineInputBorder(),
                                  labelText: 'City*',
                                  helperText: '*required',
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(width: 10),

                            // Province
                            Flexible(
                              flex: 1,
                              child: TextFormField(
                                controller: _provinceController,
                                decoration: const InputDecoration(
                                  // Empty icon to align with other text fields
                                  icon: Icon(Icons.location_on,
                                      color: Colors.transparent, size: 0),
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                  border: OutlineInputBorder(),
                                  labelText: 'Province*',
                                  helperText: '*required',
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        datePicker(context, startDate, endDate),
                      ],
                    ),
                  ),
                ),
              ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cancel Button
              // Cancel Button
              TextButton(
                onPressed: () {
                  context.pop();
                  ref.read(navBarVisibilityProvider.notifier).show();
                },
                child: const Text('Cancel'),
              ),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final userUid = ref.read(userProvider)?.uid ?? '';
                    final imagePath =
                        'events/${_nameController.text}/${_image?.path.split('/').last ?? ''}';

                    var event = EventModel(
                      cooperative: EventCooperative(
                        cooperativeId: widget.coop.uid!,
                        cooperativeName: widget.coop.name,
                      ),
                      name: _nameController.text,
                      description: _descriptionController.text,
                      address: _locationController.text,
                      city: _cityController.text,
                      province: _provinceController.text,
                      eventType: _selectedType,
                      imagePath: imagePath,
                      members: [userUid],
                      managers: [userUid],
                      startDate: startDate,
                      endDate: endDate,
                    );

                    ref
                        .read(storageRepositoryProvider)
                        .storeFile(
                          path: 'events/${_nameController.text}',
                          id: _image?.path.split('/').last ?? '',
                          file: _image,
                        )
                        .then((value) => value.fold(
                              (failure) => debugPrint(
                                'Failed to upload image: $failure',
                              ),
                              (imageUrl) {
                                event = event.copyWith(imageUrl: imageUrl);
                                // Register cooperative
                                addEvent(event);
                              },
                            ));
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget datePicker(
      BuildContext context, DateTime? startDate, DateTime? endDate) {
    return ListTile(
      title: const Text('Date'),
      leading: const Icon(Icons.calendar_today_outlined),
      subtitle: Text(startDate == null || endDate == null
          ? 'Select a date'
          : '${DateFormat.yMMMMd().format(startDate)} - ${DateFormat.yMMMMd().format(endDate)}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        onTapDate();
      },
    );
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     const Text(
    //       'Dates',
    //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    //     ),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Text(
    //           'Start Date: ${DateFormat('dd MMM').format(startDate)}',
    //           style: const TextStyle(fontSize: 16),
    //         ),
    //         ElevatedButton(
    //           onPressed: () async {
    //             final DateTime? selectedStartDate = await _selectDate(
    //               context,
    //               startDate,
    //               DateTime.now(),
    //             );
    //             if (selectedStartDate != null) {
    //               setState(() {
    //                 startDate = selectedStartDate;
    //               });
    //             }
    //           },
    //           child: const Text('Select Start Date'),
    //         ),
    //       ],
    //     ),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Text(
    //           'End Date: ${DateFormat('dd MMM').format(endDate)}',
    //           style: const TextStyle(fontSize: 16),
    //         ),
    //         ElevatedButton(
    //           onPressed: () async {
    //             final DateTime? selectedEndDate = await _selectDate(
    //               context,
    //               endDate,
    //               startDate,
    //             );
    //             if (selectedEndDate != null) {
    //               setState(() {
    //                 endDate = selectedEndDate;
    //               });
    //             }
    //           },
    //           child: const Text('Select End Date'),
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }

  // ignore: unused_element
  Future<DateTime?> _selectDate(
    BuildContext context,
    DateTime initialDate,
    DateTime firstDate,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2101),
    );
    return picked;
  }
}

class ImagePickerFormField extends FormField<File> {
  ImagePickerFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
  }) : super(
          builder: (FormFieldState<File> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (pickedFile != null) {
                      state.didChange(File(pickedFile.path));
                    }
                  },
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: state.value != null
                        ? Image.file(state.value!, fit: BoxFit.cover)
                        : const Center(child: Text('Select an image')),
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
