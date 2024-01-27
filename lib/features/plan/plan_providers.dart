import 'package:flutter_riverpod/flutter_riverpod.dart';

// Plan Location Provider
final planLocationProvider =
    StateNotifierProvider<PlanLocationProvider, String?>(
  (ref) => PlanLocationProvider(),
);

class PlanLocationProvider extends StateNotifier<String?> {
  PlanLocationProvider() : super(null);

  void setLocation(String location) {
    state = location;
  }
}

// Plan Start Date State Notifier Provider
final planStartDateProvider =
    StateNotifierProvider<PlanStartDateProvider, DateTime?>(
  (ref) => PlanStartDateProvider(),
);

class PlanStartDateProvider extends StateNotifier<DateTime?> {
  PlanStartDateProvider() : super(null);

  void setStartDate(DateTime startDate) {
    state = startDate;
  }
}

// Plan End Date State Notifier Provider
final planEndDateProvider =
    StateNotifierProvider<PlanEndDateProvider, DateTime?>(
  (ref) => PlanEndDateProvider(),
);

class PlanEndDateProvider extends StateNotifier<DateTime?> {
  PlanEndDateProvider() : super(null);

  void setEndDate(DateTime endDate) {
    state = endDate;
  }
}

// Selected Date State Notifier Provider
final selectedDateProvider =
    StateNotifierProvider<SelectedDateProvider, DateTime?>(
  (ref) => SelectedDateProvider(),
);

class SelectedDateProvider extends StateNotifier<DateTime?> {
  SelectedDateProvider() : super(null);

  void setSelectedDate(DateTime selectedDate) {
    state = selectedDate;
  }
}
