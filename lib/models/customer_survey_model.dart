import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lakbay/core/util/utils.dart';

part 'customer_survey_model.freezed.dart';
part 'customer_survey_model.g.dart';

@freezed
class CustomerSurveyModel with _$CustomerSurveyModel {
  factory CustomerSurveyModel({
    String? uid,
    required String userId,
    String? surveyType,
    @TimestampSerializer() DateTime? dateCreated,
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
  }) = _CustomerSurveyModel;

  factory CustomerSurveyModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerSurveyModelFromJson(json);
}
