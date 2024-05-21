import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/wiki/wiki_controller.dart';
import 'package:lakbay/models/wiki_model.dart';

class WikiPage extends ConsumerStatefulWidget {
  const WikiPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WikiPageState();
}

enum SortOption { newest, mostVotes }

// State Notifier Provider
final sortOptionProvider =
    StateNotifierProvider<SortOptionNotifier, SortOption>(
  (ref) => SortOptionNotifier(),
);

class _WikiPageState extends ConsumerState<WikiPage> {
  /*
    ROUTES DEFINITION
  */
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

  /*
    VARIABLE DEFINITION
  */

  List<Tag> availableTags = [
    Tag('Discussion', false),
    Tag('Issue', false),
    Tag('Advice', false),
  ];

  bool _isSearching = false;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final sortOption = ref.watch(sortOptionProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
        appBar: _appBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ref.watch(getAllWikiProvider).when(
                data: (wikis) {
                  // wikis = [];
                  if (wikis.isEmpty) {
                    return emptyWikis();
                  }

                  // Filter wikis based on search query
                  final searchedWikis = wikis
                      .where((wiki) => wiki.title
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()))
                      .toList();

                  if (searchedWikis.isEmpty) {
                    return emptyWikis();
                  }

                  // Filter wikis based on selected tags only if any tag is selected
                  final filteredWikis =
                      availableTags.where((tag) => tag.isSelected).isEmpty
                          ? searchedWikis
                          : searchedWikis
                              .where((wiki) => availableTags
                                  .where((tag) => tag.isSelected)
                                  .map((tag) => tag.name)
                                  .contains(wiki.tag))
                              .toList();

                  // Sort wikis based on selected sort option
                  if (sortOption == SortOption.newest) {
                    filteredWikis
                        .sort((a, b) => b.createdAt.compareTo(a.createdAt));

                    debugPrint('Sorted by newest');
                  } else if (sortOption == SortOption.mostVotes) {
                    filteredWikis
                        .sort((a, b) => b.votes?.compareTo(a.votes ?? 0) ?? 0);

                    debugPrint('Sorted by most votes');
                  }

                  if (filteredWikis.isEmpty) {
                    return Column(
                      children: [
                        sortAndTags(),
                        const SizedBox(height: 12),
                        emptyWikis(),
                      ],
                    );
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        sortAndTags(),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredWikis.length * 2,
                          itemBuilder: (context, index) {
                            final wiki =
                                filteredWikis[index % filteredWikis.length];
                            return wikiCard(wiki);
                          },
                        ),
                      ],
                    ),
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

  AppBar _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: _isSearching ? null : const BackButton(),
      title: _isSearching
          ? Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                height: 20, // Set the desired height
                child: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
            )
          : const Text('Wikis'),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchQuery = '';
              }
            });
          },
          icon: Icon(_isSearching ? Icons.close : Icons.search_outlined),
        ),
      ],
    );
  }

  SingleChildScrollView sortAndTags() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            FilledButton(
              onPressed: () {
                showModalSortBy();
              },
              child: const Row(
                children: [
                  Icon(Icons.sort_outlined, size: 20),
                  SizedBox(width: 4),
                  Text(
                    "Sort by",
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: List<Widget>.generate(
                availableTags.length,
                (int index) {
                  return availableTags[index].isSelected
                      ? FilledButton(
                          onPressed: () {
                            setState(() {
                              availableTags[index].isSelected =
                                  !availableTags[index].isSelected;
                            });
                          },
                          child: Text(availableTags[index].name),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            setState(() {
                              availableTags[index].isSelected =
                                  !availableTags[index].isSelected;
                            });
                          },
                          child: Text(availableTags[index].name),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showModalSortBy() {
    return showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setState /*You can rename this!*/) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Sort Wikis",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Sort by"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      radioListTile(context, "Newest", true, false,
                          SortOption.newest, setState),
                      radioListTile(context, "Most Votes", false, true,
                          SortOption.mostVotes, setState),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget radioListTile(BuildContext context, String title, bool isFirst,
      bool isLast, SortOption sortOption, StateSetter setState) {
    return Column(
      children: [
        RadioListTile<SortOption>(
          controlAffinity: ListTileControlAffinity.trailing,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: isFirst
                  ? const Radius.circular(8.0)
                  : const Radius.circular(0),
              topRight: isFirst
                  ? const Radius.circular(8.0)
                  : const Radius.circular(0),
              bottomLeft: isLast
                  ? const Radius.circular(8.0)
                  : const Radius.circular(0),
              bottomRight: isLast
                  ? const Radius.circular(8.0)
                  : const Radius.circular(0),
            ),
          ),
          tileColor: Theme.of(context).colorScheme.primary.withOpacity(0.03),
          title: Text(title),
          value: sortOption,
          groupValue: ref.watch(sortOptionProvider),
          onChanged: (SortOption? value) {
            setState(() {
              ref.read(sortOptionProvider.notifier).setSortOption(value!);
            });
          },
        ),
        if (!isLast)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              height: 0,
              thickness: 0.5,
            ),
          ),
      ],
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
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          fit: FlexFit.loose,
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

class Tag {
  final String name;
  bool isSelected;

  Tag(this.name, this.isSelected);
}

// State Notifiers
class SortOptionNotifier extends StateNotifier<SortOption> {
  SortOptionNotifier() : super(SortOption.mostVotes);

  void setSortOption(SortOption option) {
    state = option;
  }
}
