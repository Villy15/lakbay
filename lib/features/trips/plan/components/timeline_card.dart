import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/trips/plan/plan_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/plan_model.dart';

class TimelineCard extends ConsumerStatefulWidget {
  final PlanModel plan;
  final PlanActivity activity;
  final DateTime thisDay;
  const TimelineCard({
    super.key,
    required this.plan,
    required this.activity,
    required this.thisDay,
  });

  @override
  ConsumerState<TimelineCard> createState() => _TimelineCardState();
}

class _TimelineCardState extends ConsumerState<TimelineCard> {
  void onTap(ListingModel listing) {
    // Action for Check In Details
    context.push('/market/${listing.category}', extra: listing);
  }

  void deleteActivity() {
    // Create a local variable for the BuildContext
    final localContext = context;

    // Show confirmation dialog
    showDialog<bool>(
      context: localContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this activity?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    ).then((confirmDelete) {
      // Proceed with deletion if confirmed
      if (confirmDelete == true) {
        var updatedPlan = widget.plan.copyWith(
          activities: widget.plan.activities
              ?.where((activity) => activity.key != widget.activity.key)
              .toList(),
        );

        ref
            .read(plansControllerProvider.notifier)
            .deleteActivityFromPlan(updatedPlan, localContext);

        // Optionally, show a feedback message
        showSnackBar(localContext, 'Activity deleted successfully');
      }
    });
  }

  String getDuration(DateTime? start, DateTime? end) {
    if (start != null && end != null) {
      final duration = end.difference(start);
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      if (hours == 0) {
        return '$minutes mins';
      }

      if (minutes == 0) {
        return '$hours hours';
      }

      return '$hours hours $minutes mins';
    }
    return '';
  }

  void addStartTime() {
    // Add a start time to the activity by adding a time picker
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((time) {
      if (time != null) {
        final updatedPlan = widget.plan.copyWith(
          activities: widget.plan.activities?.map((activity) {
            if (activity.key == widget.activity.key) {
              return activity.copyWith(
                  startTime: DateTime(
                widget.activity.dateTime!.year,
                widget.activity.dateTime!.month,
                widget.activity.dateTime!.day,
                time.hour,
                time.minute,
              ));
            }
            return activity;
          }).toList(),
        );

        debugPrint('updatedPlan: $updatedPlan');

        ref
            .read(plansControllerProvider.notifier)
            .updatePlan(updatedPlan, context, false);
      }
    });
  }

  void addEndTime() {
    // Add a start time to the activity by adding a time picker
    showTimePicker(
      context: context,
      // Make the initial time to startDate
      initialTime: widget.activity.startTime != null
          ? TimeOfDay.fromDateTime(
              widget.activity.startTime!.add(const Duration(hours: 1)))
          : TimeOfDay.now(),
    ).then((time) {
      if (time != null) {
        final updatedPlan = widget.plan.copyWith(
          activities: widget.plan.activities?.map((activity) {
            if (activity.key == widget.activity.key) {
              return activity.copyWith(
                  endTime: DateTime(
                widget.activity.dateTime!.year,
                widget.activity.dateTime!.month,
                widget.activity.dateTime!.day,
                time.hour,
                time.minute,
              ));
            }
            return activity;
          }).toList(),
        );

        debugPrint('updatedPlan: $updatedPlan');

        ref
            .read(plansControllerProvider.notifier)
            .updatePlan(updatedPlan, context, false);
      }
    });
  }

  void addExpense() {
    TextEditingController controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Add Expense',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Text('Enter the amount spent'),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '₱100',
                  prefixText: '₱',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Show modal bottomsheet that adds checkList items
  void addCheckList() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Add Check List',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Text('Enter the item'),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Item',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.activity.startTime != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                DateFormat('hh:mm a').format(widget.activity.startTime!),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ref.watch(getListingProvider(widget.activity.listingId!)).when(
              data: (listing) {
                return _buildCard(context, listing);
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) {
                debugPrint('Error: $error');
                return Text('Error: $error');
              },
            ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Delete Activity
            IconButton(
              onPressed: () => deleteActivity(),
              icon: const Icon(
                Icons.delete_outline,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () => addStartTime(),
                  icon: const Icon(
                    Icons.timer_outlined,
                  ),
                ),
                // Set Duration
                IconButton(
                  onPressed: widget.activity.startTime != null
                      ? () => addEndTime()
                      : null,
                  icon: const Icon(
                    Icons.timelapse_outlined,
                  ),
                ),
                // Manage expenses
                IconButton(
                  onPressed: () => addExpense(),
                  icon: const Icon(
                    Icons.attach_money,
                  ),
                ),
                IconButton(
                  onPressed: () => addCheckList(),
                  icon: const Icon(
                    Icons.checklist_outlined,
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Card _buildCard(BuildContext context, ListingModel listing) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: InkWell(
        splashColor: Colors.orange.withAlpha(30),
        onTap: () => onTap(listing),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // DisplayImage
              if (widget.activity.imageUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.activity.imageUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.activity.title!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    if (widget.activity.description != '') ...[
                      Text(
                        widget.activity.description!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5)),
                      ),
                    ] else ...[
                      Text('No description',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5))),
                    ],
                    const SizedBox(height: 8),
                    // Check in and check out time lables
                    if (widget.activity.category == "Accommodation" &&
                        widget.thisDay.day == widget.activity.startTime!.day)
                      Row(
                        children: [
                          Text(
                            'Check In:     ',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            DateFormat('hh:mm a').format(listing.checkIn!),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 4),
                    if (widget.activity.category == "Accommodation" &&
                        widget.thisDay.day == widget.activity.endTime!.day)
                      Row(
                        children: [
                          Text(
                            'Check Out:  ',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            DateFormat('hh:mm a').format(listing.checkOut!),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        getDuration(
                            widget.activity.startTime, widget.activity.endTime),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    // TextButton(
                    //   onPressed: () => onTap(),
                    //   child: const Text('Check In Details'),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
