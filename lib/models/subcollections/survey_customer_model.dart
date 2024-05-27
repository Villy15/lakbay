import 'package:freezed_annotation/freezed_annotation.dart';

part 'survey_customer_model.freezed.dart';
part 'survey_customer_model.g.dart';

@freezed
class CustomerSurvey with _$CustomerSurvey {
  factory CustomerSurvey({
    required String age,
    required String gender,
    required String countryOfOrigin,
    required String purposeOfVisit,
    required String typeOfAccommodation,
    required String modeOfTransportation,
    required String frequencyOfVisit,
    required String averageDailySpending,
    required String purchasesOfLocalProductsAndServices,
    required String engagementWithLocalBusinesses,
    required String awarenessOfLocalEnvironmentalGuidelines,
    required String participationInEcoFriendlyActivities,
    required String observationsOnEnvironmentalPracticesOfVisitedPlaces,
    required List<String> actionsTakenToReduceEnvironmentalImpact,
    required String interactionWithLocalCommunities,
    required String participationInLocalCulturalEventsAndActivities,
    required String respectForLocalCustomsAndTraditions,
    required String perceptionOfImpactOnLocalCommunity,
    required String willingnessToPayMoreForSustainableOptions,
    required String adjustmentsMadeToTravelPlansToSupportSustainability,
    required String futureConsiderationsForSustainableTravel,
  }) = _CustomerSurvey;

  factory CustomerSurvey.fromJson(Map<String, dynamic> json) =>
      _$CustomerSurveyFromJson(json);
}
