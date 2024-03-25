import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/providers/app_bar_provider.dart';
// import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/models/user_model.dart';

void createRoom(BuildContext context, String senderId, UserModel user) async {
  // Create a room
  final room = await FirebaseChatCore.instance.createRoom(
    types.User(id: senderId),
  );

  // ignore: use_build_context_synchronously
  context.push(
    '/inbox/id/$senderId',
    extra: room,
  );
}

class InboxPage extends ConsumerWidget {
  const InboxPage({super.key});

  String? lastMessage(List<types.Message> messages) {
    if (messages.isEmpty) {
      return 'No message: Start a conversation';
    }

    final lastMessage = messages.first;
    if (lastMessage.type == types.MessageType.text) {
      return (lastMessage as types.TextMessage).text;
    }

    if (lastMessage.type == types.MessageType.image) {
      return 'Sent an image';
    }

    if (lastMessage.type == types.MessageType.video) {
      return 'Sent a video';
    }

    if (lastMessage.type == types.MessageType.file) {
      return 'Sent a file';
    }

    if (lastMessage.type == types.MessageType.audio) {
      return 'Sent an audio';
    }

    return 'No message';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = ref.watch(scaffoldKeyProvider);
    final user = ref.watch(userProvider);
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: _appBar(scaffoldKey, user, context),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
              StreamBuilder(
                stream: FirebaseChatCore.instance.rooms(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox.shrink(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: SizedBox.shrink(),
                    );
                  }
                  final rooms = snapshot.data as List<types.Room>;

                  if (rooms.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'lib/core/images/SleepingCatFromGlitch.svg',
                            height: 100, // Adjust height as desired
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'No messages yet!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Start a conversation when you chat',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const Text(
                            'with someone now!',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      final room = rooms[index];
                      final user = room.users.firstWhere(
                        (element) => element.id != ref.read(userProvider)?.uid,
                      );

                      // Get the senderId where the current user is not the sender in the rooms.users

                      final senderId = room.users
                          .firstWhere(
                            (element) =>
                                element.id != ref.read(userProvider)?.uid,
                          )
                          .id;

                      return ref.watch(getUserDataProvider(user.id)).maybeWhen(
                          orElse: () {
                        return const SizedBox();
                      }, data: (user) {
                        return StreamBuilder(
                            stream: FirebaseChatCore.instance.messages(room),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                return const Center(
                                  child: Text('Error'),
                                );
                              }
                              final messages =
                                  snapshot.data as List<types.Message>;

                              return ListTile(
                                onTap: () {
                                  context.push(
                                    '/inbox/id/$senderId',
                                    extra: room,
                                  );
                                },
                                title: Text(user.name),
                                // Show the last message
                                subtitle: Text(lastMessage(messages)!),

                                leading: CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage: user.profilePic != ''
                                      ? NetworkImage(user.profilePic)
                                      : null,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  child: user.profilePic == ''
                                      ? Text(
                                          user.name[0].toUpperCase(),
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                          ),
                                        )
                                      : null,
                                ),
                              );
                            });

                        // return ListTile(
                        //   onTap: () {
                        //     createRoom(context, senderId, user);
                        //   },
                        //   title: Text(user.name),
                        //   subtitle: const Text('Hello po'),
                        //   leading: CircleAvatar(
                        //     radius: 20.0,
                        //     backgroundImage: user.profilePic != ''
                        //         ? NetworkImage(user.profilePic)
                        //         : null,
                        //     backgroundColor:
                        //         Theme.of(context).colorScheme.onBackground,
                        //     child: user.profilePic == ''
                        //         ? Text(
                        //             user.name[0].toUpperCase(),
                        //             style: TextStyle(
                        //               color: Theme.of(context)
                        //                   .colorScheme
                        //                   .background,
                        //             ),
                        //           )
                        //         : null,
                        //   ),
                        // );
                      });

                      // return Text(user.id);
                      // return ListTile(
                      //   onTap: () {
                      //     context.push(
                      //       '/inbox/id/${user.id}',
                      //       extra: room,
                      //     );
                      //   },
                      //   title: Text(user.id),
                      //   subtitle: const Text('Hello po'),
                      //   leading: CircleAvatar(
                      //     radius: 20.0,
                      //     backgroundImage: user.imageUrl != ''
                      //         ? NetworkImage(user.imageUrl!)
                      //         : null,
                      //     backgroundColor:
                      //         Theme.of(context).colorScheme.onBackground,
                      //     child: user.imageUrl == ''
                      //         ? Text(
                      //             user.id[0].toUpperCase(),
                      //             style: TextStyle(
                      //               color: Theme.of(context)
                      //                   .colorScheme
                      //                   .background,
                      //             ),
                      //           )
                      //         : null,
                      //   ),
                      // );
                    },
                  );
                },
              ),
              // ref.watch(getAllUsersExceptCurrentUserProvider(user!.uid)).when(
              //       data: (data) {
              //         return ListView.separated(
              //           itemCount: data.length,
              //           itemBuilder: (context, index) {
              //             final user = data[index];

              //             return ListTile(
              //               onTap: () => {
              //                 createRoom(context, user.uid, user),
              //               },
              //               title: Text(user.name),
              //               subtitle: const Text('Hello po'),
              //               leading: CircleAvatar(
              //                 radius: 20.0,
              //                 backgroundImage: user.profilePic != ''
              //                     ? NetworkImage(user.profilePic)
              //                     : null,
              //                 backgroundColor:
              //                     Theme.of(context).colorScheme.onBackground,
              //                 child: user.profilePic == ''
              //                     ? Text(
              //                         user.name[0].toUpperCase(),
              //                         style: TextStyle(
              //                           color: Theme.of(context)
              //                               .colorScheme
              //                               .background,
              //                         ),
              //                       )
              //                     : null,
              //               ),
              //             );
              //           },
              //           separatorBuilder: (context, index) => const Divider(),
              //         );
              //       },
              //       error: (error, stackTrace) => Scaffold(
              //         body: ErrorText(
              //           error: error.toString(),
              //           stackTrace: stackTrace.toString(),
              //         ),
              //       ),
              //       loading: () => const Scaffold(
              //         body: Loader(),
              //       ),
              //     ),

              // Food
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'lib/core/images/SleepingCatFromGlitch.svg',
                      height: 100, // Adjust height as desired
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No messages yet!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Start a conversation when you chat',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      'with someone now!',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  PreferredSize _appBar(GlobalKey<ScaffoldState> scaffoldKey, UserModel? user,
      BuildContext context) {
    List<Widget> tabs = [
      const SizedBox(
        width: 100.0,
        child: Tab(
          icon: Icon(Icons.person),
          child: Flexible(child: Text('Individual')),
        ),
      ),
      const SizedBox(
        width: 100.0,
        child: Tab(
          icon: Icon(Icons.people),
          child: Flexible(child: Text('Groups')),
        ),
      ),
    ];

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 75),
      child: AppBar(
        title: const Text(
          'Inbox',
        ),
        // Add icon on the right side of the app bar of a person
        actions: [
          IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openEndDrawer();
            },
            icon: CircleAvatar(
              radius: 20.0,
              backgroundImage:
                  user?.profilePic != null && user?.profilePic != ''
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
        bottom: TabBar(
          tabs: tabs,
        ),
      ),
    );
  }
}
