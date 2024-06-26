import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/providers/storage_repository_providers.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/events/events_controller.dart';
import 'package:lakbay/models/event_model.dart';

class EditEventPage extends ConsumerStatefulWidget {
  final EventModel event;

  const EditEventPage({super.key, required this.event});

  @override
  ConsumerState<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends ConsumerState<EditEventPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _image;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _locationController = TextEditingController();
  final _cityController = TextEditingController(); // Added city field
  final _provinceController = TextEditingController(); // Added province field
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });

    // Set initial values
    _nameController.text = widget.event.name;
    _descriptionController.text = widget.event.description ?? '';
    _startDateController.text =
        DateFormat('yyyy-MM-dd').format(widget.event.startDate!);
    _endDateController.text =
        DateFormat('yyyy-MM-dd').format(widget.event.endDate!);
    _locationController.text = widget.event.address;
    _cityController.text = widget.event.city;
    _provinceController.text = widget.event.province;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _locationController.dispose();
    _cityController.dispose();
    _provinceController.dispose();

    super.dispose();
  }

  void updateEvent(EventModel event) {
    ref.read(eventsControllerProvider.notifier).editEvent(event, context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(eventsControllerProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        ref.read(navBarVisibilityProvider.notifier).show();
        context.pop();
        
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Event')),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cancel Button
              TextButton(
                onPressed: () {
                  ref.read(navBarVisibilityProvider.notifier).show();
                  context.pop();
                },
                child: const Text('Cancel'),
              ),

              // Save Button
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final imagePath =
                        'events/${_nameController.text}/${_image?.path.split('/').last ?? ''}';

                    // Process data.
                    var updatedEvent = widget.event.copyWith(
                      name: _nameController.text,
                      description: _descriptionController.text,
                      startDate: DateTime.parse(_startDateController.text),
                      endDate: DateTime.parse(_endDateController.text),
                      address: _locationController.text,
                      city: _cityController.text,
                      province: _provinceController.text,
                      imagePath: imagePath,
                    );

                    // Upload image to Firebase Storage
                    if (_image != null) {
                      ref
                          .read(storageRepositoryProvider)
                          .storeFile(
                            path: 'events/${_nameController.text}',
                            id: _image?.path.split('/').last ?? '',
                            file: _image,
                          )
                          .then(
                            (value) => value.fold(
                              (failure) => debugPrint(
                                'Failed to upload image: $failure',
                              ),
                              (imageUrl) {
                                updatedEvent =
                                    updatedEvent.copyWith(imageUrl: imageUrl);
                                // Edit event
                                updateEvent(updatedEvent);
                              },
                            ),
                          );

                      return;
                    }

                    // Edit event
                    updateEvent(updatedEvent);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
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
                                  imageUrl: widget.event.imageUrl,
                                  initialValue: _image,
                                  onSaved: (File? file) {
                                    _image = file;
                                  },
                                  // validator: (File? file) {
                                  //   if (file == null) {
                                  //     return 'Please select an image';
                                  //   }
                                  //   return null;
                                  // },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Name
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.event,
                            ),
                            border: OutlineInputBorder(),
                            labelText: 'Event Name*',
                            helperText: '*required',
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Description
                        TextFormField(
                          controller: _descriptionController,
                          // minLines: 3,
                          maxLines: null,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.description),
                            border: OutlineInputBorder(),
                            labelText: 'Description',
                            helperText: 'optional',
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Location (Address)
                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.location_on),
                            border: OutlineInputBorder(),
                            labelText: 'Location (Address)',
                          ),
                        ),

                        const SizedBox(height: 10),

                        // City
                        TextFormField(
                          controller: _cityController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.location_city),
                            border: OutlineInputBorder(),
                            labelText: 'City',
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Province
                        TextFormField(
                          controller: _provinceController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.landscape),
                            border: OutlineInputBorder(),
                            labelText: 'Province',
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Dates
                        datePicker(context),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget datePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dates',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Start Date: ${DateFormat('dd MMM').format(startDate)}',
              style: const TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () async {
                final DateTime? selectedStartDate = await _selectDate(
                  context,
                  startDate,
                  DateTime.now(),
                );
                if (selectedStartDate != null) {
                  setState(() {
                    startDate = selectedStartDate;
                    _startDateController.text =
                        DateFormat('yyyy-MM-dd').format(startDate);
                  });
                }
              },
              child: const Text('Select Start Date'),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'End Date: ${DateFormat('dd MMM').format(endDate)}',
              style: const TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () async {
                final DateTime? selectedEndDate = await _selectDate(
                  context,
                  endDate,
                  startDate,
                );
                if (selectedEndDate != null) {
                  setState(() {
                    endDate = selectedEndDate;
                    _endDateController.text =
                        DateFormat('yyyy-MM-dd').format(endDate);
                  });
                }
              },
              child: const Text('Select End Date'),
            ),
          ],
        ),
      ],
    );
  }

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
    String? imageUrl,
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
                        : (imageUrl != null && imageUrl.isNotEmpty)
                            ? Image.network(imageUrl, fit: BoxFit.cover)
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
