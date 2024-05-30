import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/trips/plan/plan_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/plan_model.dart';

class TripsInfo extends ConsumerStatefulWidget {
  final PlanModel plan;
  const TripsInfo({super.key, required this.plan});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TripsInfoState();
}

class _TripsInfoState extends ConsumerState<TripsInfo> {
  void onDeleteTrip() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete Trip"),
            content: const Text("You are about to delete your planned trip."),
            actions: [
              FilledButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Close')),
              FilledButton(
                  onPressed: () {
                    ref
                        .read(plansControllerProvider.notifier)
                        .deletePlan(widget.plan, context);
                    context.pop();
                    context.pop();
                    context.pop();
                  },
                  child: const Text('Continue')),
            ],
          );
        });
  }

  void onEditTrip() {
    ref.read(planLocationProvider.notifier).setLocation(widget.plan.location);
    ref
        .read(planStartDateProvider.notifier)
        .setStartDate(widget.plan.startDate!);
    ref.read(planEndDateProvider.notifier).setEndDate(widget.plan.endDate!);
    context.push('/trips/edit', extra: widget.plan).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          iconSize: 20,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.plan.imageUrl! != '') ...[
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(20), // round the corners of the image
                child: Image(
                  image: NetworkImage(widget.plan.imageUrl!),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ] else ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: const Image(
                  image: AssetImage('lib/core/images/plans_stock.png'),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
            ],
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12.0, right: 12.0, top: 15),
                    child: Text(
                      widget.plan.name,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12.0, bottom: 15),
                    child: Text(
                      "${DateFormat('d MMM').format(widget.plan.startDate!)} - ${DateFormat('d MMM').format(widget.plan.endDate!)}",
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 1.2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              onDeleteTrip();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                              ),
                            ),
                            child: const Text('Delete Trip'),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 40,
                        ),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => onEditTrip(),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                              ),
                            ),
                            child: const Text('Edit Trip'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 1.2,
                    child: FilledButton(
                      onPressed: () async {
                        PlanModel updatedPlan =
                            widget.plan.copyWith(tripStatus: 'Completed');
                        ref
                            .read(plansControllerProvider.notifier)
                            .updatePlan(updatedPlan, context);
                      },
                      child: const Text('Complete Trip'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.plan.location,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                      maxLines: 1, // Set maximum lines to 1
                      overflow:
                          TextOverflow.ellipsis, // Use ellipsis for overflow
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  const Icon(Icons.people),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.plan.guests} Participants',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Budget
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  const Icon(Icons.attach_money),
                  const SizedBox(width: 8),
                  Text(
                    'Budget: ₱ ${widget.plan.budget} per person',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Our Memories',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                padding: const EdgeInsets.all(6),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: SizedBox(
                    height: 100,
                    // max width
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: const Center(
                      child: Icon(
                        Icons.camera_alt,
                      ),
                    ),
                  ),
                ),
              ),
            )
            // Location
          ],
        ),
      ),
    );
  }
}
