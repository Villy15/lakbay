// custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/common/providers/app_bar_provider.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = ref.watch(scaffoldKeyProvider);
     
    return AppBar(
      title: Text(title),
      // Add icon on the right side of the app bar of a person
      actions: [
        IconButton(
          onPressed: () {
            scaffoldKey.currentState?.openEndDrawer();
          },
          icon: const Icon(Icons.person),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}