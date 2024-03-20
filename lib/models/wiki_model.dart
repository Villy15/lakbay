import 'package:freezed_annotation/freezed_annotation.dart';

part 'wiki_model.freezed.dart';
part 'wiki_model.g.dart';

@freezed
class WikiModel with _$WikiModel {
  factory WikiModel({
    String? uid,
    required String title,
    required String description,
    String? imageUrl,
    required String createdBy,
    required DateTime createdAt,
    required String coopId,
    required String tag,
    List<WikiComments>? comments,
    num? votes,
  }) = _WikiModel;

  factory WikiModel.fromJson(Map<String, dynamic> json) =>
      _$WikiModelFromJson(json);
}

@freezed
class WikiComments with _$WikiComments {
  factory WikiComments({
    required String comment,
    required String createdBy,
    required DateTime createdAt,
    String? imageUrl,
    num? votes,
  }) = _WikiComments;

  factory WikiComments.fromJson(Map<String, dynamic> json) =>
      _$WikiCommentsFromJson(json);
}
