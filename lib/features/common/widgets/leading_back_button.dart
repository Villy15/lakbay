import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';

class LeadingBackButton extends StatelessWidget {
  const LeadingBackButton({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 20),
      height: 10,
      width: 10,
      child: IconButton(
        icon: Icon(
          Icons.arrow_back,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () {
          ref.read(navBarVisibilityProvider.notifier).show();
          context.pop(); // to go back
        },
      ),
    );
  }
}
