import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/sales/sales_controller.dart';
import 'package:lakbay/models/sale_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CoopDashboard extends ConsumerStatefulWidget {
  final String coopId;
  const CoopDashboard({super.key, required this.coopId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CoopDashboardState();
}

class _CoopDashboardState extends ConsumerState<CoopDashboard> {
  DateTime _selectedDate = DateTime.now();
  final List<String> _filterTypes = ['Day', 'Week', 'Month', 'Year'];
  String _selectedFilterType = 'Year';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    debugPrintJson("File Name: coop_dashboard.dart");
    return Scaffold(
      appBar: CustomAppBar(title: 'Coop Dashboard', user: user),
      body: ref.watch(getSalesByCoopIdProvider(user!.currentCoop!)).when(
            data: (sales) {
              if (sales.isEmpty) {
                return salesEmpty();
              }

              // Sort sales by date
              sales.sort((a, b) {
                final bookingA = ref
                    .watch(getBookingByIdProvider((a.listingId, a.bookingId)))
                    .asData
                    ?.value;

                final bookingB = ref
                    .watch(getBookingByIdProvider((b.listingId, b.bookingId)))
                    .asData
                    ?.value;

                if (bookingA == null || bookingB == null) {
                  return 0;
                }

                return bookingA.startDate!.compareTo(bookingB.startDate!);
              });

              // Filter data based on selection
              final filteredSales = sales.where((sale) {
                final booking = ref.watch(
                    getBookingByIdProvider((sale.listingId, sale.bookingId)));
                final startDate = booking.asData?.value.startDate;
                if (startDate != null) {
                  return filterDataBasedOnSelection(startDate);
                }
                return false;
              }).toList();

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    dashboardFunctions(context),
                    if (filteredSales.isNotEmpty) ...[
                      rowSummaryCards(filteredSales),
                      rowShareCapital(filteredSales),
                      lineChart(filteredSales),
                      pieChart(filteredSales),
                      pieChartByCategory(sales),
                      const SizedBox(height: 16),
                      Text('Transactions',
                          style: Theme.of(context).textTheme.titleLarge),
                      listTransactions(filteredSales),
                    ] else ...[
                      Padding(
                        // padding screen height - appbar height - padding
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.2),
                        child: salesEmpty(),
                      ),
                    ],
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

  Center salesEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'lib/core/images/SleepingCatFromGlitch.svg',
            height: 100, // Adjust height as desired
          ),
          const SizedBox(height: 20),
          const Text(
            'No sales yet!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Start selling your services',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const Text(
            'and see your sales here!',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  ListView listTransactions(List<SaleModel> sales) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sales.length,
      itemBuilder: (context, index) {
        final sale = sales[index];
        return ListTile(
          leading: DisplayImage(
            imageUrl: ref.watch(getListingProvider(sale.listingId)).when(
                  data: (listing) {
                    // If listing is null, return Icon
                    return listing.images?.first.url;
                  },
                  loading: () => '',
                  error: (error, stackTrace) => '',
                ),
            width: 50,
            height: 50,
            radius: BorderRadius.circular(8),
          ),
          title: Text(sale.listingName),
          trailing: Text('₱${sale.saleAmount.toStringAsFixed(2)}'),
          subtitle: ref
              .watch(getBookingByIdProvider((sale.listingId, sale.bookingId)))
              .when(
                data: (booking) {
                  return Text(
                      '${DateFormat('MM/dd/yyyy').format(booking.startDate!)} - ${DateFormat('MM/dd/yyyy').format(booking.endDate!)}');
                },
                loading: () => const Text('Loading...'),
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                  stackTrace: stackTrace.toString(),
                ),
              ),
        );
      },
    );
  }

  Card pieChart(List<SaleModel> sales) {
    // Group the filtered data by listingName.
    final Map<String, num> groupedSales = {};
    for (var sale in sales) {
      groupedSales[sale.listingName] =
          (groupedSales[sale.listingName] ?? 0) + sale.saleAmount;
    }

// Create a SaleData object for each group of sales.
    final List<SaleData> data = groupedSales.entries.map((entry) {
      return SaleData(entry.key, entry.value, '');
    }).toList();

// Create a pie series.
    final List<PieSeries<SaleData, String>> createSeries = [
      PieSeries<SaleData, String>(
        dataSource: data,
        xValueMapper: (SaleData data, _) => data.listingName,
        yValueMapper: (SaleData data, _) => data.saleAmount,
        dataLabelMapper: (SaleData data, _) =>
            '₱${data.saleAmount.toStringAsFixed(2)}',
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelPosition: ChartDataLabelPosition.outside,
          connectorLineSettings:
              ConnectorLineSettings(type: ConnectorType.line),
          textStyle: TextStyle(fontSize: 12),
          labelIntersectAction: LabelIntersectAction.shift,
        ),
      ),
    ];

    return Card(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SfCircularChart(
            title: const ChartTitle(
                text: 'Sales Participation by Listing Name',
                textStyle:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            legend: const Legend(
                isVisible: true,
                overflowMode: LegendItemOverflowMode.wrap,
                position: LegendPosition.bottom),
            series: [
              ...createSeries,
            ],
          )),
    );
  }

  Card pieChartByCategory(List<SaleModel> sales) {
    // Define the categories.
    debugPrint('Sales: $sales');

    // Group the sales data by category.
    final Map<String, num> groupedSales = {};
    for (var sale in sales) {
      groupedSales[sale.category] =
          (groupedSales[sale.category] ?? 0) + sale.saleAmount;
    }

    // Calculate the total sales amount.
    final num totalSales =
        groupedSales.values.fold(0, (sum, amount) => sum + amount);

    // Create a SaleData object for each category with the percentage.
    final List<SaleData> data = groupedSales.entries.map((entry) {
      final percentage = (entry.value / totalSales) * 100;
      // Assuming listingName is not relevant for the pie chart, using category as listingName
      return SaleData(entry.key, percentage, entry.key);
    }).toList();

    // Create a pie series.
    final List<PieSeries<SaleData, String>> createSeries = [
      PieSeries<SaleData, String>(
        dataSource: data,
        xValueMapper: (SaleData data, _) => data.category,
        yValueMapper: (SaleData data, _) => data.saleAmount,
        dataLabelMapper: (SaleData data, _) =>
            '${data.category}: ${data.saleAmount.toStringAsFixed(2)}%',
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelPosition: ChartDataLabelPosition.outside,
          connectorLineSettings:
              ConnectorLineSettings(type: ConnectorType.line),
          textStyle: TextStyle(fontSize: 12),
          labelIntersectAction: LabelIntersectAction.shift,
        ),
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SfCircularChart(
          title: const ChartTitle(
              text: 'Sales Participation by Category',
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          legend: const Legend(
              isVisible: true,
              overflowMode: LegendItemOverflowMode.wrap,
              position: LegendPosition.bottom),
          series: [
            ...createSeries,
          ],
        ),
      ),
    );
  }

  Card lineChart(List<SaleModel> sales) {
    // Group the filtered data by listingName.
    final chartDataByCategory =
        sales.fold<Map<String, List<SaleModel>>>({}, (previousValue, element) {
      if (previousValue.containsKey(element.listingName)) {
        previousValue[element.listingName]!.add(element);
      } else {
        previousValue[element.listingName] = [element];
      }
      return previousValue;
    });

    // Create a line series for each listingName.
    final List<LineSeries<SaleModel, DateTime>> createSeries =
        chartDataByCategory.entries
            .map((entry) => LineSeries<SaleModel, DateTime>(
                  dataSource: entry.value,
                  xValueMapper: (SaleModel sales, _) => ref
                      .watch(getBookingByIdProvider(
                          (sales.listingId, sales.bookingId)))
                      .asData
                      ?.value
                      .startDate!,
                  yValueMapper: (SaleModel sales, _) => sales.saleAmount,
                  name: entry.key,
                  markerSettings: const MarkerSettings(isVisible: true),
                ))
            .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SfCartesianChart(
          title: const ChartTitle(
              text: 'Sales Trend by Listing Name',
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          // plotAreaBorderColor: Colors.transparent,
          legend: const Legend(
              isVisible: true,
              alignment: ChartAlignment.center,
              position: LegendPosition.bottom),
          primaryXAxis: DateTimeAxis(
            dateFormat: _selectedFilterType == 'Week'
                ? DateFormat.MMMd()
                : _selectedFilterType == 'Month'
                    ? DateFormat.MMMd()
                    : _selectedFilterType == 'Year'
                        ? DateFormat.MMM()
                        : DateFormat.MMMd(),
          ),
          primaryYAxis: NumericAxis(
            numberFormat: NumberFormat('₱#,##0'),
            maximum: sales.fold(
                0.0,
                (previousValue, sale) =>
                    previousValue! + sale.saleAmount.toDouble() * 1.1),
            // Average interval
            interval: 1000,
          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            header: '',
            canShowMarker: false,
            format: 'point.x : point.y',
          ),
          series: [
            ...createSeries,
          ],
        ),
      ),
    );
  }

  Widget rowShareCapital(List<SaleModel> sales) {
    final totalSales = sales.fold(0.0,
        (previousValue, sale) => previousValue + sale.saleAmount.toDouble());

    final getSharePercentage = ref
            .watch(getCooperativeProvider(widget.coopId))
            .asData
            ?.value
            .membershipDividends ??
        0.0;

    var shareCapital = totalSales * (getSharePercentage / 100);

    if (shareCapital.isNaN) {
      shareCapital = 0.0;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          summaryCard('Share Percentage', '${getSharePercentage.toString()}%'),
          summaryCard('Share Capital', '₱${shareCapital.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget rowSummaryCards(List<SaleModel> sales) {
    final totalSales = sales.fold(0.0,
        (previousValue, sale) => previousValue + sale.saleAmount.toDouble());
    var averageSales = totalSales / sales.length;

    if (averageSales.isNaN) {
      averageSales = 0.0;
    }

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
              onPressed: () => _selectDate(context),
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

  void _selectDate(BuildContext context) {
    DateTime tempDate = _selectedDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            height: 500, // Increase the height to accommodate the buttons
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SfDateRangePicker(
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  if (args.value is DateTime) {
                    tempDate = args.value as DateTime;
                  }
                },
                // selectionMode: DateRangePickerSelectionMode.range,
                selectionMode: DateRangePickerSelectionMode.single,
                view: _selectedFilterType == 'Day'
                    ? DateRangePickerView.month
                    : _selectedFilterType == 'Week'
                        ? DateRangePickerView.month
                        : _selectedFilterType == 'Month'
                            ? DateRangePickerView.month
                            : DateRangePickerView.year,
                showActionButtons:
                    true, // Enable the confirm and cancel buttons
                onSubmit: (Object? value) {
                  setState(() {
                    _selectedDate = tempDate;
                  });
                  Navigator.pop(context);
                },
                onCancel: () {
                  // Pop the dialog without updating _selectedDate
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  bool filterDataBasedOnSelection(DateTime bookingStartDate) {
    switch (_selectedFilterType) {
      case 'Day':
        return bookingStartDate.day == _selectedDate.day &&
            bookingStartDate.month == _selectedDate.month &&
            bookingStartDate.year == _selectedDate.year;
      case 'Week':
        DateTime startWeek =
            _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
        DateTime endWeek = startWeek.add(const Duration(days: 7));
        return bookingStartDate.isAfter(startWeek) &&
            bookingStartDate.isBefore(endWeek.add(const Duration(days: 1)));
      case 'Month':
        return bookingStartDate.month == _selectedDate.month &&
            bookingStartDate.year == _selectedDate.year;
      case 'Year':
        return bookingStartDate.year == _selectedDate.year;
      default:
        return true;
    }
  }
  // switch (_selectedFilterType) {
  //   case 'Day':
  //     return data.date.toDate().day == _selectedDate.day &&
  //         data.date.toDate().month == _selectedDate.month &&
  //         data.date.toDate().year == _selectedDate.year;
  //   case 'Week':
  //     DateTime startWeek =
  //         _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
  //     DateTime endWeek = startWeek.add(const Duration(days: 7));
  //     return data.date.toDate().isAfter(startWeek) &&
  //         data.date.toDate().isBefore(endWeek.add(const Duration(days: 1)));
  //   case 'Month':
  //     return data.date.toDate().month == _selectedDate.month &&
  //         data.date.toDate().year == _selectedDate.year;
  //   case 'Year':
  //     return data.date.toDate().year == _selectedDate.year;
  //   default:
  //     return true;
  // }
}

class SaleData {
  final String listingName;
  final num saleAmount;
  final String category;

  SaleData(this.listingName, this.saleAmount, this.category);
}
