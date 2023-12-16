import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@freezed
class EventModel with _$EventModel {
  factory EventModel({
    String? uid,
    required String name,
    String? description,
    required String address,
    required String city,
    required String province,
    required String imagePath,
    String? imageUrl,
    required List<String> members,
    required List<String> managers,
    required DateTime startDate,
    required DateTime endDate,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}
