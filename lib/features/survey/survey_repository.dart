import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lakbay/core/constants/firebase_constants.dart';
import 'package:lakbay/core/failure.dart';
import 'package:lakbay/core/providers/firebase_providers.dart';
import 'package:lakbay/core/typdef.dart';
import 'package:lakbay/models/subcollections/survey_customer_model.dart';
import 'package:lakbay/models/survey_model.dart';

final surveyRepositoryProvider = Provider((ref) {
  return SurveyRepository(firestore: ref.watch(firestoreProvider));
});

class SurveyRepository {
  final FirebaseFirestore _firestore;
  SurveyRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  // Add an survey
  FutureEither<String> addSurvey(SurveyModel survey) async {
    try {
      // Generate a new document ID
      var doc = _surveys.doc();

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

  FutureEither<String> addCustomerSurvey(
      String coopId, CustomerSurvey survey) async {
    try {
      // Generate a new document ID
      var doc = customerSurvey(coopId).doc();

      await doc.set(survey.toJson());

      return right("Success");
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Read all events
  Stream<List<SurveyModel>> readSurveys() {
    return _surveys.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return SurveyModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Read event by uid
  Stream<SurveyModel> readSurvey(String uid) {
    return _surveys.doc(uid).snapshots().map((snapshot) {
      return SurveyModel.fromJson(snapshot.data() as Map<String, dynamic>);
    });
  }

  CollectionReference get _surveys =>
      _firestore.collection(FirebaseConstants.surveyCollection);

  CollectionReference customerSurvey(String surveyId) {
    return _surveys
        .doc(surveyId)
        .collection(FirebaseConstants.customerSurveyCollection);
  }
}
