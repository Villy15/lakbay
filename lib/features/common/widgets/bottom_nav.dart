import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/models/user_model.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  final UserModel? user;
  const BottomNavBar({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final currentPageIndex = ref.watch(bottomNavBarProvider);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentPageIndex,
      onTap: (index) {
        _onTap(index);
      },
      items: [
        // First Nav Bar
        if (widget.user?.isCoopView ?? false) ...[
          // If user toggles coopview and user is manager
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          )
        ] else ...[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          )
        ],

        // Second Nav Bar
        const BottomNavigationBarItem(
          icon: Icon(Icons.store_mall_directory_outlined),
          activeIcon: Icon(Icons.store_mall_directory),
          label: 'Market',
        ),

        // Third Nav Bar
        const BottomNavigationBarItem(
          icon: Icon(Icons.event_available_outlined),
          activeIcon: Icon(Icons.event_available),
          label: 'Events',
        ),

        // Fourth Nav Bar
        const BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          activeIcon: Icon(Icons.people),
          label: 'Coops',
        ),

        // Fifth Nav Bar
        const BottomNavigationBarItem(
          icon: Badge(
              isLabelVisible: true,
              label: Text('1'),
              child: Icon(Icons.inbox_outlined)),
          activeIcon: Icon(Icons.inbox),
          label: 'Inbox',
        ),
      ],
    );
  }

  void _onTap(int index) {
    ref.read(bottomNavBarProvider.notifier).setPosition(index);

    switch (index) {
      case 0:
        // If user toggles coopview and user is manager
        if (widget.user?.isCoopView ?? false) {
          context.go('/manager_dashboard');
        } else {
          context.go('/customer_home');
        }
        break;
      case 1:
        context.go('/market');
        break;
      case 2:
        context.go('/events');
        break;
      case 3:
        context.go('/coops');
        break;
      case 4:
        context.go('/inbox');
        break;
    }
  }
}
