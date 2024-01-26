import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/models/user_model.dart';
import 'package:lakbay/models/wiki_model.dart'; 
import 'package:lakbay/features/wiki/wiki_controller.dart'; 
import 'package:lakbay/features/common/providers/app_bar_provider.dart';
class ReadWikiPage extends ConsumerWidget {
  final String wikiId;

  const ReadWikiPage({super.key, required this.wikiId});

  void editWiki(BuildContext context, WikiModel wiki) {
    context.pushNamed(
      'edit_wiki',
      extra: wiki,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final scaffoldKey = ref.watch(scaffoldKeyProvider);

    return ref.watch(getWikiProvider(wikiId)).when(
      data: (WikiModel wiki) {
        return Scaffold(
          appBar: _appBar(scaffoldKey, user),
          body: SingleChildScrollView(
            child: Column(
              children: [
                DisplayImage(
                  imageUrl: wiki.imageUrl,
                  height: 150,
                  width: double.infinity,
                  radius: BorderRadius.zero,
                ),
                const SizedBox(height: 20),

                Text(
                  wiki.name,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(wiki.description ?? ''),
                ),
                const SizedBox(height: 20),

                // Edit Wiki Button
                ElevatedButton(
                  onPressed: () {
                    editWiki(context, wiki);
                  },
                  child: const Text('Edit Wiki'),
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) => Scaffold(
        body: ErrorText(error: error.toString(), stackTrace: ''),
      ),
      loading: () => const Scaffold(
        body: Loader(),
      ),
    );
  }

  AppBar _appBar(GlobalKey<ScaffoldState> scaffoldKey, UserModel? user) {
    return AppBar(
      title: const Text("View Wiki"),
      actions: [
        IconButton(
          onPressed: () {
            scaffoldKey.currentState?.openEndDrawer();
          },
          icon: CircleAvatar(
            radius: 20.0,
            backgroundImage: user?.profilePic != null && user?.profilePic != ''
                ? NetworkImage(user!.profilePic)
                : const AssetImage('lib/core/images/default_profile_pic.jpg') as ImageProvider,
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
