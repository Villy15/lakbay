import 'package:freezed_annotation/freezed_annotation.dart';

part 'rooms_params.freezed.dart';
part 'rooms_params.g.dart';

@freezed
class GetRoomsParams with _$GetRoomsParams {
  factory GetRoomsParams({
    List<String>? unavailableRoomUids,
    num? guests,
  }) = _GetRoomsParams;

  factory GetRoomsParams.fromJson(Map<String, dynamic> json) =>
      _$GetRoomsParamsFromJson(json);
}
