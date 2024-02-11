import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/plan/plan_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/plan_model.dart';

class TimelineCard extends ConsumerStatefulWidget {
  final PlanModel plan;
  final PlanActivity activity;
  const TimelineCard({
    super.key,
    required this.plan,
    required this.activity,
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
              ?.where(
                  (activity) => activity.startTime != widget.activity.startTime)
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
        return '$hours hour';
      }

      return '$hours hours $minutes mins';
    }
    return '';
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
                  onPressed: () => {},
                  icon: const Icon(
                    Icons.timer_outlined,
                  ),
                ),
                // Set Duration
                IconButton(
                  onPressed: () => {},
                  icon: const Icon(
                    Icons.timelapse_outlined,
                  ),
                ),
                // Manage expenses
                IconButton(
                  onPressed: () => {},
                  icon: const Icon(
                    Icons.attach_money,
                  ),
                ),
                IconButton(
                  onPressed: () => {},
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
