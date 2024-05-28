import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/survey/survey_controller.dart';
import 'package:lakbay/models/customer_survey_model.dart';

class CustomerSurveyPage extends ConsumerStatefulWidget {
  const CustomerSurveyPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerSurveyPageState();
}

class _CustomerSurveyPageState extends ConsumerState<CustomerSurveyPage> {
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

  // Define the headers
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

  List<String?> selectedOptions = List.filled(21, null);

  List<String> selectedEnvironmentalImpactActions = [];

  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  void onSubmit() {
    // Handle form submission
    final user = ref.read(userProvider);

    var survey = CustomerSurveyModel(
      userId: user!.uid,
      surveyType: 'Customer',
      dateCreated: DateTime.now(),
      age: selectedOptions[0]!,
      gender: selectedOptions[1]!,
      countryOfOrigin: selectedOptions[2]!,
      purposeOfVisit: selectedOptions[3]!,
      typeOfAccommodation: selectedOptions[4]!,
      modeOfTransportation: selectedOptions[5]!,
      frequencyOfVisit: selectedOptions[6]!,
      averageDailySpending: selectedOptions[7]!,
      purchasesOfLocalProductsAndServices: selectedOptions[8]!,
      engagementWithLocalBusinesses: selectedOptions[9]!,
      awarenessOfLocalEnvironmentalGuidelines: selectedOptions[10]!,
      participationInEcoFriendlyActivities: selectedOptions[11]!,
      observationsOnEnvironmentalPracticesOfVisitedPlaces: selectedOptions[12]!,
      actionsTakenToReduceEnvironmentalImpact:
          selectedEnvironmentalImpactActions,
      interactionWithLocalCommunities: selectedOptions[14]!,
      participationInLocalCulturalEventsAndActivities: selectedOptions[15]!,
      respectForLocalCustomsAndTraditions: selectedOptions[16]!,
      perceptionOfImpactOnLocalCommunity: selectedOptions[17]!,
      willingnessToPayMoreForSustainableOptions: selectedOptions[18]!,
      adjustmentsMadeToTravelPlansToSupportSustainability: selectedOptions[19]!,
      futureConsiderationsForSustainableTravel: selectedOptions[20]!,
    );

    debugPrint(survey.toString());
    ref.read(surveysControllerProvider.notifier).addSurvey(survey, context);
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
          title: const Text('Customer Survey'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    headers[currentStep],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Subheading

              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Padding(
              //     padding: const EdgeInsets.only(bottom: 16.0),
              //     child: Text(
              //       subheaders[currentStep],
              //       style: TextStyle(
              //         fontSize: 14,
              //         color: Theme.of(context)
              //             .colorScheme
              //             .onSurface
              //             .withOpacity(0.6),
              //       ),
              //     ),
              //   ),
              // ),

              ...buildOptions(
                options[currentStep],
                selectedOptions[currentStep],
                (value) {
                  setState(() {
                    selectedOptions[currentStep] = value;
                    if (currentStep < headers.length - 1) {
                      currentStep++;
                    } else {
                      // Handle form submission
                    }
                  });
                },
              ),

              // Add space
              const Spacer(),

              bottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget checkboxListTile(
      BuildContext context,
      String title,
      bool isFirst,
      bool isLast,
      String option,
      List<String> selectedOptions,
      ValueChanged<List<String>> onChanged) {
    return Column(
      children: [
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.trailing,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: isFirst
                  ? const Radius.circular(8.0)
                  : const Radius.circular(0),
              topRight: isFirst
                  ? const Radius.circular(8.0)
                  : const Radius.circular(0),
              bottomLeft: isLast
                  ? const Radius.circular(8.0)
                  : const Radius.circular(0),
              bottomRight: isLast
                  ? const Radius.circular(8.0)
                  : const Radius.circular(0),
            ),
          ),
          tileColor: Theme.of(context).colorScheme.primary.withOpacity(0.03),
          title: Text(title),
          value: selectedOptions.contains(option),
          onChanged: (bool? value) {
            if (value == true) {
              selectedOptions.add(option);
            } else {
              selectedOptions.remove(option);
            }
            onChanged(selectedOptions);
          },
        ),
        if (!isLast)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              height: 0,
              thickness: 0.5,
            ),
          ),
      ],
    );
  }

  Row bottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (currentStep > 0)
          ElevatedButton(
            onPressed: () {
              setState(() {
                currentStep--;
              });
            },
            child: const Text('Previous'),
          ),
        FilledButton(
          onPressed: () {
            setState(() {
              if (currentStep < headers.length - 1) {
                currentStep++;
              } else {
                onSubmit();
              }
            });
          },
          child: Text(currentStep < headers.length - 1 ? 'Continue' : 'Submit'),
        ),
      ],
    );
  }

  Widget radioListTile(
      BuildContext context,
      String title,
      bool isFirst,
      bool isLast,
      String option,
      String? selectedOption,
      ValueChanged<String?> onChanged) {
    return Column(
      children: [
        RadioListTile<String>(
          controlAffinity: ListTileControlAffinity.trailing,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: isFirst
                  ? const Radius.circular(8.0)
                  : const Radius.circular(0),
              topRight: isFirst
                  ? const Radius.circular(8.0)
                  : const Radius.circular(0),
              bottomLeft: isLast
                  ? const Radius.circular(8.0)
                  : const Radius.circular(0),
              bottomRight: isLast
                  ? const Radius.circular(8.0)
                  : const Radius.circular(0),
            ),
          ),
          tileColor: Theme.of(context).colorScheme.primary.withOpacity(0.03),
          title: Text(title),
          value: option,
          groupValue: selectedOption,
          onChanged: (String? value) {
            onChanged(value);
          },
        ),
        if (!isLast)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              height: 0,
              thickness: 0.5,
            ),
          ),
      ],
    );
  }

  List<Widget> buildOptions(List<String> options, String? selectedOption,
      ValueChanged<String?> onChanged) {
    return [
      for (var i = 0; i < options.length; i++)
        currentStep == 13
            ? checkboxListTile(
                context,
                options[i],
                i == 0,
                i == options.length - 1,
                options[i],
                selectedEnvironmentalImpactActions, (value) {
                setState(() {
                  selectedEnvironmentalImpactActions = value;
                });
              })
            : radioListTile(context, options[i], i == 0,
                i == options.length - 1, options[i], selectedOption, onChanged),
    ];
  }
}
