import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/models/coop_model.dart';

class ManagerToolsPage extends ConsumerWidget {
  final CooperativeModel coop;
  const ManagerToolsPage({super.key, required this.coop});

  void editCoop(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'edit_coop',
      extra: coop,
    );
  }

  void manageCommittees(
      BuildContext context, CooperativeModel coop, String committeeName) {
    context.pushNamed(
      'manage_committees',
      extra: coop,
      pathParameters: {'committeeName': committeeName},
    );
  }

  void managePrivileges(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'manage_privileges',
      extra: coop,
    );
  }

  void addBoardRole(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'add_board_role',
      extra: coop,
    );
  }

  void joinCoopCode(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'join_coop_code',
      extra: coop,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, Function> listTileMapCoopDetails = {
      'Edit Cooperative': () => ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Cooperative'),
            onTap: () => editCoop(context, coop),
          ),
      // Delete cooperative
      'Delete Cooperative': () => ListTile(
          leading: const Icon(Icons.delete),
          title: const Text('Delete Cooperative'),
          onTap: () => {
                showSnackBar(
                  context,
                  'Delete Cooperative',
                )
              }),
      'Manage Privileges': () => ListTile(
            leading: const Icon(Icons.manage_accounts),
            title: const Text('Manage Privileges'),
            onTap: () => {
              managePrivileges(
                context,
                coop,
              )
            },
          ),
      // Join Cooperative Code
      'Add Members with CSV': () => ListTile(
            leading: const Icon(Icons.group_add),
            title: const Text('Add Members with CSV'),
            onTap: () => {
              joinCoopCode(
                context,
                coop,
              )
            },
          ),
    };

    // List Tile Map Manage Committees
    Map<String, Function> listTileMapManageCommittees = {
      'Tourism Committee': () => ListTile(
          leading: const Icon(Icons.beach_access),
          title: const Text('Tourism Committee'),
          onTap: () => manageCommittees(context, coop, 'Tourism')),
      'Events Committee': () => ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Events Committee'),
            onTap: () => manageCommittees(context, coop, 'Events'),
          ),
      'Training Committee': () => ListTile(
            leading: const Icon(Icons.model_training),
            title: const Text('Training Committee'),
            onTap: () => manageCommittees(context, coop, 'Training'),
          ),
      'Election Committee': () => ListTile(
            leading: const Icon(Icons.how_to_vote),
            title: const Text('Election Committee'),
            onTap: () => manageCommittees(context, coop, 'Election'),
          ),
      'Audit Committee': () => ListTile(
            leading: const Icon(Icons.fact_check),
            title: const Text('Audit Committee'),
            onTap: () => manageCommittees(context, coop, 'Audit'),
          ),
    };

    // List Tile Map Manager Board
    Map<String, Function> listTileMapManageBoard = {
      'Add Board Role': () => ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Board Role'),
            onTap: () => {
              showSnackBar(
                context,
                'Add Board Role',
              )
            },
          ),
      'Edit Board Role': () => ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Edit Board Role'),
          onTap: () => {
                showSnackBar(
                  context,
                  'Edit Board Role',
                )
              }),
      // Delete Board Role
      'Delete Board Role': () => ListTile(
          leading: const Icon(Icons.delete),
          title: const Text('Delete Board Role'),
          onTap: () => {
                showSnackBar(
                  context,
                  'Delete Board Role',
                )
              }),
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Manager Tools')),
      body: Scrollbar(
        // Always show scrollbar
        thumbVisibility: true,
        child: SingleChildScrollView(
          // Show scroll bar only when needed
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cooperative Details
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Cooperative Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listTileMapCoopDetails.length,
                  itemBuilder: (context, index) {
                    final key = listTileMapCoopDetails.keys.elementAt(index);
                    final listTile = listTileMapCoopDetails[key]!();
                    return listTile;
                  },
                  separatorBuilder: (context, index) => const Divider(),
                ),

                // Manage Committees
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Manage Committees',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listTileMapManageCommittees.length,
                  itemBuilder: (context, index) {
                    final key =
                        listTileMapManageCommittees.keys.elementAt(index);
                    final listTile = listTileMapManageCommittees[key]!();
                    return listTile;
                  },
                  separatorBuilder: (context, index) => const Divider(),
                ),

                // Manage Board
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Manage Board',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listTileMapManageBoard.length,
                  itemBuilder: (context, index) {
                    final key = listTileMapManageBoard.keys.elementAt(index);
                    final listTile = listTileMapManageBoard[key]!();
                    return listTile;
                  },
                  separatorBuilder: (context, index) => const Divider(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
