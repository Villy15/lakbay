import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/app_bar_provider.dart';
import 'package:lakbay/features/user/user_controller.dart';
// import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/models/user_model.dart';

void readInbox(BuildContext context, String senderId) {
  context.push('/inbox/id/$senderId');
}

class InboxPage extends ConsumerWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = ref.watch(scaffoldKeyProvider);
    final user = ref.watch(userProvider);
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: _appBar(scaffoldKey, user, context),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
              // Accomodation
              ref.watch(getAllUsersExceptCurrentUserProvider(user!.uid)).when(
                    data: (data) {
                      return ListView.separated(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final user = data[index];

                          return ListTile(
                            onTap: () => {
                              readInbox(context, user.uid),
                            },
                            title: Text(user.name),
                            subtitle: const Text('Hello po'),
                            leading: CircleAvatar(
                              radius: 20.0,
                              backgroundImage: user.profilePic != ''
                                  ? NetworkImage(user.profilePic)
                                  : null,
                              backgroundColor:
                                  Theme.of(context).colorScheme.onBackground,
                              child: user.profilePic == ''
                                  ? Text(
                                      user.name[0].toUpperCase(),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                    )
                                  : null,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                      );
                    },
                    error: (error, stackTrace) => Scaffold(
                      body: ErrorText(error: error.toString()),
                    ),
                    loading: () => const Scaffold(
                      body: Loader(),
                    ),
                  ),

              // Food
              const Center(
                child: Text('Groups'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSize _appBar(GlobalKey<ScaffoldState> scaffoldKey, UserModel? user,
      BuildContext context) {
    List<Widget> tabs = [
      const SizedBox(
        width: 100.0,
        child: Tab(
          icon: Icon(Icons.person),
          child: Flexible(child: Text('Individual')),
        ),
      ),
      const SizedBox(
        width: 100.0,
        child: Tab(
          icon: Icon(Icons.people),
          child: Flexible(child: Text('Groups')),
        ),
      ),
    ];

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 75),
      child: AppBar(
        title: const Text(
          'Inbox',
        ),
        // Add icon on the right side of the app bar of a person
        actions: [
          IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openEndDrawer();
            },
            icon: CircleAvatar(
              radius: 20.0,
              backgroundImage:
                  user?.profilePic != null && user?.profilePic != ''
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
        bottom: TabBar(
          tabs: tabs,
        ),
      ),
    );
  }
}
