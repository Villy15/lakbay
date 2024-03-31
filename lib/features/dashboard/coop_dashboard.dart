import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/sales/sales_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/listing_model.dart';

class CoopDashboard extends ConsumerStatefulWidget {
  final String coopId;
  const CoopDashboard({super.key, required this.coopId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CoopDashboardState();
}

class _CoopDashboardState extends ConsumerState<CoopDashboard> {
  DateTime _selectedDate = DateTime.now();
  final List<String> _filterTypes = ['Day', 'Week', 'Month', 'Year'];
  String _selectedFilterType = 'Month';
  late AsyncValue<List<ListingModel>> _listings;

  @override
  void initState() {
    super.initState();
    // Fetch the list of listings when the widget initializes
    _listings = ref.read(getAllListingsProvider);
  }

@override
Widget build(BuildContext context) {
  final user = ref.watch(userProvider);
  debugPrintJson("File Name: coop_dashboard.dart");
  return Scaffold(
    appBar: CustomAppBar(title: 'My Dashboard', user: user),
    body: ref.watch(getSalesProvider).when(
      data: (sales) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              dashboardFunctions(context),
                            ref.watch(getAllListingsProvider).when(
                data: (listings) {
                  if (listings.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  int totalBookingsForUserListings = 0;
                  
                  for (final listing in listings) {
                    if (listing.publisherName == user!.name) {
                      ref.watch(getAllBookingsProvider(listing.uid!)).when(
                        data: (List<ListingBookings> bookings) {
                          for (final booking in bookings) {
                              totalBookingsForUserListings++;
                          }
                        },
                        error: (error, stackTrace) => ErrorText(
                          error: error.toString(),
                          stackTrace: stackTrace.toString(),
                        ),
                        loading: () => const Loader(),
                      );
                    }
                  }

                  return Column(
                    children: [
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          "Current points: $totalBookingsForUserListings",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                  stackTrace: stackTrace.toString(),
                ),
                loading: () => const Loader(),
              ),
              rowSummaryCards(12000, 500),
              lineChart(),
              const SizedBox(height: 16),
              const Text("Sample Sales"),

              // ListView of listTile of sales name
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sales.length,
                itemBuilder: (context, index) {
                  final sale = sales[index];
                  return ListTile(
                    title: Text(sale.category),
                  );
                },
              ),


            ],
          ),
        );
      },
      error: (error, stackTrace) => ErrorText(
        error: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
      loading: () => const Loader(),
    ),
  );
}

  Card lineChart() {
    return Card(
      child: SfCartesianChart(
        title: const ChartTitle(
            text: 'Sales Trend by Service Category',
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        // plotAreaBorderColor: Colors.transparent,
        legend: const Legend(
            isVisible: true,
            alignment: ChartAlignment.center,
            position: LegendPosition.bottom),
        primaryXAxis: DateTimeAxis(
          dateFormat: _selectedFilterType == 'Week' ? DateFormat.MMMd() : null,
        ),
        primaryYAxis: NumericAxis(
          numberFormat: NumberFormat('₱#,##0'),
          maximum: 10000,
          interval: 1000,
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          header: '',
          canShowMarker: false,
          format: 'point.x : point.y',
        ),
      ),
    );
  }

  Widget rowSummaryCards(num totalSales, double averageSales) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          summaryCard('Total Sales', '₱${totalSales.toStringAsFixed(2)}'),
          summaryCard('Average Sales', '₱${averageSales.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget summaryCard(String title, String value) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value),
            ],
          ),
        ),
      ),
    );
  }

  Widget dashboardFunctions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            DropdownButton(
              value: _selectedFilterType,
              icon: const Icon(
                Icons.arrow_downward,
                size: 16,
              ),
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
              items: _filterTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFilterType = newValue!;
                });
              },
            ),
            // Add a today button
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedDate = DateTime.now();
                });
              },
              child: const Text('Today?'),
            ),
          ],
        ),
        Row(
          children: [
            // Add Icon of date
            const Icon(Icons.calendar_today),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => (),
              child: Text(_selectedFilterType == 'Week'
                  ? '${DateFormat('MM/dd/yyyy').format(_selectedDate)} - ${DateFormat('MM/dd/yyyy').format(_selectedDate.add(const Duration(days: 6)))}'
                  : _selectedFilterType == 'Month'
                      ? DateFormat.yMMM().format(_selectedDate)
                      : _selectedFilterType == 'Year'
                          ? DateFormat.y().format(_selectedDate)
                          : DateFormat.yMd().format(_selectedDate)),
            ),
          ],
        ),
      ],
    );
  }
}
