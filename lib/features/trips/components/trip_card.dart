import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/models/plan_model.dart';

class TripCard extends ConsumerWidget {
  final PlanModel plan;
  const TripCard({super.key, required this.plan});

  void onTap(BuildContext context, WidgetRef ref) {
    // context.push('/market/${listing.category}', extra: listing);
    context.push('/trips/details/${plan.uid}', extra: plan);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 1,
        // surfaceTintColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: InkWell(
          splashColor: Colors.orange.withAlpha(30),
          onTap: () => onTap(context, ref),
          child: SizedBox(
              width: double.infinity,
              // height: 290,
              child: Column(
                children: [
                  // Random Image
                  if (plan.imageUrl! != '') ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          20), // round the corners of the image
                      child: Image(
                        image: NetworkImage(plan.imageUrl!),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ] else ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          20), // round the corners of the image
                      child: const Image(
                        // Image from root/lib/core/images/plans_stock.jpg
                        image: AssetImage('lib/core/images/plans_stock.jpg'),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],

                  // Card Title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          // width: 200,
                          child: Text(
                            plan.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Location Province
                      ],
                    ),
                  ),

                  // Location
                  Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                          ),
                          Text(
                            plan.location,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )),

                  // Date Range
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                    // Date should be 18 Feb - 22 Feb
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${DateFormat('d MMM').format(plan.startDate!)} - ${DateFormat('d MMM').format(plan.endDate!)}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),

                        // Participants
                        const Row(
                          children: [
                            Icon(
                              Icons.people,
                              size: 16,
                            ),
                            Text(
                              ' 2 participants',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
