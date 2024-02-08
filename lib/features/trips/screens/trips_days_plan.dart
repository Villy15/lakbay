import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/listings/widgets/listing_card.dart';
import 'package:lakbay/models/listing_model.dart';

class TripsDaysPlan extends ConsumerStatefulWidget {
  const TripsDaysPlan({super.key});

  @override
  ConsumerState<TripsDaysPlan> createState() => _TripsDaysPlanState();
}

class _TripsDaysPlanState extends ConsumerState<TripsDaysPlan>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      SizedBox(
        width: 150.0,
        height: 70.0,
        child: Tab(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Day 1',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                'March 01, 2019',
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(
        width: 150.0,
        height: 70.0,
        child: Tab(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Day 2'),
              Text('March 02, 2019'),
            ],
          ),
        ),
      ),
    ];

    return ref.watch(getAllListingsProvider).when(
          data: (List<ListingModel> listings) {
            return Column(
              children: <Widget>[
                TabBar.secondary(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  controller: _tabController,
                  labelPadding: EdgeInsets.zero,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: tabs,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: listings.length,
                        itemBuilder: (context, index) {
                          final listing = listings[index];
                          return ListingCard(
                            listing: listing,
                          );
                        },
                      ),
                      const Card(
                        margin: EdgeInsets.all(16.0),
                        child: Center(child: Text('Specifications tab')),
                      ),
                      const Card(
                        margin: EdgeInsets.all(16.0),
                        child: Center(child: Text('Specifications tab')),
                      ),
                      const Card(
                        margin: EdgeInsets.all(16.0),
                        child: Center(child: Text('Specifications tab')),
                      ),
                      const Card(
                        margin: EdgeInsets.all(16.0),
                        child: Center(child: Text('Specifications tab')),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          error: (error, stackTrace) => Scaffold(
            body: ErrorText(
              error: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          ),
          loading: () => const Scaffold(
            body: Loader(),
          ),
        );
  }
}
