// custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/common/providers/app_bar_provider.dart';
import 'package:lakbay/models/user_model.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final UserModel? user;
  const CustomAppBar({super.key, required this.title, this.user});

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
          icon: CircleAvatar(
            radius: 20.0,
            backgroundImage: user?.profilePic != null && user?.profilePic != ''
                ? NetworkImage(user!.profilePic)
                : null,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
            child: user?.profilePic == null || user?.profilePic == ''
                ? Text(
                    user?.name[0].toUpperCase() ?? 'L',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
