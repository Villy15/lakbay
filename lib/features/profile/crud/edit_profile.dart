import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lakbay/core/providers/storage_repository_providers.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/user/user_controller.dart';
import 'package:lakbay/models/user_model.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final UserModel user;

  const EditProfilePage({super.key, required this.user});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _image;
  String? _governmentId;
  final _nameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergenyNoController = TextEditingController();
  final _emergencyNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Set initial values
    _nameController.text = widget.user.name;
    _firstNameController.text = widget.user.firstName ?? '';
    _lastNameController.text = widget.user.lastName ?? '';
    _phoneNoController.text = widget.user.phoneNo ?? '';
    _addressController.text = widget.user.address ?? '';
    _emergenyNoController.text = widget.user.emergencyContact ?? '';
    _emergencyNameController.text = widget.user.emergencyContactName ?? '';
    _governmentId = widget.user.governmentId ?? '';
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed.
    _nameController.dispose();

    super.dispose();
  }

  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var user = widget.user.copyWith(
        name: _nameController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phoneNo: _phoneNoController.text,
        address: _addressController.text,
        emergencyContact: _emergenyNoController.text,
        emergencyContactName: _emergencyNameController.text,
      );

      // Upload image to Firebase Storage
      if (_image != null) {
        ref
            .read(storageRepositoryProvider)
            .storeFile(
              path: 'users/${_nameController.text}',
              id: _image?.path.split('/').last ?? '',
              file: _image,
            )
            .then((value) => value.fold(
                  (failure) => debugPrint(
                    'Failed to upload image: $failure',
                  ),
                  (imageUrl) {
                    // Update user
                    user = user.copyWith(profilePic: imageUrl);

                    // Register cooperative
                    ref
                        .read(usersControllerProvider.notifier)
                        .editProfile(context, user.uid, user);
                  },
                ));

        return;
      }

      ref
          .read(usersControllerProvider.notifier)
          .editProfile(context, user.uid, user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(coopsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Cancel Button
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),

            // Save Button
            TextButton(
              onPressed: () {
                onSubmit();
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
                      // User Image
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
                                imageUrl: widget.user.profilePic,
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

                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.person,
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Name*',
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
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.person,
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'First Name*',
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
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.person,
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Last Name*',
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
                        controller: _phoneNoController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.phone,
                          ),
                          prefixText: '+63',
                          border: OutlineInputBorder(),
                          labelText: 'Phone Number*',
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
                        controller: _addressController,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.home,
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

                      TextFormField(
                        controller: _emergenyNoController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.phone,
                          ),
                          prefixText: '+63',
                          border: OutlineInputBorder(),
                          labelText: 'Emergency Number*',
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
                        controller: _emergencyNameController,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.person,
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Emergency Name*',
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
                      ListTile(
                        leading: const Icon(Icons.file_copy),
                        title: const Text('Government ID'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        subtitle: _governmentId == null ? const Text('Upload a Valid Government ID')
                            : Text('File selected: ${_governmentId!.split('/').last}'),
                        // onTap: () async {
                        //   FilePickerResult? result 
                        // }
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
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
