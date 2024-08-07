import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/trips/app_coop.dart';
import 'package:lakbay/features/trips/components/trip_card.dart';
import 'package:lakbay/features/trips/plan/plan_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/plan_model.dart';
import 'package:lakbay/models/user_model.dart';

class PlanPage extends ConsumerStatefulWidget {
  const PlanPage({super.key});

  @override
  ConsumerState<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends ConsumerState<PlanPage> {
  void onNewTripPressed() {
    context.push(
      '/trips/add',
    );
  }

  void onTap(BuildContext context, WidgetRef ref, PlanModel plan) {
    // context.push('/market/${listing.category}', extra: listing);
    ref.read(currentTripProvider.notifier).setPlan(plan);
    context.push('/trips/details/${plan.uid}');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    Query query = FirebaseFirestore.instance
        .collectionGroup('plans')
        .where('tripStatus', isEqualTo: 'Completed');

    if (user?.isCoopView == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/today');
      });
    }

    if (user?.isAdmin ?? false) {
      return adminScaffold(user);
    }

    return Scaffold(
      appBar: CustomAppBar(title: 'Explore', user: user),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ref.watch(getPlansByPropertiesProvider(query)).when(
                    data: (plans) {
                      List<PlanModel> filteredPlans = [];
                      for (var plan in plans) {
                        if (plan.tripStatus == 'Completed') {
                          filteredPlans.add(plan);
                        }
                      }

                      if (filteredPlans.isEmpty) {
                        return Padding(
                          // Use screen size to center the content
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 5,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'lib/core/images/SleepingCatFromGlitch.svg',
                                  height: 100, // Adjust height as desired
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'No Complete trips by others!',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Complete a new trip now!',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const Text(
                                  'Or wait for others to complete their trips.',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                createNewTrip(),
                              ],
                            ),
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Explore Lakbay\'s successful\ntrips!',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          completedTrips(plans),
                        ],
                      );
                    },
                    error: (error, stackTrace) => ErrorText(
                        error: error.toString(),
                        stackTrace: stackTrace.toString()),
                    loading: () => const Loader(),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  void approveCoop(BuildContext context, CooperativeModel coop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return ApproveCoop(
          parentContext: context,
          coop: coop,
        );
      },
    );
  }

  Scaffold adminScaffold(UserModel? user) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Admin Page', user: user),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pending Cooperatives to Approve',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Pending Cooperatives
            ref.watch(getAllCooperativesProvider).when(
                  data: (cooperatives) {
                    // Update cooperatives list to coops that have not been approved
                    cooperatives = cooperatives
                        .where(
                            (coop) => coop.validityStatus?.status == 'pending')
                        .toList();

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cooperatives.length,
                      itemBuilder: (context, index) {
                        final coop = cooperatives[index];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(coop.imageUrl!),
                          ),
                          title: Text(coop.name),
                          subtitle: Text(
                            'Date Created: ${DateFormat('MMM d, y').format(coop.dateCreated ?? DateTime.now())}',
                          ),
                          // Trailing arrow to the right
                          trailing: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              approveCoop(context, coop);
                            },
                          ),

                          onTap: () {
                            approveCoop(context, coop);
                          },
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) => Scaffold(
                    body: ErrorText(
                      error: error.toString(),
                      stackTrace: stackTrace.toString(),
                    ),
                  ),
                  loading: () => const Loader(),
                ),
            const SizedBox(height: 20),

            // Approve Reistered Cooperatives
            const Text(
              'Approve Registered Cooperatives',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            ref.watch(getAllCooperativesProvider).when(
                  data: (cooperatives) {
                    cooperatives = cooperatives
                        .where(
                            (coop) => coop.validityStatus?.status == 'approved')
                        .toList();

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cooperatives.length,
                      itemBuilder: (context, index) {
                        final coop = cooperatives[index];

                        return ListTile(
                          onTap: () {
                            approveCoop(context, coop);
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(coop.imageUrl!),
                          ),
                          title: Text(coop.name),
                          subtitle: Text(
                            'Date Approved: ${DateFormat('MMM d, y').format(coop.validityStatus?.dateValidated ?? DateTime.now())}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () {
                              approveCoop(context, coop);
                            },
                          ),
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) => Scaffold(
                    body: ErrorText(
                      error: error.toString(),
                      stackTrace: stackTrace.toString(),
                    ),
                  ),
                  loading: () => const Loader(),
                )
          ],
        ),
      )),
    );
  }

  FilledButton createNewTrip() {
    return FilledButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(
          double.infinity,
          50,
        )), // Set width to double.infinity
      ),
      onPressed: () {
        onNewTripPressed();
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add),
          SizedBox(width: 10),
          Text('CREATE A NEW TRIP'),
        ],
      ),
    );
  }

  Padding gridPastTrips(List<PlanModel> plans) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.5,
          mainAxisExtent: 200,
        ),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return Center(
            child: Card(
              clipBehavior: Clip.hardEdge,
              elevation: 1,
              surfaceTintColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: InkWell(
                splashColor: Colors.orange.withAlpha(30),
                onTap: () => onTap(context, ref, plan),
                child: SizedBox(
                    width: double.infinity,
                    // height: 290,
                    child: Column(
                      children: [
                        if (plan.imageUrl! != '') ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                20), // round the corners of the image
                            child: Image(
                              image: NetworkImage(plan.imageUrl!),
                              width: double.infinity,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ] else ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                20), // round the corners of the image
                            child: const Image(
                              // Image from root/lib/core/images/plans_stock.jpg
                              image:
                                  AssetImage('lib/core/images/plans_stock.jpg'),
                              width: double.infinity,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                        // Card Title
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                            child: Text(
                              'Boracay Trip w Family', // 'Boracay Trip
                              // plan.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        // Date Range
                        dateCreated(plan.endDate!),
                      ],
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

  Padding dateCreated(DateTime endDate) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
      // Date should be 18 Feb - 22 Feb
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '1 month ago',
            // timeAgo(endDate),
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String timeAgo(DateTime endDate) {
    final difference = DateTime.now().difference(endDate);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes != 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours != 1 ? 's' : ''} ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} day${difference.inDays != 1 ? 's' : ''} ago';
    } else {
      final months = (difference.inDays / 30).round();
      return '$months month${months != 1 ? 's' : ''} ago';
    }
  }

  Padding completedTrips(List<PlanModel> plans) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(
          height: 12.0,
        ),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return TripCard(
            plan: plan,
          );
        },
      ),
    );
  }
}
