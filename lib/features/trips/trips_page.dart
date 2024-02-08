import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/trips/components/trip_card.dart';
import 'package:lakbay/models/plan_model.dart';

class TripsPage extends ConsumerStatefulWidget {
  const TripsPage({super.key});

  @override
  ConsumerState<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends ConsumerState<TripsPage> {
  void onNewTripPressed() {
    context.push(
      '/trips/add',
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    // sample Plans
    final plans = [
      PlanModel(
        uid: '1',
        location: 'Boracay',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 5)),
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/lakbay-cd97e.appspot.com/o/listings%2FIwahori%20Multipurpose%20Cooperative%2F357817a_hb_a_050.jpg_0?alt=media&token=a150369f-6029-432d-9b50-2dbabe67249e',
        activities: [
          PlanActivity(
            dateTime: DateTime.now(),
            title: 'Beach',
            description: 'Swimming and Sunbathing',
            startTime: DateTime.now(),
            endTime: DateTime.now().add(const Duration(hours: 2)),
          ),
          PlanActivity(
            dateTime: DateTime.now().add(const Duration(days: 1)),
            title: 'Island Hopping',
            description: 'Visit nearby islands',
            startTime: DateTime.now().add(const Duration(days: 1)),
            endTime: DateTime.now().add(const Duration(days: 1, hours: 4)),
          ),
        ],
        name: 'Boracay Trip',
        budget: 10000,
        guests: 2,
        userId: user?.uid ?? '',
      ),
    ];

    return Scaffold(
      appBar: CustomAppBar(title: 'Trips', user: user),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Ongoing Trips',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 12.0,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    return TripCard(
                      plan: plan,
                    );
                  },
                ),
              ),

              // Create a new Trip
              const SizedBox(height: 20),
              FilledButton(
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
              ),

              // Past Trips

              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Past Trips',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ref.watch(getAllListingsProvider).when(
                    data: (listings) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            final listing = listings[index];
                            return Center(
                              child: Card(
                                clipBehavior: Clip.hardEdge,
                                elevation: 1,
                                surfaceTintColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: InkWell(
                                  splashColor: Colors.orange.withAlpha(30),
                                  onTap: () => {},
                                  child: SizedBox(
                                      width: double.infinity,
                                      // height: 290,
                                      child: Column(
                                        children: [
                                          // Random Image
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                20), // round the corners of the image
                                            child: Image(
                                              image: NetworkImage(
                                                  listing.images!.first.url!),
                                              width: double.infinity,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),

                                          // Card Title
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8.0, 8.0, 8.0, 0.0),
                                              child: Text(
                                                listing.title,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),

                                          // Date Range
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                8.0, 0.0, 8.0, 8.0),
                                            // Date should be 18 Feb - 22 Feb
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "1 month ago",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            );
                          },
                        ),
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
}
