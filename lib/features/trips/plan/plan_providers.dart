import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/models/plan_model.dart';

// TEST Without DBASE
// List of Plan Model State Notifier Provider
final currentTripProvider =
    StateNotifierProvider<CurrentTripProvider, PlanModel?>(
  (ref) => CurrentTripProvider(),
);

class CurrentTripProvider extends StateNotifier<PlanModel?> {
  CurrentTripProvider() : super(null);

  void setPlan(PlanModel plan) {
    state = plan;
  }
}

final planModelProvider =
    StateNotifierProvider<PlanModelProvider, List<PlanModel>>(
  (ref) => PlanModelProvider(),
);

class PlanModelProvider extends StateNotifier<List<PlanModel>> {
  PlanModelProvider() : super([]);

  void addPlan(PlanModel plan, BuildContext context) {
    state = [...state, plan];
    context.pop();
  }

  void removePlan(PlanModel plan) {
    state = state.where((element) => element != plan).toList();
  }
}

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

  // set the location to empty
  void clearLocation() {
    state = '';
  }
  
  void reset () {
    state = null;
  }
}

final listingLocationProvider =
    StateNotifierProvider<ListingLocationProvider, String?>(
        (ref) => ListingLocationProvider());

class ListingLocationProvider extends StateNotifier<String?> {
  ListingLocationProvider() : super(null);

  void setLocation(String location) {
    state = location;
  }

  // set the location to empty
  void clearLocation() {
    state = null;
  }

  void reset() {
    state = null;
  }
}

// set current location
final currentLocationProvider =
    StateNotifierProvider<CurrentLocationProvider, String?>(
        (ref) => CurrentLocationProvider());

class CurrentLocationProvider extends StateNotifier<String?> {
  CurrentLocationProvider() : super(null);

  void setLocation(String location) {
    state = location;
  }
}

final destinationLocationProvider =
    StateNotifierProvider<DestinationLocationProvider, String?>(
        (ref) => DestinationLocationProvider());

class DestinationLocationProvider extends StateNotifier<String?> {
  DestinationLocationProvider() : super(null);

  void setLocation(String location) {
    state = location;
  }

  // set the location to empty
  void clearLocation() {
    state = '';
  }
  
  void reset() {
    state = null;
  }
}

final pickupPointLocationProvider =
    StateNotifierProvider<PickupPointLocationProvider, String?>(
        (ref) => PickupPointLocationProvider());

class PickupPointLocationProvider extends StateNotifier<String?> {
  PickupPointLocationProvider() : super(null);

  void setLocation(String location) {
    state = location;
  }

  // set the location to empty
  void clearLocation() {
    state = '';
  }
  void reset() {
    state = null;
  
  }
}

// Plan Search Location State Notifier Provider
final planSearchLocationProvider =
    StateNotifierProvider<PlanSearchLocationProvider, String?>(
  (ref) => PlanSearchLocationProvider(),
);

class PlanSearchLocationProvider extends StateNotifier<String?> {
  PlanSearchLocationProvider() : super(null);

  void setLocation(String location) {
    state = location;
  }

  void reset() {
    state = null;
  }

  void clearLocation() {
    state = '';
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

  void reset() {
    state = null;
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

  void reset() {
    state = null ;
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

// Current id of plan to be edited
final currentPlanIdProvider =
    StateNotifierProvider<CurrentPlanIdProvider, String?>(
  (ref) => CurrentPlanIdProvider(),
);

class CurrentPlanIdProvider extends StateNotifier<String?> {
  CurrentPlanIdProvider() : super(null);

  void setCurrentPlanId(String id) {
    state = id;
  }
}

// Current number of guests of plan
final currentPlanGuestsProvider =
    StateNotifierProvider<CurrentPlanGuests, num?>(
  (ref) => CurrentPlanGuests(),
);

class CurrentPlanGuests extends StateNotifier<num?> {
  CurrentPlanGuests() : super(null);

  void setCurrentGuests(num guests) {
    state = guests;
  }
}

// Create a StateNotifierProvider for the ParentState
final parentStateProvider = StateNotifierProvider<ParentState, bool>(
  (ref) => ParentState(),
);

class ParentState extends StateNotifier<bool> {
  ParentState() : super(false);

  void setState(bool parentState) {
    state = parentState;
  }
}
