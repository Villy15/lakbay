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

    if (widget.user?.isAdmin ?? false) {
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
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            )
          ] else if (widget.user?.isAdmin ?? false) ...[
            const BottomNavigationBarItem(
              icon: Icon(Icons.verified_outlined),
              activeIcon: Icon(Icons.verified),
              label: 'Validate',
            ),
          ] else ...[
            const BottomNavigationBarItem(
              icon: Icon(Icons.card_travel_outlined),
              activeIcon: Icon(Icons.card_travel),
              label: 'Trips',
            ),
          ],

          // Fourth Nav Bar
          if (widget.user?.isCoopView ?? false) ...[
            // Tourism Listings
            const BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
          ] else ...[
            const BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Coops',
            ),
          ],
        ],
      );
    }

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
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          )
        ] else ...[
          const BottomNavigationBarItem(
            icon: Icon(Icons.card_travel_outlined),
            activeIcon: Icon(Icons.card_travel),
            label: 'Trips',
          ),
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
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore',
          )
        ],

        // Third Nav Bar
        if (widget.user?.isCoopView ?? false) ...[
          // Tourism Listings
          const BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            activeIcon: Icon(Icons.groups),
            label: 'Community',
          ),
        ] else ...[
          const BottomNavigationBarItem(
            icon: Icon(Icons.travel_explore_outlined),
            activeIcon: Icon(Icons.travel_explore),
            label: 'Bookings',
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
            icon: Icon(Icons.event_available_outlined),
            activeIcon: Icon(Icons.event_available),
            label: 'Events',
          ),
        ],

        // Fourth Nav Bar
        if (widget.user?.isCoopView ?? false) ...[
          // Tourism Listings
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
        ] else ...[
          const BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Coops',
          ),
        ],
      ],
    );
  }

  void _onTap(int index) {
    ref.read(bottomNavBarProvider.notifier).setPosition(index);

    switch (index) {
      case 0:
        if (widget.user?.isCoopView ?? false) {
          context.go('/today');
        } else {
          context.go('/trips');
        }
        break;
      case 1:
        if (widget.user?.isCoopView ?? false) {
          context.go('/calendar');
        } else if (widget.user?.isAdmin ?? false) {
          context.go('/coops');
        } else {
          context.go('/plan');
        }
        break;
      case 2:
        if (widget.user?.isCoopView ?? false) {
          context.go('/my_coop/listings/${widget.user?.currentCoop}');
        } else {
          context.go('/bookings');
        }
        break;
      case 3:
        if (widget.user?.isCoopView ?? false) {
          context.go('/my_coop/${widget.user?.currentCoop}');
        } else {
          context.go('/events');
        }
        break;
      case 4:
        if (widget.user?.isCoopView ?? false) {
          context.go('/my_coop/my_dashboard/${widget.user?.currentCoop}');
        } else {
          context.go('/coops');
        }
        break;
    }
  }
}
