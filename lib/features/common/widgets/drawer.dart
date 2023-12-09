import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/theme/theme.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/user/user_controller.dart';
import 'package:lakbay/models/user_model.dart';

class CustomDrawer extends ConsumerStatefulWidget {
  final UserModel? user;
  const CustomDrawer({super.key, this.user});

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends ConsumerState<CustomDrawer> {
  void logout() async {
    ref.read(authControllerProvider.notifier).logout();
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  void registerCooperative(WidgetRef ref) {
    context.pop();
    context.go('/coops/register');
  }

  void switchView(WidgetRef ref) {
    ref.read(usersControllerProvider.notifier).editUserIsCoopView(
        context, widget.user!.uid, !(widget.user!.isCoopView ?? false));
    context.pop();

    if (widget.user!.isManager ?? false) {
      context.go('/manager_dashboard');
    } else {
      context.go('/customer_home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.user!.profilePic),
                  radius: 70,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => {
                    // Show modal bottom sheet
                    modalBottomSheet(context)
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          widget.user!.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Arrow down
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Manage cooperative button
                widget.user!.isManager ?? false
                    ? switchViewButton(
                        context, widget.user!.isCoopView ?? false)
                    : const SizedBox.shrink(),
                const Padding(
                  padding: EdgeInsets.fromLTRB(28, 16, 28, 0),
                  child: Divider(),
                ),
                ListTile(
                  title: const Text('My Profile'),
                  leading: const Icon(Icons.person),
                  onTap: () => {},
                ),
                ListTile(
                  title: const Text('Bookings'),
                  leading: const Icon(Icons.book),
                  onTap: () => {},
                ),
                widget.user!.isManager ?? false
                    ? const SizedBox.shrink()
                    : ListTile(
                        title: const Text('Register a Cooperative'),
                        leading: const Icon(Icons.group_add),
                        onTap: () => registerCooperative(ref),
                      ),
                const SizedBox(height: 10),
              ],
            ),
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(28, 0, 28, 0),
                  child: Divider(),
                ),
                // Add logout button
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                  child: ListTile(
                    title: const Text('Settings'),
                    leading: const Icon(Icons.settings),
                    trailing: IconButton(
                        onPressed: () => toggleTheme(ref),
                        icon: Icon(
                            Theme.of(context).brightness == Brightness.light
                                ? Icons.dark_mode_outlined
                                : Icons.dark_mode_rounded)),
                    onTap: () => logout(),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Padding switchViewButton(BuildContext context, bool isCoopView) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: FilledButton(
        // Fill size width
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(
              Size(MediaQuery.of(context).size.width * 0.8, 40)),
        ),
        onPressed: () => switchView(ref),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isCoopView
                ? const Icon(Icons.shopping_bag, size: 20)
                : const Icon(Icons.manage_accounts, size: 20),
            const SizedBox(width: 10),
            isCoopView
                ? const Text('Switch to Customer',
                    style: TextStyle(fontSize: 14))
                : const Text('Switch to Coop View',
                    style: TextStyle(fontSize: 14))
          ],
        ),
      ),
    );
  }

  Future<dynamic> modalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        showDragHandle: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text saying acounts
                const Padding(
                  padding: EdgeInsets.fromLTRB(28, 0, 28, 0),
                  child: Text('Accounts',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(28, 0, 28, 0),
                  child: Divider(),
                ),
                ListTile(
                  title: const Text('Adrian Villanueva'),
                  trailing: SizedBox(
                    width: 60,
                    child: Row(
                      children: [
                        const Icon(Icons.check),
                        const SizedBox(width: 10),
                        GestureDetector(
                            onTap: logout, child: const Icon(Icons.logout)),
                      ],
                    ),
                  ),
                  leading: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: widget.user?.profilePic != null &&
                            widget.user?.profilePic != ''
                        ? NetworkImage(widget.user!.profilePic)
                        // Use placeholder image if user has no profile pic
                        : const AssetImage(
                                'lib/core/images/default_profile_pic.jpg')
                            as ImageProvider,
                    backgroundColor: Colors.transparent,
                  ),
                  onTap: () => {},
                ),
              ],
            ),
          );
        });
  }
}
