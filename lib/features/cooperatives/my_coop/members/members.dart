// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/app_bar_provider.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/user_model.dart';

class MembersPage extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  const MembersPage({super.key, required this.coop});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MembersPageState();
}

class _MembersPageState extends ConsumerState<MembersPage> {
  void readMember(UserModel user) {
    context.push('/my_coop/functions/members/${user.uid}');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final scaffoldKey = ref.watch(scaffoldKeyProvider);

    return ref.watch(getAllMembersProvider(widget.coop.uid!)).when(
          data: (members) {
            return DefaultTabController(
              initialIndex: 0,
              length: 4,
              child: Scaffold(
                appBar: _appBar(scaffoldKey, user),
                body: TabBarView(
                  children: [
                    // All Members

                    ListView.separated(
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        final member = members[index];

                        return ref.watch(getUserDataProvider(member.uid!)).when(
                              data: (user) {
                                return ListTile(
                                  onTap: () => {
                                    readMember(user),
                                  },
                                  title: Text(user.name),
                                  subtitle: Text(member.role?.role ?? 'Test'),
                                  leading: CircleAvatar(
                                    radius: 20.0,
                                    backgroundImage: user.profilePic != ''
                                        ? NetworkImage(user.profilePic)
                                        : null,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
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
                              error: (error, stackTrace) => const SizedBox(),
                              loading: () => const SizedBox(),
                            );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                    ),

                    // Regular Members
                    Container(
                      child: const Center(
                        child: Text('Regular Members'),
                      ),
                    ),
                    // Committees
                    const NestedTabBarCommittees(),
                    // Board
                    Container(
                      child: const Center(
                        child: Text('Board'),
                      ),
                    ),
                  ],
                ),
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

  PreferredSize _appBar(GlobalKey<ScaffoldState> scaffoldKey, UserModel? user) {
    List<Widget> tabs = [
      const SizedBox(
        width: 100.0,
        child: Tab(
          icon: Icon(Icons.person),
          child: Flexible(child: Text('All Members')),
        ),
      ),
      const SizedBox(
        width: 100.0,
        child: Tab(
          icon: Icon(Icons.people),
          child: Flexible(child: Text('Regular')),
        ),
      ),
      const SizedBox(
        width: 100.0,
        child: Tab(
          icon: Icon(Icons.groups_2),
          child: Flexible(child: Text('Committees')),
        ),
      ),
      const SizedBox(
        width: 100.0,
        child: Tab(
          icon: Icon(Icons.supervisor_account),
          child: Flexible(child: Text('Board')),
        ),
      ),
    ];

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 75),
      child: AppBar(
        title: const Text("Members"),
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
          tabAlignment: TabAlignment.start,
          // labelPadding: EdgeInsets.zero,
          isScrollable: true,
          // indicatorSize: TabBarIndicatorSize.label,
          tabs: tabs,
        ),
      ),
    );
  }
}

class NestedTabBarCommittees extends StatefulWidget {
  const NestedTabBarCommittees({super.key});

  @override
  State<NestedTabBarCommittees> createState() => _NestedTabBarCommitteesState();
}

class _NestedTabBarCommitteesState extends State<NestedTabBarCommittees>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> tabs = [
    const SizedBox(
      width: 150.0,
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.beach_access),
            SizedBox(width: 4.0),
            Text('Tourism'),
          ],
        ),
      ),
    ),
    const SizedBox(
      width: 150.0,
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event),
            SizedBox(width: 4.0),
            Text('Events'),
          ],
        ),
      ),
    ),
    const SizedBox(
      width: 150.0,
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.model_training),
            SizedBox(width: 4.0),
            Text('Training'),
          ],
        ),
      ),
    ),
    const SizedBox(
      width: 150.0,
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.how_to_vote),
            SizedBox(width: 4.0),
            Text('Election'),
          ],
        ),
      ),
    ),
    const SizedBox(
      width: 150.0,
      child: Tab(
        // icon: Icon(Icons.pool_outlned),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fact_check),
            SizedBox(width: 4.0),
            Text('Audit'),
          ],
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar.secondary(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          controller: _tabController,
          labelPadding: EdgeInsets.zero,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: tabs,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const <Widget>[
              Card(
                margin: EdgeInsets.all(16.0),
                child: Center(child: Text('Overview tab')),
              ),
              Card(
                margin: EdgeInsets.all(16.0),
                child: Center(child: Text('Specifications tab')),
              ),
              Card(
                margin: EdgeInsets.all(16.0),
                child: Center(child: Text('Specifications tab')),
              ),
              Card(
                margin: EdgeInsets.all(16.0),
                child: Center(child: Text('Specifications tab')),
              ),
              Card(
                margin: EdgeInsets.all(16.0),
                child: Center(child: Text('Specifications tab')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
