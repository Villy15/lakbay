// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/providers/app_bar_provider.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/user_model.dart';

class MembersPage extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  const MembersPage({super.key, required this.coop});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MembersPageState();
}

class _MembersPageState extends ConsumerState<MembersPage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final scaffoldKey = ref.watch(scaffoldKeyProvider);

    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: _appBar(scaffoldKey, user),
        body: TabBarView(
          children: [
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
  }

  PreferredSize _appBar(GlobalKey<ScaffoldState> scaffoldKey, UserModel? user) {
    List<Widget> tabs = [
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
              backgroundImage: user?.profilePic != null &&
                      user?.profilePic != ''
                  ? NetworkImage(user!.profilePic)
                  // Use placeholder image if user has no profile pic
                  : const AssetImage('lib/core/images/default_profile_pic.jpg')
                      as ImageProvider,
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
        bottom: TabBar(
          // tabAlignment: TabAlignment.start,
          // labelPadding: EdgeInsets.zero,
          // isScrollable: true,
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
      width: 100.0,
      child: Tab(
        icon: Icon(Icons.beach_access),
        child: Flexible(child: Text('Tourism')),
      ),
    ),
    const SizedBox(
      width: 100.0,
      child: Tab(
        icon: Icon(Icons.event),
        child: Flexible(child: Text('Events')),
      ),
    ),
    const SizedBox(
      width: 100.0,
      child: Tab(
        icon: Icon(Icons.model_training),
        child: Flexible(child: Text('Training')),
      ),
    ),
    const SizedBox(
      width: 100.0,
      child: Tab(
        icon: Icon(Icons.how_to_vote),
        child: Flexible(child: Text('Election')),
      ),
    ),
    const SizedBox(
      width: 100.0,
      child: Tab(
        icon: Icon(Icons.fact_check),
        child: Flexible(child: Text('Audit')),
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
