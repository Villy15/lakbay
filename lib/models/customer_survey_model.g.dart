// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_survey_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerSurveyModelImpl _$$CustomerSurveyModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CustomerSurveyModelImpl(
      uid: json['uid'] as String?,
      userId: json['userId'] as String,
      surveyType: json['surveyType'] as String?,
      dateCreated: const TimestampSerializer()
          .fromJson(json['dateCreated'] as Timestamp?),
      age: json['age'] as String,
      gender: json['gender'] as String,
      countryOfOrigin: json['countryOfOrigin'] as String,
      purposeOfVisit: json['purposeOfVisit'] as String,
      typeOfAccommodation: json['typeOfAccommodation'] as String,
      modeOfTransportation: json['modeOfTransportation'] as String,
      frequencyOfVisit: json['frequencyOfVisit'] as String,
      averageDailySpending: json['averageDailySpending'] as String,
      purchasesOfLocalProductsAndServices:
          json['purchasesOfLocalProductsAndServices'] as String,
      engagementWithLocalBusinesses:
          json['engagementWithLocalBusinesses'] as String,
      awarenessOfLocalEnvironmentalGuidelines:
          json['awarenessOfLocalEnvironmentalGuidelines'] as String,
      participationInEcoFriendlyActivities:
          json['participationInEcoFriendlyActivities'] as String,
      observationsOnEnvironmentalPracticesOfVisitedPlaces:
          json['observationsOnEnvironmentalPracticesOfVisitedPlaces'] as String,
      actionsTakenToReduceEnvironmentalImpact:
          (json['actionsTakenToReduceEnvironmentalImpact'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      interactionWithLocalCommunities:
          json['interactionWithLocalCommunities'] as String,
      participationInLocalCulturalEventsAndActivities:
          json['participationInLocalCulturalEventsAndActivities'] as String,
      respectForLocalCustomsAndTraditions:
          json['respectForLocalCustomsAndTraditions'] as String,
      perceptionOfImpactOnLocalCommunity:
          json['perceptionOfImpactOnLocalCommunity'] as String,
      willingnessToPayMoreForSustainableOptions:
          json['willingnessToPayMoreForSustainableOptions'] as String,
      adjustmentsMadeToTravelPlansToSupportSustainability:
          json['adjustmentsMadeToTravelPlansToSupportSustainability'] as String,
      futureConsiderationsForSustainableTravel:
          json['futureConsiderationsForSustainableTravel'] as String,
    );

Map<String, dynamic> _$$CustomerSurveyModelImplToJson(
        _$CustomerSurveyModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'userId': instance.userId,
      'surveyType': instance.surveyType,
      'dateCreated': const TimestampSerializer().toJson(instance.dateCreated),
      'age': instance.age,
      'gender': instance.gender,
      'countryOfOrigin': instance.countryOfOrigin,
      'purposeOfVisit': instance.purposeOfVisit,
      'typeOfAccommodation': instance.typeOfAccommodation,
      'modeOfTransportation': instance.modeOfTransportation,
      'frequencyOfVisit': instance.frequencyOfVisit,
      'averageDailySpending': instance.averageDailySpending,
      'purchasesOfLocalProductsAndServices':
          instance.purchasesOfLocalProductsAndServices,
      'engagementWithLocalBusinesses': instance.engagementWithLocalBusinesses,
      'awarenessOfLocalEnvironmentalGuidelines':
          instance.awarenessOfLocalEnvironmentalGuidelines,
      'participationInEcoFriendlyActivities':
          instance.participationInEcoFriendlyActivities,
      'observationsOnEnvironmentalPracticesOfVisitedPlaces':
          instance.observationsOnEnvironmentalPracticesOfVisitedPlaces,
      'actionsTakenToReduceEnvironmentalImpact':
          instance.actionsTakenToReduceEnvironmentalImpact,
      'interactionWithLocalCommunities':
          instance.interactionWithLocalCommunities,
      'participationInLocalCulturalEventsAndActivities':
          instance.participationInLocalCulturalEventsAndActivities,
      'respectForLocalCustomsAndTraditions':
          instance.respectForLocalCustomsAndTraditions,
      'perceptionOfImpactOnLocalCommunity':
          instance.perceptionOfImpactOnLocalCommunity,
      'willingnessToPayMoreForSustainableOptions':
          instance.willingnessToPayMoreForSustainableOptions,
      'adjustmentsMadeToTravelPlansToSupportSustainability':
          instance.adjustmentsMadeToTravelPlansToSupportSustainability,
      'futureConsiderationsForSustainableTravel':
          instance.futureConsiderationsForSustainableTravel,
    };
