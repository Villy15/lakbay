import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
        child: Text(
          'Menu',
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      const NavigationDrawerDestination(
        label: Text('Home'),
        icon: Icon(Icons.home),
        selectedIcon: Icon(Icons.home),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
        child: Divider(),
      ),
      // Add logout button
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: FilledButton.icon(
          icon: const Icon(Icons.logout),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () {
            context.go('/login');
          },
          label: const Text("Logout"),
        ),
      )
    ]);
  }
}
