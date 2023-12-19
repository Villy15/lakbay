import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/app_bar_provider.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/user_model.dart';

class ReadCoopPage extends ConsumerWidget {
  final String coopId;
  const ReadCoopPage({super.key, required this.coopId});

  void editCoop(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'edit_coop',
      extra: coop,
    );
  }

  void joinCoop(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'join_coop',
      extra: coop,
    );
  }

  void leaveCoop(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'leave_coop',
      extra: coop,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final scaffoldKey = ref.watch(scaffoldKeyProvider);

    return ref.watch(getCooperativeProvider(coopId)).when(
          data: (CooperativeModel coop) {
            // debugPrintJson(coop);
            return Scaffold(
              appBar: _appBar(scaffoldKey, user, context),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    DisplayImage(
                      imageUrl: coop.imageUrl,
                      height: 150,
                      width: double.infinity,
                      radius: BorderRadius.zero,
                    ),
                    const SizedBox(height: 20),
                    Text(coop.name),
                    const SizedBox(height: 20),
                    Text(coop.description ?? ''),
                    const SizedBox(height: 20),

                    // Edit Cooperative Button
                    ElevatedButton(
                      onPressed: () {
                        editCoop(context, coop);
                      },
                      child: const Text('Edit Cooperative'),
                    ),

                    // Join Cooperative Button
                    ElevatedButton(
                      onPressed: () {
                        joinCoop(context, coop);
                      },
                      child: const Text('Join Cooperative'),
                    ),

                    // Leave Cooperative Button
                    ElevatedButton(
                      onPressed: () {
                        leaveCoop(context, coop);
                      },
                      child: const Text('Leave Cooperative'),
                    ),
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) => Scaffold(
            body: ErrorText(error: error.toString()),
          ),
          loading: () => const Scaffold(
            body: Loader(),
          ),
        );
  }

  AppBar _appBar(GlobalKey<ScaffoldState> scaffoldKey, UserModel? user,
      BuildContext context) {
    return AppBar(
      title: const Text("View Cooperative"),
      // Add icon on the right side of the app bar of a person
      actions: [
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
}
