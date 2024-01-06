import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/events/events_controller.dart';
import 'package:lakbay/core/providers/storage_repository_providers.dart';
import 'package:lakbay/models/coop_model.dart';
//import 'package:lakbay/features/events/events_repository.dart';
import 'package:lakbay/models/event_model.dart';

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

    super.dispose();
  }

  void addEvent(EventModel event) {
    ref.read(eventsControllerProvider.notifier).addEvent(event, context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(eventsControllerProvider);

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
                        horizontal: 16.0, vertical: 8.0),
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
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.location_on),
                            border: OutlineInputBorder(),
                            labelText: 'Location',
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _cityController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.location_city),
                            border: OutlineInputBorder(),
                            labelText: 'City',
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _provinceController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.landscape),
                            border: OutlineInputBorder(),
                            labelText: 'Province',
                          ),
                        ),
                        const SizedBox(height: 10),
                        datePicker(context),
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
                  context.pop();
                },
                child: const Text('Submit'),
              ),
            ],
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
