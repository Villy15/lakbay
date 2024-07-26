// custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/providers/app_bar_provider.dart';
import 'package:lakbay/models/user_model.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final UserModel? user;
  const CustomAppBar({super.key, required this.title, this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = ref.watch(scaffoldKeyProvider);

    return AppBar(
      scrolledUnderElevation: 0,
      title: Text(
        title,
        style: title == 'Tara! Lakbay!'
            ? const TextStyle(
                fontFamily: 'Satisfy',
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              )
            : null,
      ),
      // Add icon on the right side of the app bar of a person
      actions: [
        // Inbox Icon Button for the app bar
        //
        if (user?.isCoopView == true) ...[
          // Add a question mark icon button for the app bar

          if (title == "Home") ...[
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Help'),
                      content: const Text(
                        'Here you can view your:\n\n'
                        '1. Summaries for the week\n'
                        '2. Upcoming bookings\n'
                        '3. Upcoming tasks for both bookings and events',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.help_outline),
            ),
          ],

          if (title == "Calendar") ...[
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Help'),
                      content: const Text(
                        'Here you can view your activities for your selected calendar format.\n\n'
                        'You can choose to view your activities by week, 2 weeks, month in a list view',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.help_outline),
            ),
          ],

          if (title == "My Dashboard") ...[
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Help'),
                      content: const Text('Here you can view your:\n\n'
                          '1. Contributions summary\n'
                          '2. Total sales from your provided services\n'
                          '3. Charts to view your sales and contributions\n'
                          '4. Transactions summary\n'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.help_outline),
            ),
          ],
        ],

        if (title == "Tara! Lakbay!") ...[
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Help'),
                    content: const Text(
                        'Here you can view your trips on this platform:\n\n'
                        '1. Create a trip in the create a new trip button\n'
                        '2. View your past trips on the bottom\n'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.help_outline),
          ),
        ],

        if (title == "Explore") ...[
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Help'),
                    content: const Text(
                        'Here you can the trips that are completed from different users for this platform'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.help_outline),
          ),
        ],

        if (title == "Bookings") ...[
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Help'),
                    content: const Text(
                        'Here you can view all the bookings that you made for your trips'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.help_outline),
          ),
        ],

        if (title == "Events") ...[
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Help'),
                    content: const Text(
                        'Here you can view all the events created for this platform \n\n'
                        '1. You can join events and participate on communtiy engagement events\n'
                        '2. You can also contribute to the events by looking at the tasks that needs contribution'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.help_outline),
          ),
        ],

        if (title == "Coops") ...[
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Help'),
                    content: const Text(
                        'Here you can view all the cooperatives created for this platform \n\n'
                        '1. You can join cooperatives and participate on their services by contributing to their specified roles\n'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.help_outline),
          ),
        ],

        IconButton(
          onPressed: () {
            context.push('/inbox');
          },
          icon: const Badge(
            isLabelVisible: false,
            label: Text('3'),
            child: Icon(Icons.inbox_outlined),
          ),
        ),

        IconButton(
          onPressed: () {
            scaffoldKey.currentState?.openEndDrawer();
          },
          icon: CircleAvatar(
            radius: 20.0,
            backgroundImage: user?.profilePic != null && user?.profilePic != ''
                ? NetworkImage(user!.profilePic)
                : null,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
            child: user?.profilePic == null || user?.profilePic == ''
                ? Text(
                    user?.name[0].toUpperCase() ?? 'L',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
