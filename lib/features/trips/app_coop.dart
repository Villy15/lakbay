import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:path_provider/path_provider.dart';

class ApproveCoop extends ConsumerStatefulWidget {
  final BuildContext parentContext;
  final CooperativeModel coop;
  const ApproveCoop(
      {super.key, required this.parentContext, required this.coop});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ApproveCoopState();
}

class _ApproveCoopState extends ConsumerState<ApproveCoop> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        validityStatus: ValidityStatus(
          status: 'approved',
          dateValidated: DateTime.now(),
        ),
      );

      ref.read(coopsControllerProvider.notifier).editCooperative(coop, context);
      ref.read(navBarVisibilityProvider.notifier).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(coopsControllerProvider);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.95,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Approve Coop'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              ref.read(navBarVisibilityProvider.notifier).show();
              context.pop(widget.parentContext);
            },
          ),
        ),
        // If approved dont show the bottom nav
        bottomNavigationBar: widget.coop.validityStatus?.status == 'approved'
            ? _bottomNavBarRemove(context)
            : _bottomNavBar(context),
        body: isLoading ? const Loader() : _body(),
      ),
    );
  }

  void onRemove() {
    final coop = widget.coop.copyWith(
      validityStatus: ValidityStatus(
        status: 'pending',
        dateValidated: DateTime.now(),
      ),
    );

    ref.read(coopsControllerProvider.notifier).editCooperative(coop, context);
    ref.read(navBarVisibilityProvider.notifier).show();
  }

  BottomAppBar _bottomNavBarRemove(BuildContext context) {
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
              onRemove();
            },
            child: const Text('Remove'),
          ),
        ],
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
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView _body() {
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
              // Image
              DisplayImage(
                imageUrl: widget.coop.imageUrl,
                height: 200,
                width: double.infinity,
                radius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 10),
              const Text(
                'Coop Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListTile(
                title: const Text('Name',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(widget.coop.name),
              ),
              ListTile(
                title: const Text('Description',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(widget.coop.description ?? ''),
              ),

              // Addresss
              ListTile(
                title: const Text('Address',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(widget.coop.address ?? ''),
              ),

              // City
              ListTile(
                title: const Text('City',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(widget.coop.city),
              ),

              // Province
              ListTile(
                title: const Text('Province',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(widget.coop.province),
              ),

              const Text(
                'Documents Submitted',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Document
              ListTile(
                leading: const Icon(Icons.file_copy),
                title: const Text('Letter of authorization'),
                // Trailing arrow
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
                subtitle: widget.coop.validationFiles?.letterAuth == null
                    ? const Text('No file uploaded')
                    : Text(getFileUrl(widget.coop.validationFiles!.letterAuth)),
                onTap: () async {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: true,
                    builder: (BuildContext context) {
                      return ViewPdf(
                        url: widget.coop.validationFiles!.letterAuth!,
                      );
                    },
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.file_copy),
                title: const Text('Articles of Cooperation'),
                // Trailing arrow
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
                subtitle: widget.coop.validationFiles?.articlesOfCooperation ==
                        null
                    ? const Text('No file uploaded')
                    : Text(getFileUrl(
                        widget.coop.validationFiles!.articlesOfCooperation)),
                onTap: () async {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: true,
                    builder: (BuildContext context) {
                      return ViewPdf(
                        url:
                            widget.coop.validationFiles!.articlesOfCooperation!,
                      );
                    },
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.file_copy),
                title: const Text('By Laws'),
                // Trailing arrow
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
                subtitle: widget.coop.validationFiles?.byLaws == null
                    ? const Text('No file uploaded')
                    : Text(getFileUrl(widget.coop.validationFiles!.byLaws)),

                onTap: () async {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: true,
                    builder: (BuildContext context) {
                      return ViewPdf(
                        url: widget.coop.validationFiles!.byLaws!,
                      );
                    },
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.file_copy),
                title: const Text('Audit'),
                // Trailing arrow
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
                subtitle: widget.coop.validationFiles?.audit == null
                    ? const Text('No file uploaded')
                    : Text(getFileUrl(widget.coop.validationFiles!.audit)),
                onTap: () async {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: true,
                    builder: (BuildContext context) {
                      return ViewPdf(
                        url: widget.coop.validationFiles!.audit!,
                      );
                    },
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.file_copy),
                title: const Text('Certificate of Registration'),
                // Trailing arrow
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
                subtitle:
                    widget.coop.validationFiles?.certificateOfRegistration ==
                            null
                        ? const Text('No file uploaded')
                        : Text(getFileUrl(widget
                            .coop.validationFiles!.certificateOfRegistration)),

                onTap: () async {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: true,
                    builder: (BuildContext context) {
                      return ViewPdf(
                        url: widget
                            .coop.validationFiles!.certificateOfRegistration!,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getFileUrl(String? value) {
    String url = value ?? '';
    Uri uri = Uri.parse(url);
    String fullPath = uri.pathSegments.last;

    List<String> parts = fullPath.split('/');
    String filename = parts.last;

    return filename;
  }
}

class ViewPdf extends ConsumerStatefulWidget {
  final String url;

  const ViewPdf({super.key, required this.url});

  @override
  ConsumerState<ViewPdf> createState() => _ViewPdfState();
}

class _ViewPdfState extends ConsumerState<ViewPdf> {
  Future<String>? path;

  @override
  void initState() {
    super.initState();
    path = downloadFile();
  }

  Future<String> downloadFile() async {
    final Dio dio = Dio();

    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/${Uri.parse(widget.url).pathSegments.last}';

    debugPrint('Path: $path');

    final response = await dio.download(
      widget.url,
      path,
    );
    if (response.statusCode == 200) {
      debugPrint('Downloaded');
    }

    return path;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: path,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          debugPrint('Path: ${snapshot.data}');
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.95,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('View Pdf'),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ),
              body: PDFView(
                filePath: snapshot.data!,
              ),
            ),
          );
        }
      },
    );
  }
}
