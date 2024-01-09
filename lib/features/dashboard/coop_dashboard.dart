import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Coop Dashboard'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                dashboardFunctions(context),
                rowSummaryCards(12000, 500),
                lineChart(),
                const SizedBox(height: 16),
              ],
            ),
          )),
    );
  }

  Card lineChart() {
    return Card(
      child: SfCartesianChart(
        title: ChartTitle(
            text: 'Sales Trend by Service Category',
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        // plotAreaBorderColor: Colors.transparent,
        legend: Legend(
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
