import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomNavBarProvider =
    StateNotifierProvider<BottomNavBarController, int>((ref) {
  return BottomNavBarController(0);
});

class BottomNavBarController extends StateNotifier<int> {
  BottomNavBarController(super.state);

  void setPosition(int value) {
    state = value;
  }
}

// final appBarVisibilityProvider = StateProvider<bool>((ref) => true);
final navBarVisibilityProvider =
    StateNotifierProvider<NavBarVisibilityNotifier, bool>(
        (ref) => NavBarVisibilityNotifier(true));

class NavBarVisibilityNotifier extends StateNotifier<bool> {
  NavBarVisibilityNotifier(super.state);

  void show() {
    state = true;
  }

  void hide() {
    state = false;
  }
}
