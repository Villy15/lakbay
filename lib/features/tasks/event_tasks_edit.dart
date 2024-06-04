import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/tasks/tasks_controller.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';
import 'package:lakbay/models/task_model.dart';
import 'package:lakbay/models/wrappers/committee_params.dart';

class EditEventTask extends ConsumerStatefulWidget {
  final TaskModel task;
  const EditEventTask({super.key, required this.task});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditEventTaskState();
}

enum Priority { low, medium, high }

class _EditEventTaskState extends ConsumerState<EditEventTask> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _title = TextEditingController();
  final _description = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 3));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 12, minute: 0);

  Priority _priority = Priority.low;

  final List<String> _selectedMemberIds = [];

  @override
  void initState() {
    super.initState();

    _title.text = widget.task.title;
    _description.text = widget.task.description ?? '';
    _selectedDate =
        widget.task.dueDate ?? DateTime.now().add(const Duration(days: 3));
    _selectedTime = TimeOfDay.fromDateTime(_selectedDate);
    _priority = Priority.values.firstWhere(
      (element) => element.toString().split('.').last == widget.task.priority,
    );
    _selectedMemberIds.addAll(widget.task.assignedTo ?? []);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(tasksControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event Task'),
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

                  var newTask = widget.task.copyWith(
                    title: _title.text,
                    description: _description.text,
                    priority: _priority.toString().split('.').last,
                    dueDate: DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      _selectedTime.hour,
                      _selectedTime.minute,
                    ).toLocal(),
                    assignedTo: _selectedMemberIds,
                  );

                  ref
                      .read(tasksControllerProvider.notifier)
                      .updateTask(context, newTask);

                  context.pop();
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

                  // Add Members
                  addMembersFormField(context),

                  const SizedBox(height: 10),

                  // Priority
                  priorityFormField(),
                ],
              ),
            ),
    );
  }

  Widget addMembersFormField(BuildContext context) {
    const String committeeName = "Events";

    return ref
        .watch(getAllMembersInCommitteeProvider(CommitteeParams(
          committeeName: committeeName,
          coopUid: ref.watch(userProvider)!.currentCoop!,
        )))
        .when(
          data: (members) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextButton(
                    onPressed: () async {
                      await addMembersBottomSheet(
                          context, committeeName, members);
                      setState(() {});
                    },
                    child: const Text('Add Members'),
                  ),
                ),
                const Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _selectedMemberIds.length,
                  itemBuilder: (context, index) {
                    final memberId = _selectedMemberIds[index];
                    return ref.watch(getUserDataProvider(memberId)).when(
                          data: (user) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  user.profilePic,
                                ),
                              ),
                              title: Text(user.name),
                              trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedMemberIds.remove(memberId);
                                  });
                                },
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                            );
                          },
                          error: (error, stack) => const SizedBox(),
                          loading: () => const SizedBox(),
                        );
                  },
                ),
              ],
            );
          },
          loading: () => const Loader(),
          error: (error, stack) => ErrorText(
            error: error.toString(),
            stackTrace: stack.toString(),
          ),
        );
  }

  Future<dynamic> addMembersBottomSheet(BuildContext context,
      String committeeName, List<CooperativeMembers> members) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            // Use StatefulBuilder here
            builder: (BuildContext context, StateSetter setStateModal) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 12, 28, 0),
                      child: Text('$committeeName Committee',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(28, 0, 28, 0),
                      child: Divider(),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        final member = members[index];
                        return ref.watch(getUserDataProvider(member.uid!)).when(
                              data: (user) {
                                return ListTile(
                                  onTap: () {
                                    setStateModal(() {
                                      // Update using setStateModal
                                      if (_selectedMemberIds
                                          .contains(member.uid)) {
                                        _selectedMemberIds.remove(member.uid);
                                      } else {
                                        _selectedMemberIds.add(member.uid!);
                                      }
                                    });
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      user.profilePic,
                                    ),
                                  ),
                                  title: Text(user.name),
                                  trailing: Checkbox(
                                    value:
                                        _selectedMemberIds.contains(member.uid),
                                    onChanged: (value) {
                                      setStateModal(() {
                                        // Update using setStateModal
                                        if (value == true) {
                                          _selectedMemberIds.add(member.uid!);
                                        } else {
                                          _selectedMemberIds.remove(member.uid);
                                        }
                                      });
                                    },
                                  ),
                                );
                              },
                              error: (error, stackTrace) => const SizedBox(),
                              loading: () => const SizedBox(),
                            );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        });
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
            readOnly: true,
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
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                setState(() {
                  _selectedDate = date;
                });
              }
            },
            controller: TextEditingController(
              text: DateFormat('dd MMM yy').format(_selectedDate),
            ),
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
            readOnly: true,
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
                initialTime: _selectedTime,
              );
              if (time != null) {
                setState(() {
                  _selectedTime = time;
                });
              }
            },
            controller: TextEditingController(
              text: DateFormat('hh:mm a').format(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                _selectedTime.hour,
                _selectedTime.minute,
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
        labelText: 'Task Name*',
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
