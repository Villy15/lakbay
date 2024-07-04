import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/theme/theme.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
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

  void viewHome(WidgetRef ref) {
    context.pop();
    ref.read(navBarVisibilityProvider.notifier).show();
    context.go('/customer_home');
  }

  void viewBookings(WidgetRef ref) {
    context.pop();
    context.go('/bookings');
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

  void viewAnswerCustomerSurvey() {
    context.pop();
    context.push('/surveys/customer');
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getUserDataProvider(widget.user!.uid)).when(
          data: (data) {
            return _buildDrawer(context, data);
          },
          loading: () => const Loader(),
          error: (error, stackTrace) {
            return Center(
                child: ErrorText(
                    error: error.toString(),
                    stackTrace: stackTrace.toString()));
          },
        );
  }

  Drawer _buildDrawer(BuildContext context, UserModel user) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  _profile(context, user),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(28, 8, 28, 0),
                    child: Divider(),
                  ),

                  //Go to customer home

                  _functions(context),
                ],
              ),
              _logout(context)
            ],
          ),
        ),
      ),
    );
  }

  Column _logout(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 0, 28, 0),
          child: Divider(),
        ),
        // Add logout button
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
          child: ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            trailing: IconButton(
                onPressed: () => toggleTheme(ref),
                icon: Icon(Theme.of(context).brightness == Brightness.light
                    ? Icons.dark_mode_outlined
                    : Icons.dark_mode_rounded)),
            onTap: () => logout(),
          ),
        ),
      ],
    );
  }

  Widget _functions(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.38,
      child: Scrollbar(
        trackVisibility: true,
        // thumbVisibility: true,
        radius: const Radius.circular(10),
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: const Text('My Profile'),
              leading: const Icon(Icons.person),
              onTap: () => {
                widget.user!.isCoopView ?? false
                    ? viewMyProfileCoop()
                    : viewMyProfileCustomer()
              },
            ),

            // View Current Cooperative
            widget.user!.isCoopView ?? false
                ? const SizedBox.shrink()
                : ListTile(
                    title: const Text('View Current Cooperative'),
                    leading: const Icon(Icons.group),
                    onTap: () => {viewCurrentCooperative(ref)},
                  ),

            widget.user!.isCoopView ?? false
                ? const SizedBox.shrink()
                : ListTile(
                    title: const Text('Register a Cooperative'),
                    leading: const Icon(Icons.group_add),
                    onTap: () => registerCooperative(ref),
                  ),
            // Add Cooperative Dashboard
            widget.user!.isCoopView ?? false
                ? ListTile(
                    title: const Text('Cooperative Dashboard'),
                    leading: const Icon(Icons.dashboard),
                    onTap: () => {
                      context.pop(),
                      context.push(
                          '/my_coop/dashboard/${widget.user?.currentCoop}'),
                    },
                  )
                : ListTile(
                    title: const Text('Customer Survey'),
                    leading: const Icon(Icons.question_answer),
                    onTap: () => {
                      viewAnswerCustomerSurvey(),
                    },
                  ),

            // Wiki Page

            widget.user!.isCoopView ?? false
                ? ListTile(
                    title: const Text('Wiki'),
                    leading: const Icon(Icons.book_outlined),
                    onTap: () => {
                      context.pop(),
                      context.push('/wiki'),
                    },
                  )
                : const SizedBox.shrink(),

            widget.user!.isCoopView ?? false
                ? ListTile(
                    title: const Text('Announcements'),
                    leading: const Icon(Icons.announcement_outlined),
                    onTap: () => {
                      context.pop(),
                      context.push('/announcements'),
                    },
                  )
                : const SizedBox.shrink(),

            widget.user!.isCoopView ?? false
                ? ListTile(
                    title: const Text('Coop Goals'),
                    leading: const Icon(Icons.emoji_events_outlined),
                    onTap: () => {
                      context.pop(),
                      context.push('/goals'),
                    },
                  )
                : const SizedBox.shrink(),

            // votes
            widget.user!.isCoopView ?? false
                ? ListTile(
                    title: const Text('Votes'),
                    leading: const Icon(Icons.how_to_vote_outlined),
                    onTap: () => {
                      context.pop(),
                      context.push('/votes'),
                    },
                  )
                : const SizedBox.shrink(),

            // Sustainability
            widget.user!.isCoopView ?? false
                ? ListTile(
                    title: const Text('Sustainability Report'),
                    leading: const Icon(Icons.eco_outlined),
                    onTap: () => {
                      context.pop(),
                      context.push('/surveys/coop'),
                    },
                  )
                : const SizedBox.shrink(),

            // Assets
            // widget.user!.isCoopView ?? false
            //     ? ListTile(
            //         title: const Text('Assets'),
            //         leading: const Icon(Icons.car_rental_outlined),
            //         onTap: () => {
            //           context.pop(),
            //           context.push('/assets'),
            //         },
            //       )
            //     : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Column _profile(BuildContext context, UserModel user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 70.0,
          backgroundImage:
              widget.user?.profilePic != null && widget.user?.profilePic != ''
                  ? NetworkImage(widget.user!.profilePic)
                  : null,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          child:
              widget.user?.profilePic == null || widget.user?.profilePic == ''
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
            // modalBottomSheet(context, user)
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
              // const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Switch View Button show if the user is a member of a cooperative
        user.cooperativesJoined?.isNotEmpty ?? false
            ? switchViewButton(
                context,
                widget.user!.isCoopView ?? false,
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 10),
        // Current cooperative dropdown
        user.isCoopView ?? false
            ? ref
                .watch(getCooperativeProvider(user.currentCoop ?? ''))
                .maybeWhen(
                    data: (data) => ListTile(
                          onTap: () =>
                              {modalBottomSheetCooperative(context, user)},
                          title: Text(data.name),
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
                          trailing: const Icon(Icons.arrow_drop_down),
                          subtitle: user.role.isNotEmpty
                              ? Text(
                                  user.role,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                )
                              : null,
                        ),
                    orElse: () => const SizedBox.shrink())
            : const SizedBox.shrink(),
        // Display user's role
      ],
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

  Future<dynamic> modalBottomSheetCooperative(
      BuildContext context, UserModel user) {
    return showModalBottomSheet(
        isScrollControlled: true,
        showDragHandle: true,
        context: context,
        builder: (BuildContext context) {
          return Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text saying acounts
                  const Padding(
                    padding: EdgeInsets.fromLTRB(28, 0, 28, 0),
                    child: Text('Cooperatives Joined',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(28, 0, 28, 0),
                    child: Divider(),
                  ),

                  ref
                      .watch(getCooperativesByMemberProvider(user.uid))
                      .maybeWhen(
                          data: (data) {
                            debugPrint('data: $data');
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                // Store the uid of the cooperative
                                final coop = data[index];
                                return ListTile(
                                  title: Text(coop.name),
                                  trailing: SizedBox(
                                    width: 60,
                                    child: Row(
                                      children: [
                                        // If user is in current coop, show check icon
                                        if (coop.uid == user.currentCoop)
                                          const Icon(Icons.check),
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    radius: 20.0,
                                    backgroundImage: coop.imageUrl != null &&
                                            coop.imageUrl != ''
                                        ? NetworkImage(coop.imageUrl!)
                                        // Use placeholder image if user has no profile pic
                                        : const AssetImage(
                                            'lib/core/images/default_profile_pic.jpg',
                                          ) as ImageProvider,
                                    backgroundColor: Colors.transparent,
                                  ),
                                  onTap: () => {
                                    // Edit user's currentCoop
                                    ref
                                        .read(usersControllerProvider.notifier)
                                        .editUserAfterJoinCoop(
                                          user.uid,
                                          user.copyWith(currentCoop: coop.uid),
                                        ),

                                    // Close modal
                                    context.pop(),
                                    context.pop(),
                                  },
                                );
                              },
                            );
                          },
                          orElse: () => const SizedBox.shrink()),
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   itemCount: user.cooperativesJoined?.length ?? 0,
                  //   itemBuilder: (context, index) {
                  //     debugPrint(
                  //         'item count: ${user.cooperativesJoined?.length}');
                  //     // Store the uid of the cooperative
                  //     final uid =
                  //         user.cooperativesJoined?[index].cooperativeId ?? '';

                  //     debugPrint('uid: $uid');

                  //     return ref.watch(getCooperativeProvider(uid)).maybeWhen(
                  //           data: (data) {
                  //             debugPrint('dataa: $data');
                  //             debugPrint('dataa: $data');
                  //             return ListTile(
                  //               title: Text(data.name),
                  //               trailing: const SizedBox(
                  //                 width: 60,
                  //                 child: Row(
                  //                   children: [
                  //                     Icon(Icons.check),
                  //                     SizedBox(width: 10),
                  //                   ],
                  //                 ),
                  //               ),
                  //               leading: CircleAvatar(
                  //                 radius: 20.0,
                  //                 backgroundImage: data.imageUrl != null &&
                  //                         data.imageUrl != ''
                  //                     ? NetworkImage(data.imageUrl!)
                  //                     // Use placeholder image if user has no profile pic
                  //                     : const AssetImage(
                  //                         'lib/core/images/default_profile_pic.jpg',
                  //                       ) as ImageProvider,
                  //                 backgroundColor: Colors.transparent,
                  //               ),
                  //               onTap: () => {},
                  //             );
                  //           },
                  //           orElse: () => const Text('No '),
                  //         );
                  //   },
                  // ),
                ],
              ),
            );
          });
        });
  }

  Future<dynamic> modalBottomSheet(BuildContext context, UserModel user) {
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
