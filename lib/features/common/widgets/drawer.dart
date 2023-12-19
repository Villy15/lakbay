import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/theme/theme.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
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
    var user =
        widget.user?.copyWith(isCoopView: !(widget.user!.isCoopView ?? false));

    ref.read(usersControllerProvider.notifier).editUserIsCoopView(
          context,
          widget.user!.uid,
          user!,
        );
  }

  void viewCurrentCooperative(WidgetRef ref) {
    context.pop();
    context.go('/coops/id/${widget.user?.currentCoop}');
  }

  void viewMyProfileCustomer() {
    context.pop();
    context.push('/profile/id/${widget.user?.uid}');
  }

  void viewMyProfileCoop() {
    context.pop();
    context.push('/my_coop/functions/members/${widget.user?.uid}');
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
                  radius: 70.0,
                  backgroundImage: widget.user?.profilePic != null &&
                          widget.user?.profilePic != ''
                      ? NetworkImage(widget.user!.profilePic)
                      : null,
                  backgroundColor: Theme.of(context).colorScheme.onBackground,
                  child: widget.user?.profilePic == null ||
                          widget.user?.profilePic == ''
                      ? Text(
                          widget.user?.name[0].toUpperCase() ?? 'L',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                            fontSize: 40,
                          ),
                        )
                      : null,
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
                // Switch View Button show if the user is a member of a cooperative
                widget.user!.cooperativesJoined?.isNotEmpty ?? false
                    ? switchViewButton(
                        context,
                        widget.user!.isCoopView ?? false,
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 10),
                // Current cooperative dropdown
                widget.user!.isCoopView ?? false
                    ? ref
                        .watch(getCooperativeProvider(
                            widget.user?.currentCoop ?? ''))
                        .maybeWhen(
                            data: (data) => GestureDetector(
                                  onTap: () => {
                                    // Show modal bottom sheet
                                    modalBottomSheetCooperative(context)
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Icon of cooperative
                                      const Padding(
                                        padding: EdgeInsets.only(left: 16.0),
                                        child: Icon(Icons.group_outlined,
                                            size: 20),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, right: 7.0),
                                        child: Text(
                                          data.name,
                                          // Make it so that when the text is too long, it will be replaced with ellipsis
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      // Arrow down
                                      const Icon(Icons.arrow_drop_down),
                                    ],
                                  ),
                                ),
                            orElse: () => const SizedBox.shrink())
                    : const SizedBox.shrink(),
                // Display user's role
                widget.user!.isCoopView ?? false
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Row(
                                children: [
                                  Icon(Icons.person_outline, size: 20),
                                  // Text Role:
                                  SizedBox(width: 10),
                                  Text(
                                    'Role: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              widget.user!.role,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),

                const Padding(
                  padding: EdgeInsets.fromLTRB(28, 8, 28, 0),
                  child: Divider(),
                ),
                ListTile(
                  title: const Text('My Profile'),
                  leading: const Icon(Icons.person),
                  onTap: () => {
                    widget.user!.isCoopView ?? false
                        ? viewMyProfileCoop()
                        : viewMyProfileCustomer()
                  },
                ),

                widget.user!.isCoopView ?? false
                    ? const SizedBox.shrink()
                    : ListTile(
                        title: const Text('Bookings'),
                        leading: const Icon(Icons.book),
                        onTap: () => {},
                      ),

                // View Current Cooperative
                widget.user!.isCoopView ?? false
                    ? ListTile(
                        title: const Text('View Current Cooperative'),
                        leading: const Icon(Icons.group),
                        onTap: () => {viewCurrentCooperative(ref)},
                      )
                    : const SizedBox.shrink(),

                widget.user!.isManager
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
                ? const Text('Switch to Customer View',
                    style: TextStyle(fontSize: 14))
                : const Text('Switch to Coop View',
                    style: TextStyle(fontSize: 14))
          ],
        ),
      ),
    );
  }

  Future<dynamic> modalBottomSheetCooperative(BuildContext context) {
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
                  child: Text('Cooperatives Joined',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(28, 0, 28, 0),
                  child: Divider(),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.user?.cooperativesJoined?.length ?? 0,
                  itemBuilder: (context, index) {
                    // Store the uid of the cooperative
                    final uid =
                        widget.user?.cooperativesJoined?[index].cooperativeId ??
                            '';

                    return ref.watch(getCooperativeProvider(uid)).maybeWhen(
                          data: (data) => ListTile(
                            title: Text(data.name),
                            trailing: const SizedBox(
                              width: 60,
                              child: Row(
                                children: [
                                  Icon(Icons.check),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                            leading: CircleAvatar(
                              radius: 20.0,
                              backgroundImage: data.imageUrl != null &&
                                      data.imageUrl != ''
                                  ? NetworkImage(data.imageUrl!)
                                  // Use placeholder image if user has no profile pic
                                  : const AssetImage(
                                          'lib/core/images/default_profile_pic.jpg')
                                      as ImageProvider,
                              backgroundColor: Colors.transparent,
                            ),
                            onTap: () => {},
                          ),
                          orElse: () => const SizedBox.shrink(),
                        );
                  },
                ),
              ],
            ),
          );
        });
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
