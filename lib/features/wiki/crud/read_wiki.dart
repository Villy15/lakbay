import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/app_bar_provider.dart';
import 'package:lakbay/features/wiki/wiki_controller.dart';
import 'package:lakbay/models/user_model.dart';
import 'package:lakbay/models/wiki_model.dart';

class ReadWikiPage extends ConsumerStatefulWidget {
  final String wikiId;

  const ReadWikiPage({super.key, required this.wikiId});

  @override
  @override
  ReadWikiPageState createState() => ReadWikiPageState();
}

class ReadWikiPageState extends ConsumerState<ReadWikiPage> {
  // Controller for Comment
  final TextEditingController _commentController = TextEditingController();

  void editWiki(BuildContext context, WikiModel wiki) {
    context.pushNamed(
      'edit_wiki',
      extra: wiki,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final scaffoldKey = ref.watch(scaffoldKeyProvider);

    return ref.watch(getWikiProvider(widget.wikiId)).when(
          data: (WikiModel wiki) {
            return Scaffold(
              appBar: _appBar(scaffoldKey, user),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    _header(wiki, user),
                    const SizedBox(height: 8),
                    _category(wiki, context),
                    const SizedBox(height: 8),
                    ref.watch(getUserDataProvider(wiki.createdBy)).maybeWhen(
                          data: (UserModel user) {
                            return _creator(wiki, user);
                          },
                          orElse: () => const SizedBox(),
                        ),
                    const SizedBox(height: 8),
                    _title(wiki),
                    const SizedBox(height: 24),
                    _desc(wiki),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        _votes(wiki),
                        _comments(wiki),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(),
                    ),

                    // Add the comments here
                    _listComments(wiki),
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

  String timeAgo(DateTime endDate) {
    final difference = DateTime.now().difference(endDate);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes != 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours != 1 ? 's' : ''} ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} day${difference.inDays != 1 ? 's' : ''} ago';
    } else {
      final months = (difference.inDays / 30).round();
      return '$months month${months != 1 ? 's' : ''} ago';
    }
  }

  void updateVoteComments(WikiModel wiki, int votes, String createdAt) {
    // update the vote comments by there createdAt
    var newWiki = wiki.copyWith(
      comments: wiki.comments!.map((comment) {
        if (comment.createdAt.toString() == createdAt) {
          return comment.copyWith(votes: votes);
        }
        return comment;
      }).toList(),
    );

    ref
        .read(wikiControllerProvider.notifier)
        .updateVoteComments(newWiki, context);
  }

  Widget _listComments(WikiModel wiki) {
    if (wiki.comments == null || wiki.comments!.isEmpty) {
      return _emptyPlaceholder();
    }

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: wiki.comments!.length,
          itemBuilder: (BuildContext context, int index) {
            final comment = wiki.comments![index];
            return Column(
              children: [
                Row(
                  children: [
                    // Comment Creator
                    ref.watch(getUserDataProvider(comment.createdBy)).maybeWhen(
                          data: (UserModel user) {
                            return _creator(wiki, user);
                          },
                          orElse: () => const SizedBox(),
                        ),

                    const SizedBox(width: 8),
                    // Time Ago
                    Text('· ${timeAgo(comment.createdAt)}'),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      comment.comment,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  // Use the screen size to align the buttons to the right
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 2,
                  ),
                  child: Row(
                    children: [
                      OutlinedButton(
                        // Remove
                        // Make the button remove the radius on the right
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Colors
                                .transparent, // Make the border color transparent
                            width: 1, // Adjust border width as needed
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                        ),
                        onPressed: () => {
                          updateVoteComments(
                            wiki,
                            comment.votes!.toInt() + 1,
                            comment.createdAt.toString(),
                          ),
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_upward_outlined),
                            const SizedBox(width: 8),
                            Text(comment.votes.toString()),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        // Make the button remove the radius on the left
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Colors
                                .transparent, // Make the border color transparent
                            width: 1, // Adjust border width as needed
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                        ),
                        onPressed: () => {
                          updateVoteComments(
                            wiki,
                            comment.votes!.toInt() - 1,
                            comment.createdAt.toString(),
                          ),
                        },
                        child: const Icon(Icons.arrow_downward_outlined),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ],
    );
  }

  Column _emptyPlaceholder() {
    return Column(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              SvgPicture.asset(
                'lib/core/images/SleepingCatFromGlitch.svg',
                height: 100, // Adjust height as desired
              ),
              const SizedBox(height: 20),
              const Text(
                'No comments created so far!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Start the conversation by adding a comment',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const Text(
                'above beside the voting',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _creator(WikiModel wiki, UserModel user) {
    return Row(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              radius: 20.0,
              backgroundImage:
                  user.profilePic != '' ? NetworkImage(user.profilePic) : null,
              backgroundColor: Theme.of(context).colorScheme.onBackground,
              child: user.profilePic == ''
                  ? Text(
                      user.name[0].toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                      ),
                    )
                  : null,
            ),
          ),
        ),
        Text(
          user.name,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void replyComment(WikiModel wiki, String comment) {
    final user = ref.read(userProvider);

    if (comment.isEmpty) {
      showSnackBar(context, 'Comment cannot be empty');
      return;
    }

    var reply = WikiComments(
      comment: comment,
      createdBy: user!.uid,
      createdAt: DateTime.now(),
      votes: 0,
    );

    ref
        .watch(wikiControllerProvider.notifier)
        .addComment(wiki.uid!, reply, context);
  }

  // Show modal bottom sheet to add comments
  void addComment(BuildContext context, WikiModel wiki) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Please be respectful to others when adding comments.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: 'Type your comment here',
                  labelText: 'Add Comment',
                ),
                minLines: 3,
                maxLines: null,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // IconButton to add image
                  IconButton.filledTonal(
                    onPressed: () {
                      showSnackBar(context, 'Add Image Not Implemented Yet');
                    },
                    icon: const Icon(Icons.image_outlined),
                  ),
                  FilledButton(
                    onPressed: () {
                      replyComment(wiki, _commentController.text);
                    },
                    child: const Text('Reply'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _comments(WikiModel wiki) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: OutlinedButton(
        onPressed: () => {
          addComment(context, wiki),
        },
        child: Row(
          children: [
            const Icon(Icons.comment_outlined),
            const SizedBox(width: 8),
            Text(wiki.comments?.length.toString() ?? '0'),
          ],
        ),
      ),
    );
  }

  void updateVotes(WikiModel wiki, int votes) {
    ref
        .read(wikiControllerProvider.notifier)
        .updateVotes(wiki.uid!, votes, context);
  }

  Widget _votes(WikiModel wiki) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Row(
        children: [
          OutlinedButton(
            // Make the button remove the radius on the right
            style: OutlinedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
            onPressed: () => {
              updateVotes(wiki, wiki.votes!.toInt() + 1),
            },
            child: Row(
              children: [
                const Icon(Icons.arrow_upward_outlined),
                const SizedBox(width: 8),
                Text(wiki.votes.toString()),
              ],
            ),
          ),
          OutlinedButton(
            // Make the button remove the radius on the left
            style: OutlinedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            onPressed: () => {
              updateVotes(wiki, wiki.votes!.toInt() - 1),
            },
            child: const Icon(Icons.arrow_downward_outlined),
          ),
        ],
      ),
    );
  }

  Widget _category(WikiModel wiki, BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Text(
          wiki.tag.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  Padding _desc(WikiModel wiki) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(
        wiki.description,
        style: const TextStyle(
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget _title(WikiModel wiki) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Text(
          wiki.title,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Padding _header(WikiModel wiki, UserModel? user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today),
              const SizedBox(width: 8),
              Text(
                DateFormat('d MMM yyyy').format(wiki.createdAt),
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          if (user?.uid == wiki.createdBy)
            OutlinedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                ),
              ),
              child: const Text('Creator Tools'),
            )
        ],
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
                : const AssetImage('lib/core/images/default_profile_pic.jpg')
                    as ImageProvider,
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
