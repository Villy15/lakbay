import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<T> buildPageWithSharedAxisTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  required SharedAxisTransitionType transitionType, // Add this parameter to define the axis
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Use SharedAxisTransition from the animations package
      return SharedAxisTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        transitionType: transitionType, // Use the provided transition type
        child: child,
      );
    },
  );
}