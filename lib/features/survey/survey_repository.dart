import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lakbay/core/constants/firebase_constants.dart';
import 'package:lakbay/core/failure.dart';
import 'package:lakbay/core/providers/firebase_providers.dart';
import 'package:lakbay/core/typdef.dart';
import 'package:lakbay/models/customer_survey_model.dart';

final surveyRepositoryProvider = Provider((ref) {
  return SurveyRepository(firestore: ref.watch(firestoreProvider));
});

class SurveyRepository {
  final FirebaseFirestore _firestore;
  SurveyRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  // Add an survey
  FutureEither<String> addSurvey(CustomerSurveyModel survey) async {
    try {
      // Generate a new document ID
      var doc = _customerSurveys.doc();

      // Update the uid of the survey
      survey = survey.copyWith(uid: doc.id);

      await doc.set(survey.toJson());

      // Return the uid of the newly added survey
      return right(survey.uid!);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Read all events
  Stream<List<CustomerSurveyModel>> readSurveys() {
    return _customerSurveys.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CustomerSurveyModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Read event by uid
  Stream<CustomerSurveyModel> readSurvey(String uid) {
    return _customerSurveys.doc(uid).snapshots().map((snapshot) {
      return CustomerSurveyModel.fromJson(
          snapshot.data() as Map<String, dynamic>);
    });
  }

  CollectionReference get _customerSurveys =>
      _firestore.collection(FirebaseConstants.customerSurveysCollection);
}
