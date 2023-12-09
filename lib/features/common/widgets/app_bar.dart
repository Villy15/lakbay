// custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/common/providers/app_bar_provider.dart';
import 'package:lakbay/models/user_model.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final UserModel? user;
  const CustomAppBar({Key? key, required this.title, this.user})
      : super(key: key);

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
                // Use placeholder image if user has no profile pic
                : const AssetImage('lib/core/images/default_profile_pic.jpg')
                    as ImageProvider,
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
