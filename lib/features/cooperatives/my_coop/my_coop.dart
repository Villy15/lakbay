import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/user_model.dart';

class MyCoopPage extends ConsumerStatefulWidget {
  final String coopId;
  const MyCoopPage({super.key, required this.coopId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyCoopPageState();
}

class _MyCoopPageState extends ConsumerState<MyCoopPage> {
  void viewMembers(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'coop_members',
      extra: coop,
    );
  }

  void viewEvents(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'coop_events',
      extra: coop,
    );
  }

  void managerTools(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'manager_tools',
      extra: coop,
    );
  }

  void leaveCoop(BuildContext context, CooperativeModel coop) {
    context.pop();
    context.pushNamed(
      'leave_coop',
      extra: coop,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return ref.watch(getCooperativeProvider(widget.coopId)).when(
          data: (CooperativeModel coop) {
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  sliverAppBar(coop),
                  sliverPaddingHeader(coop, user, context),
                ];
              },
              body: const Column(
                children: [
                  // View Members Button
                ],
              ),
            );
          },
          error: (error, stackTrace) => Scaffold(
            body: ErrorText(
              error: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          ),
          loading: () => const Scaffold(
            body: Loader(),
          ),
        );
  }

  SliverPadding sliverPaddingHeader(
      CooperativeModel coop, UserModel? user, BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    coop.imageUrl!,
                  ),
                  radius: 35,
                ),
                coop.managers.contains(user?.uid)
                    ? OutlinedButton(
                        onPressed: () {
                          managerTools(context, coop);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                        ),
                        child: const Text('Manager Tools'),
                      )
                    : OutlinedButton(
                        onPressed: () {
                          _showModalBottomSheet(context, coop);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                        ),
                        child: Text(coop.members.contains(user?.uid)
                            ? 'Joined'
                            : 'Join'),
                      ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              coop.name,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              coop.description ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            // Joined Date
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 14,
                ),
                const SizedBox(width: 5),
                Text(
                  'Joined April 2015 !! Constant',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  '${coop.members.length}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                const Text('Members'),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    viewMembers(context, coop);
                  },
                  child: const Text('View Members'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showModalBottomSheet(
      BuildContext context, CooperativeModel coop) {
    return showModalBottomSheet(
        isScrollControlled: true,
        showDragHandle: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  onTap: () => leaveCoop(context, coop),
                  leading: const Icon(Icons.warning),
                  title: const Text('Leave Cooperative'),
                  subtitle: const Text(
                      'Are you sure you want to leave this cooperative?'),
                ),
              ],
            ),
          );
        });
  }

  SliverAppBar sliverAppBar(CooperativeModel coop) {
    return SliverAppBar(
      expandedHeight: 150,
      collapsedHeight: kToolbarHeight,
      pinned: true,
      floating: true,
      snap: true,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Calculate the percentage of the expanded height
          double percent = ((constraints.maxHeight - kToolbarHeight) /
              (150 - kToolbarHeight));
          return FlexibleSpaceBar(
            titlePadding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
            title: percent < 0.36 // Show title when the appBar is 50% collapsed
                ? Row(
                    children: [
                      // CircleAvatar
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          coop.imageUrl!,
                        ),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            coop.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            '${coop.members.length} Members',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : null,
            background: DisplayImage(
              imageUrl: coop.imageUrl,
              height: 150,
              width: double.infinity,
              radius: BorderRadius.zero,
            ),
          );
        },
      ),
      actionsIconTheme: const IconThemeData(
        opacity: 0.5,
      ),
    );
  }
}
