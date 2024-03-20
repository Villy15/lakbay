import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lakbay/core/util/utils.dart';

part 'coop_announcements_model.freezed.dart';
part 'coop_announcements_model.g.dart';

@freezed
class CoopAnnouncements with _$CoopAnnouncements {
  factory CoopAnnouncements({
    required String title,
    required String description,
    required String coopId,
    @TimestampSerializer() DateTime? timestamp,
    String? uid,
    String? imageUrl,
    String? category,
  }) = _CoopAnnouncements;

  factory CoopAnnouncements.fromJson(Map<String, dynamic> json) =>
      _$CoopAnnouncementsFromJson(json);
}
