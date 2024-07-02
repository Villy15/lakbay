import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';
import 'package:lakbay/models/subcollections/coop_vote_model.dart';
import 'package:lakbay/models/user_model.dart';

class ReadVote extends ConsumerStatefulWidget {
  final CoopVote vote;
  const ReadVote({super.key, required this.vote});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReadVoteState();
}

class _ReadVoteState extends ConsumerState<ReadVote> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  void viewResults() {
    // show bottom sheet with results
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        // Return the list of names with the number of votes
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.bar_chart),
                        SizedBox(width: 8),
                        Text('Results', style: TextStyle(fontSize: 24)),
                      ],
                    ),
                    // Close button
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              // Divider
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: widget.vote.candidates!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final candidate = widget.vote.candidates![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ref
                                  .watch(getUserDataProvider(candidate.uid!))
                                  .when(
                                    data: (user) {
                                      return Text(
                                        user.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      );
                                    },
                                    loading: () =>
                                        const CircularProgressIndicator(),
                                    error: (error, stack) =>
                                        const Text('Error'),
                                  ),

                              // Total Percentage
                              Text(
                                '${widget.vote.percentage(candidate.uid!)}%',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground
                                        .withOpacity(0.6)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(10),
                            minHeight: 5,
                            value: widget.vote.percentage(candidate.uid!),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary),
                          ),

                          // Number of votes
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${widget.vote.votes(candidate.uid!)} votes',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.6)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final members =
        ref.watch(getAllMembersProvider(widget.vote.coopId!)).asData?.value;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        ref.read(navBarVisibilityProvider.notifier).show();
        context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Read Vote'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _header(members),
              // _category(),
              const SizedBox(height: 8),
              _title(),
              const SizedBox(height: 4),
              _desc(),

              // Grid of Candidates
              const SizedBox(height: 16),

              _candidates(),

              // View Results
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => viewResults(),
                    child: const Text('View Results'),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void changeVote(String candidateId, String? votedFor) {
    final user = ref.read(userProvider)!;

    // Update vote using copyWith
    var newVote = widget.vote.copyWith(
      candidates: widget.vote.candidates!.map((candidate) {
        if (candidate.uid == candidateId) {
          // Add uid to the list of voters
          return candidate.copyWith(
            voters: [...candidate.voters!, user.uid],
          );
        }
        if (candidate.uid == votedFor) {
          // Remove uid from the list of voters
          return candidate.copyWith(
            voters:
                candidate.voters!.where((voter) => voter != user.uid).toList(),
          );
        }
        return candidate;
      }).toList(),
    );

    debugPrint('New vote: ${newVote.toString()}');

    ref
        .read(coopsControllerProvider.notifier)
        .editVote(widget.vote.coopId!, newVote, context);
  }

  void vote(String candidateId) {
    final user = ref.read(userProvider)!;
    // Update vote using copyWith
    var newVote = widget.vote.copyWith(
      candidates: widget.vote.candidates!.map((candidate) {
        if (candidate.uid == candidateId) {
          // Add uid to the list of voters
          return candidate.copyWith(
            voters: [...candidate.voters!, user.uid],
          );
        }
        return candidate;
      }).toList(),
    );

    debugPrint('New vote: ${newVote.toString()}');

    ref
        .read(coopsControllerProvider.notifier)
        .editVote(widget.vote.coopId!, newVote, context);
  }

  Widget _candidates() {
    // Check if the current user has already voted
    final user = ref.read(userProvider)!;

    final hasVoted = widget.vote.isVoted(user.uid);
    final votedFor = widget.vote.votedFor(user.uid);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.vote.candidates!.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          mainAxisExtent: 250,
        ),
        itemBuilder: (context, index) {
          final candidate = widget.vote.candidates![index];

          return ref.watch(getUserDataProvider(candidate.uid!)).when(
            data: (user) {
              return Column(
                children: [
                  SizedBox(
                    height: 200,
                    width: 250,
                    child: candidateCard(user, hasVoted),
                  ),

                  // Show message if user has already voted and voted for this candidate
                  if (hasVoted && votedFor == candidate.uid) ...[
                    FilledButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.green.withOpacity(0.8)),
                      ),
                      onPressed: null,
                      child: const Text('Candidate Voted!',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ] else if (hasVoted && votedFor != candidate.uid) ...[
                    // Change vote
                    ElevatedButton(
                      onPressed: () {
                        // Cast vote
                        changeVote(
                          candidate.uid!,
                          votedFor,
                        );
                      },
                      child: const Text('Change Vote'),
                    ),
                  ] else ...[
                    FilledButton(
                      onPressed: () {
                        // Cast vote
                        vote(
                          candidate.uid!,
                        );
                      },
                      child: const Text('Vote'),
                    ),
                  ],

                  // if (hasVoted) ...[
                  //   const Text(
                  //     'You have already voted',
                  //     style: TextStyle(
                  //       color: Colors.red,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ] else ...[
                  //   // Show message if user has not voted
                  //   // Vote button
                  //   FilledButton(
                  //     onPressed: () {
                  //       // Cast vote
                  //       vote(
                  //         candidate.uid!,
                  //       );
                  //     },
                  //     child: const Text('Vote'),
                  //   ),
                  // ],
                ],
              );
            },
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
            error: (error, stack) {
              return const Center(child: Text('Error loading candidate'));
            },
          );
          // return candidateCard(candidate);
        },
      ),
    );
  }

  Widget candidateCard(UserModel candidate, bool hasVoted) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(10.0), // Rounded corners for the card
      ),
      child: InkWell(
        onTap: () {
          // Go to the candidate's profile
          context.push('/my_coop/functions/members/${candidate.uid}');
        },
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10.0), // Rounded corners for the image
                ),
                child: candidate.profilePic != ''
                    ? Image.network(
                        candidate.profilePic,
                        fit: BoxFit
                            .cover, // Make the image cover the entire space
                      )
                    : Container(
                        color: Theme.of(context).colorScheme.onBackground,
                        child: Center(
                          child: Text(
                            candidate.name[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                candidate.name,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _category() {
  //   return Align(
  //     alignment: Alignment.centerLeft,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 12.0),
  //       child: Text(
  //         widget.vote.category!.toUpperCase(),
  //         style: TextStyle(
  //           fontSize: 14,
  //           color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Padding _desc() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(
        'New cooperative ${widget.vote.position!} will be assigned, as we do every quarter. Your vote matters and cast it now. Click on the picture of your choice for this election',
        style: const TextStyle(
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget _title() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Text(
          widget.vote.position!,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Padding _header(List<CooperativeMembers>? members) {
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
                'Due Date: ${DateFormat('d MMM yyyy').format(widget.vote.dueDate!)}',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          OutlinedButton(
            onPressed: () {
              // managerTools
              voteManagerTools(members);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
            ),
            child: const Text('Manager Tools'),
          )
        ],
      ),
    );
  }

  // void check who does not vote yet
  void showMembersNotVoting(List<CooperativeMembers>? members) {
    // Get the list of members who have not voted
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        // Return the list of names with the number of votes
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.bar_chart),
                          SizedBox(width: 8),
                          Text('Check Members vote status',
                              style: TextStyle(fontSize: 18)),
                        ],
                      ),
                      // Close button
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                // Divider
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: members!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final member = members[index];

                      return ref
                          .watch(getUserDataProvider(member.uid!))
                          .maybeWhen(
                            data: (user) {
                              return ListTile(
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
                                title: Text(user.name),
                                trailing:
                                    hasVoted(member.uid!).toString() == 'true'
                                        ? const Icon(Icons.check,
                                            color: Colors.green)
                                        : const Icon(Icons.close,
                                            color: Colors.red),
                              );
                            },
                            orElse: () => const SizedBox(
                                height: 50, child: CircularProgressIndicator()),
                          );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Check if a user has voted or the uid is in the list of voters
  bool hasVoted(String uid) {
    return widget.vote.isVoted(uid);
  }

  Future<dynamic> voteManagerTools(List<CooperativeMembers>? members) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              children: [
                const SizedBox(
                  height: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.bar_chart),
                          SizedBox(width: 8),
                          Text('Manager Tools', style: TextStyle(fontSize: 24)),
                        ],
                      ),
                      // Close button
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // Check who does not vote yet
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Check members vote status'),
                  onTap: () {
                    showMembersNotVoting(members);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(),
                ),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit Vote'),
                  onTap: () {
                    showSnackBar(context, 'Edit Vote Not yet implemented');
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(),
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete Vote'),
                  onTap: () {
                    showSnackBar(context, 'Edit Vote Not yet implemented');
                  },
                ),
              ],
            ),
          );
        },
      );
}
