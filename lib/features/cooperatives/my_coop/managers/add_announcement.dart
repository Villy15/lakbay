import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/subcollections/coop_announcements_model.dart';

class AddAnnouncement extends ConsumerStatefulWidget {
  final BuildContext parentContext;
  final CooperativeModel coop;
  const AddAnnouncement(
      {super.key, required this.parentContext, required this.coop});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddAnnouncementState();
}

class _AddAnnouncementState extends ConsumerState<AddAnnouncement> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

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

      var announcement = CoopAnnouncements(
        title: _titleController.text,
        description: _descriptionController.text,
        category: _categoryController.text,
        timestamp: DateTime.now(),
        coopId: widget.coop.uid!,
      );

      debugPrint('Announcement: ${announcement.toString()}');

      // Add the announcement to the database
      ref.read(coopsControllerProvider.notifier).addAnnouncement(
            widget.coop.uid!,
            announcement,
            context,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(coopsControllerProvider);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.95,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Announcement'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
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
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.event),
                  border: OutlineInputBorder(),
                  labelText: 'Announcement Title*',
                  helperText: '*required',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                  labelText: 'Description*',
                  helperText: '*required',
                ),
                maxLines: null,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                  labelText: 'Category*',
                  helperText: '*required',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
