// custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/common/providers/app_bar_provider.dart';
import 'package:lakbay/models/user_model.dart';

class CustomerHomeAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final String title;
  final UserModel? user;
  const CustomerHomeAppBar({super.key, required this.title, this.user});

  @override
  ConsumerState<CustomerHomeAppBar> createState() => _CustomerHomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 75);
}

class _CustomerHomeAppBarState extends ConsumerState<CustomerHomeAppBar>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final scaffoldKey = ref.watch(scaffoldKeyProvider);

    List<Widget> tabs = [
      const SizedBox(
        width: 100.0,
        child: Tab(
          icon: Icon(Icons.nature_rounded),
          child: Flexible(child: Text('Nature')),
        ),
      ),
      const SizedBox(
        width: 100.0,
        child: Tab(
          icon: Icon(Icons.museum),
          child: Flexible(child: Text('Cultural')),
        ),
      ),
      const SizedBox(
        width: 100.0,
        child: Tab(
          icon: Icon(Icons.beach_access),
          child: Flexible(child: Text('Beach')),
        ),
      ),
      const SizedBox(
        width: 100.0,
        child: Tab(
          icon: Icon(Icons.health_and_safety),
          child: Flexible(child: Text('Health')),
        ),
      ),
      const SizedBox(
        width: 100.0,
        child: Tab(
          icon: Icon(Icons.scuba_diving),
          child: Flexible(child: Text('Diving')),
        ),
      ),
    ];

    return DefaultTabController(
      length: tabs.length,
      initialIndex: 0,
      child: AppBar(
        title: Text(widget.title,
            style: const TextStyle(
              fontFamily: 'Satisfy',
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            )),
        // Add icon on the right side of the app bar of a person
        actions: [
          IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openEndDrawer();
            },
            icon: CircleAvatar(
              radius: 20.0,
              backgroundImage: widget.user?.profilePic != null &&
                      widget.user?.profilePic != ''
                  ? NetworkImage(widget.user!.profilePic)
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
