import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lakbay/core/providers/storage_repository_providers.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/wiki/wiki_controller.dart';
import 'package:lakbay/models/wiki_model.dart';

class AddWikiPage extends ConsumerStatefulWidget {
  const AddWikiPage({super.key});

  @override
  ConsumerState<AddWikiPage> createState() => _AddWikiPageState();
}

class _AddWikiPageState extends ConsumerState<AddWikiPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _image;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedTag; // Store the selected tag

  List<Tag> availableTags = [
    Tag(
        name: 'Discussion',
        description: 'Open-ended questions and brainstorming'),
    Tag(name: 'Advice', description: 'Seeking specific guidance'),
    Tag(name: 'Issue', description: 'Reporting a problem'),
  ];

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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(wikiControllerProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
          appBar: AppBar(title: const Text('Add Wiki')),
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
                      final user = ref.read(userProvider);

                      // final imagePath =
                      //     'wikis/${_nameController.text}/${_image?.path.split('/').last ?? ''}';

                      var wiki = WikiModel(
                        title: _nameController.text,
                        description: _descriptionController.text,
                        votes: 0,
                        coopId: user!.currentCoop!,
                        createdAt: DateTime.now(),
                        createdBy: user.uid,
                        tag: _selectedTag!,
                      );

                      // // Upload image to Firebase Storage
                      if (_image != null) {
                        ref
                            .read(storageRepositoryProvider)
                            .storeFile(
                              path: 'wikis/${_nameController.text}',
                              id: _image?.path.split('/').last ?? '',
                              file: _image,
                            )
                            .then((value) => value.fold(
                                  (failure) => debugPrint(
                                    'Failed to upload image: $failure',
                                  ),
                                  (imageUrl) {
                                    wiki = wiki.copyWith(imageUrl: imageUrl);
                                    ref
                                        .read(wikiControllerProvider.notifier)
                                        .addWiki(wiki, context);
                                  },
                                ));
                      } else {
                        ref
                            .read(wikiControllerProvider.notifier)
                            .addWiki(wiki, context);
                      }
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
                          // Optional
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.event),
                              border: OutlineInputBorder(),
                              labelText: 'Wiki Title*',
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
                              helperText: '*required',
                            ),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _selectedTag,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.tag),
                              border: OutlineInputBorder(),
                              labelText: 'Tag',
                              helperText: '*required',
                            ),
                            hint: const Text('Select a Tag'),
                            items: availableTags.map((Tag tag) {
                              return DropdownMenuItem<String>(
                                value: tag.name,
                                child: Text(tag.name),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedTag = newValue;
                              });
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a tag';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          // Display Descriptions of Each Tag
                          if (_selectedTag != null)
                            Text(
                              availableTags
                                  .firstWhere((tag) => tag.name == _selectedTag)
                                  .description,
                            ),

                          //
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
                        : const Center(
                            child: Text('Select an image (optional)')),
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

class Tag {
  final String name;
  final String description;

  Tag({required this.name, required this.description});
}
