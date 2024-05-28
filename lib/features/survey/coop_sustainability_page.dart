import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/survey/report.dart';
import 'package:lakbay/features/survey/survey_controller.dart';
import 'package:lakbay/models/customer_survey_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CoopSustainabilityPage extends ConsumerStatefulWidget {
  const CoopSustainabilityPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CoopSustainabilityPageState();
}

class _CoopSustainabilityPageState
    extends ConsumerState<CoopSustainabilityPage> {
  DateTime _selectedDate = DateTime.now();
  final List<String> _filterTypes = ['Day', 'Week', 'Month', 'Year'];
  String _selectedFilterType = 'Year';

  Uint8List? pdfData;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      ref.read(navBarVisibilityProvider.notifier).hide();
      pdfData = await generateReport();
      setState(() {});
    });
  }

  void viewGeneratedReport() {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Generated Report'),
          ),
          // Save the generated report to the device
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () async {},
                  child: const Text('Save PDF'),
                ),
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
          body: pdfData != null
              ? PDFView(
                  pdfData: pdfData,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );
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
          // floating action button to generate report as pdf file
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              viewGeneratedReport();
            },
            child: const Icon(Icons.picture_as_pdf),
          ),
          appBar: AppBar(
            title: const Text('Coop Sustainability Report'),
          ),
          body: ref.watch(getAllSurveysProvider).when(
                data: (surveys) {
                  if (surveys.isEmpty) {
                    return salesEmpty();
                  }

                  // Sort surveys by created_at
                  surveys.sort((a, b) {
                    final aCreatedAt = a.dateCreated;
                    final bCreatedAt = b.dateCreated;
                    if (aCreatedAt != null && bCreatedAt != null) {
                      return bCreatedAt.compareTo(aCreatedAt);
                    }
                    return 0;
                  });

                  // Filter data based on selected date
                  final filteredSurveys = surveys
                      .where((survey) =>
                          filterDataBasedOnSelection(survey.dateCreated!))
                      .toList();

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        dashboardFunctions(context),
                        if (filteredSurveys.isNotEmpty) ...[
                          summaryCard(filteredSurveys),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: headers.length,
                            itemBuilder: (context, index) {
                              return lineChart(
                                filteredSurveys,
                                index + 1,
                                headers,
                                options,
                              );
                            },
                          ),
                        ] else ...[
                          Padding(
                            // padding screen height - appbar height - padding
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.2),
                            child: salesEmpty(),
                          ),
                        ],
                        // Generate report button
                      ],
                    ),
                  );
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString(), stackTrace: ''),
                loading: () => const Loader(),
              )),
    );
  }

  Card summaryCard(List<CustomerSurveyModel> filteredSurveys) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Total People who took the survey:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              filteredSurveys.length.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  final List<List<String>> options = [
    [
      'Under 18',
      '18-24',
      '25-34',
      '35-44',
      '45-54',
      '55-64',
      '65+'
    ], // Age options
    ['Male', 'Female', 'Non-binary', 'Prefer not to say'], // Gender options
    ['Domestic', 'International'], // Country of Origin options
    ['Leisure', 'Business', 'Family', 'Other'], // Purpose of Visit options
    ['Hotel', 'Homestay', 'Eco-lodge', 'Other'], // Accommodation options
    ['Public transport', 'Private car'], // Transportation options
    [
      'First time',
      '2-5 times',
      'More than 5 times'
    ], // Frequency of Visit options
    // Less than in Pesos
    [
      'Less than 500 Pesos',
      '500-1000',
      '1000-2000',
      '2000-5000',
      '5000-10000',
      'More than 10000'
    ], // Average Daily Spending options
    ['Yes', 'No'], // Purchases of Local Products and Services options
    [
      'Frequently',
      'Occasionally',
      'Rarely',
      'Never'
    ], // Engagement with Local Businesses options
    ['Yes', 'No'], // Awareness of Local Environmental Guidelines options
    [
      'Frequently',
      'Occasionally',
      'Rarely',
      'Never'
    ], // Participation in Eco-friendly Activities options
    [
      'Excellent',
      'Good',
      'Average',
      'Poor',
      'Very Poor'
    ], // Observations on Environmental Practices of Visited Places options
    [
      'Reduced Plastic Use',
      'Energy Conservation',
      'Water Conservation',
      'Waste Management',
      'Sustainable Transportation',
      'Responsible Wildlife Interaction',
      'Other',
    ], // Actions Taken to Reduce Environmental Impact options
    [
      'Frequently',
      'Occasionally',
      'Rarely',
      'Never'
    ], // Interaction with Local Communities options
    [
      'Frequently',
      'Occasionally',
      'Rarely',
      'Never'
    ], // Participation in Local Cultural Events and Activities options
    [
      'Excellent',
      'Good',
      'Average',
      'Poor',
      'Very Poor'
    ], // Respect for Local Customs and Traditions options
    [
      'Very Positive',
      'Positive',
      'Neutral',
      'Negative',
      'Very Negative'
    ], // Perception of Impact on Local Community options
    ['Yes', 'No'], // Willingness to Pay More for Sustainable Options options
    [
      'Yes',
      'No'
    ], // Adjustments Made to Travel Plans to Support Sustainability options
    [
      'Very likely',
      'Likely',
      'Neutral',
      'Unlikely',
      'Very unlikely'
    ], // Future Considerations for Sustainable Travel options
  ];

  final List<String> headers = [
    'What is your age?',
    'Gender',
    'Country of Origin',
    'Purpose of Visit',
    'Type of Accomodation',
    'Mode of Transportation',
    'Frequency of Visit',
    'Average Daily Spending',
    'Purchases of Local Products and Services',
    'Engagement with Local Businesses',
    'Awareness of Local Environmental Guidelines',
    'Participation in Eco-friendly Activities',
    'Observations on Environmental Practices of Visited Places',
    'Actions Taken to Reduce Environmental Impact',
    'Interaction with Local Communities',
    'Participation in Local Cultural Events and Activities',
    'Respect for Local Customs and Traditions',
    'Perception of Impact on Local Community',
    'Willingness to Pay More for Sustainable Options',
    'Adjustments Made to Travel Plans to Support Sustainability',
    'Future Considerations for Sustainable Travel',
  ];

  Card lineChart(
    List<CustomerSurveyModel> surveys,
    int questionNumber,
    List<String> headers,
    List<List<String>> options,
  ) {
    final Map<int, String> fieldMap = {
      1: 'age',
      2: 'gender',
      3: 'countryOfOrigin',
      4: 'purposeOfVisit',
      5: 'typeOfAccommodation',
      6: 'modeOfTransportation',
      7: 'frequencyOfVisit',
      8: 'averageDailySpending',
      9: 'purchasesOfLocalProductsAndServices',
      10: 'engagementWithLocalBusinesses',
      11: 'awarenessOfLocalEnvironmentalGuidelines',
      12: 'participationInEcoFriendlyActivities',
      13: 'observationsOnEnvironmentalPracticesOfVisitedPlaces',
      14: 'actionsTakenToReduceEnvironmentalImpact',
      15: 'interactionWithLocalCommunities',
      16: 'participationInLocalCulturalEventsAndActivities',
      17: 'respectForLocalCustomsAndTraditions',
      18: 'perceptionOfImpactOnLocalCommunity',
      19: 'willingnessToPayMoreForSustainableOptions',
      20: 'adjustmentsMadeToTravelPlansToSupportSustainability',
      21: 'futureConsiderationsForSustainableTravel',
    };

    final String fieldName = fieldMap[questionNumber]!;
    final List<String> questionOptions = options[questionNumber - 1];

    // Initialize response counts for each option
    final Map<String, int> responseCounts = {
      for (var option in questionOptions) option: 0
    };

    // Aggregate responses
    for (var survey in surveys) {
      var response = _getFieldValue(survey, fieldName);

      if (response is List<String>) {
        for (var item in response) {
          if (responseCounts.containsKey(item)) {
            responseCounts[item] = responseCounts[item]! + 1;
          }
        }
      } else if (responseCounts.containsKey(response)) {
        responseCounts[response] = responseCounts[response]! + 1;
      }
    }

    // Create SurveyData objects
    final List<SurveyData> data = responseCounts.entries
        .map((entry) => SurveyData(entry.key, entry.value.toDouble()))
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SfCartesianChart(
          tooltipBehavior: TooltipBehavior(enable: true),
          title: ChartTitle(
              text: headers[questionNumber - 1],
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: (surveys.length).toDouble() * 1.1,
            interval: (surveys.length).toDouble() / 10,
          ),
          series: <CartesianSeries<SurveyData, String>>[
            ColumnSeries<SurveyData, String>(
              dataSource: data,
              xValueMapper: (SurveyData data, _) => data.x,
              yValueMapper: (SurveyData data, _) => data.y,
              name: 'Responses',
              color: const Color.fromRGBO(8, 142, 255, 1),
              dataLabelMapper: (SurveyData data, _) =>
                  '${data.y.toInt()} responses',
            )
          ],
        ),
      ),
    );
  }

  dynamic _getFieldValue(CustomerSurveyModel survey, String fieldName) {
    switch (fieldName) {
      case 'age':
        return survey.age;
      case 'gender':
        return survey.gender;
      case 'countryOfOrigin':
        return survey.countryOfOrigin;
      case 'purposeOfVisit':
        return survey.purposeOfVisit;
      case 'typeOfAccommodation':
        return survey.typeOfAccommodation;
      case 'modeOfTransportation':
        return survey.modeOfTransportation;
      case 'frequencyOfVisit':
        return survey.frequencyOfVisit;
      case 'averageDailySpending':
        return survey.averageDailySpending;
      case 'purchasesOfLocalProductsAndServices':
        return survey.purchasesOfLocalProductsAndServices;
      case 'engagementWithLocalBusinesses':
        return survey.engagementWithLocalBusinesses;
      case 'awarenessOfLocalEnvironmentalGuidelines':
        return survey.awarenessOfLocalEnvironmentalGuidelines;
      case 'participationInEcoFriendlyActivities':
        return survey.participationInEcoFriendlyActivities;
      case 'observationsOnEnvironmentalPracticesOfVisitedPlaces':
        return survey.observationsOnEnvironmentalPracticesOfVisitedPlaces;
      case 'actionsTakenToReduceEnvironmentalImpact':
        return survey.actionsTakenToReduceEnvironmentalImpact;
      case 'interactionWithLocalCommunities':
        return survey.interactionWithLocalCommunities;
      case 'participationInLocalCulturalEventsAndActivities':
        return survey.participationInLocalCulturalEventsAndActivities;
      case 'respectForLocalCustomsAndTraditions':
        return survey.respectForLocalCustomsAndTraditions;
      case 'perceptionOfImpactOnLocalCommunity':
        return survey.perceptionOfImpactOnLocalCommunity;
      case 'willingnessToPayMoreForSustainableOptions':
        return survey.willingnessToPayMoreForSustainableOptions;
      case 'adjustmentsMadeToTravelPlansToSupportSustainability':
        return survey.adjustmentsMadeToTravelPlansToSupportSustainability;
      case 'futureConsiderationsForSustainableTravel':
        return survey.futureConsiderationsForSustainableTravel;
      default:
        throw ArgumentError('Invalid field name');
    }
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
            'No surveys yet!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'No surveys have been taken yet',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const Text(
            'Please check back later',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
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
}

class SurveyData {
  SurveyData(this.x, this.y);

  final String x;
  final double y;
}
