import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/user_model.dart';

class JoinCoopPage extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  final bool? isMember;

  const JoinCoopPage({super.key, required this.coop, this.isMember});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JoinCoopPageState();
}

class _JoinCoopPageState extends ConsumerState<JoinCoopPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _image;
  final _lastName = TextEditingController();
  final _firstName = TextEditingController();
  final _middleName = TextEditingController();
  DateTime? _birthDate;

  final _age = TextEditingController();
  final _gender = TextEditingController();
  final _religion = TextEditingController();
  final _nationality = TextEditingController();
  final _civilStatus = TextEditingController();

  File? _validId;
  File? _birthCertificate;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });

    // Set initial values
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed.

    super.dispose();
  }

  void joinCooperative() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    final userUid = ref.read(userProvider)?.uid ?? '';
    // Add user to members in Coop
    var updatedCoop = widget.coop.copyWith(
      members: [...widget.coop.members, userUid],
    );

    // Update coop
    ref
        .read(coopsControllerProvider.notifier)
        .joinCooperative(updatedCoop, context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(coopsControllerProvider);
    final user = ref.watch(userProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Join Cooperative')),
        // bottomNavigationBar: BottomAppBar(
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       // If isMember is true, add an input where he can input the code

        //       // Cancel Button
        //       TextButton(
        //         onPressed: () {
        //           context.pop();
        //           ref.read(navBarVisibilityProvider.notifier).show();
        //         },
        //         child: const Text('Cancel'),
        //       ),

        //       // Save Button
        //       TextButton(
        //         onPressed: () {
        //           if (_formKey.currentState!.validate()) {
        //             _formKey.currentState!.save();

        //             // // Check if code is correct
        //             // if (_codeController.text == widget.coop.code) {
        //             //   // Join Cooperative
        //             joinCooperative();
        //             // } else {
        //             //   // Show error
        //             //   ScaffoldMessenger.of(context).showSnackBar(
        //             //     const SnackBar(
        //             //       content: Text('Invalid Code'),
        //             //     ),
        //             //   );
        //             // }
        //           }
        //         },
        //         child: const Text('Submit'),
        //       ),
        //     ],
        //   ),
        // ),
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
                    child: ref.watch(getUserDataProvider(user!.uid)).maybeWhen(
                          data: (userData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Personal Information',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                // Subtext
                                Text(
                                  'Please provide your personal information',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground
                                        .withOpacity(0.6),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                _buildImage(context, userData),

                                const SizedBox(height: 20),

                                // Full Name
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        controller: _lastName,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Last Name*',
                                          icon: Icon(Icons.person),
                                          helperText: '*required',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your last name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        controller: _firstName,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'First Name*',
                                          helperText: '*required',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your first name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                // Middle Name
                                TextFormField(
                                  controller: _middleName,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    icon: Icon(Icons.person,
                                        color: Colors.transparent),
                                    labelText: 'Middle Name',
                                    helperText: 'optional',
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Birth Date
                                TextFormField(
                                  controller: _birthDate != null
                                      ? TextEditingController(
                                          text: _birthDate!.toString())
                                      : null,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Birth Date',
                                    icon: Icon(Icons.calendar_today),
                                    helperText: 'optional',
                                  ),
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now(),
                                    );

                                    if (date != null) {
                                      setState(() {
                                        _birthDate = date;
                                      });
                                    }
                                  },
                                ),

                                const SizedBox(height: 10),

                                // Age and Gender inside row
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        controller: _age,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          icon: Icon(Icons.person,
                                              color: Colors.transparent),
                                          labelText: 'Age*',
                                          helperText: '*required',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        controller: _gender,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Gender',
                                          helperText: 'optional*',
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                                const SizedBox(height: 10),

                                // religion
                                TextFormField(
                                  controller: _religion,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    icon: Icon(Icons.person,
                                        color: Colors.transparent),
                                    labelText: 'Religion',
                                    helperText: 'optional',
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Nationality
                                // religion
                                TextFormField(
                                  controller: _nationality,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    icon: Icon(Icons.flag),
                                    labelText: 'Nationality',
                                    helperText: 'optional',
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Civil Status
                                TextFormField(
                                  controller: _civilStatus,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    icon: Icon(Icons.person_outline_outlined),
                                    labelText: 'Civil Status',
                                    helperText: 'optional',
                                  ),
                                ),

                                const SizedBox(height: 20),

                                const Text(
                                  'Documents',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                // Subtext
                                Text(
                                  'Please provide the following documents',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground
                                        .withOpacity(0.6),
                                  ),
                                ),

                                // Valid ID
                                const SizedBox(height: 20),
                                ListTile(
                                  onTap: () async {
                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: [
                                        'pdf'
                                      ], // specify the allowed extensions
                                    );

                                    if (result != null) {
                                      setState(() {
                                        _validId =
                                            File(result.files.single.path!);
                                      });
                                    }
                                  },
                                  title: const Text('Valid ID'),
                                  subtitle: _validId != null
                                      ? const Text('PDF selected')
                                      : const Text('Select a PDF file'),
                                  trailing:
                                      const Icon(Icons.file_copy_outlined),
                                ),

                                const SizedBox(height: 10),

                                // Valid IDs are as follow:
                                Text(
                                  'Valid IDs are as follow: ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground
                                        .withOpacity(0.6),
                                  ),
                                ),

                                // Valid IDs
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('1. Passport'),
                                      Text('2. Driver\'s License'),
                                      Text('3. SSS ID'),
                                      Text('4. GSIS ID'),
                                      Text('5. PRC ID'),
                                    ],
                                  ),
                                ),

                                // Birth Certificate
                                const SizedBox(height: 20),
                                ListTile(
                                  onTap: () async {
                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: [
                                        'pdf'
                                      ], // specify the allowed extensions
                                    );

                                    if (result != null) {
                                      setState(() {
                                        _birthCertificate =
                                            File(result.files.single.path!);
                                      });
                                    }
                                  },
                                  title: const Text('Birth Certificate'),
                                  subtitle: _birthCertificate != null
                                      ? const Text('PDF selected')
                                      : const Text('Select a PDF file'),
                                  trailing:
                                      const Icon(Icons.file_copy_outlined),
                                ),

                                const SizedBox(height: 10),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 24.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Pay with',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 70, // specify the width
                                                height:
                                                    40, // specify the height
                                                child: Image.asset(
                                                    "lib/core/images/paymaya.png"),
                                              ),
                                              Icon(Icons.payment,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                              // Add more payment method icons as needed
                                            ],
                                          ),

                                          const SizedBox(height: 10),

                                          // Payment Instructions
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Total',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),

                                              // TODO Add Amount For membership
                                              Text('₱500.00',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),

                                          // Details of Payment Label
                                          const SizedBox(height: 10),
                                          const Text('Details of Payment',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),

                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Membership Fee"),
                                              Text("₱100.00"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        const Text(
                                          'By confirming below, you agree to our terms and conditions, and privacy policy.',
                                          style: TextStyle(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                            height: 20), // Add some spacing
                                        ElevatedButton(
                                          // Make it larger
                                          // TODO Add Payment Functionality
                                          onPressed: () {
                                            joinCooperative();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            // Color
                                            backgroundColor:
                                                Colors.orange.shade700,
                                            minimumSize:
                                                const Size(double.infinity, 50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          // Color
                                          child: Text(
                                              'Confirm and Join Cooperative',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .background,
                                                  fontSize: 16)),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                          orElse: () => const SizedBox(),
                        ),
                  ),
                ),
              ),
      ),
    );
  }

  GestureDetector _buildImage(BuildContext context, UserModel userData) {
    return GestureDetector(
      child: Row(
        children: [
          Icon(Icons.image, color: Theme.of(context).iconTheme.color),
          const SizedBox(
              width: 15), // Add some spacing between the icon and the container
          Expanded(
            child: ImagePickerFormField(
              imageUrl: userData.profilePic,
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
