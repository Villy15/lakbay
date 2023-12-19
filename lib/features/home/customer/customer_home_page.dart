import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/providers/app_bar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/home/customer/widgets/nestested_accomodation.dart';
import 'package:lakbay/models/user_model.dart';

class CustomerHomePage extends ConsumerWidget {
  const CustomerHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final scaffoldKey = ref.watch(scaffoldKeyProvider);

    if (user?.isCoopView == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/manager_dashboard');
      });
    }

    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        appBar: _appBar(scaffoldKey, user),
        body: const TabBarView(
          children: [
            // Accomodation
            NestedTabBarAccomodation(),

            // Food
            Center(
              child: Text('Food'),
            ),

            // Transport
            Center(
              child: Text('Transport'),
            ),

            // Tours
            Center(
              child: Text('Tours'),
            ),

            // Products
            Center(
              child: Text('Products'),
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
          icon: Icon(Icons.hotel_outlined),
          child: Flexible(child: Text('Accomodation')),
        ),
      ),
      const SizedBox(
        width: 100.0,
        child: Tab(
          icon: Icon(Icons.restaurant_outlined),
          child: Flexible(child: Text('Food')),
        ),
      ),
      const SizedBox(
        width: 100.0,
        child: Tab(
          icon: Icon(Icons.directions_bus_outlined),
          child: Flexible(child: Text('Transport')),
        ),
      ),
      const SizedBox(
        width: 100.0,
        child: Tab(
          icon: Icon(Icons.map_outlined),
          child: Flexible(child: Text('Tours')),
        ),
      ),
      const SizedBox(
        width: 100.0,
        child: Tab(
          icon: Icon(Icons.movie_creation_outlined),
          child: Flexible(child: Text('Entertainment')),
        ),
      ),
    ];

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 75),
      child: AppBar(
        title: const Text(
          'Lakbay',
          style: TextStyle(
            fontFamily: 'Satisfy',
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
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
          tabAlignment: TabAlignment.start,
          labelPadding: EdgeInsets.zero,
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: tabs,
        ),
      ),
    );
  }
}
