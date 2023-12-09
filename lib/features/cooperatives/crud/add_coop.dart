import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/models/coop_model.dart';

class AddCoopPage extends ConsumerStatefulWidget {
  const AddCoopPage({super.key});

  @override
  ConsumerState<AddCoopPage> createState() => _AddCoopPageState();
}

class _AddCoopPageState extends ConsumerState<AddCoopPage> {
  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _image;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();

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
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _provinceController.dispose();

    super.dispose();
  }

  void registerCooperative(CooperativeModel coop) {
    ref
        .read(coopsControllerProvider.notifier)
        .registerCooperative(coop, context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(coopsControllerProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
          appBar: AppBar(title: const Text('Register Cooperative')),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cancel Button
                TextButton(
                  onPressed: () {
                    context.pop();
                    ref.read(navBarVisibilityProvider.notifier).show();
                  },
                  child: const Text('Cancel'),
                ),

                // Save Button
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save(); //

                      final userUid = ref.read(userProvider)?.uid ?? '';

                      // Process data.
                      final coop = CooperativeModel(
                        name: _nameController.text,
                        description: _descriptionController.text,
                        address: _addressController.text,
                        city: _cityController.text,
                        province: _provinceController.text,
                        imageUrl: _image?.path ?? '',
                        members: [userUid],
                        managers: [userUid],
                      );

                      // Register cooperative
                      registerCooperative(coop);
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
                          horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        children: [
                          // Cooperative Logo
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
                          // Name
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              icon: Icon(
                                Icons.person,
                              ),
                              border: OutlineInputBorder(),
                              labelText: 'Cooperative Name*',
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
                              // alignLabelWithHint: true,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Address
                          TextFormField(
                            controller: _addressController,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.location_on),
                              border: OutlineInputBorder(),
                              labelText: 'Address',
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
                          )
                        ],
                      ),
                    ),
                  ),
                )),
    );
  }
}

class ImagePickerFormField extends FormField<File> {
  ImagePickerFormField({
    Key? key,
    FormFieldSetter<File>? onSaved,
    FormFieldValidator<File>? validator,
    File? initialValue,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
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
