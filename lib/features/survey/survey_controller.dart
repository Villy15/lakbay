import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/survey/survey_repository.dart';
import 'package:lakbay/models/customer_survey_model.dart';

final getSurveyProvider =
    StreamProvider.autoDispose.family<CustomerSurveyModel, String>((ref, uid) {
  final surveyController = ref.watch(surveysControllerProvider.notifier);
  return surveyController.getSurvey(uid);
});

final getAllSurveysProvider = StreamProvider<List<CustomerSurveyModel>>((ref) {
  final surveyController = ref.watch(surveysControllerProvider.notifier);
  return surveyController.getAllSurveys();
});

final surveysControllerProvider =
    StateNotifierProvider<SurveyController, bool>((ref) {
  final surveysRepository = ref.watch(surveyRepositoryProvider);
  return SurveyController(
    surveysRepository: surveysRepository,
    ref: ref,
  );
});

class SurveyController extends StateNotifier<bool> {
  final SurveyRepository _surveysRepository;
  final Ref _ref;

  SurveyController({
    required SurveyRepository surveysRepository,
    required Ref ref,
  })  : _surveysRepository = surveysRepository,
        _ref = ref,
        super(false);

  Stream<List<CustomerSurveyModel>> getAllSurveys() {
    return _surveysRepository.readSurveys();
  }

  void addSurvey(CustomerSurveyModel survey, BuildContext context) async {
    final result = await _surveysRepository.addSurvey(survey);

    result.fold(
      (failure) {
        state = false;
        showSnackBar(context, failure.message);
      },
      (surveyUid) {
        state = false;
        _ref.read(navBarVisibilityProvider.notifier).show();
        context.pop();
        showSnackBar(context, 'Survey added successfully');
      },
    );
  }

  Stream<CustomerSurveyModel> getSurvey(String uid) {
    return _surveysRepository.readSurvey(uid);
  }
}
