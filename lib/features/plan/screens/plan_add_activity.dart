import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/plan/plan_controller.dart';
import 'package:lakbay/features/plan/plan_providers.dart';
import 'package:lakbay/models/plan_model.dart';

class PlanAddActivity extends ConsumerStatefulWidget {
  const PlanAddActivity({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PlanAddActivityState();
}

class _PlanAddActivityState extends ConsumerState<PlanAddActivity> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  TimeOfDay _startTime = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 12, minute: 0);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  void onSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final user = ref.watch(userProvider);
      final planLocation = ref.watch(planLocationProvider);
      final planStartDate = ref.watch(planStartDateProvider);
      final planEndDate = ref.watch(planEndDateProvider);
      final selectedDate = ref.watch(selectedDateProvider);

      var plan = PlanModel(
        location: planLocation ?? '',
        startDate: planStartDate,
        endDate: planEndDate,
        userId: user!.uid,
        activities: [
          PlanActivity(
            title: _nameController.text,
            description: _descriptionController.text,
            startTime: DateTime(
              selectedDate!.year,
              selectedDate.month,
              selectedDate.day,
              _startTime.hour,
              _startTime.minute,
            ),
            endTime: DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              _endTime.hour,
              _endTime.minute,
            ),
            dateTime: selectedDate,
          )
        ],
      );

      ref.watch(plansControllerProvider.notifier).addPlan(plan, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Activity'),
        ),
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
                  onSave();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  // Name
                  activityName(),

                  const SizedBox(height: 10),

                  // Description
                  activityDesc(),

                  const SizedBox(height: 10),

                  startAndEndTime(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField activityDesc() {
    return TextFormField(
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
    );
  }

  TextFormField activityName() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        icon: Icon(
          Icons.person,
        ),
        border: OutlineInputBorder(),
        labelText: 'Activity Name*',
        helperText: '*required',
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  Row startAndEndTime(BuildContext context) {
    return Row(
      children: [
        // Start Time
        Flexible(
          flex: 1,
          child: TextFormField(
            readOnly: true,
            decoration: const InputDecoration(
              icon: Icon(Icons.access_time, color: Colors.transparent),
              suffixIcon: Icon(Icons.access_time_outlined),
              border: OutlineInputBorder(),
              labelText: 'Start Time*',
              helperText: '*required',
            ),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _startTime,
              );
              if (time != null) {
                setState(() {
                  _startTime = time;
                });
              }
            },
            controller: TextEditingController(
              text: DateFormat('hh:mm a').format(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                _startTime.hour,
                _startTime.minute,
              )),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a time';
              }
              return null;
            },
          ),
        ),

        const SizedBox(width: 10),

        // Time
        Flexible(
          flex: 1,
          child: TextFormField(
            readOnly: true,
            decoration: const InputDecoration(
              icon: Icon(Icons.access_time, color: Colors.transparent),
              suffixIcon: Icon(Icons.access_time_outlined),
              border: OutlineInputBorder(),
              labelText: 'End Time*',
              helperText: '*required',
            ),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _endTime,
              );
              if (time != null) {
                setState(() {
                  _endTime = time;
                });
              }
            },
            controller: TextEditingController(
              text: DateFormat('hh:mm a').format(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                _endTime.hour,
                _endTime.minute,
              )),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a time';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
