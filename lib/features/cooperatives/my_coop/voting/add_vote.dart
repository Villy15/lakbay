import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/subcollections/coop_vote_model.dart';

class AddVote extends ConsumerStatefulWidget {
  final BuildContext parentContext;
  final CooperativeModel coop;
  const AddVote({super.key, required this.parentContext, required this.coop});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddVoteState();
}

class _AddVoteState extends ConsumerState<AddVote> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  DateTime? _selectedDate;

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

      var vote = CoopVote(
        position: _titleController.text,
        dueDate: _selectedDate!,
        coopId: widget.coop.uid!,
      );

      ref.read(coopsControllerProvider.notifier).addVote(
            widget.coop.uid!,
            vote,
            context,
          );
    }
  }

  void _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(coopsControllerProvider);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.95,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Vote'),
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
                  labelText: 'Position Title*',
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

              // Target Date Field
              const SizedBox(height: 10.0),

              // Target Date Field
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(),
                  labelText: 'Target Date*',
                  helperText: '*required',
                ),
                readOnly: true,
                onTap: () => _showDatePicker(context),
                controller: TextEditingController(
                  text: _selectedDate != null
                      ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                      : '',
                ),
                validator: (String? value) {
                  if (_selectedDate == null) {
                    return 'Please select a target date';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
