import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/listings/widgets/listing_card.dart';
import 'package:lakbay/models/listing_model.dart';

class NestedTabBarAccomodation extends ConsumerStatefulWidget {
  const NestedTabBarAccomodation({super.key});

  @override
  ConsumerState<NestedTabBarAccomodation> createState() =>
      _NestedTabBarAccomodationState();
}

class _NestedTabBarAccomodationState
    extends ConsumerState<NestedTabBarAccomodation>
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

  List<Widget> tabs = [
    const SizedBox(
      width: 150.0,
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.forest_outlined),
            SizedBox(width: 4.0),
            Text('Nature-based'),
          ],
        ),
      ),
    ),
    const SizedBox(
      width: 150.0,
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.diversity_2_outlined),
            SizedBox(width: 4.0),
            Text('Cultural'),
          ],
        ),
      ),
    ),
    const SizedBox(
      width: 150.0,
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.beach_access_outlined),
            SizedBox(width: 4.0),
            Text('Sun & beach'),
          ],
        ),
      ),
    ),
    const SizedBox(
      width: 150.0,
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_hospital_outlined),
            SizedBox(width: 4.0),
            Text('Health'),
          ],
        ),
      ),
    ),
    const SizedBox(
      width: 150.0,
      child: Tab(
        // icon: Icon(Icons.pool_outlned),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.scuba_diving_outlined),
            SizedBox(width: 4.0),
            Text('Diving '),
          ],
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListingCard(
                              listing: listing,
                            ),
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
