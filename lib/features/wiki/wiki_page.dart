import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/wiki/wiki_controller.dart';
import 'package:lakbay/models/wiki_model.dart';

class WikiPage extends ConsumerStatefulWidget {
  const WikiPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WikiPageState();
}

class _WikiPageState extends ConsumerState<WikiPage> {
  void readWiki(BuildContext context, String wikiId) {
    context.push("/wiki/$wikiId");
  }

  void navigateToAddWiki(BuildContext context) {
    context.push("/add_wiki");
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
    final user = ref.watch(userProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
        appBar: CustomAppBar(title: 'Wiki', user: user),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ref.watch(getAllWikiProvider).when(
                data: (wikis) {
                  if (wikis.isEmpty) {
                    return emptyWikis();
                  }

                  return Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: wikis.length,
                        itemBuilder: (context, index) {
                          final wiki = wikis[index];
                          return wikiCard(wiki);
                        },
                      ),
                    ],
                  );
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString(), stackTrace: ''),
                loading: () => const Loader(),
              ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateToAddWiki(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Card wikiCard(WikiModel wiki) {
    return Card(
      child: InkWell(
        onTap: () => {
          readWiki(context, wiki.uid!),
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Chip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    wiki.tag.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                  ),
                  // Votes Length
                  const SizedBox(width: 8),
                  Text(
                    '${wiki.votes} votes',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ref.watch(getUserDataProvider(wiki.createdBy)).maybeWhen(
                    data: (user) {
                      return Row(
                        children: [
                          Text(
                            user.name,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(width: 4),
                          // Time ago
                          Text(
                            timeAgo(wiki.createdAt),
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                          ),
                        ],
                      );
                    },
                    orElse: () => const SizedBox(),
                  ),
              const SizedBox(height: 8),
              Text(
                wiki.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(wiki.description,
                  maxLines: 3, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 24),
              // Elevated button that spands the width of the screen
              FilledButton.tonal(
                style: ElevatedButton.styleFrom(
                  // Make it wide
                  minimumSize: const Size(double.infinity, 40),
                ),
                onPressed: () => {},
                child: Row(
                  children: [
                    const Icon(Icons.comment_outlined, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      (wiki.comments?.length ?? 0).toString(),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Latest Comment
                    if (wiki.comments?.isNotEmpty ?? false)
                      ref
                          .watch(getUserDataProvider(
                              wiki.comments!.last.createdBy))
                          .maybeWhen(
                            orElse: () => const SizedBox(),
                            data: (user) {
                              return Row(
                                children: [
                                  CircleAvatar(
                                    radius: 15.0,
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
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      wiki.comments?.isNotEmpty ?? false
                                          ? wiki.comments!.last.comment
                                          : '',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              );
                            },
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

  Widget emptyWikis() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'lib/core/images/SleepingCatFromGlitch.svg',
                  height: 100, // Adjust height as desired
                ),
                const SizedBox(height: 20),
                const Text(
                  'No knowledge created so far!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Create a wiki at the button below',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const Text(
                  'to share your knowledge',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
