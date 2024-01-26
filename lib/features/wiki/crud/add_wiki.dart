import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/wiki/wiki_controller.dart';  
import 'package:lakbay/core/providers/storage_repository_providers.dart';
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

    @override
    void initState() {
      super.initState();
      Future.delayed(Duration.zero, (){
        ref.read(navBarVisibilityProvider.notifier).hide();
      });
    }

    @override
    void dispose(){
      _nameController.dispose();
      _descriptionController.dispose();

      super.dispose();
    }

    void addWiki (WikiModel wiki) {
    ref
        .read(wikiControllerProvider.notifier)
        .addWiki(wiki, context);
  }

  @override
  Widget build(BuildContext context){
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

                      final imagePath =
                          'wikis/${_nameController.text}/${_image?.path.split('/').last ?? ''}';

                      // Process data.
                      var wiki = WikiModel(
                        name: _nameController.text,
                        description: _descriptionController.text,
                        imagePath: imagePath,
                      );

                      // Upload image to Firebase Storage
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
                                // Register wiki
                                ref
                                    .read(wikiControllerProvider.notifier)
                                    .addWiki(wiki, context);
                                },
                              ));
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
                          onTap: () async {
                            final picker = ImagePicker();
                            final pickedFile =
                                await picker.pickImage(source: ImageSource.gallery);

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
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.event),
                            border: OutlineInputBorder(),
                            labelText: 'Wiki Title*',
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
