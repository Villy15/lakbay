import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/wiki/wiki_controller.dart';
import 'package:lakbay/models/wiki_model.dart';

class EditWikiPage extends ConsumerStatefulWidget {
  final WikiModel wiki;

  const EditWikiPage({super.key, required this.wiki});

  @override
  ConsumerState<EditWikiPage> createState() => _EditWikiPageState();
}

class _EditWikiPageState extends ConsumerState<EditWikiPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _image;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });

    // Set initial values
    // _nameController.text = widget.wiki.name;
    // _descriptionController.text = widget.wiki.description ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  void updateWiki(WikiModel wiki) {
    ref.read(wikiControllerProvider.notifier).editWiki(wiki, context);
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
        appBar: AppBar(title: const Text('Edit Wiki')),
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
                    _formKey.currentState!.save();

                    final imagePath =
                        'wikis/${_nameController.text}/${_image?.path.split('/').last ?? ''}';

                    // // Process data.
                    // var updatedWiki = widget.wiki.copyWith(
                    //   name: _nameController.text,
                    //   description: _descriptionController.text,
                    //   imagePath: imagePath,
                    // );

                    // // Upload image to Firebase Storage
                    // ref
                    //     .read(storageRepositoryProvider)
                    //     .storeFile(
                    //       path: 'wikis/${_nameController.text}',
                    //       id: _image?.path.split('/').last ?? '',
                    //       file: _image,
                    //     )
                    //     .then((value) => value.fold(
                    //           (failure) => debugPrint(
                    //             'Failed to upload image: $failure',
                    //           ),
                    //           (imageUrl) {
                    //             updatedWiki =
                    //                 updatedWiki.copyWith(imageUrl: imageUrl);
                    //             // Edit wiki
                    //             updateWiki(updatedWiki);
                    //           },
                    //         ));
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
                        // Wiki Image
                        GestureDetector(
                          onTap: () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);

                            if (pickedFile != null) {
                              setState(() {
                                _image = File(pickedFile.path);
                              });
                            }
                          },
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: _image != null
                                ? Image.file(_image!, fit: BoxFit.cover)
                                : const Center(child: Text('Select an image')),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Name
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.article,
                            ),
                            border: OutlineInputBorder(),
                            labelText: 'Wiki Name*',
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
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
