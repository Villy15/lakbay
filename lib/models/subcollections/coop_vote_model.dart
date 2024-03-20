import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lakbay/core/util/utils.dart';

part 'coop_vote_model.freezed.dart';
part 'coop_vote_model.g.dart';

@freezed
class CoopVote with _$CoopVote {
  const CoopVote._();

  factory CoopVote({
    String? uid,
    String? coopId,
    String? position,
    List<CoopVoteCandidate>? candidates,
    @TimestampSerializer() DateTime? dueDate,
  }) = _CoopVote;

  factory CoopVote.fromJson(Map<String, dynamic> json) =>
      _$CoopVoteFromJson(json);

  // CHECK IF your id is in one of the voters list of the candidate
  bool isVoted(String id) {
    return candidates!.any((candidate) => candidate.voters!.contains(id));
  }

  // Check what candidate the user voted for
  String? votedFor(String id) {
    for (var candidate in candidates!) {
      if (candidate.voters!.contains(id)) {
        return candidate.uid;
      }
    }
    return null;
  }

  // Check how many votes a candidate has
  int votes(String id) {
    return candidates!
        .firstWhere((candidate) => candidate.uid == id)
        .voters!
        .length;
  }

  // Check the total number of votes
  int totalVotes() {
    return candidates!
        .map((candidate) => candidate.voters!.length)
        .reduce((value, element) => value + element);
  }

  // Check the percentage of votes a candidate has
  double percentage(String id) {
    int total = totalVotes();
    // Check votes of candidate and if equals to 0 return 0
    if (votes(id) == 0) {
      return 0;
    }

    return total == 0 ? 0 : (votes(id) / total) * 100;
  }
}

// Candidate

@freezed
class CoopVoteCandidate with _$CoopVoteCandidate {
  factory CoopVoteCandidate({
    String? uid,
    List<String>? voters,
  }) = _CoopVoteCandidate;

  factory CoopVoteCandidate.fromJson(Map<String, dynamic> json) =>
      _$CoopVoteCandidateFromJson(json);
}
