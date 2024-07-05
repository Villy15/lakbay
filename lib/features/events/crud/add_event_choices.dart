import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/models/coop_model.dart';

class AddEventChoices extends ConsumerStatefulWidget {
  final CooperativeModel coop;

  const AddEventChoices({super.key, required this.coop});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddEventChoicesState();
}

class _AddEventChoicesState extends ConsumerState<AddEventChoices> {
  void addEvent(BuildContext context, CooperativeModel coop, String eventType) {
    context.pushNamed(
      'add_event',
      extra: {'coop': coop, 'eventType': eventType},
    );
  }

  void addEventPredetermined(
      BuildContext context,
      CooperativeModel coop,
      String eventType,
      String eventName,
      String eventDesc,
      String eventGoal,
      num eventObjective) {
    context.pushNamed(
      'add_event_predetermined',
      extra: {
        'coop': coop,
        'eventType': eventType,
        'eventName': eventName,
        'eventDesc': eventDesc,
        'eventGoal': eventGoal,
        'eventObjective': eventObjective,
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        ref.read(navBarVisibilityProvider.notifier).show();
        context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Event'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Create Community Engagement Events for your Community!, Here are samples',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.local_florist),
                      title: const Text('Tree Planting'),
                      onTap: () => addEventPredetermined(
                        context,
                        widget.coop,
                        'Community Engagement',
                        'Tree Planting',
                        'Planting trees is a great way to help the environment. Trees provide oxygen, improve air quality, conserve water, preserve soil, and support wildlife. Planting trees is also a great way to help the environment. Trees provide oxygen, improve air quality, conserve water, preserve soil, and support wildlife.',
                        'Trees planted',
                        100,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.recycling),
                      title: const Text('Plastic Waste Reduction Campaigns'),
                      onTap: () => addEventPredetermined(
                        context,
                        widget.coop,
                        'Community Engagement',
                        'Plastic Waste Reduction Campaigns',
                        'Plastic waste reduction campaigns are a great way to help the environment. Plastic waste reduction campaigns help reduce the amount of plastic waste that ends up in landfills and oceans. Plastic waste reduction campaigns also help raise awareness about the importance of reducing plastic waste and encourage people to use less plastic.',
                        'Amount of trash collected (in kilograms)',
                        100,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.water),
                      title: const Text(
                        'River and Watershed Protection Programs',
                      ),
                      onTap: () => addEventPredetermined(
                        context,
                        widget.coop,
                        'Community Engagement',
                        'River and Watershed Protection Programs',
                        'River and watershed protection programs are a great way to help the environment. River and watershed protection programs help protect rivers and watersheds from pollution, habitat destruction, and other threats. River and watershed protection programs also help raise awareness about the importance of protecting rivers and watersheds and encourage people to take action to protect them.',
                        'Amount of trash collected (in kilograms)',
                        100,
                      ),
                    ),
                    // Create your own community engagement events here
                    ListTile(
                      leading: const Icon(Icons.add),
                      title: const Text(
                          'Create your own community engagement event'),
                      onTap: () => addEvent(
                        context,
                        widget.coop,
                        'Community Engagement',
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Event for cooperatives?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.school),
                      title: const Text('Seminar'),
                      onTap: () => addEvent(context, widget.coop, 'Seminar'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.work),
                      title: const Text('Training'),
                      onTap: () => addEvent(
                          context, widget.coop, 'Training and Education'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.group),
                      title: const Text('General Assembly'),
                      onTap: () =>
                          addEvent(context, widget.coop, 'General Assembly'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
