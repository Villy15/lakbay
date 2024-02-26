// Event Start Date State Notifier Provider
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventStartDateProvider =
    StateNotifierProvider<EventStartDateNotifier, DateTime?>(
  (ref) => EventStartDateNotifier(),
);

class EventStartDateNotifier extends StateNotifier<DateTime?> {
  EventStartDateNotifier() : super(null);

  void setStartDate(DateTime startDate) {
    state = startDate;
  }

  void clearStartDate() {
    state = null;
  }
}

// Event End Date State Notifier Provider
final eventEndDateProvider =
    StateNotifierProvider<EventEndDateNotifier, DateTime?>(
  (ref) => EventEndDateNotifier(),
);

class EventEndDateNotifier extends StateNotifier<DateTime?> {
  EventEndDateNotifier() : super(null);

  void setEndDate(DateTime endDate) {
    state = endDate;
  }

  void clearEndDate() {
    state = null;
  }
}
