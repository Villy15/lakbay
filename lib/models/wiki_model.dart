import 'package:freezed_annotation/freezed_annotation.dart';

part 'wiki_model.freezed.dart';
part 'wiki_model.g.dart';

@freezed
class WikiModel with _$WikiModel {

  factory WikiModel({
    String? uid,
    required String name,
    String? description,
    required String imagePath,
    String? imageUrl,
  }) = _WikiModel;

  factory WikiModel.fromJson(Map<String, dynamic> json) => _$WikiModelFromJson(json);
}