import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/models/coop_model.dart';

class ValidateCoop extends ConsumerStatefulWidget {
  final BuildContext parentContext;
  final CooperativeModel coop;
  const ValidateCoop(
      {super.key, required this.parentContext, required this.coop});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ValidateCoopState();
}

class _ValidateCoopState extends ConsumerState<ValidateCoop> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _certificateOfRegistration;
  File? _articlesOfCooperation;
  File? _byLaws;
  File? _latestAuditFinancialStatements;
  File? _letterOfAuthorization;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final coop = widget.coop.copyWith(
        validationFiles: ValidationFiles(
          certificateOfRegistration: _certificateOfRegistration?.path,
          articlesOfCooperation: _articlesOfCooperation?.path,
          byLaws: _byLaws?.path,
          audit: _latestAuditFinancialStatements?.path,
          letterAuth: _letterOfAuthorization?.path,
        ),
      );

      // Upload files
    ref
          .read(storageRepositoryProvider)
          .storeFile(
            path: 'events/${_nameController.text}',
            id: _image?.path.split('/').last ?? '',
            file: _image,
          )

      // ref
      //     .read(storageRepositoryProvider)
      //     .storeFile(
      //       path: 'events/${_nameController.text}',
      //       id: _image?.path.split('/').last ?? '',
      //       file: _image,
      //     )
      //     .then((value) => value.fold(
      //           (failure) => debugPrint(
      //             'Failed to upload image: $failure',
      //           ),
      //           (imageUrl) {
      //             event = event.copyWith(imageUrl: imageUrl);
      //             // Register cooperative
      //             addEvent(event);
      //           },
      //         ));

      ref.read(coopsControllerProvider.notifier).editCooperative(coop, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(coopsControllerProvider);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.95,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Validate Cooperative'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              ref.read(navBarVisibilityProvider.notifier).show();
              context.pop(widget.parentContext);
            },
          ),
        ),
        bottomNavigationBar: _bottomNavBar(context),
        body: isLoading ? const Loader() : _body(),
      ),
    );
  }

  BottomAppBar _bottomNavBar(BuildContext context) {
    return BottomAppBar(
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
              minimumSize: MaterialStateProperty.all<Size>(const Size(120, 45)),
            ),
            onPressed: () {
              onSubmit();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView _body() {
    Map<String, Function> documents = {
      'Certificate of Registration': () => ListTile(
            leading: const Icon(Icons.file_copy),
            title: const Text('Certificate of Registration'),
            // Trailing arrow
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
            subtitle: _certificateOfRegistration == null
                ? const Text('Upload Certificate of Registration')
                : Text(
                    'PDF selected: ${_certificateOfRegistration!.path.split('/').last}'),
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf'], // specify the allowed extensions
              );

              if (result != null) {
                setState(() {
                  _certificateOfRegistration = File(result.files.single.path!);
                });
              }
            },
          ),
      'Articles of Cooperation': () => ListTile(
            leading: const Icon(Icons.file_copy),
            title: const Text('Articles of Cooperation'),
            // Trailing arrow
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
            subtitle: _articlesOfCooperation == null
                ? const Text('Upload Articles of Cooperation')
                : Text(
                    'PDF selected: ${_articlesOfCooperation!.path.split('/').last}'),
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf'], // specify the allowed extensions
              );

              if (result != null) {
                setState(() {
                  _articlesOfCooperation = File(result.files.single.path!);
                });
              }
            },
          ),
      'By-Laws': () => ListTile(
            leading: const Icon(Icons.file_copy),
            title: const Text('By-Laws'),
            // Trailing arrow
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
            subtitle: _byLaws == null
                ? const Text('Upload By-Laws')
                : Text('PDF selected: ${_byLaws!.path.split('/').last}'),
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf'], // specify the allowed extensions
              );

              if (result != null) {
                setState(() {
                  _byLaws = File(result.files.single.path!);
                });
              }
            },
          ),
      'Latest audit financial statements': () => ListTile(
            leading: const Icon(Icons.file_copy),
            title: const Text('Latest audit financial statements'),
            // Trailing arrow
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
            subtitle: _latestAuditFinancialStatements == null
                ? const Text('Upload Latest audit financial statements')
                : Text(
                    'PDF selected: ${_latestAuditFinancialStatements!.path.split('/').last}'),
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf'], // specify the allowed extensions
              );

              if (result != null) {
                setState(() {
                  _latestAuditFinancialStatements =
                      File(result.files.single.path!);
                });
              }
            },
          ),
      'Letter of authorization': () => ListTile(
            leading: const Icon(Icons.file_copy),
            title: const Text('Letter of authorization'),
            // Trailing arrow
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
            subtitle: _letterOfAuthorization == null
                ? const Text('Upload Letter of authorization')
                : Text(
                    'PDF selected: ${_letterOfAuthorization!.path.split('/').last}'),
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf'], // specify the allowed extensions
              );

              if (result != null) {
                setState(() {
                  _letterOfAuthorization = File(result.files.single.path!);
                });
              }
            },
          ),
    };

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Valid IDs are as follow:
              Text(
                'Your cooperative must submit the following documents to validate your cooperative.',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Additionally we require a letter from your board of directors stating that you are authorized to represent the cooperative.',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1. Certificate of Registration'),
                    Text('2. Articles of Cooperation'),
                    Text('3. By-Laws'),
                    Text('4. Latest audit financial statements'),
                    Text(
                        '5. Letter of authorization from the board of directors'),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final key = documents.keys.elementAt(index);
                  final listTile = documents[key]!();
                  return listTile;
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
