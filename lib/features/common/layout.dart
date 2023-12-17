import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/providers/app_bar_provider.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/bottom_nav.dart';
import 'package:lakbay/features/common/widgets/drawer.dart';

class Layout extends ConsumerStatefulWidget {
  final Widget child;
  const Layout({super.key, required this.child});

  @override
  ConsumerState<Layout> createState() => _LayoutState();
}

class _LayoutState extends ConsumerState<Layout> {
  @override
  Widget build(BuildContext context) {
    final scaffoldKey = ref.watch(scaffoldKeyProvider);
    final appBarVisibility = ref.watch(navBarVisibilityProvider);
    final user = ref.watch(userProvider);

    debugPrintJson(user ?? {});

    return Scaffold(
      key: scaffoldKey,
      body: widget.child,
      endDrawer: CustomDrawer(user: user),
      bottomNavigationBar: appBarVisibility ? BottomNavBar(user: user) : null,
    );
  }
}
