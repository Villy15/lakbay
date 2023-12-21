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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, Function> listTileMap = {
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
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Manager Tools')),
      body: SingleChildScrollView(
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
                itemCount: listTileMap.length,
                itemBuilder: (context, index) {
                  final key = listTileMap.keys.elementAt(index);
                  final listTile = listTileMap[key]!();
                  return listTile;
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
