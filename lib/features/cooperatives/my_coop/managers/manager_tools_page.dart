import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/cooperatives/my_coop/announcements/add_announcement.dart';
import 'package:lakbay/features/cooperatives/my_coop/goals/add_goal.dart';
import 'package:lakbay/features/cooperatives/my_coop/managers/add_jobs.dart';
import 'package:lakbay/features/cooperatives/my_coop/managers/manage_member_dvidends.dart';
import 'package:lakbay/features/cooperatives/my_coop/managers/manage_member_fee.dart';
import 'package:lakbay/features/cooperatives/my_coop/managers/manage_share_capital.dart';
import 'package:lakbay/features/cooperatives/my_coop/managers/validate_coop.dart';
import 'package:lakbay/features/cooperatives/my_coop/voting/add_vote.dart';
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

  void addAnnouncement(BuildContext context, CooperativeModel coop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return AddAnnouncement(
          parentContext: context,
          coop: coop,
        );
      },
    );
  }

  void addGoal(BuildContext context, CooperativeModel coop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return AddGoal(
          parentContext: context,
          coop: coop,
        );
      },
    );
  }

  void addVote(BuildContext context, CooperativeModel coop) {
    showDialog(
        context: context,
        builder: (context) {
          return SizedBox(
            child: Dialog.fullscreen(
                child: AddVote(
              parentContext: context,
              coop: coop,
            )),
          );
        });
  }

  void addJobs(BuildContext context, CooperativeModel coop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return AddJobs(
          parentContext: context,
          coop: coop,
        );
      },
    );
  }

  void manageMemberShipFee(BuildContext context, CooperativeModel coop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return ManageMemberFee(
          parentContext: context,
          coop: coop,
        );
      },
    );
  }

  // Validate Cooperative
  void validateCooperative(BuildContext context, CooperativeModel coop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return ValidateCoop(
          parentContext: context,
          coop: coop,
        );
      },
    );
  }

  // Manage Member Dividends
  void manageMemberDividends(BuildContext context, CooperativeModel coop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return ManageMemberDividends(
          parentContext: context,
          coop: coop,
        );
      },
    );
  }

  // Manager Share Capital
  void manageShareCapital(BuildContext context, CooperativeModel coop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return ManageShareCapital(
          parentContext: context,
          coop: coop,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // List Tile Map Cooperative Activities
    Map<String, Function> listTileMapCoopActivities = {
      // Add Announcement
      'Add Announcement': () => ListTile(
            leading: const Icon(Icons.announcement),
            title: const Text('Add Announcement'),
            subtitle: const Text('Add an announcement to the cooperative'),
            onTap: () => addAnnouncement(context, coop),
          ),

      // Add Goal
      'Add Goal': () => ListTile(
            leading: const Icon(Icons.add_task),
            title: const Text('Add Goal'),
            subtitle: const Text('Add a goal to the cooperative'),
            onTap: () => addGoal(
              context,
              coop,
            ),
          ),

      // Add Election Vote
      'Add Election Vote': () => ListTile(
            leading: const Icon(Icons.how_to_vote),
            title: const Text('Add Election Vote'),
            subtitle: const Text('Add a vote to the cooperative'),
            onTap: () => {
              addVote(
                context,
                coop,
              )
            },
          ),
      // Add Job Roles
      'Add Job Roles': () => ListTile(
            leading: const Icon(Icons.groups_2_outlined),
            title: const Text('Add Tourism Jobs'),
            subtitle: const Text('Add job roles to the cooperative'),
            onTap: () => {
              addJobs(
                context,
                coop,
              )
            },
          ),
    };

    // List Tile Map Cooperative Details
    Map<String, Function> listTileMapCoopDetails = {
      'Edit Cooperative': () => ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Cooperative'),
            subtitle: const Text('Edit the cooperative details'),
            onTap: () => editCoop(context, coop),
          ),
      // Delete cooperative
      'Delete Cooperative': () => ListTile(
          leading: const Icon(Icons.delete),
          title: const Text('Delete Cooperative'),
          subtitle: const Text('Delete the cooperative'),
          onTap: () => {
                showSnackBar(
                  context,
                  'Delete Cooperative',
                )
              }),
      'Manage Privileges': () => ListTile(
            leading: const Icon(Icons.manage_accounts),
            title: const Text('Manage Privileges'),
            subtitle: const Text('Manage privileges for the cooperative'),
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
            subtitle: const Text('Add members to the cooperative with CSV'),
            onTap: () => {
              joinCoopCode(
                context,
                coop,
              )
            },
          ),
      'Manage Membership Fee': () => ListTile(
            leading: const Icon(Icons.money),
            title: const Text('Manage Membership Fee'),
            subtitle: const Text('Manage membership fee for the cooperative'),
            onTap: () => {
              manageMemberShipFee(
                context,
                coop,
              )
            },
          ),
      // Validate Cooperative
      'Validate Cooperative': () => ListTile(
          leading: const Icon(Icons.verified),
          title: const Text('Validate Cooperative'),
          subtitle: const Text('Validate the cooperative'),
          onTap: () => {
                validateCooperative(
                  context,
                  coop,
                )
              }),
      // Member Dividends
      'Manage Member Dividends': () => ListTile(
          leading: const Icon(Icons.money_off),
          title: const Text('Member Dividends'),
          subtitle: const Text('Manage member dividends'),
          onTap: () => {
                manageMemberDividends(
                  context,
                  coop,
                )
              }),
      // Manager Share Capital
      'Manage Share Capital': () => ListTile(
          leading: const Icon(Icons.money),
          title: const Text('Manage Share Capital'),
          subtitle: const Text('Manage share capital for your cooperative'),
          onTap: () => {
                manageShareCapital(
                  context,
                  coop,
                )
              }),
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

    return PopScope(
      // onPopInvoked: (bool didPop) {
      //   context.pop();
      //   ref.read(navBarVisibilityProvider.notifier).show();
      // },
      child: Scaffold(
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
                  // Cooperative Activities
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Cooperative Activities',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listTileMapCoopActivities.length,
                    itemBuilder: (context, index) {
                      final key =
                          listTileMapCoopActivities.keys.elementAt(index);
                      final listTile = listTileMapCoopActivities[key]!();
                      return listTile;
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  ),

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
      ),
    );
  }
}
