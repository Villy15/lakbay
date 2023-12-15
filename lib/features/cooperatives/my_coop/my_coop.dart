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

class MyCoopPage extends ConsumerStatefulWidget {
  final String coopId;
  const MyCoopPage({super.key, required this.coopId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyCoopPageState();
}

class _MyCoopPageState extends ConsumerState<MyCoopPage> {
  void viewMembers(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'coop_members',
      extra: coop,
    );
  }

  void viewEvents(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'coop_events',
      extra: coop,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final scaffoldKey = ref.watch(scaffoldKeyProvider);

    return ref.watch(getCooperativeProvider(widget.coopId)).when(
          data: (CooperativeModel coop) {
            return Scaffold(
              appBar: _appBar(scaffoldKey, user),
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

                    // View Members Button
                    ElevatedButton(
                      onPressed: () {
                        viewMembers(context, coop);
                      },
                      child: const Text('View Members'),
                    ),

                    // View Events Button
                    ElevatedButton(
                      onPressed: () {
                        viewEvents(context, coop);
                      },
                      child: const Text('View Events'),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) => Scaffold(
            // appBar: CustomAppBar(title: 'Error', user: user),
            body: ErrorText(error: error.toString()),
          ),
          loading: () => const Scaffold(
            // appBar: CustomAppBar(title: 'Loading...', user: user),
            body: Loader(),
          ),
        );
  }

  AppBar _appBar(GlobalKey<ScaffoldState> scaffoldKey, UserModel? user) {
    return AppBar(
      title: const Text("My Cooperative"),
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
                // Use placeholder image if user has no profile pic
                : const AssetImage('lib/core/images/default_profile_pic.jpg')
                    as ImageProvider,
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
