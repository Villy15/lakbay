import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/plan/plan_providers.dart';

class PlanSelectLocation extends ConsumerStatefulWidget {
  const PlanSelectLocation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PlanSelectLocationState();
}

class _PlanSelectLocationState extends ConsumerState<PlanSelectLocation> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select Location'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Search Bar
              TextField(
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),

              const SizedBox(height: 8.0),

              // List of Locations
              Expanded(
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: const Text('Marivles, Bataan'),
                      onTap: () {
                        ref.read(planLocationProvider.notifier).setLocation(
                              'Marivles, Bataan',
                            );
                        context.pop();
                        ref.read(navBarVisibilityProvider.notifier).show();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
