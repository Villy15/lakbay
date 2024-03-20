import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/wiki/wiki_repository.dart';
import 'package:lakbay/models/wiki_model.dart';

final getAllWikiProvider = StreamProvider<List<WikiModel>>((ref) {
  final wikiController = ref.watch(wikiControllerProvider.notifier);
  return wikiController.getAllWikis();
});

final getWikiProvider =
    StreamProvider.autoDispose.family<WikiModel, String>((ref, uid) {
  final wikiController = ref.watch(wikiControllerProvider.notifier);
  return wikiController.getWiki(uid);
});

final wikiControllerProvider =
    StateNotifierProvider<WikiController, bool>((ref) {
  final wikiRepository = ref.watch(wikiRepositoryProvider);
  return WikiController(
    wikiRepository: wikiRepository,
    ref: ref,
  );
});

class WikiController extends StateNotifier<bool> {
  final WikiRepository _wikiRepository;
  final Ref _ref;

  WikiController({
    required WikiRepository wikiRepository,
    required Ref ref,
  })  : _wikiRepository = wikiRepository,
        _ref = ref,
        super(false);

  Stream<List<WikiModel>> getAllWikis() {
    return _wikiRepository.readWikis();
  }

  void addWiki(WikiModel wiki, BuildContext context) async {
    final result = await _wikiRepository.addWiki(wiki);

    result.fold(
      (failure) {
        state = false;
        showSnackBar(context, failure.message);
      },
      (wikiUid) {
        state = false;
        showSnackBar(context, 'Wiki added successfully');
        _ref.read(navBarVisibilityProvider.notifier).show();
        context.pop();
      },
    );
  }

  void editWiki(WikiModel wiki, BuildContext context) async {
    state = true;
    final result = await _wikiRepository.updateWiki(wiki);

    result.fold(
      (failure) {
        state = false;
        showSnackBar(context, failure.message);
      },
      (success) {
        state = false;
        showSnackBar(context, 'Wiki updated successfully');
      },
    );
  }

  // Update the votes of the wiki
  void updateVotes(String uid, int votes, BuildContext context) async {
    state = true;
    final result = await _wikiRepository.updateVotes(uid, votes);

    result.fold(
      (failure) {
        state = false;
        showSnackBar(context, failure.message);
      },
      (success) {
        state = false;
      },
    );
  }

  void updateVoteComments(WikiModel wiki, BuildContext context) async {
    state = true;
    final result = await _wikiRepository.updateCommentsVote(wiki);

    result.fold(
      (failure) {
        state = false;
        showSnackBar(context, failure.message);
      },
      (success) {
        state = false;
      },
    );
  }

  // Add a comment to the wiki
  void addComment(
      String uid, WikiComments comment, BuildContext context) async {
    state = true;
    final result = await _wikiRepository.addComment(uid, comment);

    result.fold(
      (failure) {
        state = false;
        showSnackBar(context, failure.message);
      },
      (success) {
        state = false;
        context.pop();
        showSnackBar(context, 'Comment added successfully');
      },
    );
  }

  Stream<WikiModel> getWiki(String uid) {
    return _wikiRepository.readWiki(uid);
  }
}
