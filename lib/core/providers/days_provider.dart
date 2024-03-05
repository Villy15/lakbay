// this is the provider for the days plan
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// q: is this provider for the days plan widget from the plan page?
// a: yes, this provider is for the days plan widget from the plan page

class DaysPlanProvider extends ChangeNotifier {
  int _days = 1;
  DateTime? _currentDay;
  int get days => _days;
  DateTime? get currentDay => _currentDay;

  void setDays(int days) {
    _days = days;
    notifyListeners();
  }

  void setCurrentDay(DateTime day) {
    _currentDay = day;
    // convert to YYYY/MM/DD 
    _currentDay = DateTime(day.year, day.month, day.day);
    notifyListeners();
  
  }
}

// Plan End Date State Notifier Provider
final daysPlanProvider = ChangeNotifierProvider<DaysPlanProvider>((ref) {
  return DaysPlanProvider();
});