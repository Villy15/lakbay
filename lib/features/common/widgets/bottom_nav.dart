import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  const BottomNavBar({
    super.key,
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
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home), 
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.store_mall_directory_outlined),
          activeIcon: Icon(Icons.store_mall_directory),
          label: 'Market',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_available_outlined),
          activeIcon: Icon(Icons.event_available),
          label: 'Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          activeIcon: Icon(Icons.people),
          label: 'Coops',
        ),
        BottomNavigationBarItem(
          icon: Badge(
            isLabelVisible: true,
            label: Text('1'),
            child: Icon(Icons.inbox_outlined)
          ),
          activeIcon: Icon(Icons.inbox),
          label: 'Inbox',
        ),
      ],
    );
  }
  
  void _onTap(int index) {
    ref.read(bottomNavBarProvider.notifier).setPosition(index);

    switch(index) {
      case 0: 
        context.go('/customer_home');
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
