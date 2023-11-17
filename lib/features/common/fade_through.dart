import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<T> buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Use FadeThroughTransition from the animations package
      return FadeThroughTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      );
    },
  );
}
