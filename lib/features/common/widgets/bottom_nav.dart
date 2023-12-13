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
            icon: Icon(Icons.today_outlined),
            activeIcon: Icon(Icons.today),
            label: 'Today',
          )
        ] else ...[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          )
        ],

        // Second Nav Bar
        if (widget.user?.isCoopView ?? false) ...[
          // If user toggles coopview and user is manager
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Calendar',
          )
        ] else ...[
          const BottomNavigationBarItem(
            icon: Icon(Icons.card_travel_outlined),
            activeIcon: Icon(Icons.card_travel),
            label: 'Trips',
          ),
        ],

        // Third Nav Bar
        if (widget.user?.isCoopView ?? false) ...[
          // Tourism Listings
          const BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: 'Listings',
          ),
        ] else ...[
          const BottomNavigationBarItem(
            icon: Icon(Icons.event_available_outlined),
            activeIcon: Icon(Icons.event_available),
            label: 'Events',
          ),
        ],

        // Fourth Nav Bar
        if (widget.user?.isCoopView ?? false) ...[
          // Tourism Listings
          const BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'My Coop',
          ),
        ] else ...[
          const BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Coops',
          ),
        ],

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
        if (widget.user?.isCoopView ?? false) {
          context.go('/manager_dashboard');
        } else {
          context.go('/customer_home');
        }
        break;
      case 1:
        context.go('/trips');
        break;
      case 2:
        context.go('/events');
        break;
      case 3:
        if (widget.user?.isCoopView ?? false) {
          context.go('/my_coop/${widget.user?.currentCoop}');
        } else {
          context.go('/coops');
        }
        break;
      case 4:
        context.go('/inbox');
        break;
    }
  }
}
