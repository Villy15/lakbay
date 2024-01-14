import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/tasks/tasks_controller.dart';
import 'package:lakbay/models/event_model.dart';
import 'package:lakbay/models/task_model.dart';

class AddEventTask extends ConsumerStatefulWidget {
  final EventModel event;
  const AddEventTask({super.key, required this.event});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddEventTaskState();
}

enum Priority { low, medium, high }

class _AddEventTaskState extends ConsumerState<AddEventTask> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _title = TextEditingController();
  final _description = TextEditingController();
  final _date = TextEditingController();
  final _time = TextEditingController();

  Priority _priority = Priority.low;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final isLoading = ref.watch(tasksControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event Task'),
      ),
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
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save(); //

                  // DebugPrint the data entered into the form
                  final newTask = TaskModel(
                    title: _title.text,
                    description: _description.text,
                    dueDate: DateFormat('dd MMM y hh:mm a')
                        .parse(
                          '${_date.text} ${_time.text}',
                        )
                        .toLocal(),
                    priority: _priority.toString().split('.').last,
                    coopId: user!.currentCoop!,
                    type: 'event',
                    eventId: widget.event.uid,
                    publisherId: user.uid,
                    createdAt: DateTime.now(),
                  );

                  // Add the new task
                  ref
                      .read(tasksControllerProvider.notifier)
                      .addTask(context, newTask);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Loader()
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Title
                  titleFormField(),

                  const SizedBox(height: 10),

                  // Description
                  descriptionFormField(),

                  const SizedBox(height: 10),

                  dateTimeFormField(context),

                  const SizedBox(height: 10),

                  // Priority
                  priorityFormField(),
                ],
              ),
            ),
    );
  }

  Widget priorityFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Priority*'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ToggleButtons(
              borderWidth: 5.0,
              borderColor: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16.0),
              fillColor: Theme.of(context).colorScheme.primary,
              selectedColor: Theme.of(context).colorScheme.background,
              selectedBorderColor: Theme.of(context).colorScheme.primary,
              renderBorder: false,
              constraints: BoxConstraints.expand(
                width: MediaQuery.of(context).size.width / 3 - 12,
                height: 40.0,
              ),
              onPressed: (int index) {
                setState(() {
                  _priority = Priority.values[index];
                });
              },
              isSelected: [
                _priority == Priority.low,
                _priority == Priority.medium,
                _priority == Priority.high,
              ],
              children: const [
                Text('Low'),
                Text('Medium'),
                Text('High'),
              ],
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text('*required', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  Row dateTimeFormField(BuildContext context) {
    return Row(
      children: [
        // Date
        Flexible(
          flex: 1,
          child: TextFormField(
            readOnly: true, // make field read only
            decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today, color: Colors.transparent),
              suffixIcon: Icon(Icons.calendar_today_outlined),
              border: OutlineInputBorder(),
              labelText: 'Date*',
              helperText: '*required',
            ),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                // Format the date and set it to the text field value
                final formattedDate = DateFormat('dd MMM yy').format(date);
                // This will update the text in the TextFormField
                _date.text = formattedDate;
              }
            },
            controller: _date, // define this controller in your widget
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a date';
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
            readOnly: true, // make field read only
            decoration: const InputDecoration(
              icon: Icon(Icons.access_time, color: Colors.transparent),
              suffixIcon: Icon(Icons.access_time_outlined),
              border: OutlineInputBorder(),
              labelText: 'Time*',
              helperText: '*required',
            ),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null) {
                // Format the time and set it to the text field value
                final formattedTime = DateFormat('hh:mm a').format(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  time.hour,
                  time.minute,
                ));
                // This will update the text in the TextFormField
                _time.text = formattedTime;
              }
            },
            controller: _time, // define this controller in your widget
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

  TextFormField descriptionFormField() {
    return TextFormField(
      controller: _description,
      maxLines: null,
      decoration: const InputDecoration(
          icon: Icon(Icons.description),
          border: OutlineInputBorder(),
          labelText: 'Description',
          helperText: 'optional'),
    );
  }

  TextFormField titleFormField() {
    return TextFormField(
      controller: _title,
      decoration: const InputDecoration(
        icon: Icon(Icons.event),
        border: OutlineInputBorder(),
        labelText: 'Event Name*',
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
}
